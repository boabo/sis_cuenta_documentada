<br><br><br>
<table width="100%" style="width: 100%; text-align: center;" cellspacing="0" cellpadding="1" border="1">
	<tbody>
	<tr>
		<td style="width: 28%; color: #444444; " rowspan="4">
			 &nbsp;<br/>
			<img  style="width: 110px;" src="./../../../lib/imagenes/logos/logo.jpg" alt="Logo">
		</td>		
		<td style="width: 45%; color: black; font-size:130%;" rowspan="3"><h1><?php  echo $titulo1?></h1></td>
		<td style="width: 23%; color: #444444;">R-GG-08 <?php echo '<br>' ?> Rev. 1-Sep/2012</td>
	</tr>	
    <?php if ($this->datos_detalle[0]["num_memo"] != null || $this->datos_detalle[0]["num_memo"] != '') {?>
        <tr>
		    <td style="width: 23%; color: #444444;" ><b>N°:</b> <?php echo $this->datos_detalle[0]["num_memo"]?> </td>
        </tr>
    <?php }else{?>
        <tr >
            <td style="width: 23%; color: #444444;" align="left"><b>&nbsp;&nbsp;&nbsp;N°:</b><br></td>
        </tr> 
    <?php 
    }?>
    <?php if ($newDate != null || $newDate != '') {?>
        <tr>		
            <td style="width: 23%; color: #444444;"><b>Fecha:</b> <?php  echo $newDate; ?></td>
        </tr>
    <?php }else{ ?>
    	<tr>		
		    <td style="width: 23%; color: #444444;" align="left"><b>&nbsp;&nbsp;&nbsp;Fecha:</b></td>
	    </tr>
    <?php 
    }?>

</tbody>
</table>