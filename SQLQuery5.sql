create table marks(
	id int not null PRIMARY KEY IDENTITY(1,2),
	name varchar(100) not null
);
insert into marks (name) values ('Dodge');
insert into marks (name) values ('Isuzu');
insert into marks (name) values ('Ford');
insert into marks (name) values ('Mitsubishi');
insert into marks (name) values ('Pontiac');
insert into marks (name) values ('GMC');
insert into marks (name) values ('Chevrolet');
insert into marks (name) values ('Lincoln');
insert into marks (name) values ('Plymouth');
insert into marks (name) values ('Lamborghini');
insert into marks (name) values ('Honda');
insert into marks (name) values ('Ford');
insert into marks (name) values ('Ford');
insert into marks (name) values ('Isuzu');
insert into marks (name) values ('Mercedes-Benz');
insert into marks (name) values ('Rolls-Royce');
insert into marks (name) values ('Subaru');
insert into marks (name) values ('Dodge');
insert into marks (name) values ('Land Rover');
insert into marks (name) values ('Ford');
insert into marks (name) values ('Saab');
insert into marks (name) values ('Nissan');
insert into marks (name) values ('Lotus');
insert into marks (name) values ('Mitsubishi');
insert into marks (name) values ('Mazda');
insert into marks (name) values ('Nissan');
insert into marks (name) values ('Honda');
insert into marks (name) values ('Cadillac');
insert into marks (name) values ('Ford');
insert into marks (name) values ('Isuzu');

Select * from marks



create table lines(
	id int not null PRIMARY KEY IDENTITY (1,2),
	name varchar(100) not null
);

insert into lines (name) values ('10.000.000');
insert into lines (name) values ('5.000.000');
insert into lines (name) values ('2.000.000');
insert into lines (name) values ('1.000.000');
insert into lines (name) values ('500.000');
insert into lines (name) values ('100.000');

Select * from lines

create table deposits(
	id int not null PRIMARY KEY IDENTITY(1,2),
	name varchar(200) not null
);
insert into deposits (name) values ('Automores');
insert into deposits (name) values (' taller');
insert into deposits (name) values ('Electronica');

Select * from deposits


create table products(
	id int not null PRIMARY KEY IDENTITY (1,2),
	name varchar(100) not null,
	description varchar(225) not null,
	unit_cost decimal not null,
	iva decimal not null,
	mark_id int not null FOREIGN KEY REFERENCES marks(id),
	line_id int not null  FOREIGN KEY REFERENCES lines(id)
);
insert into products(name,description,unit_cost,iva,mark_id,line_id)values('Filtro','Filtro de la marca Dodge','10.000','10',1,1)
select * from products

create table stocks(
	id int not null PRIMARY KEY IDENTITY (1,2),
	quantity  int not null,
	product_id int not null FOREIGN KEY REFERENCES products(id),
	deposit_id int not null FOREIGN KEY REFERENCES deposits(id)
);

insert into stocks(quantity,product_id,deposit_id)values(100,1,1)

create table providers(
	id int not null PRIMARY KEY IDENTITY(1,2),
	name varchar(255) not null , 
	address varchar(255) not null ,
	phone varchar(15) not null,
	email varchar(100) not null,
	credit_amount decimal not null
);
insert into providers(name,address,phone,email,credit_amount)
values('Sebastian ','Las palmereas ','0985777888','sncatro40@gmail.com',1000000)

insert into providers(name,address,phone,email,credit_amount)
values('Tobias ','calle los gladiadores ','0985235578','tobas40@gmail.com',2000000)

insert into providers(name,address,phone,email,credit_amount)
values('Andres ','calle ingeniero ','0985984673','andre89@gmail.com',500000)

Select * from providers

