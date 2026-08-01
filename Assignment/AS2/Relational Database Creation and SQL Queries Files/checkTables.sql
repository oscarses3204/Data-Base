/* COMP 3311: checkTables.sql */

/*******************************************************************************
*                           >>>  IMPORTANT NOTE  <<<                           *
*  If each tuple in this script file can be successfully inserted into its     *
*  respective relation, then the relation has been defined correctly as to the *
*  number of the attributes and possibly the order and type of each attribute. *
*  However, the order and type of the attributes is not guaranteed to be       *
*  correct even if a tuple can be inserted successfully. Furthermore, the      *
*  tuples need to be inserted in the correct order and the order in which they *
*  appear in this script file is not necessarily the correct order in which    *
*  the relations should be created. The tuples may need to be reordered        *
*  according to your specified referential integrity constraints so that they  *
*  can be successfully inserted into the relations.                            *
*******************************************************************************/


/********** Movie relation **********/
insert into Movie values (1000,'movie title','movie synopsis','2022',120,'PG',10,1);

/********** MoviePerson relation **********/
insert into MoviePerson values (999,'name','biography','M','01-JAN-2000',null);

/********** AcademyAward relation **********/
insert into AcademyAward values (1,'Best Picture');

/********** AppearsIn relation  **********/
insert into AppearsIn values (1000,999,'role');

/********** AwardWin relation **********/
insert into AwardWin values (1000,999,1);

/********** CreditCard relation **********/
insert into CreditCard values ('000000000000000','Cardholder','Visa','000','01','2030');

/********** ReelflicsMember relation **********/
insert into ReelflicsMember values ('testuser','pseudonym','first','last','student','testuser@nomail.com','M','01-JAN-2000','00000000','none','000000000000000');

/********** Directs relation **********/
insert into Directs values (1000,999);

/********** Genre relation **********/
insert into Genre values (1000,'genre');

/********** Review relation **********/
insert into Review values (1000,'testuser','review title',5,'review text','01-JAN-2026');

/********** StreamingHistory relation **********/
insert into StreamingHistory values (1000,'testuser','01-JAN-2026');

/********** WatchList relation **********/
insert into WatchList values (1000,'testuser');