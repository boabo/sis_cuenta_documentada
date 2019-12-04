<br><br><br>
<table width="90%" cellpadding="2px"  rules="cols" border="0" style="font-size: 10" border="0">
	<tbody>
	<tr>		
		<td width="80%" align="left"><span><b>A &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<?php echo $this->datos_detalle[0]["desc_funcionario"]?></span></td>				
	</tr>
	<tr>		
        <td width="80%" align="left"><span><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<?php echo $this->datos_detalle[0]["cargo_funcionario"]?></b></span></td>				
	</tr>
	<tr><br>		
		<td width="80%" align="left"><span><b>DE &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<?php echo $this->datos_detalle[0]["aprobador"]?></span></td>				
	</tr>
	<tr>		
        <td width="80%" align="left"><span><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<?php echo $this->datos_detalle[0]["cargo_aprobador"]?></b></span></td>				
	</tr>
	<tr><br>		
        <td width="80%" align="left"><span><b>Asunto: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ASIGNACION DE FONDOS EN AVANCE, &nbsp;&nbsp;<?php echo $this->datos_detalle[0]["nro_tramite"]?><br></b></span></td>				
	</tr>   
</tbody>
</table>
<?php echo '<hr style="width:95%; border: 2px solid orange;">' ?>

<table width="88%" cellpadding="5px"  rules="cols" style="font-size: 11;font-family: Calibri, sans-serif" border="0">
<?php echo "<br>" ?>
<?php echo "<br>" ?>
	<tbody> 
	<tr >
        <td width="3%"></td>		
		<td width="100%" align="justify"><?php echo $genero.$this->datos_detalle[0]["desc_funcionario"].': '?></td>				
	</tr>
	<tr>		
        <td width="3%"></td>		
		<td width="100%" align="justify">Tengo a bien comunicar a usted que ha sido <?php echo $desig ?> como responsable de la administración
        del fondo en avance asignado <?php echo $texto_memo?>.
        </td>				
	</tr>    
	<tr>
        <td width="3%"></td>				
		<td width="100%" align="justify" style="text-align: justify;">El importe asignado es de  <?php echo $cod_moneda.' '.$importe.'.- ('.$importe_literal.' '.$cod_moneda.'.)'.' según trámite '.$nro_tramite.', 
            comprobante Nro. '.$nro_cbte.' y número de cheque '.$nro_cheque ?>.
        </td>
	</tr>   
	<tr>		
        <td width="3%"></td>				    
        <td width="100%" align="justify">Recordarle que la entrega del memorándum de designación no implica la aprobación de los gastos efectuados.
        </td>				
	</tr>
	<tr>
        <td width="3%"></td>						
        <td width="100%" align="justify">El manejo operativo de estos fondos estará sujeto a Normativa Vigente y al Reglamento Interno de Fondos en Avance 
            aprobado mediante Resolución Administrativa de Directorio N° 20/2015, mismo que podrá ser consultado en la página 
            web:<span style="color:#1B4F72; text-decoration:underline;"> http://sms.obairlines.bo/IntranetDocumentos</span>
            (Sección Documentos - Gerencia Administrativa Financiera – Documentos Públicos-Reglamentos) o caso contrario solicitar 
            a la Unidad de Tesorería.
        </td>				
	</tr> 
    <tr>
        <td width="3%"></td>				    		
        <td width="100%" align="justify">A partir de la entrega de cheque, corren los 15 días hábiles para la rendición del fondo en avance.
        </td>				
	</tr>  
    <tr>
        <td width="3%"></td>				    		
        <td width="100%" align="justify">Sin otro particular, saludo a usted atentamente.</td>				
	</tr>
    <tr>
        <td width="3%"></td>
        <td width="100%" height="25%" align="justify"></td>				
	</tr>
    <?php if ($aprobador != null || $aprobador != ''){ ?> 
        <table>
            <tr>
            <td style="width: 25%"></td>
            <td style="width: 45%">
            <table cellspacing="0" cellpadding="1" border="1" style="font-family: Calibri; font-size: 9px;">
                <tr>            
                    <td style="font-family: Calibri; font-size: 9px;"><b> Aprobado por: &nbsp;</b><?php echo $aprobador?></td>
                </tr>
                <tr>
                    <td align="center" >
                        <br><br>
                        <img  style="width: 90px; height: 90px;" src="<?php echo $QR ?>" alt="Logo">
                        <br>
                    </td>
                </tr>
            </table>
        </td>
        <td style="width:15%;"></td>
        </tr>
        </table>
        <?php 
        }else {?> 
        <tr>
            <td width="20%" align="center"><br><br><br><br><br><br></td>
        </tr>
        <?php             
        }?>        				
    <tr style="font-size:6;">		
        <td width="3%" align="center"></td>
        <td width="20%" align="left">CC/ <br>C.c.Arch. <br>Memos</td>				
	</tr>                       
</tbody>
</table>