create table purchases(
	id int not null PRIMARY KEY IDENTITY(1,2),
	dat date not null,
	condition int not null,
	invoice_expiration date not null ,
	total decimal not null,
	total_iva decimal not null,
	provider_id int not null FOREIGN KEY REFERENCES providers (id),
	deposit_id int not null FOREIGN KEY REFERENCES deposits(id)
);

insert into purchases(dat,condition,invoice_expiration,total,total_iva,provider_id,deposit_id)
values('2022-07-08',10,'2022-07-20',1000000,1090909,1,1)

insert into purchases(dat,condition,invoice_expiration,total,total_iva,provider_id,deposit_id)
values('2022-12-08',15,'2022-12-20',1000000,1090909,1,1)

insert into purchases(dat,condition,invoice_expiration,total,total_iva,provider_id,deposit_id)
values('2022-11-10',20,'2022-07-20',1000000,1090909,1,1)

Select * from purchases

create table payments_orders(
	id int not null PRIMARY KEY IDENTITY(1,2),
	date date not null,
	total decimal not null
);

insert into payments_orders(date,total)
values('2022-07-20' ,10000000 )

insert into payments_orders(date,total)
values('2022-12-20' ,20000000 )

insert into payments_orders(date,total)
values('2022-09-20' ,5000000 )

insert into payments_orders(date,total)
values('2022-10-20' ,1000000 )

select * from payments_orders;

create table payment(
	id int not null PRIMARY KEY IDENTITY(1,2),
	payment_order_id int not null FOREIGN KEY REFERENCES payments_orders(id),
	purchase_id int not null FOREIGN KEY REFERENCES purchases(id),
	monto decimal not null 
);

insert into payment(payment_order_id,purchase_id,monto)
values(1,1,10000000)

insert into payment(payment_order_id,purchase_id,monto)
values(1,1,5000000)

insert into payment(payment_order_id,purchase_id,monto)
values(3,1,500000)

Select * from payment

create table pay_methods(
	id int not null PRIMARY KEY IDENTITY(1,2),
	name varchar(100) not null
)

Insert into pay_methods(name)
values('Credito'),('Contado')

create table pay_method_detail(
	id int not null PRIMARY KEY IDENTITY(1,2),
	pay_method_id int not null FOREIGN KEY REFERENCES pay_methods(id),
	payment_order_id int not null FOREIGN KEY REFERENCES  payments_orders(id),
	monto  decimal not null
)
Insert into pay_method_detail(pay_method_id,payment_order_id,monto)
values(1,1,500000) ,(1,1,1000000)


create table rol(id int not null PRIMARY KEY IDENTITY(1,2),
name varchar(100) not null
)

insert into rol(name)
values('administrador'),('Gerente'),('Mecanico'),('Secretario')
select * from rol
create table persons(
id int not null PRIMARY KEY IDENTITY(1,2),
name varchar(100) not null,
lastname varchar(100) not null,
rol_id int  not null FOREIGN KEY REFERENCES rol(id)
)

insert into persons (name,lastname,rol_id)
values('Gaston' , 'Castro' , 3),('Angel' , 'Castro' , 1),('Jose' , 'Estefano' , 7)

create table deposit_transfers(id int not null PRIMARY KEY IDENTITY(1,2),
origin_deposit_id int not null FOREIGN KEY REFERENCES deposits(id),
destination_deposit_id int not null FOREIGN KEY REFERENCES deposits(id),
manager_id int not null FOREIGN KEY REFERENCES persons(id),
authorization_id int not null FOREIGN KEY REFERENCES persons(id),
date date not null 			       
)

insert into deposit_transfers (origin_deposit_id,destination_deposit_id,manager_id,authorization_id,date)
values(1,3,1,1,'2022-05-07')

create table purchases_details(id int not null PRIMARY KEY IDENTITY(1,2),
			       product_id int not null FOREIGN KEY REFERENCES products(id),
			       purchase_id int not null foreign key references purchases(id),
			       quantity int not null,
			       unit_cost decimal not null,
			       iva decimal not null)

Select * from deposits ,persons


