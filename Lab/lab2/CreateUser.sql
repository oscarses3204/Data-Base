/* COMP 3311: Script to create a user in Oracle XE */

-- Allow users to be created without the C## prefix
alter session set "_ORACLE_SCRIPT"=true;

-- Create a user and grant required permissions
create user <username> identified by <password> default tablespace users quota unlimited on users;
grant create table, create session, create procedure to <username>;

-- Grant permissions for debugging procedures/functions
grant debug connect session, debug any procedure to <username>;
grant execute on DBMS_DEBUG_JDWP to <username>;

-- PL/SQL procedure to allow a debugging connection to Oracle XE
begin
  dbms_network_acl_admin.append_host_ace
  (host=>'127.0.0.1',
  ace=> sys.xs$ace_type(privilege_list=>sys.XS$NAME_LIST('JDWP') ,
  principal_name=>'<username>',
  principal_type=>sys.XS_ACL.PTYPE_DB) );
end;
/