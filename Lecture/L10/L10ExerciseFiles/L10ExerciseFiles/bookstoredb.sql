/* Book Store Database */

drop table OrderDetails;
drop table BookOrder;
drop table Book;
drop table Author;
drop table Customer;

create table Author (
	authorId    smallint primary key,
	firstName   varchar(10) not null,
	lastName    varchar(15) not null
);

create table Book (
	bookId          smallint primary key,
	title           varchar(30) not null,
	subject			varchar(15) not null,
	quantityInStock smallint not null,
	price           numeric(5,2) not null,
	authorId        smallint not null,
	foreign key (authorId) references Author
);

create table Customer (
	customerId  smallint primary key,
	firstName   varchar(10) not null,
	lastName    varchar(15) not null,
    hkid        char(10) unique
);

create table BookOrder (
	orderId smallint primary key,
	customerId  smallint not null,
	orderYear   smallint not null,
	foreign key (customerId) references Customer
);

create table OrderDetails (
	orderId     smallint,
	bookId      smallint,
	format		varchar(10) not null,
	language	varchar(10) not null,
	quantity    smallint not null check (quantity>0),
	primary key (orderId,bookId),
	foreign key (orderId) references BookOrder,
	foreign key (bookId) references Book
);

insert into Author values (1,'Pied','Piper');
insert into Author values (2,'Donald','Green');
insert into Author values (3,'Hillary','Blue');
insert into Author values (4,'Dan','Brown');
insert into Author values (5,'Michael','Crichton');
insert into Author values (6,'Mark','Godin');
insert into Author values (7,'Eric','Ries');
insert into Author values (8,'Seth','Godin');
insert into Author values (9,'Kristin','Hannah');

insert into Book values (1,'The Art of Negotiating','Business',100,49.99,1);
insert into Book values (2,'Negotiating Art','Art',10,19.99,1);
insert into Book values (3,'Business Success','Business',120,9.99,2);
insert into Book values (4,'Appreciating Art','Art',10,8.99,3);
insert into Book values (5,'Inferno','Fiction',90,6.81,4);
insert into Book values (6,'Angels and Demons','Art',65,10.70,4);
insert into Book values (7,'Prey','Fiction',25,9.99,5);
insert into Book values (8,'Soul of a Nation','Art',15,39.95,6);
insert into Book values (9,'The Lean Startup','Business',40,28.00,7);
insert into Book values (10,'Purple Cow','Business',66,23.95,8);
insert into Book values (11,'Congo','Fiction',80,9.35,5);
insert into Book values (12,'Original Thinking','Business',105,18.00,4);
insert into Book values (13,'Origin of Art','Art',35,15.00,1);
insert into Book values (14,'Machinehood','Fiction',15,11.49,5);
insert into Book values (15,'Exodus Blue','Fiction',12,10.95,5);
insert into Book values (16,'Woman in Art','Art',7,24.95,3);
insert into Book values (17,'The Women','Fiction',42,14.99,9);

insert into Customer values (1,'Harry','Lee','L657189(6)');
insert into Customer values (2,'Sam','Lam','S681902(1)');
insert into Customer values (3,'Ron','Lee','R891234(0)');
insert into Customer values (4,'Andrew','Chu','A189235(2)');
insert into Customer values (5,'Carl','Ip','C361836(1)');
insert into Customer values (6,'Lily','Lee','P871234(5)');

insert into BookOrder values (1,1,2022);
insert into BookOrder values (2,1,2022);
insert into BookOrder values (3,1,2022);
insert into BookOrder values (4,1,2023);
insert into BookOrder values (5,1,2023);
insert into BookOrder values (6,2,2023);
insert into BookOrder values (7,3,2023);
insert into BookOrder values (8,4,2023);
insert into BookOrder values (9,4,2023);
insert into BookOrder values (10,3,2024);
insert into BookOrder values (11,5,2024);
insert into BookOrder values (12,1,2024);
insert into BookOrder values (13,5,2024);
insert into BookOrder values (14,3,2024);
insert into BookOrder values (15,2,2024);
insert into BookOrder values (16,3,2024);
insert into BookOrder values (17,1,2025);
insert into BookOrder values (18,1,2025);
insert into BookOrder values (19,2,2025);
insert into BookOrder values (20,1,2025);
insert into BookOrder values (21,3,2025);
insert into BookOrder values (22,4,2025);
insert into BookOrder values (23,1,2025);
insert into BookOrder values (24,5,2025);
insert into BookOrder values (25,6,2025);

