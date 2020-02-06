<?php
/**
 *@package pXP
 *@file gen-RendicionDet.php
 *@author  (admin)
 *@date 17-05-2016 18:01:48
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.RendicionDet = Ext.extend(Phx.gridInterfaz, {
		tipoDoc : 'compra',
		bsave : false,
		constructor : function(config) {
			this.maestro = config.maestro;
			//llama al constructor de la clase padre
			Phx.vista.RendicionDet.superclass.constructor.call(this, config);
			this.init();
			
			this.addButton('btnShowDoc',
            {
                text: 'Ver Detalle',
                iconCls: 'brenew',
                disabled: true,
                handler: this.showDoc,
                tooltip: 'Muestra el detalle del documento'
            });
			this.addButton('btnNewDoc',
                {
                    text: 'Relacionar Factura',
                    iconCls: 'blist',
                    disabled: false,
                    handler: this.modExcento,
                    tooltip: 'Permite relacionar una Factura existente al Tramite'
                }
            );
            this.addButton('btnDelRel',
                {
                    text: 'Eliminar relación',
                    iconCls: 'bdel',
                    disabled: true,
                    handler: this.delRelacion,
                    tooltip: 'Permite eliminar la relacion entre el tramite y la factura'
                }
            );
        
        
			this.bloquearMenus();
		},

		Atributos : [{
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_doc_compra_venta'
			},
			type : 'Field',
			form : true
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'tipo'
			},
			type : 'Field',
			form : true
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'porc_descuento_ley',
				allowDecimals : true,
				decimalPrecision : 10
			},
			type : 'NumberField',
			form : true
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'porc_iva_cf',
				allowDecimals : true,
				decimalPrecision : 10
			},
			type : 'NumberField',
			form : true
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'porc_iva_df',
				allowDecimals : true,
				decimalPrecision : 10
			},
			type : 'NumberField',
			form : true
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'porc_it',
				allowDecimals : true,
				decimalPrecision : 10
			},
			type : 'NumberField',
			form : true
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'porc_ice',
				allowDecimals : true,
				decimalPrecision : 10
			},
			type : 'NumberField',
			form : true
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_depto_conta'
			},
			type : 'Field',
			form : true
		},
		{
			config : {
				name : 'desc_plantilla',
				fieldLabel : 'Tipo Documento',
				allowBlank : false,
				emptyText : 'Elija una plantilla...',
				gwidth : 250
			},
			type : 'Field',
			filters : {
				pfiltro : 'pla.desc_plantilla',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			bottom_filter : true,
			form : false
		}, {
			config : {
				name : 'desc_moneda',
				origen : 'MONEDA',
				allowBlank : false,
				fieldLabel : 'Moneda',
				gdisplayField : 'desc_moneda', //mapea al store del grid
				gwidth : 70,
				width : 250,
			},
			type : 'Field',
			id_grupo : 0,
			filters : {
				pfiltro : 'incbte.desc_moneda',
				type : 'string'
			},
			grid : true,
			form : false
		}, {
			config : {
				name : 'fecha',
				fieldLabel : 'Fecha',
				allowBlank : false,
				anchor : '80%',
				gwidth : 100,
				format : 'd/m/Y',
				readOnly : true,
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y') : ''
				}
			},
			type : 'DateField',
			filters : {
				pfiltro : 'dcv.fecha',
				type : 'date'
			},
			id_grupo : 0,
			grid : true,
			form : false
		}, {
			config : {
				name : 'nro_autorizacion',
				fieldLabel : 'Autorización',
				gwidth : 250,

			},
			type : 'Field',
			filters : {
				pfiltro : 'dcv.nro_autorizacion',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			bottom_filter : true,
			form : false
		}, {
			config : {
				name : 'nit',
				fieldLabel : 'NIT',
				qtip : 'Número de indentificación del proveedor',
				allowBlank : false,
				emptyText : 'nit ...',
				gwidth : 250
			},
			type : 'ComboBox',
			filters : {
				pfiltro : 'dcv.nit',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			bottom_filter : true,
			form : false
		}, {
			config : {
				name : 'razon_social',
				fieldLabel : 'Razón Social',
				gwidth : 100,
				maxLength : 180
			},
			type : 'TextField',
			filters : {
				pfiltro : 'dcv.razon_social',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			bottom_filter : true,
			form : false
		}, {
			config : {
				name : 'nro_documento',
				fieldLabel : 'Nro Doc',
				allowBlank : false,
				anchor : '80%',
				gwidth : 100,
				maxLength : 100
			},
			type : 'TextField',
			filters : {
				pfiltro : 'dcv.nro_documento',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			bottom_filter : true,
			form : false
		}, {
			config : {
				name : 'nro_dui',
				fieldLabel : 'DUI',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 16,
				minLength : 16
			},
			type : 'TextField',
			filters : {
				pfiltro : 'dcv.nro_dui',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			form : false
		}, {
			config : {
				name : 'codigo_control',
				fieldLabel : 'Código de Control',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 200
			},
			type : 'TextField',
			filters : {
				pfiltro : 'dcv.codigo_control',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			form : false
		}, {
			config : {
				name : 'obs',
				fieldLabel : 'Obs',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 400
			},
			type : 'TextArea',
			filters : {
				pfiltro : 'dcv.obs',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			bottom_filter : true,
			form : false
		}, {
			config : {
				name : 'importe_doc',
				fieldLabel : 'Monto',
				allowBlank : false,
				anchor : '80%',
				gwidth : 100,
				maxLength : 1179650,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_doc',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_descuento',
				fieldLabel : 'Descuento',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_descuento',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_neto',
				fieldLabel : 'Neto',
				allowBlank : false,
				anchor : '80%',
				gwidth : 100,
				maxLength : 1179650,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_doc',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_excento',
				fieldLabel : 'Excento',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_excento',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_pendiente',
				fieldLabel : 'Cuenta Pendiente',
				qtip : 'Usualmente una cuenta pendiente de  cobrar o  pagar (dependiendo si es compra o venta), posterior a la emisión del documento',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_pendiente',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_anticipo',
				fieldLabel : 'Anticipo',
				qtip : 'Importe pagado por anticipado al documento',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_anticipo',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_retgar',
				fieldLabel : 'Ret. Garantia',
				qtip : 'Importe retenido por garantia',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_retgar',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_descuento_ley',
				fieldLabel : 'Descuentos de Ley',
				allowBlank : true,
				readOnly : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_descuento_ley',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_ice',
				fieldLabel : 'ICE',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_ice',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_iva',
				fieldLabel : 'IVA',
				allowBlank : true,
				readOnly : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_iva',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_it',
				fieldLabel : 'IT',
				allowBlank : true,
				anchor : '80%',
				readOnly : true,
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_it',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_pago_liquido',
				fieldLabel : 'Liquido Pagado',
				allowBlank : true,
				readOnly : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_pago_liquido',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'estado',
				fieldLabel : 'Estado',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 30
			},
			type : 'TextField',
			filters : {
				pfiltro : 'dcv.estado',
				type : 'string'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'estado_reg',
				fieldLabel : 'Estado Reg.',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 10
			},
			type : 'TextField',
			filters : {
				pfiltro : 'dcv.estado_reg',
				type : 'string'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'usr_reg',
				fieldLabel : 'Creado por',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 4
			},
			type : 'Field',
			filters : {
				pfiltro : 'usu1.cuenta',
				type : 'string'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'fecha_reg',
				fieldLabel : 'Fecha creación',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				format : 'd/m/Y',
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y H:i:s') : ''
				}
			},
			type : 'DateField',
			filters : {
				pfiltro : 'dcv.fecha_reg',
				type : 'date'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'id_usuario_ai',
				fieldLabel : '',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 4
			},
			type : 'Field',
			filters : {
				pfiltro : 'dcv.id_usuario_ai',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : false,
			form : false
		}, {
			config : {
				name : 'usr_mod',
				fieldLabel : 'Modificado por',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 4
			},
			type : 'Field',
			filters : {
				pfiltro : 'usu2.cuenta',
				type : 'string'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'fecha_mod',
				fieldLabel : 'Fecha Modif.',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				format : 'd/m/Y',
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y H:i:s') : ''
				}
			},
			type : 'DateField',
			filters : {
				pfiltro : 'dcv.fecha_mod',
				type : 'date'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'usuario_ai',
				fieldLabel : 'Funcionaro AI',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 300
			},
			type : 'TextField',
			filters : {
				pfiltro : 'dcv.usuario_ai',
				type : 'string'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}],

		tam_pag : 50,
		title : 'Detalle de Rendición',
		ActSave : '../../sis_cuenta_documentada/control/RendicionDet/insertarRendicionDet',
		ActDel : '../../sis_cuenta_documentada/control/RendicionDet/eliminarRendicionDet',
		ActList : '../../sis_cuenta_documentada/control/RendicionDet/listarRendicionDet',
		id_store : 'id_rendicion_det',
		fields : [{name : 'id_rendicion_det',type : 'numeric'}, 
		          {name : 'id_cuenta_doc',type : 'numeric'}, 
		          {name : 'id_cuenta_doc_rendicion',type : 'numeric'}, 
		          {name : 'id_doc_compra_venta',type : 'string'}, 
		          {name : 'revisado',type : 'string'}, 
		          {name : 'movil',type : 'string'}, 
		          {name : 'tipo',type : 'string'}, 
		          {name : 'importe_excento',type : 'numeric'}, 
		          {name : 'id_plantilla',type : 'numeric'}, 
		          {name : 'fecha',type : 'date',dateFormat : 'Y-m-d'}, 
		          {name : 'nro_documento',type : 'string'}, 
		          {name : 'nit',type : 'string'}, 
		          {name : 'importe_ice',type : 'numeric'}, 
		          {name : 'nro_autorizacion',type : 'string'}, 
		          {name : 'importe_iva',type : 'numeric'}, 
		          {name : 'importe_descuento',type : 'numeric'}, 
		          {name : 'importe_doc',type : 'numeric'}, 
		          {name : 'sw_contabilizar',type : 'string'}, 
		          {name : 'tabla_origen',type : 'string'}, 
		          {name : 'estado',type : 'string'}, 
		          {name : 'id_depto_conta',type : 'numeric'}, 
		          {name : 'id_origen',type : 'numeric'}, 
		          {name : 'obs',type : 'string'}, 
		          {name : 'estado_reg',type : 'string'}, 
		          {name : 'codigo_control',type : 'string'}, 
		          {name : 'importe_it',type : 'numeric'}, 
		          {name : 'razon_social',type : 'string'}, 
		          {name : 'id_usuario_ai',type : 'numeric'}, 
		          {name : 'id_usuario_reg',type : 'numeric'}, 
		          {name : 'fecha_reg',type : 'date',dateFormat : 'Y-m-d H:i:s.u'}, 
		          {name : 'usuario_ai',type : 'string'}, 
				  {name : 'id_usuario_mod',type : 'numeric'}, 
				  {name : 'fecha_mod',type : 'date',dateFormat : 'Y-m-d H:i:s.u'}, 
				  {name : 'usr_reg',type : 'string'}, 
				  {name : 'usr_mod',type : 'string'}, 
				  {name : 'importe_pendiente',type : 'numeric'}, 
				  {name : 'importe_anticipo',type : 'numeric'}, 
				  {name : 'importe_retgar',type : 'numeric'}, 
				  {name : 'importe_neto',type : 'numeric'}, 
		          'tipo_reg','desc_depto', 'desc_plantilla', 'importe_descuento_ley', 'importe_pago_liquido', 'nro_dui', 'id_moneda', 'desc_moneda', 'id_auxiliar', 'codigo_auxiliar', 'nombre_auxiliar','tipo_cambio'],
		
	sortInfo : {
			field : 'id_rendicion_det',
			direction : 'ASC'
	},
	

	onButtonNew : function() {
			this.abrirFormulario('new',undefined, false)
	},

	onButtonEdit : function() {
			this.abrirFormulario('edit', this.sm.getSelected(), false)
	}, 
		
	
	
	successRep:function(resp){
        Phx.CP.loadingHide();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if(!reg.ROOT.error){
            this.reload();
            if(reg.ROOT.datos.observaciones){
               alert(reg.ROOT.datos.observaciones)
            }
           
        }else{
            alert('Ocurrió un error durante el proceso')
        }
	},
	
	onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams={id_cuenta_doc_rendicion: this.maestro.id_cuenta_doc};
		this.load({params:{start:0, limit:50}});
	},
		
		
	 abrirFormulario : function(tipo, record, readOnly) {
			//abrir formulario de solicitud
			var me = this;
			me.objSolForm = Phx.CP.loadWindows('../../../sis_cuenta_documentada/vista/rendicion_det/FormRendicionCD.php', 'Formulario de Rendición', {
				modal : true,
				width : '95%',
				height : '95%'
			}, {
				data : {
					objPadre : me,
					tipoDoc : me.tipoDoc,
					tipo_form : tipo,
					id_depto : me.maestro.id_depto_conta,
					id_cuenta_doc : me.maestro.id_cuenta_doc,
					datosOriginales : record,
					readOnly: readOnly
				},
				id_moneda_defecto : me.maestro.id_moneda,
				bsubmit: !readOnly
			}, this.idContenedor, 'FormRendicionCD');
	},
		
	
   showDoc:  function() {
        this.abrirFormulario('edit', this.sm.getSelected(), true);
   },
	modExcento : function () {
		var me = this;
		var simple = new Ext.FormPanel({
			labelWidth: 75, // label settings here cascade unless overridden
			frame:true,
			bodyStyle:'padding:5px 5px 0; background:linear-gradient(45deg, #a7cfdf 0%,#a7cfdf 100%,#23538a 100%);',
			width: 300,
			height:70,
			defaultType: 'textfield',
			items: [
				new Ext.form.ComboBox(
					{
						name: 'id_doc_compra_venta',
						fieldLabel: 'Facturas',
						allowBlank: false,
						emptyText:'Elija una plantilla...',
						store:new Ext.data.JsonStore(
							{
								url: '../../sis_contabilidad/control/DocCompraVenta/listarDocCompraVenta',
								id: 'id_doc_compra_venta',
								root:'datos',
								sortInfo:{
									field:'dcv.nro_documento',
									direction:'asc'
								},
								totalProperty:'total',
								fields: ['id_doc_compra_venta','revisado','nro_documento','nit',
									'desc_plantilla', 'desc_moneda','importe_doc','nro_documento',
									'tipo','razon_social','fecha'],
								remoteSort: true,
								baseParams:{par_filtro:'pla.desc_plantilla#dcv.razon_social#dcv.nro_documento#dcv.nit#dcv.importe_doc#dcv.codigo_control', id_periodo: me.maestro.id_periodo, isRendicionDet: 'si'},
							}),
						tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{razon_social}</b>,  NIT: {nit}</p><p>{desc_plantilla} </p><p ><span style="color: #F00000">Doc: {nro_documento}</span> de Fecha: {fecha}</p><p style="color: green;"> {importe_doc} {desc_moneda}  </p></div></tpl>',
						valueField: 'id_doc_compra_venta',
						hiddenValue: 'id_doc_compra_venta',
						displayField: 'desc_plantilla',
						gdisplayField:'nro_documento',
						listWidth:'401',
						forceSelection:true,
						typeAhead: false,
						triggerAction: 'all',
						lazyRender:true,
						mode:'remote',
						pageSize:20,
						queryDelay:500,
						gwidth: 250,
						minChars:2,
						resizable: true
					})
			]

		});
		this.excento_formulario = simple;

		var win = new Ext.Window({
			title: '<h1 style="height:20px; font-size:15px;"><p style="margin-left:30px;">Listar Facturas<p></h1>', //the title of the window
			width:320,
			height:150,
			//closeAction:'hide',
			modal:true,
			plain: true,
			items:simple,
			buttons: [{
				text:'<i class="fa fa-floppy-o fa-lg"></i> Guardar',
				scope:this,
				handler: function(){
					this.modificarNuevo(win);
				}
			},{
				text: '<i class="fa fa-times-circle fa-lg"></i> Cancelar',
				handler: function(){
					win.hide();
				}
			}]

		});
		win.show();

	},
	modificarNuevo : function (win) {
		if (this.excento_formulario.items.items[0].getValue() == '' || this.excento_formulario.items.items[0].getValue() == 0) {
			Ext.Msg.show({
				title:'<h1 style="font-size:15px;">Aviso!</h1>',
				msg: '<p style="font-weight:bold; font-size:12px;">Tiene que seleccionar una factura para continuar</p>',
				buttons: Ext.Msg.OK,
				width:320,
				height:150,
				icon: Ext.MessageBox.WARNING,
				scope:this
			});
		} else {
			this.guardarDetalles();
			win.hide();
		}

	},
	guardarDetalles : function(){
		var me = this;
		Ext.Ajax.request({
			url:'../../sis_cuenta_documentada/control/RendicionDet/getRendicionDet',
			params:{'id_doc_compra_venta' : this.excento_formulario.items.items[0].getValue()},
			success: function(resp){
				var reg =  Ext.decode(Ext.util.Format.trim(resp.responseText));
				var id_doc_compra_venta = this.excento_formulario.items.items[0].getValue();
				var revisado = reg.ROOT.datos.revisado;
				var movil = reg.ROOT.datos.movil;
				var tipo = reg.ROOT.datos.tipo;
				var importe_excento = reg.ROOT.datos.importe_excento;
				var id_plantilla = reg.ROOT.datos.id_plantilla;
				var nro_documento = reg.ROOT.datos.nro_documento;
				var nit = reg.ROOT.datos.nit;
				var importe_ice = reg.ROOT.datos.importe_ice;
				var nro_autorizacion = reg.ROOT.datos.nro_autorizacion;
				var importe_iva = reg.ROOT.datos.importe_iva;
				var importe_descuento = reg.ROOT.datos.importe_descuento;
				var importe_doc = reg.ROOT.datos.importe_doc;
				var sw_contabilizar = reg.ROOT.datos.sw_contabilizar;
				var tabla_origen = reg.ROOT.datos.tabla_origen;
				var estado = reg.ROOT.datos.estado;
				var id_depto_conta = reg.ROOT.datos.id_depto_conta;
				var id_origen = reg.ROOT.datos.id_origen;
				var obs = reg.ROOT.datos.obs;
				var estado_reg = reg.ROOT.datos.estado_reg;
				var codigo_control = reg.ROOT.datos.codigo_control;
				var importe_it = reg.ROOT.datos.importe_it ;
				var razon_social = reg.ROOT.datos.razon_social ;
				var id_usuario_ai = reg.ROOT.datos.id_usuario_ai ;
				var id_usuario_reg = reg.ROOT.datos.id_usuario_reg ;
				var usuario_ai = reg.ROOT.datos.usuario_ai ;
				var id_usuario_mod = reg.ROOT.datos.id_usuario_mod ;
				var usr_reg = reg.ROOT.datos.usr_reg ;
				var usr_mod = reg.ROOT.datos.usr_mod ;
				var importe_pendiente = reg.ROOT.datos.importe_pendiente ;
				var importe_anticipo = reg.ROOT.datos.importe_anticipo ;
				var importe_retgar = reg.ROOT.datos.importe_retgar ;
				var importe_neto = reg.ROOT.datos.importe_neto ;
				var desc_depto = reg.ROOT.datos.desc_depto ;
				var desc_plantilla = reg.ROOT.datos.desc_plantilla ;
				var importe_descuento_ley = reg.ROOT.datos.importe_descuento_ley ;
				var importe_pago_liquido = reg.ROOT.datos.importe_pago_liquido ;
				var nro_dui = reg.ROOT.datos.nro_dui ;
				var id_moneda = reg.ROOT.datos.id_moneda ;
				var desc_moneda = reg.ROOT.datos.desc_moneda ;
				var id_auxiliar = reg.ROOT.datos.id_auxiliar ;
				var codigo_auxiliar = reg.ROOT.datos.codigo_auxiliar ;
				var nombre_auxiliar = reg.ROOT.datos.nombre_auxiliar ;
				var id_tipo_doc_compra_venta = reg.ROOT.datos.id_tipo_doc_compra_venta ;
				var desc_tipo_doc_compra_venta = reg.ROOT.datos.desc_tipo_doc_compra_venta ;
				var fecha = reg.ROOT.datos.fecha ;
				var sb = {id: "39659",data:{id_rendicion_det: "39659",id_cuenta_doc: me.maestro.id_cuenta_doc,id_cuenta_doc_rendicion: "6843",id_doc_compra_venta: id_doc_compra_venta,revisado: revisado,movil: movil,tipo: "compra",importe_excento: importe_excento,id_plantilla: id_plantilla,nro_documento: nro_documento,nit: nit,importe_ice: importe_ice,nro_autorizacion: nro_autorizacion,importe_iva: importe_iva,importe_descuento: importe_descuento,importe_doc: importe_doc,sw_contabilizar: sw_contabilizar,tabla_origen: tabla_origen,estado: estado,id_depto_conta: id_depto_conta,id_origen: id_origen,obs: obs,estado_reg: estado_reg,codigo_control: codigo_control,importe_it: importe_it,razon_social: razon_social,id_usuario_ai: id_usuario_ai,id_usuario_reg: id_usuario_reg,usuario_ai: usuario_ai,id_usuario_mod: id_usuario_mod,usr_reg: usr_reg,usr_mod: usr_mod,importe_pendiente: importe_pendiente,importe_anticipo: importe_anticipo,importe_retgar: importe_retgar,importe_neto: importe_neto,tipo_reg: "",desc_depto: desc_depto,desc_plantilla: desc_plantilla,importe_descuento_ley: importe_descuento_ley,importe_pago_liquido: importe_pago_liquido,nro_dui: nro_dui,id_moneda: id_moneda,desc_moneda: desc_moneda,id_auxiliar: id_auxiliar,codigo_auxiliar: codigo_auxiliar,nombre_auxiliar: nombre_auxiliar,isNewRelationEditable:'si',fecha: fecha},json:{id_rendicion_det: "39659",id_cuenta_doc: me.maestro.id_cuenta_doc,id_cuenta_doc_rendicion: "6843",id_doc_compra_venta: id_doc_compra_venta,revisado: revisado,movil: movil,tipo: "compra",importe_excento: importe_excento,id_plantilla: id_plantilla,nro_documento: nro_documento,nit: nit,importe_ice: importe_ice,nro_autorizacion: nro_autorizacion,importe_iva: importe_iva,importe_descuento: importe_descuento,importe_doc: importe_doc,sw_contabilizar: sw_contabilizar,tabla_origen: tabla_origen,estado: estado,id_depto_conta: id_depto_conta,id_origen: id_origen,obs: obs,estado_reg: estado_reg,codigo_control: codigo_control,importe_it: importe_it,razon_social: razon_social,id_usuario_ai: id_usuario_ai,id_usuario_reg: id_usuario_reg,usuario_ai: usuario_ai,id_usuario_mod: id_usuario_mod,usr_reg: usr_reg,usr_mod: usr_mod,importe_pendiente: importe_pendiente,importe_anticipo: importe_anticipo,importe_retgar: importe_retgar,importe_neto: importe_neto,tipo_reg: "",desc_depto: desc_depto,desc_plantilla: desc_plantilla,importe_descuento_ley: importe_descuento_ley,importe_pago_liquido: importe_pago_liquido,nro_dui: nro_dui,id_moneda: id_moneda,desc_moneda: desc_moneda,id_auxiliar: id_auxiliar,codigo_auxiliar: codigo_auxiliar,nombre_auxiliar: nombre_auxiliar,id_tipo_doc_compra_venta: id_tipo_doc_compra_venta,desc_tipo_doc_compra_venta: desc_tipo_doc_compra_venta, fecha: fecha}};
				
				this.abrirFormulario('edit', sb, false)
			},
			failure: this.conexionFailure,
			timeout:this.timeout,
			scope:this
		});
	},
	delRelacion : function(){
		var rec = this.sm.getSelected();
		var data = rec.data;
		/*Recuperamos de la venta detalle si existe algun concepto con excento*/
		if (confirm('¿Esta seguro de eliminar el registro?')) {
			Ext.Ajax.request({
				url: '../../sis_cuenta_documentada/control/RendicionDet/eliminarRelacionDetalle',
				params: {
					'id_rendicion_det': data.id_rendicion_det
				},
				success: this.successExportHtml,
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope: this
			});
			this.reload();
		}
	}
		
})
</script>