
/***********************************I-SCP-RAC-CD-1-04/05/2016****************************************/


CREATE TABLE cd.ttipo_cuenta_doc (
  id_tipo_cuenta_doc SERIAL NOT NULL,
  codigo VARCHAR(100),
  nombre VARCHAR(500),
  descripcion VARCHAR,
  PRIMARY KEY(id_tipo_cuenta_doc)
) INHERITS (pxp.tbase)

WITH (oids = false);


CREATE TABLE cd.ttipo_categoria (
  id_tipo_categoria SERIAL NOT NULL,
  codigo VARCHAR(100),
  nombre VARCHAR(400),
  PRIMARY KEY("id_tipo_categoria")
) INHERITS (pxp.tbase)

WITH (oids = false);

CREATE TABLE cd.tcategoria (
  id_categoria SERIAL NOT NULL,
  id_tipo_categoria INTEGER,
  id_moneda INTEGER,
  codigo VARCHAR(100) NOT NULL,
  nombre VARCHAR(400),
  monto NUMERIC(18,2),
  PRIMARY KEY(id_categoria)
) INHERITS (pxp.tbase)

WITH (oids = false);

CREATE TABLE cd.tcuenta_doc (
  id_cuenta_doc SERIAL,
  id_tipo_cuenta_doc INTEGER NOT NULL,
  id_funcionario INTEGER NOT NULL,
  id_depto INTEGER NOT NULL,
  id_uo INTEGER NOT NULL,
  id_moneda INTEGER NOT NULL,
  id_proceso_wf INTEGER NOT NULL,
  id_estado_wf INTEGER NOT NULL,
  id_caja INTEGER,
  id_cuenta_doc_fk INTEGER,
  tipo_pago VARCHAR,
  fecha DATE NOT NULL,
  nro_tramite VARCHAR(150) NOT NULL,
  estado VARCHAR(100) NOT NULL,
  sw_modo VARCHAR(40) DEFAULT 'cheque'::character varying NOT NULL,
  nombre_cheque VARCHAR(300),
  motivo VARCHAR NOT NULL,
  CONSTRAINT tcuenta_doc_pkey PRIMARY KEY(id_cuenta_doc)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN cd.tcuenta_doc.sw_modo
IS 'Deshabilitado...';


ALTER TABLE cd.tcuenta_doc
  ALTER COLUMN tipo_pago SET DEFAULT 'cheque';

ALTER TABLE cd.tcuenta_doc
  ALTER COLUMN tipo_pago SET NOT NULL;
  

COMMENT ON COLUMN cd.tcuenta_doc.id_depto
IS 'depato de obligacion de pago';


ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_depto_lb INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_depto_lb
IS 'depto de libro de bancos de donde se ara la tranaferencia o cheque';


COMMENT ON COLUMN cd.tcuenta_doc.tipo_pago
IS 'cheque, transferencia, caja, define de que forma de ara el pago';  


ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_funcionario_cuenta_bancaria INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_funcionario_cuenta_bancaria
IS 'en caso de transferencia describe la cuenta bancaria destino';


--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN importe NUMERIC(2,0) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN cd.tcuenta_doc.importe
IS 'importe para ser entregado';


ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_funcionario_gerente INTEGER NOT NULL;

COMMENT ON COLUMN cd.tcuenta_doc.id_funcionario_gerente
IS 'funcionario encargado de aprobar';


ALTER TABLE cd.tcuenta_doc
  ALTER COLUMN importe DROP DEFAULT;

ALTER TABLE cd.tcuenta_doc
  ALTER COLUMN importe TYPE NUMERIC(12,2);

ALTER TABLE cd.tcuenta_doc
  ALTER COLUMN importe SET DEFAULT 0;

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_depto_conta INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_depto_conta
IS 'idnetifica el depatamento de conta donde se contabiliza';

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_cuenta_bancaria INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_cuenta_bancaria
IS 'cuenta bancaria  con la que se paga';


ALTER TABLE cd.ttipo_cuenta_doc
  ADD COLUMN codigo_wf VARCHAR(100);

COMMENT ON COLUMN cd.ttipo_cuenta_doc.codigo_wf
IS 'codigo del proceso de wf correspondiente';


ALTER TABLE cd.ttipo_cuenta_doc
  ADD COLUMN codigo_plantilla_cbte VARCHAR(100);

COMMENT ON COLUMN cd.ttipo_cuenta_doc.codigo_plantilla_cbte
IS 'codigo de la plantilla de comprobante';

--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_gestion INTEGER;

--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_int_comprobante INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_int_comprobante
IS 'cbte asociado';

--------------- SQL ---------------

CREATE TABLE cd.trendicion_det (
  id_rendicion_det SERIAL NOT NULL,
  id_doc_compra_venta INTEGER NOT NULL,
  id_cuenta_doc INTEGER NOT NULL,
  id_cuenta_doc_rendicion INTEGER,
  PRIMARY KEY(id_rendicion_det)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN cd.trendicion_det.id_cuenta_doc
IS 'cuenta doc a la que pertenece la factura rendicida';

COMMENT ON COLUMN cd.trendicion_det.id_cuenta_doc_rendicion
IS 'agrupador de la rendicion';


--------------- SQL ---------------

ALTER TABLE cd.ttipo_cuenta_doc
  ADD COLUMN sw_solicitud VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN cd.ttipo_cuenta_doc.sw_solicitud
IS 'marca los tipo que son solitud';

/***********************************F-SCP-CD-ADQ-1-04/05/2016****************************************/


/***********************************I-SCP-CD-RAC-1-24/05/2016****************************************/


--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_cuenta_bancaria_mov INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_cuenta_bancaria_mov
IS 'hace referencia en pago de regionales, (depto LB con prioridad = 2),  al deposito de libro de bancos de donde se originan los fondos';

--------------- SQL ---------------

CREATE TABLE cd.tbloqueo_cd (
  id_bloqueo_cd SERIAL NOT NULL,
  id_tipo_cuenta_doc INTEGER,
  id_funcionario INTEGER,
  estado VARCHAR(40) DEFAULT 'bloqueado' NOT NULL,
  PRIMARY KEY(id_bloqueo_cd)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN cd.tbloqueo_cd.estado
IS 'bloqueado o autorizado';


--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN nro_correspondencia VARCHAR(300);
  
  --------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN fecha_entrega DATE DEFAULT now() NOT NULL;

COMMENT ON COLUMN cd.tcuenta_doc.fecha_entrega
IS 'fecha a partir de la cual corren los dias para hacer la rendicion';

--------------- SQL ---------------



ALTER TABLE cd.tcuenta_doc
  ADD COLUMN sw_max_doc_rend VARCHAR(10) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN cd.tcuenta_doc.sw_max_doc_rend
IS 'por defecto no permite que se sobre pase el maximo valor configurador en variable globarl para el registro de documentos en rendicion';



--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN num_memo VARCHAR(200);

COMMENT ON COLUMN cd.tcuenta_doc.num_memo
IS 'nro de memo de asignacion de fondos se creea al validar el cbte contable';


--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN num_rendicion VARCHAR(20);

COMMENT ON COLUMN cd.tcuenta_doc.num_rendicion
IS 'numera el correlativo';

--------------- SQL ---------------



ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_usuario_reg_ori INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_usuario_reg_ori
IS 'almacena el usuario que registro originalmente, solo en caso de que sea cambio el usuaario que debe regitrar la rendiciones';


--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN presu_comprometido VARCHAR(3) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN cd.tcuenta_doc.presu_comprometido
IS 'indica si el presupeusto ya se encuentra comprometido';


--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN importe_total_rendido NUMERIC(32,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN cd.tcuenta_doc.importe_total_rendido
IS 'importe rendido, solo en solicitudesse llena cuando las rendiciones son finalizadas, peude llegar a ser negativo si se rinde mas de lo solicitado';


/***********************************F-SCP-CD-RAC-1-24/05/2016****************************************/






/***********************************I-SCP-CD-GSS-1-14/06/2017****************************************/

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_funcionario_aprobador INTEGER;
   

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_periodo INTEGER;

/***********************************F-SCP-CD-GSS-1-14/06/2017****************************************/

/***********************************I-SCP-CD-MAY-0-29/08/2018****************************************/
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN tipo_rendicion VARCHAR(50);

COMMENT ON COLUMN cd.tcuenta_doc.tipo_rendicion
IS 'rendir y rendir/reponer';
/***********************************F-SCP-CD-MAY-0-29/08/2018****************************************/


/***********************************I-SCP-CD-AKFG-0-29/11/2019****************************************/

--patch fondos en avance
COMMENT ON FUNCTION cd.trig_tcuenta_doc()
IS 'funcion que devuelve un tringger de la tabla tcuenta_doc';
COMMENT ON FUNCTION cd.ft_tipo_cuenta_doc_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla cd.ttipo_cuenta_doc';
COMMENT ON FUNCTION cd.ft_tipo_cuenta_doc_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla cd.ttipo_cuenta_doc';
COMMENT ON FUNCTION cd.ft_tipo_categoria_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla cd.ttipo_categoria';
COMMENT ON FUNCTION cd.ft_tipo_categoria_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla cd.ttipo_categoria';
COMMENT ON FUNCTION cd.ft_rendicion_det_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla cd.trendicion_det';
COMMENT ON FUNCTION cd.ft_rendicion_det_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla cd.trendicion_det';
COMMENT ON FUNCTION cd.ft_cuenta_doc_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla cd.tcuenta_doc';
COMMENT ON FUNCTION cd.ft_cuenta_doc_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla cd.tcuenta_doc';
COMMENT ON FUNCTION cd.ft_categoria_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla cd.tcategoria';
COMMENT ON FUNCTION cd.ft_categoria_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla cd.tcategoria';
COMMENT ON FUNCTION cd.ft_bloqueo_cd_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla cd.tbloqueo_cd';
COMMENT ON FUNCTION cd.ft_bloqueo_cd_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla cd.tbloqueo_cd';
COMMENT ON FUNCTION cd.f_validar_documentos(p_id_usuario integer, p_id_cuenta_doc integer)
IS 'esta funcion reliza validacion en el registro de documentos y facturas ';
COMMENT ON FUNCTION cd.f_lista_funcionario_gerente_cd_wf_sel(p_id_usuario integer, p_id_tipo_estado integer, p_fecha date, p_id_estado_wf integer, p_count boolean, p_limit integer, p_start integer, p_filtro varchar)
IS 'funcion que lista los fucionarios gerente de tesoreria a partir del id_Estado_wf del plan de pagos';
COMMENT ON FUNCTION cd.f_lista_depto_conta_wf_sel(p_id_usuario integer, p_id_tipo_estado integer, p_fecha date, p_id_estado_wf integer, p_count boolean, p_limit integer, p_start integer, p_filtro varchar)
IS 'funcion que lista los departamentos de tesoreria que coinciden con la EP y UP de la cotizacion adjudicada';
COMMENT ON FUNCTION cd.f_gestionar_presupuesto_cd(p_id_cuenta_doc integer, p_id_usuario integer, p_operacion varchar, p_conexion varchar)
IS 'Esta funcion gestion el presupeusto para las cuentas documentadas';
COMMENT ON FUNCTION cd.f_gestionar_cbte_cuenta_doc_eliminacion(p_id_usuario integer, p_id_usuario_ai integer, p_usuario_ai varchar, p_id_int_comprobante integer, p_conexion varchar)
IS 'Esta funcion retrocede el estado de los planes de pago cuando los comprobantes son eliminados';
COMMENT ON FUNCTION cd.f_gestionar_cbte_cuenta_doc(p_id_usuario integer, p_id_usuario_ai integer, p_usuario_ai varchar, p_id_int_comprobante integer, p_conexion varchar)
IS 'Esta funcion gestiona los cbtes de cuenta_documentada cuando son validados';
COMMENT ON FUNCTION cd.f_gestionar_cbte_cd_prevalidacion(p_id_usuario integer, p_id_usuario_ai integer, p_usuario_ai varchar, p_id_int_comprobante integer, p_conexion varchar)
IS 'Esta funcion revierte el presupeusto comprometido en las facturas rendidas';
COMMENT ON FUNCTION cd.f_fun_regreso_cuenta_doc_wf(p_id_usuario integer, p_id_usuario_ai integer, p_usuario_ai varchar, p_id_estado_wf integer, p_id_proceso_wf integer, p_codigo_estado varchar)
IS 'funcion que actualiza los estados despues del registro de un retroceso en la cuenta documentada';
COMMENT ON FUNCTION cd.f_fun_inicio_cuenta_doc_wf(p_id_usuario integer, p_id_usuario_ai integer, p_usuario_ai varchar, p_id_estado_wf integer, p_id_proceso_wf integer, p_codigo_estado varchar, p_id_depto_lb integer, p_id_cuenta_bancaria integer, p_id_depto_conta integer, p_estado_anterior varchar, p_id_cuenta_bancaria_mov integer)
IS 'funcion que actualiza los estados despues del registro de estado en cuenta ddocumentada';
COMMENT ON FUNCTION cd.f_fondos_abiertos(p_id_auxiliar integer, p_id_tabla integer, p_tabla varchar, p_id_tipo_estado_cuenta integer, p_desde date, p_hasta date)
IS 'esta funcion es hecha para el estado de cuenta de proveedores
busca todos los pagos pendientes en tesoeria para el proveedor
los parametors de entrada son
    p_id_auxiliar integer,
    p_id_tabla integer,
    p_tabla varchar,
    p_id_tipo_estado_cuenta integer,
    p_desde date,
    p_hasta date

retorna array numeric

   [1]  moneda base
   [2]  moneda triangulacion';

--tablas



COMMENT ON TABLE cd.tcuenta_doc
IS 'Esta tabla contiene informacion del usuario y el tipo de fondo en avance que solicito un funcionario
asi como el estado en el que se encuentra el fondo en avance';
COMMENT ON COLUMN cd.tcuenta_doc.id_depto
IS 'depto de obligacion de pago';
COMMENT ON COLUMN cd.tcuenta_doc.id_moneda
IS 'identificador de la moneda solicitada para el fondo en avance';
COMMENT ON COLUMN cd.tcuenta_doc.id_proceso_wf
IS 'identificador del proceso del workflow';
COMMENT ON COLUMN cd.tcuenta_doc.tipo_pago
IS 'cheque, transferencia, caja, define de que forma de ara el pago';
COMMENT ON COLUMN cd.tcuenta_doc.estado
IS 'estado en el que se encuentra el fondo en avance solicitado';
COMMENT ON COLUMN cd.tcuenta_doc.sw_modo
IS 'Deshabilitado...';
COMMENT ON COLUMN cd.tcuenta_doc.nombre_cheque
IS 'nombre al que va destinado el cheque';
COMMENT ON COLUMN cd.tcuenta_doc.motivo
IS 'motivo de solicitud del fondo en avance';
COMMENT ON COLUMN cd.tcuenta_doc.id_depto_lb
IS 'depto de libro de bancos de donde se ara la tranaferencia o cheque';
COMMENT ON COLUMN cd.tcuenta_doc.id_funcionario_cuenta_bancaria
IS 'en caso de transferencia describe la cuenta bancaria destino';
COMMENT ON COLUMN cd.tcuenta_doc.importe
IS 'importe para ser entregado';
COMMENT ON COLUMN cd.tcuenta_doc.id_funcionario_gerente
IS 'funcionario encargado de aprobar';
COMMENT ON COLUMN cd.tcuenta_doc.id_depto_conta
IS 'idnetifica el depatamento de conta donde se contabiliza';
COMMENT ON COLUMN cd.tcuenta_doc.id_cuenta_bancaria
IS 'cuenta bancaria  con la que se paga';
COMMENT ON COLUMN cd.tcuenta_doc.id_int_comprobante
IS 'cbte asociado';
COMMENT ON COLUMN cd.tcuenta_doc.id_cuenta_bancaria_mov
IS 'hace referencia en pago de regionales, (depto LB con prioridad = 2),  al deposito de libro de bancos de donde se originan los fondos';
COMMENT ON COLUMN cd.tcuenta_doc.fecha_entrega
IS 'fecha a partir de la cual corren los dias para hacer la rendicion';
COMMENT ON COLUMN cd.tcuenta_doc.sw_max_doc_rend
IS 'por defecto no permite que se sobre pase el maximo valor configurador en variable globarl para el registro de documentos en rendicion';
COMMENT ON COLUMN cd.tcuenta_doc.num_memo
IS 'nro de memo de asignacion de fondos se creea al validar el cbte contable';
COMMENT ON COLUMN cd.tcuenta_doc.num_rendicion
IS 'numera el correlativo';
COMMENT ON COLUMN cd.tcuenta_doc.id_usuario_reg_ori
IS 'almacena el usuario que registro originalmente, solo en caso de que sea cambio el usuaario que debe regitrar la rendiciones';
COMMENT ON COLUMN cd.tcuenta_doc.presu_comprometido
IS 'indica si el presupeusto ya se encuentra comprometido';
COMMENT ON COLUMN cd.tcuenta_doc.importe_total_rendido
IS 'importe rendido, solo en solicitudesse llena cuando las rendiciones son finalizadas, peude llegar a ser negativo si se rinde mas de lo solicitado';
COMMENT ON COLUMN cd.tcuenta_doc.tipo_rendicion
IS 'rendir y rendir/reponer';

COMMENT ON TABLE cd.ttipo_cuenta_doc
IS 'Esta tabla contiene informacion del tipo de solicitud para el fondo en avance asi como el codigo
para la generacion del comprobante ';
COMMENT ON COLUMN cd.ttipo_cuenta_doc.codigo
IS
COMMENT ON COLUMN cd.ttipo_cuenta_doc.nombre
IS 'nombre del tipo de cuenta de solicitud de fondos en avance';
COMMENT ON COLUMN cd.ttipo_cuenta_doc.descripcion
IS 'descripcion del fondo en avance';
COMMENT ON COLUMN cd.ttipo_cuenta_doc.codigo_wf
IS 'codigo del proceso de wf correspondiente';
COMMENT ON COLUMN cd.ttipo_cuenta_doc.codigo_plantilla_cbte
IS 'codigo de la plantilla de comprobante';
COMMENT ON COLUMN cd.ttipo_cuenta_doc.sw_solicitud
IS 'marca los tipo que son solitud';

COMMENT ON TABLE cd.trendicion_det
IS 'esta tabla contiene informacion de la rendicion de cuentas del fondo en avance
como ser el documento de compra y venta ';
COMMENT ON COLUMN cd.trendicion_det.id_doc_compra_venta
IS 'identificador de los documentos de compra y venta';
COMMENT ON COLUMN cd.trendicion_det.id_cuenta_doc
IS 'cuenta doc a la que pertenece la factura rendicida';
COMMENT ON COLUMN cd.trendicion_det.id_cuenta_doc_rendicion
IS 'agrupador de la rendicion';

COMMENT ON TABLE cd.tdeposito_cd
IS 'Esta tabla contiene de saldos a favor depositados en una cuenta bancaria y el libro de bancos del cual se hizo
el retiro del fondo en avance  ';
COMMENT ON COLUMN cd.tdeposito_cd.id_libro_bancos
IS 'identificador del libro de bancos al cual se realizo el deposito del saldo del fondo en avance';
COMMENT ON COLUMN cd.tdeposito_cd.importe_contable_deposito
IS 'importe del saldo del fondo en avance depositado al banco correspondiente';

COMMENT ON TABLE cd.tcategoria
IS 'contiene informacion de las configuraciones del fondo en avances';

COMMENT ON TABLE cd.tbloqueo_cd
IS 'Esta tabla contiene informacion de los usuarios que bloquearon la rendicion de cuentas
para el fondo en avance solicitado, al no haber cumplido con la fecha para relizar
su rendicione en efectivo';
COMMENT ON COLUMN cd.tbloqueo_cd.id_funcionario
IS 'identificador del usuario con el fondo en avance bloqueado por no rendir cuentas en el plazo establecido';
COMMENT ON COLUMN cd.tbloqueo_cd.estado
IS 'bloqueado o autorizado';

/***********************************F-SCP-CD-AKFG-0-29/11/2019****************************************/

/***********************************I-SCP-CD-MAY-0-30/11/2019****************************************/
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_int_comprobante_reposicion INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_int_comprobante_reposicion
IS 'id del comprobante cuando este tiene la opcion de tipo_rendicion rendir_reponer';
/***********************************F-SCP-CD-MAY-0-18/09/2019****************************************/

