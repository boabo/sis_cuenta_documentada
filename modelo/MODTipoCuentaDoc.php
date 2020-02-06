<?php
/**
*@package pXP
*@file gen-MODTipoCuentaDoc.php
*@author  (admin)
*@date 04-05-2016 20:13:26
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTipoCuentaDoc extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarTipoCuentaDoc(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_tipo_cuenta_doc_sel';
		$this->transaccion='CD_TCD_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_cuenta_doc','int4');
		$this->captura('codigo','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('nombre','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('codigo_plantilla_cbte','varchar');
        $this->captura('codigo_wf','varchar');
				$this->captura('sw_solicitud','varchar');
				$this->captura('estacion','varchar');
		$this->captura('tipo_rendicion','varchar');



		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarTipoCuentaDoc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_tipo_cuenta_doc_ime';
		$this->transaccion='CD_TCD_INS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo_plantilla_cbte','codigo_plantilla_cbte','varchar');
        $this->setParametro('codigo_wf','codigo_wf','varchar');
				$this->setParametro('sw_solicitud','sw_solicitud','varchar');
				$this->setParametro('estacion','estacion','varchar');
		$this->setParametro('tipo_rendicion','tipo_rendicion','varchar');


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarTipoCuentaDoc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_tipo_cuenta_doc_ime';
		$this->transaccion='CD_TCD_MOD';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_tipo_cuenta_doc','id_tipo_cuenta_doc','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo_plantilla_cbte','codigo_plantilla_cbte','varchar');
        $this->setParametro('codigo_wf','codigo_wf','varchar');
				$this->setParametro('sw_solicitud','sw_solicitud','varchar');
				$this->setParametro('estacion','estacion','varchar');
		$this->setParametro('tipo_rendicion','tipo_rendicion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarTipoCuentaDoc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_tipo_cuenta_doc_ime';
		$this->transaccion='CD_TCD_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_tipo_cuenta_doc','id_tipo_cuenta_doc','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	/*Aumentando para obtener el combo tipo de rendicion (Ismael Valdivia 16/01/2020)*/
	function listarTipoRendicion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_tipo_cuenta_doc_sel';
		$this->transaccion='CD_TREN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		$this->setParametro('id_tipo_cuenta_doc','id_tipo_cuenta_doc','int4');		

		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_rendicion','int4');
		$this->captura('tipo_rendicion','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('filtrar','varchar');


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	/*********************************************************************************/

}
?>
