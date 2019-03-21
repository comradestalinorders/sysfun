

--drop function sysusers();
--select users 
--DROP FUNCTION sysusers();
CREATE OR REPLACE FUNCTION sysusers()
 RETURNS table  (usysid oid, usename name)
 LANGUAGE sql
AS $function$
select  t.usesysid, t.usename
from pg_user t  order by t.usename;
$function$;

select * from sysusers();


--DROP FUNCTION sysuser_schema(text);
CREATE OR REPLACE FUNCTION sysuser_schema(inusername text)
 RETURNS table (nspname name, nspowner oid, nspacl aclitem[])
 LANGUAGE sql
AS $function$
select ns.nspname, ns.nspowner, ns.nspacl
from pg_namespace ns 
where 1=1  
and ns.nspowner = (select usesysid  
from pg_user 
where 1=1 
and upper(usename) = upper(inusername)) order by nspname;
$function$;

--select schmas for user
select * from sysuser_schema('pdv');


--DROP function sysuser_functions(nspowner oid);
CREATE OR REPLACE FUNCTION  sysuser_functions(nspowner oid)
 RETURNS table (procoid oid, proname name, pronamespace oid, proowner oid, prolang oid, procost real, prorows real, provariadic oid, 
 protransform regproc, proisagg boolean, proiswindow boolean, prosecdef boolean, proleakproof boolean, proisstrict boolean, proretset boolean, provolatile char, pronargs smallint, pronargsdefaults smallint,
 prorettype oid, proargtypes oidvector, proallargtypes oid [], proargmodes char [], proargnames text[], proargdefaults pg_node_tree, proscr text, probin text, proconfig text[],
 proacl aclitem [], nspname name, nspacl aclitem [] )
 LANGUAGE sql
AS $function$
select    p.oid procoid, p.*, n.nspname, n.nspacl
          from pg_proc p 
          join pg_namespace n on p.pronamespace = n.oid 
          where  1=1  
          and n.nspowner =  nspowner;
$function$;

--select user functions
--function arg types
select oidvectortypes(proargtypes) from sysuser_functions(10);

--get function definition for function oid
select * from pg_get_functiondef(122);



         
select row_to_json(t)
from (
select proargdefaults from sysuser_functions(10) where proargdefaults is not null
) t