insert into OrderDetails values (1,1,'hardcover','French',35);
insert into OrderDetails values (1,2,'softcover','Chinese',25);
insert into OrderDetails values (2,4,'hardcover','English',45); 
insert into OrderDetails values (3,7,'softcover','English',4);
insert into OrderDetails values (3,9,'hardcover','Chinese',10);
insert into OrderDetails values (3,10,'softcover','English',35);
insert into OrderDetails values (4,11,'softcover','Chinese',15);
insert into OrderDetails values (4,12,'hardcover','English',23);
insert into OrderDetails values (4,13,'hardcover','French',49);
insert into OrderDetails values (5,14,'hardcover','Chinese',12);
insert into OrderDetails values (5,15,'softcover','Chinese',17);
insert into OrderDetails values (6,1,'hardcover','English',145);
insert into OrderDetails values (6,9,'hardcover','French',37);
insert into OrderDetails values (6,10,'hardcover','English',122);
insert into OrderDetails values (7,7,'ebook','English',83);
insert into OrderDetails values (8,1,'softcover','English',3);
insert into OrderDetails values (8,3,'hardcover','English',77);
insert into OrderDetails values (8,6,'ebook','English',82);
insert into OrderDetails values (9,7,'hardcover','Chinese',160);
insert into OrderDetails values (9,10,'softcover','English',139);
insert into OrderDetails values (10,5,'hardcover','English',105);
insert into OrderDetails values (11,8,'ebook','French',37);
insert into OrderDetails values (11,4,'softcover','French',41);
insert into OrderDetails values (12,16,'softcover','French',16);
insert into OrderDetails values (12,3,'hardcover','English',49);
insert into OrderDetails values (12,1,'hardcover','French',83);
insert into OrderDetails values (13,1,'hardcover','French',52);
insert into OrderDetails values (13,9,'softcover','English',111);
insert into OrderDetails values (14,16,'hardcover','French',73);
insert into OrderDetails values (14,13,'ebook','French',40);
insert into OrderDetails values (15,10,'ebook','English',105);
insert into OrderDetails values (16,2,'softcover','Chinese',83);
insert into OrderDetails values (17,8,'softcover','Chinese',51);
insert into OrderDetails values (18,3,'hardcover','French',42);
insert into OrderDetails values (19,13,'softcover','Chinese',140);
insert into OrderDetails values (19,6,'hardcover','English',102);
insert into OrderDetails values (19,16,'hardcover','Chinese',28);
insert into OrderDetails values (19,1,'hardcover','French',32);
insert into OrderDetails values (20,5,'ebook','English',13);
insert into OrderDetails values (20,6,'ebook','French',49);
insert into OrderDetails values (21,15,'hardcover','French',89);
insert into OrderDetails values (21,5,'ebook','Chinese',111);
insert into OrderDetails values (22,8,'ebook','French',65);
insert into OrderDetails values (22,3,'softcover','English',132);
insert into OrderDetails values (22,14,'ebook','Chinese',53);
insert into OrderDetails values (23,1,'hardcover','English',42);
insert into OrderDetails values (23,3,'ebook','French',44);
insert into OrderDetails values (23,7,'softcover','English',52);
insert into OrderDetails values (24,3,'hardcover','French',162);
insert into OrderDetails values (24,16,'softcover','English',111);
insert into OrderDetails values (24,4,'hardcover','Chinese',70);
insert into OrderDetails values (25,5,'hardcover','English',25);
insert into OrderDetails values (25,7,'hardcover','English',25);
insert into OrderDetails values (25,16,'hardcover','English',1);
insert into OrderDetails values (25,4,'hardcover','English',2);
insert into OrderDetails values (25,8,'hardcover','English',5);

commit;