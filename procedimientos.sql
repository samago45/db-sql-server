/*Para dar alta/baja/modificación de una tabla simple (proveedores, productos, etc) (1)*/

create or alter procedure CrearProveedor
@nombre varchar(255), @direccion varchar(255), @telefono varchar(15), @email varchar(100), @credito decimal
as 
insert into providers(name,address,phone,email,credit_amount)
values(@nombre,@direccion,@telefono,@email,@credito);

create or alter procedure EditarProveedor
@nombre varchar(255), @direccion varchar(255), @telefono varchar(15), @email varchar(100), @credito decimal, @id int
as 
update providers set
name = @nombre,
address = @direccion,
phone = @telefono,
email = @email,
credit_amount = @credito
where id = @id;

create or alter procedure EliminarProveedor
@id int
as 
delete providers 
where id = @id;


/*Para dar alta/baja/modificación de una tabla compleja (facturas compras u ordenes 
de pago) (3)*/
create or alter procedure CrearDetalleCompra
@idProducto int, @idCompra int, @cantidad int, @precio_unitario decimal, @iva decimal
as

	insert into purchases_details(product_id, purchase_id, quantity, unit_cost, iva)
	values(@idProducto, @idCompra, @cantidad, @precio_unitario, @iva);


create or alter procedure EditarDetalleCompra
@idProducto int, @idCompra int, @cantidad int, @precio_unitario decimal, @iva decimal, @id int
as 
	
	/*Actualizar Detalle*/
	update purchases_details set
		product_id = @idProducto,
		purchase_id = @idCompra,
		quantity = @cantidad,
		unit_cost = @precio_unitario,
		iva = @iva
		where id = @id;

create or alter procedure EliminarDetalleCompra
@id int
as
	/*Eliminar Detalle*/
	delete purchases_details where id = @id;



/*Uno de los informes solicitados. (1)*/
create or alter procedure ProductosNoComprados
@InitialDate Date, @FinalDate Date
as
select products.id, products.name, products.unit_cost, max(purchases.dat)
from products 
inner join purchases_details on  purchases_details.product_id = products.id
inner join purchases on purchases_details.purchase_id = purchases.id
where products.id not in(
	select products.id from products
	inner join purchases_details on purchases_details.product_id = products.id
	inner join purchases on purchases.id = purchases_details.purchase_id
	where purchases.dat >= @InitialDate and purchases.dat <= @FinalDate
)
group by products.id, products.name, products.unit_cost
exec ProductosNoComprados '2022-10-14','2022-11-01'

