create or replace procedure lab10DuplicateEmailCheck authid current_user as
begin
    -- Attempt to insert a Student record with a known duplicate email
    -- This will raise DUP_VAL_ON_INDEX because of the unique index on email
    insert into Student values ('21171371','Huang','Yeung Tai','ythuangab','55707669','2024',3.56,'MATH');

exception
    when DUP_VAL_ON_INDEX then
        dbms_output.put_line('### Tried to insert duplicate email into the Student table.');
end lab10DuplicateEmailCheck;

