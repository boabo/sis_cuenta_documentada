CREATE OR REPLACE FUNCTION cd.ft_rendicion_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documentada
 FUNCION: 		cd.ft_rendicion_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.trendicion_det'
 AUTOR: 		 (admin)
 FECHA:	        17-05-2016 18:01:48
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_rendicion_det		integer;
    v_registros				record;
    v_rec					record;
    v_tmp_resp				boolean;
    v_importe_documentos	numeric;
    v_importe_depositos		numeric;
    v_tope					numeric;
    v_sw_max_doc_rend       varchar;
    v_cd_comprometer_presupuesto     varchar;
    v_id_cuenta_doc			integer;
    v_importe_fondo			numeric;
    v_verifica_rendiciones_menor_fondo	varchar;
	v_tipo_informe			varchar;
    v_fecha_doc				date;
    v_id_plantilla 			integer;
    v_nombre_plantilla		varchar;
    v_id_doc_compra_venta   integer;

    v_estacion				varchar;
    v_registros_2			record;					   

BEGIN

    v_nombre_funcion = 'cd.ft_rendicion_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);
    v_cd_comprometer_presupuesto  = pxp.f_get_variable_global('cd_comprometer_presupuesto');

	/*********************************
 	#TRANSACCION:  'CD_REND_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin
 	#FECHA:		17-05-2016 18:01:48
	***********************************/

	if(p_transaccion='CD_REND_INS')then

        begin


             v_tope  = pxp.f_get_variable_global('cd_monto_factura_maximo')::numeric;

              select
                c.importe,
                c.estado,
                c.id_cuenta_doc,
                cdr.sw_max_doc_rend,
                cdr.estado as estado_cdr,
                cdr.importe as importe_rendicion,
                per.fecha_ini,
                per.fecha_fin,
                c.nro_tramite
             into
                v_registros
             from cd.tcuenta_doc c
             inner join cd.tcuenta_doc cdr on cdr.id_cuenta_doc_fk = c.id_cuenta_doc
             left join param.tperiodo per on per.id_periodo=cdr.id_periodo
             where cdr.id_cuenta_doc = v_parametros.id_cuenta_doc;

			--raise exception 'id %',v_parametros.id_plantilla;

			if(pxp.f_existe_parametro(p_tabla,'id_plantilla')) then
            	select doc.desc_plantilla
                into
                v_nombre_plantilla
                from param.tplantilla doc
                where doc.id_plantilla = v_parametros.id_plantilla;
            else
              	select pl.desc_plantilla
                into
                v_nombre_plantilla
                from conta.tdoc_compra_venta cv
                join param.tplantilla pl on cv.id_plantilla = pl.id_plantilla
                where cv.id_doc_compra_venta = v_parametros.id_doc_compra_venta;
            end if;

           --raise exception 'llega %',v_parametros.importe_pago_liquido;

             IF v_registros.estado != 'contabilizado' THEN
              raise exception 'Solo puede añadir facturas en solicitudes entregadas (Contabilizada)';
             END IF;

             IF v_registros.estado_cdr not in ('borrador','vbrendicion') THEN
              raise exception 'Solo puede añadir facturas en rediciones en borrador o vbtesoreria, (no en  %)',v_registros.estado_cdr;
             END IF;


             IF v_registros.estado_cdr not in ('borrador')  and v_cd_comprometer_presupuesto = 'si' THEN
                raise exception 'Solo puede añadir  en borrador por que los documentos se encuentran comprometidos';
             END IF;


             --(MAY)23/09/2019 -LAS ESTACIONES INTERNACIONALES NO SE CONTROLA EL MONTO TOPE EN FONDOS EN AVANCE BOLIVIA I SE CONTROLA EL MONTO TOPE
             v_estacion = pxp.f_get_variable_global('ESTACION_inicio');
             IF (v_estacion = 'BOL' ) THEN

             		--TODO considerar moneda del documento, el tope esta en moneda base ...
                     if v_nombre_plantilla ='Póliza de Importación - DUI' then
                          IF v_registros.sw_max_doc_rend = 'no' and  v_parametros.importe_pago_liquido > v_tope THEN
                              raise exception 'No puede registrar documentos mayores a %, si es necesario pida permiso en tesoreria para proceder',v_tope;
                          END IF;
                     else
                         IF v_registros.sw_max_doc_rend = 'no' and  v_parametros.importe_doc > v_tope THEN
                                raise exception 'No puede registrar documentos mayores a %, si es necesario pida permiso en Tesoreria para proceder',v_tope;
                         END IF;
                     end if;

             END IF;
             --

             select fecha into v_fecha_doc
             from conta.tdoc_compra_venta
             where id_doc_compra_venta=v_parametros.id_doc_compra_venta;

               --quitar el control de verificacion de la fecha de la factura para estaciones que no sean Bolivia (Alan 29/11/2019)
            IF( pxp.f_get_variable_global('ESTACION_inicio')='BOL')THEN
                   IF NOT v_fecha_doc BETWEEN v_registros.fecha_ini AND v_registros.fecha_fin THEN
                      raise exception 'El documento no corresponde al periodo % %', v_registros.fecha_ini, v_registros.fecha_fin;
                   END IF;
            end if;
            --raise exception 'llega..';
        	--Sentencia de la insercion
        	insert into cd.trendicion_det(
              id_doc_compra_venta,
              estado_reg,
              id_cuenta_doc_rendicion,
              id_cuenta_doc,
              id_usuario_reg,
              usuario_ai,
              fecha_reg,
              id_usuario_ai,
              fecha_mod,
              id_usuario_mod
          	) values(
              v_parametros.id_doc_compra_venta,
              'activo',
              v_parametros.id_cuenta_doc,   -- registro de la rendicion
              v_registros.id_cuenta_doc, --reg de la solicitud
              p_id_usuario,
              v_parametros._nombre_usuario_ai,
              now(),
              v_parametros._id_usuario_ai,
              null,
              null

			)RETURNING id_rendicion_det into v_id_rendicion_det;

            -------------------------------------
            --  validar registros de la rendicion
            -----------------------------------------
            IF  not cd.f_validar_documentos(p_id_usuario, v_parametros.id_cuenta_doc) THEN
              raise exception 'error al validar';
            END IF;



            update conta.tdoc_compra_venta dcv set
               tabla_origen = 'cd.trendicion_det',
               id_origen = v_id_rendicion_det,
               nro_tramite = v_registros.nro_tramite
            where dcv.id_doc_compra_venta = v_parametros.id_doc_compra_venta;


			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Rendición almacenado(a) con exito (id_rendicion_det'||v_id_rendicion_det||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_rendicion_det',v_id_rendicion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

   /*********************************
 	#TRANSACCION:  'CD_VALEDI_MOD'
 	#DESCRIPCION:	Valida la edicion de facturas
 	#AUTOR:		admin
 	#FECHA:		17-05-2016 18:01:48
	***********************************/

	elseif(p_transaccion='CD_VALEDI_MOD')then

        begin

             select
                c.importe,
                c.estado,
                c.id_cuenta_doc,
                cdr.estado as estado_cdr,
                cdr.importe as importe_rendicion,
                per.fecha_ini,
                per.fecha_fin
             into
                v_registros
             from cd.tcuenta_doc c
             inner join cd.tcuenta_doc cdr on cdr.id_cuenta_doc_fk = c.id_cuenta_doc
             left join param.tperiodo per on per.id_periodo=cdr.id_periodo
             where cdr.id_cuenta_doc = v_parametros.id_cuenta_doc; --registro de solicitud


            IF v_registros.estado != 'contabilizado' THEN
              raise exception 'Solo puede modificar facturas en solicitudes entregada(contabilizada)';
            END IF;


            IF v_registros.estado_cdr not in ('borrador','vbrendicion') THEN
              raise exception 'Solo puede modificar facturas en rediciones en borrador o vbtesoreria, (no en  %)',v_registros.estado_cdr;
            END IF;


            IF v_registros.estado_cdr not in ('borrador')  and v_cd_comprometer_presupuesto = 'si' THEN
                raise exception 'Solo puede añadir  en borrador por que los documentos se encuentran comprometidos';
            END IF;

            select fecha into v_fecha_doc
             from conta.tdoc_compra_venta
             where id_doc_compra_venta=v_parametros.id_doc_compra_venta;

             IF NOT v_fecha_doc BETWEEN v_registros.fecha_ini AND v_registros.fecha_fin THEN
             	raise exception 'El documento no corresponde al periodo % %', v_registros.fecha_ini, v_registros.fecha_fin;
             END IF;

            -------------------------------------
            --  validar registros de la rendicion
            -----------------------------------------
            IF  not cd.f_validar_documentos(p_id_usuario, v_parametros.id_cuenta_doc) THEN
              raise exception 'error al validar';
            END IF;


			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','validado factura rendicion'||v_id_rendicion_det||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_rendicion_det',v_id_rendicion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;



	/*********************************
 	#TRANSACCION:  'CD_RENDET_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin
 	#FECHA:		17-05-2016 18:01:48
	***********************************/

	elsif(p_transaccion='CD_RENDET_ELI')then

		begin

            select
               rd.*,
               dcv.id_depto_conta,
               dcv.fecha ,
               c.estado,
               dcv.id_plantilla
            into
               v_registros
            from cd.trendicion_det rd
            inner join cd.tcuenta_doc c on c.id_cuenta_doc = rd.id_cuenta_doc_rendicion
            inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
            where rd.id_rendicion_det = v_parametros.id_rendicion_det;


            -- solo eliminar documentos en borrador o vbrendicion

            IF v_registros.estado not in ('borrador','vbrendicion') THEN
                raise exception 'no puede elimianr documentos que  esten en borrador o visto bueno rendición';
            END IF;

            IF v_cd_comprometer_presupuesto = 'si' THEN
                raise exception 'Solo puede eliminar  en estado borrador por que los documentos se encuentran comprometidos';
            END IF;


            --validar si el periodo de conta esta cerrado o abierto
            -- recuepra el periodo de la fecha ...
            --Obtiene el periodo a partir de la fecha
        	v_rec = param.f_get_periodo_gestion(v_registros.fecha);

            select tipo_informe into v_tipo_informe
      		from param.tplantilla
      		where id_plantilla = v_registros.id_plantilla;

            -- valida que period de libro de compras y ventas este abierto
            IF v_tipo_informe = 'lcv' THEN
	            v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_registros.id_depto_conta, v_rec.po_id_periodo);
    		END IF;
			
			--revisa si el documento no esta marcado como revisado
            select
              dcv.revisado,
              dcv.id_int_comprobante,
              dcv.tabla_origen,
              dcv.id_origen,
              dcv.id_depto_conta,
              dcv.fecha,
              dcv.id_plantilla
            into
              v_registros_2
            from conta.tdoc_compra_venta dcv where dcv.id_doc_compra_venta =v_registros.id_doc_compra_venta;

            IF  v_registros_2.revisado = 'si' THEN
              raise exception 'los documentos revisados no pueden eliminarse';
            END IF;

            --elimina el dadetalle del documento
            delete
            from conta.tdoc_concepto d
            where d.id_doc_compra_venta = v_registros.id_doc_compra_venta;

            --elimina la rendicion
			delete from cd.trendicion_det
            where id_rendicion_det=v_parametros.id_rendicion_det;

            --elimina el documento
            delete
            from conta.tdoc_compra_venta d
            where d.id_doc_compra_venta = v_registros.id_doc_compra_venta;



            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Rendición eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_rendicion_det',v_parametros.id_rendicion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
 	#TRANSACCION:  'CD_CHKDOCFON_IME'
 	#DESCRIPCION:	verifica si el documento no excede el total del fondo
 	#AUTOR:		Gonzalo Sarmiento
 	#FECHA:		23-09-20156 15:57:09
	***********************************/

	elsif(p_transaccion='CD_CHKDOCFON_IME')then

		begin

        	v_verifica_rendiciones_menor_fondo = pxp.f_get_variable_global('cd_verificar_rendiciones_menor_fondo');

            IF (v_verifica_rendiciones_menor_fondo='si') THEN

                select ren.id_cuenta_doc into v_id_cuenta_doc
                from cd.trendicion_det ren
                where ren.id_doc_compra_venta = v_parametros.id_doc_compra_venta;

                select importe into v_importe_fondo
                from cd.tcuenta_doc
                where id_cuenta_doc = v_id_cuenta_doc;

                select sum(c.importe_pago_liquido) into v_importe_documentos
                from cd.trendicion_det d
                inner join conta.tdoc_compra_venta c on c.id_doc_compra_venta=d.id_doc_compra_venta
                where d.id_cuenta_doc = v_id_cuenta_doc;

                IF COALESCE(v_importe_documentos,0) >  COALESCE(v_importe_fondo,0)  THEN
                   raise exception 'No es permitido que la suma de las rendiciones sea mayor al monto del fondo recibido, verifique el importe del documento que intenta registrar';
                END IF;

            END IF;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','no excede el monto del fondo entregado');

            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
 	#TRANSACCION:  'CD_VALINDDEPREN_VAL'
 	#DESCRIPCION:	validar registro de depositos en la rendicion
 	#AUTOR:		admin
 	#FECHA:		17-05-2016 18:01:48
	***********************************/

	elsif(p_transaccion='CD_VALINDDEPREN_VAL')then

		begin



            select
               c.id_cuenta_doc,
               c.estado
            into
               v_registros
            from tes.tts_libro_bancos lb
            inner join cd.tcuenta_doc c on c.id_cuenta_doc = lb.columna_pk_valor and  lb.columna_pk = 'id_cuenta_doc' and lb.tabla = 'cd.tcuenta_doc'
             where id_libro_bancos=v_parametros.id_libro_bancos;


             IF v_registros.estado not in ('borrador','vbrendicion') THEN
                raise exception 'no puede insertar depositos en una rendición en estado  borrador o visto bueno rendición';
             END IF;

            IF  not cd.f_validar_documentos(p_id_usuario, v_registros.id_cuenta_doc) THEN
              raise exception 'error al validar';
            END IF;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Rendición eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_libro_bancos',v_parametros.id_libro_bancos::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;


    /*********************************
 	#TRANSACCION:  'CD_VALDELDDEPREN_VAL'
 	#DESCRIPCION:	validar la eliminacion de depositos en rendicion
 	#AUTOR:		admin
 	#FECHA:		17-05-2016 18:01:48
	***********************************/

	elsif(p_transaccion='CD_VALDELDDEPREN_VAL')then

		begin



            select
               c.id_cuenta_doc,
               c.estado
            into
               v_registros
            from tes.tts_libro_bancos lb
            inner join cd.tcuenta_doc c on c.id_cuenta_doc = lb.columna_pk_valor and  lb.columna_pk = 'id_cuenta_doc' and lb.tabla = 'cd.tcuenta_doc'
             where id_libro_bancos=v_parametros.id_libro_bancos;

             IF v_registros.estado not in ('borrador','vbrendicion') THEN
                raise exception 'no puede eliminar depositos que  esten en una rendición en estado  borrador o visto bueno rendición';
             END IF;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Rendición eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_libro_bancos',v_parametros.id_libro_bancos::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CD_RELDET_ELI'
 	#DESCRIPCION:	Eliminacion de la relacion trendicion_det
 	#AUTOR:		YMR
 	#FECHA:		17-12-2019 18:01:48
	***********************************/

	elsif(p_transaccion='CD_RELDET_ELI')then

		begin

           select
               rd.*,
               dcv.id_depto_conta,
               dcv.fecha ,
               c.estado,
               dcv.id_plantilla
            into
               v_registros
            from cd.trendicion_det rd
            inner join cd.tcuenta_doc c on c.id_cuenta_doc = rd.id_cuenta_doc_rendicion
            inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
            where rd.id_rendicion_det = v_parametros.id_rendicion_det;


            -- solo eliminar documentos en borrador o vbrendicion

            IF v_registros.estado not in ('borrador','vbrendicion') THEN
                raise exception 'no puede elimianr documentos que  esten en borrador o visto bueno rendición';
            END IF;

            IF v_cd_comprometer_presupuesto = 'si' THEN
                raise exception 'Solo puede eliminar  en estado borrador por que los documentos se encuentran comprometidos';
            END IF;


            --validar si el periodo de conta esta cerrado o abierto
            -- recuepra el periodo de la fecha ...
            --Obtiene el periodo a partir de la fecha
        	v_rec = param.f_get_periodo_gestion(v_registros.fecha);

            select tipo_informe into v_tipo_informe
      		from param.tplantilla
      		where id_plantilla = v_registros.id_plantilla;

            -- valida que period de libro de compras y ventas este abierto
            IF v_tipo_informe = 'lcv' THEN
	            v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_registros.id_depto_conta, v_rec.po_id_periodo);
    		END IF;
            
            select rdd.id_doc_compra_venta
            into v_id_doc_compra_venta
            from cd.trendicion_det rdd
            where rdd.id_rendicion_det = v_parametros.id_rendicion_det;
            
             --elimina el dadetalle del documento
            delete
            from conta.tdoc_concepto d
            where d.id_doc_compra_venta = v_id_doc_compra_venta;

            --elimina la rendicion
			delete from cd.trendicion_det
            where id_rendicion_det=v_parametros.id_rendicion_det;
			
			--elimina relacion con la factura 
            update conta.tdoc_compra_venta
            set    nro_tramite = NULL
            where  id_doc_compra_venta = v_id_doc_compra_venta; 

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Rendición eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_rendicion_det',v_parametros.id_rendicion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
    #TRANSACCION: 'CD_RENDET_GET'
    #DESCRIPCION: RECUPERA EL TIPO DE CAMBIO
    #AUTOR: YMR
    #FECHA: 5-12-2019
    ***********************************/

	elsif (p_transaccion = 'CD_RENDET_GET') then

  	BEGIN
      
    	select
            dcv.id_doc_compra_venta,
            dcv.revisado,
            dcv.movil,
            dcv.tipo,
            COALESCE(dcv.importe_excento,0)::numeric as importe_excento,
            dcv.id_plantilla,
            dcv.fecha,
            dcv.nro_documento,
            dcv.nit,
            COALESCE(dcv.importe_ice,0)::numeric as importe_ice,
            dcv.nro_autorizacion,
            COALESCE(dcv.importe_iva,0)::numeric as importe_iva,
            COALESCE(dcv.importe_descuento,0)::numeric as importe_descuento,
            COALESCE(dcv.importe_doc,0)::numeric as importe_doc,
            dcv.sw_contabilizar,
            COALESCE(dcv.tabla_origen,'ninguno') as tabla_origen,
            dcv.estado,
            dcv.id_depto_conta,
            dcv.id_origen,
            dcv.obs,
            dcv.estado_reg,
            dcv.codigo_control,
            COALESCE(dcv.importe_it,0)::numeric as importe_it,
            dcv.razon_social,
            dcv.id_usuario_ai,
            dcv.id_usuario_reg,
            dcv.fecha_reg,
            dcv.usuario_ai,
            dcv.id_usuario_mod,
            dcv.fecha_mod,
            usu1.cuenta as usr_reg,
            usu2.cuenta as usr_mod,
            dep.nombre as desc_depto,
            pla.desc_plantilla,
            COALESCE(dcv.importe_descuento_ley,0)::numeric as importe_descuento_ley,
            COALESCE(dcv.importe_pago_liquido,0)::numeric as importe_pago_liquido,
            dcv.nro_dui,
            dcv.id_moneda,
            mon.codigo as desc_moneda,
            dcv.id_int_comprobante,
            COALESCE(ic.nro_cbte,dcv.id_int_comprobante::varchar)::varchar  as desc_comprobante,
            COALESCE(dcv.importe_pendiente,0)::numeric as importe_pendiente,
            COALESCE(dcv.importe_anticipo,0)::numeric as importe_anticipo,
            COALESCE(dcv.importe_retgar,0)::numeric as importe_retgar,
            COALESCE(dcv.importe_neto,0)::numeric as importe_neto,
            aux.id_auxiliar,
            aux.codigo_auxiliar,
            aux.nombre_auxiliar,
            dcv.id_tipo_doc_compra_venta,
            (tdcv.codigo||' - '||tdcv.nombre)::Varchar as desc_tipo_doc_compra_venta
        into
            v_registros
        from conta.tdoc_compra_venta dcv
          inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
          inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
          inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
          inner join conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
          left join conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
          left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante
          left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
          left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
        where  dcv.id_doc_compra_venta = v_parametros.id_doc_compra_venta;
    
      --Definition of the response
        v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_registros.id_doc_compra_venta::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'revisado',v_registros.revisado::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'movil',v_registros.movil::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'tipo',v_registros.tipo::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'importe_excento',v_registros.importe_excento::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'id_plantilla',v_registros.id_plantilla::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'nro_documento',v_registros.nro_documento::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'nit',v_registros.nit::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'importe_ice',v_registros.importe_ice::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'nro_autorizacion',v_registros.nro_autorizacion::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'importe_iva',v_registros.importe_iva::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'importe_descuento',v_registros.importe_descuento::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'importe_doc',v_registros.importe_doc::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'tabla_origen',v_registros.tabla_origen::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'estado',v_registros.estado::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'id_depto_conta',v_registros.id_depto_conta::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'id_origen',v_registros.id_origen::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'obs',v_registros.obs::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'estado_reg',v_registros.estado_reg::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_control',v_registros.codigo_control::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'importe_it',v_registros.importe_it::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'razon_social',v_registros.razon_social::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'id_usuario_ai',v_registros.id_usuario_ai::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'id_usuario_reg',v_registros.id_usuario_reg::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'usuario_ai',v_registros.usuario_ai::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'id_usuario_mod',v_registros.id_usuario_mod::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'usr_reg',v_registros.usr_reg::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'usr_mod',v_registros.usr_mod::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'importe_pendiente',v_registros.importe_pendiente::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'importe_anticipo',v_registros.importe_anticipo::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'importe_retgar',v_registros.importe_retgar::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'importe_neto',v_registros.importe_neto::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'desc_depto',v_registros.desc_depto::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'desc_plantilla',v_registros.desc_plantilla::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'importe_descuento_ley',v_registros.importe_descuento_ley::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'importe_pago_liquido',v_registros.importe_pago_liquido::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'nro_dui',v_registros.nro_dui::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'id_moneda',v_registros.id_moneda::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'desc_moneda',v_registros.desc_moneda::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'id_auxiliar',v_registros.id_auxiliar::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_auxiliar',v_registros.codigo_auxiliar::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'nombre_auxiliar',v_registros.nombre_auxiliar::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_doc_compra_venta',v_registros.id_tipo_doc_compra_venta::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'desc_tipo_doc_compra_venta',v_registros.desc_tipo_doc_compra_venta::varchar);
        v_resp = pxp.f_agrega_clave(v_resp,'fecha',v_registros.fecha::varchar);
        
      --Returns the answer
        return v_resp;

  	END;

    else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

EXCEPTION

	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION cd.ft_rendicion_det_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;