CREATE DATABASE tallerMecanico
create table purchase_details(
	id int not null PRIMARY KEY IDENTITY(1,2),
	quantity int not null,
	unit_cost double not null,
	iva double not null,
	producto_id not null FOREIGN KEY REFERENCES  products(id),
	purchase_id  not null FOREIGN KEY REFERENCES purchase(id)
);


create table products(
	id int not null PRIMARY KEY IDENTITY (1,2),
	name varchar(100) not null,
	description varchar(225) not null,
	unit_cost decimal not null,
	iva decimal not null,
	mark_id int not null FOREIGN KEY REFERENCES marks(id),
	line_id int not null  FOREIGN KEY REFERENCES lines(id)

);

create table marks(
	id int not null PRIMARY KEY IDENTITY(1,2),
	name varchar(100) not null
);

create table lines(
	id int not null PRIMARY KEY IDENTITY (1,2),
	name varchar(100) not null
);
create table deposits(
	id int not null PRIMARY KEY IDENTITY(1,2),
	name varchar(200) not null
);

create table stocks(
	id int not null PRIMARY KEY IDENTITY (1,2),
	quantity  int not null,
	product_id int not null FOREIGN KEY REFERENCES products(id),
	deposit_if int not null FOREIGN KEY REFERENCES deposits(id)
);

create table purchases(
	id int not null PRIMARY KEY IDENTITY(1,2),
	dat date not null,
	condition int not null,
	invoice_expiration date not null ,
	total double not null,
	total_iva double not null,
	provider_id int not null FOREIGN KEY REFERENCES providers (id),
	deposit_id int not null FOREIGN KEY REFERENCES deposits(id)
);
create table providers(
	id int not null PRIMARY KEY IDENTITY(1,2),
	name varchar(255) not null , 
	address varchar(255) not null ,
	phone varchar(15) not null,
	email varchar(100) not null,
	credit_amount double not null
);

create table payment(
	id int not null PRIMARY KEY IDENTITY(1,2),
	payment_order_id int not null FOREIGN KEY REFERENCES payments_orders(id),
	purchase_id int not null FOREIGN KEY REFERENCES purchases(id),
	monto decimal not null 
);
create table payments_orders(
	id int not null PRIMARY KEY IDENTITY(1,2),
	date date not null,
	total double not null
);

create table pay_method_detail(
	id int not null PRIMARY KEY IDENTITY(1,2),
	pay_method_id int not null FOREIGN KEY REFERENCES pay_methods(id),
	payment_order_id int not null FOREIGN KEY REFERENCES  payments_orders(id),
	monto  decimal not null
)

create table pay_methods(
	id int not null PRIMARY KEY IDENTITY(1,2),
	name varchar(100) not null
)

create table persons(
id int not null PRIMARY KEY IDENTITY(1,2),
name varchar(100) not null,
lastname varchar(100) not null 
rol_id int  not null FOREIGN KEY REFERENCES rol(id)
)

create table deposit_transfers(id int not null PRIMARY KEY IDENTITY(1,2),
origin_deposit_id int not null FOREIGN KEY REFERENCES deposits(id),
destination_deposit_id int not null FOREIGN KEY REFERENCES deposits(id),
manager_id int not null FOREIGN KEY REFERENCES persons(id),
authorization_id int not null FOREIGN KEY REFERENCES persons(id),
date date not null 			       
)


create table rol(id int not null PRIMARY KEY IDENTITY(1,2),
name varchar(100) not null
)

