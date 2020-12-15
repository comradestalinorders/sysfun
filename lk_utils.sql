--Function: lk_utils.get_taxdoc_homeobj(ho_id numeric)

--DROP FUNCTION lk_utils.get_taxdoc_homeobj(ho_id numeric);

CREATE OR REPLACE FUNCTION lk_utils.get_taxdoc_homeobj(ho_id  numeric)
RETURNS TABLE 
(
  taxdoc_id  numeric,
  docno      text,
  partidano  text,
  user_id    numeric,
  docstatus  text
)
AS
$$
select td.taxdoc_id, td.docno, td.partidano, td.user_id, td.docstatus
from homeobj ho
join building b on b.building_id = ho.building_id
join property p on p.property_id = b.property_id
join taxdoc td on td.taxdoc_id = p.taxdoc_id
where ho.homeobj_id = ho_id limit 1;
$$
LANGUAGE 'sql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;

--Function: lk_utils.millis_to_timestamp(millis numeric)

--DROP FUNCTION lk_utils.millis_to_timestamp(millis numeric);

CREATE OR REPLACE FUNCTION lk_utils.millis_to_timestamp
(
  millis  numeric
)
RETURNS timestamp WITH TIME ZONE AS
$$
SELECT to_timestamp(millis / 1000) + ((millis % 1000 ) || ' milliseconds') :: INTERVAL
$$
LANGUAGE 'sql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;


--Function: lk_utils.date_to_millis(data date)

--DROP FUNCTION lk_utils.date_to_millis(data date);

CREATE OR REPLACE FUNCTION lk_utils.date_to_millis(data  date)
RETURNS numeric AS
$$
declare
begin
if(data is null) then  return 0; end if;
return 1;
end;
$$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;


--Function: public.log_modification()

--DROP FUNCTION public.log_modification();

CREATE OR REPLACE FUNCTION public.log_modification()
RETURNS trigger AS
$$
DECLARE
    v_old_data TEXT;
    v_new_data TEXT;
    v_id       INTEGER;
BEGIN
 
    /* This dance with casting the NEW and OLD values to a ROW is not necessary in pg 9.0+ */
    v_id = NextVal('s_logged_actions');
    IF (TG_OP = 'UPDATE') THEN
        v_old_data := ROW(OLD.*);
        v_new_data := ROW(NEW.*);
        INSERT INTO logged_actions (logged_action_id, table_name,user_id,kind_action,original_data,new_data) 
        VALUES (v_id, TG_TABLE_NAME::TEXT,1,substring(TG_OP,1,1),v_old_data,v_new_data);
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        v_old_data := ROW(OLD.*);
        INSERT INTO logged_actions (logged_action_id, table_name,user_id,kind_action,original_data,new_data) 
        VALUES (v_id, TG_TABLE_NAME::TEXT,1,substring(TG_OP,1,1),v_old_data,null);
        RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
        v_new_data := ROW(NEW.*);
        INSERT INTO logged_actions (logged_action_id, table_name,user_id,kind_action,original_data,new_data) 
        VALUES (v_id, TG_TABLE_NAME::TEXT,1,substring(TG_OP,1,1),null,v_new_data);
        RETURN NEW;
    ELSE
        RAISE WARNING 'Other action occurred: %, at %',TG_OP,now();
        RETURN NULL;
    END IF;
 
EXCEPTION
    WHEN data_exception THEN
        RAISE WARNING 'UDF ERROR [DATA EXCEPTION] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN unique_violation THEN
        RAISE WARNING 'UDF ERROR [UNIQUE] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE WARNING 'UDF ERROR [OTHER] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY DEFINER
COST 100;


  
  
  