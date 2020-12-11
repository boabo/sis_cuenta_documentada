CREATE OR REPLACE FUNCTION cd.f_same_date_cd (
  p_fecha_entrega date,
  p_day integer
)
RETURNS date AS
$body$
DECLARE
  v_cd_dias_entrega	integer;
  v_day				integer;
  v_resp 			date;
  v_fecha			date;
BEGIN
	v_cd_dias_entrega = pxp.f_get_variable_global('cd_dias_entrega');

    FOR i in 1..50 LOOP

		IF( i = 1 )THEN
			 v_day = (p_fecha_entrega::date - (now()::date) + v_cd_dias_entrega + pxp.f_get_weekend_days(p_fecha_entrega::date, now()::date))::integer;
             v_fecha =  p_fecha_entrega;
        ELSE
        	 v_fecha = v_fecha - INTERVAL '1 days';
        	 v_day = (v_fecha::date - (now()::date) + v_cd_dias_entrega + pxp.f_get_weekend_days(v_fecha::date, now()::date))::integer;
        END IF;



     	IF (v_day = p_day) THEN
        	v_resp =  v_fecha;
        	exit;
        ELSE
        	v_resp = p_fecha_entrega;
        END IF;

    END LOOP;

    return v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

COMMENT ON FUNCTION cd.f_same_date_cd(p_fecha_entrega date, p_day integer)
IS 'Recupera la fecha:entrega segun la ampliacion de dias';
