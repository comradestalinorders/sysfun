
drop table db_transaction
drop table db_statement


create table db_transaction
(
 db_transaction_id numeric, 
 start_time numeric, 
 end_time numeric, 
 statements_cnt numeric, 
 user_id numeric
);

alter table db_transaction add column ip varchar;
alter table db_transaction add column stack varchar;

create table db_statement
(
   db_statement_id numeric,
   db_transaction_id numeric, 
   seqno numeric, 
   start_time numeric, 
   end_time numeric, 
   class_name varchar, 
   sql varchar
);


CREATE SEQUENCE public.s_db_statement
  START 1
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  CACHE 1;
  
  
  CREATE SEQUENCE public.s_db_transaction
  START 1
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  CACHE 1;