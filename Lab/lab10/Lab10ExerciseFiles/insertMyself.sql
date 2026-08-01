insert into Student values ('21171371','Huang','Yeung Tai','ythuangab','55707669','2024',3.56,'MATH');

insert into EnrollsIn values ('21171371', 'COMP 3311', 95.6);
insert into EnrollsIn values ('21171371', 'COMP 4021', 88.3);
insert into EnrollsIn values ('21171371', 'ELEC 3100', 93.1);
insert into EnrollsIn values ('21171371', 'HUMA 1020', 88.4);
insert into EnrollsIn values ('21171371', 'MATH 2421', 90.5);

-- Create a unique index on the email attribute of the Student table
create unique index email_unique_idx on Student(email);

commit;
