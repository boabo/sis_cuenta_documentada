

/***********************************I-DAT-RAC-ADQ-0-05/05/2016*****************************************/


/* Data for the 'segu.tsubsistema' table  (Records 1 - 1) */

INSERT INTO segu.tsubsistema ("codigo", "nombre", "fecha_reg", "prefijo", "estado_reg", "nombre_carpeta")
VALUES 
  (E'CD', E'Cuenta Documenta', E'2016-05-04', E'CD', E'activo', E'cuenta_documentada');
  

/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'cd_codigo_macro_fondo_avance', E'FA', E'codigo de proceso marcro para fondos en avance');  


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'cd_limite_fondos', E'3', E'numero de solicitudes de fondo en avances donde se bloquea la solicitud');



/***********************************F-DAT-RAC-ADQ-0-05/05/2016*****************************************/

