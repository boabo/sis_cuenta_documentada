<?php
/**
*@package pXP
*@file CuentaDocVbContaCentral.php
*@author  Gonzalo Sarmiento
*@date 17-08-2016
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a rendiciones desde la oficina Central
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaDocVbContaCentral = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDoc.php',
	requireclase:'Phx.vista.CuentaDoc',
	title:'Cuenta Documentada',
	nombreVista: 'CuentaDocVbContaCentral',
	
	constructor: function(config) {
	   
	    //funcionalidad para listado de historicos
        this.historico = 'no';
        this.tbarItems = ['-',{
            text: 'Histórico',
            enableToggle: true,
            pressed: false,
            toggleHandler: function(btn, pressed) {
               
                if(pressed){
                    this.historico = 'si';
                     this.desBotoneshistorico();
                }
                else{
                   this.historico = 'no' 
                }
                
                this.store.baseParams.historico = this.historico;
                this.reload();
             },
            scope: this
           }, '-',this.cmbGestion,'-'];

        //Filtro por gestion
        if(this.nombreVista != 'solicitudApro'){
            Ext.Ajax.request({
                url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
                params:{fecha:new Date()},
                success:function(resp){
                    var reg =  Ext.decode(Ext.util.Format.trim(resp.responseText));
                    this.cmbGestion.setValue(reg.ROOT.datos.id_gestion);
                    this.cmbGestion.setRawValue(reg.ROOT.datos.anho);
                    this.store.baseParams.id_gestion=reg.ROOT.datos.id_gestion;
                    this.load({params:{start:0, limit:this.tam_pag}});
                },
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
        }
           
        var me = this;
		this.Atributos[this.getIndAtributo('importe')].config.renderer = function(value, p, record) {  
			    
				if (record.data.estado == 'vbrendicion') {
					var  saldo = me.roundTwo(record.data.importe_documentos) + me.roundTwo(record.data.importe_depositos) -  me.roundTwo(record.data.importe_retenciones);
			        saldo = me.roundTwo(saldo);
					return String.format("<b><font color = 'red'>Monto a Rendir: {0}</font></b><br>"+
										 "<b><font color = 'green' >En Documentos:{1}</font></b><br>"+
										 "<b><font color = 'green' >En Depositos:{2}</font></b><br>"+
										 "<b><font color = 'orange' >Retenciones de Ley:{3}</font></b>", saldo, record.data.importe_documentos, record.data.importe_depositos, record.data.importe_retenciones );
				} 
				else {
					return String.format('<font>Solicitado: {0}</font>', value);
				}
				
				

		};
	   
	   Phx.vista.CuentaDocVbContaCentral.superclass.constructor.call(this,config);
       this.init();
       
       this.addButton('onBtnRepSol', {
				grupo : [0,1,2,3],
				text : 'Reporte Sol.',
				iconCls : 'bprint',
				disabled : false,
				handler : this.onBtnRepSol,
				tooltip : '<b>Reporte de solicitud de fondos</b>'
		});
		
		this.addButton('onBtnMemo', {
				grupo : [0,1,2,3],
				text : 'Memo',
				iconCls : 'bprint',
				disabled : false,
				handler : this.onButtonMemoDesignacion,
				tooltip : '<b>Reporte de designaci�n</b>'
		});
		
		
       
		this.store.baseParams = { tipo_interfaz: this.nombreVista };
		
		if(config.filtro_directo){
           this.store.baseParams.filtro_valor = config.filtro_directo.valor;
           this.store.baseParams.filtro_campo = config.filtro_directo.campo;
        }
		//primera carga
		this.store.baseParams.pes_estado = 'borrador';
    	this.load({params:{start:0, limit:this.tam_pag}});

        this.cmbGestion.on('select',function(){

            this.store.baseParams.id_gestion = this.cmbGestion.getValue();
            if(!this.store.baseParams.id_gestion){
                delete this.store.baseParams.id_gestion;
            }
            this.reload();
        }, this);
		
		this.finCons = true;
   },
    cmbGestion: new Ext.form.ComboBox({
        fieldLabel: 'Gestion',
        allowBlank: true,
        emptyText:'Gestion...',
        store:new Ext.data.JsonStore(
            {
                url: '../../sis_parametros/control/Gestion/listarGestion',
                id: 'id_gestion',
                root: 'datos',
                sortInfo:{
                    field: 'gestion',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_gestion','gestion'],
                // turn on remote sorting
                remoteSort: true,
                baseParams:{par_filtro:'gestion'}
            }),
        valueField: 'id_gestion',
        triggerAction: 'all',
        displayField: 'gestion',
        hiddenName: 'id_gestion',
        mode: 'remote',
        pageSize: 50,
        queryDelay: 500,
        listWidth: '280',
        width: 80
    }),
   
    preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
      Phx.vista.CuentaDoc.superclass.preparaMenu.call(this,n); 
      this.getBoton('btnChequeoDocumentosWf').enable();
      this.getBoton('diagrama_gantt').enable();
      this.getBoton('btnObs').enable();
      this.getBoton('chkpresupuesto').enable(); 
      
      if(this.sw_solicitud == 'si'){
        this.getBoton('onBtnRepSol').enable(); 
      }
      else{
      	this.getBoton('onBtnRepSol').disable(); 
      }
      if(this.historico == 'no'){
          
         if(data.estado == 'anulado' || data.estado == 'finalizado' || data.estado == 'pendiente'|| data.estado == 'contabilizado'|| data.estado == 'rendido'){
                this.getBoton('ant_estado').disable();
                this.getBoton('sig_estado').disable();
         }
            
         if(data.estado != 'borrador' && data.estado !='anulado' && data.estado !='finalizado'&& data.estado !='pendiente' && data.estado !='contabilizado'&&data.estado != 'rendido'){
                this.getBoton('ant_estado').enable();
                this.getBoton('sig_estado').enable();
         }
      }     
      else{
          this.desBotoneshistorico();
      }   
      return tb 
   },
   
   liberaMenu:function(){
        var tb = Phx.vista.CuentaDoc.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('sig_estado').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('btnObs').disable();
            this.getBoton('onBtnRepSol').disable(); 
        }
        return tb
    },
    
    onButtonMemoDesignacion: function(){
                var rec=this.sm.getSelected();
                Ext.Ajax.request({
                    url:'../../sis_cuenta_documentada/control/CuentaDoc/reporteMemoDesignacion',
                    params: {'id_proceso_wf':rec.data.id_proceso_wf},
                    success: this.successExport,
                    failure: function() {
                        alert("fail");
                    },
                    timeout: function() {
                        alert("timeout");
                    },
                    scope:this
                });
        },
        
     
    
   tabsouth:[
	     {
	          url:'../../../sis_cuenta_documentada/vista/rendicion_det/RendicionDetTes.php',
	          title:'Facturas', 
	          height:'50%',
	          cls: 'RendicionDetTes'
         },
         {
			  url: '../../../sis_cuenta_documentada/vista/rendicion_det/CdDeposito.php',
			  title: 'Depositos',
			  height: '50%',
			  cls: 'CdDeposito'
		 }
	   ] 
};
</script>
