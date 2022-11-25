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
@idProducto int, @idCompra int, @cantidad int
as
	declare @precio_unitario as decimal, 
			@iva as decimal

	select @precio_unitario = unit_cost, 
		   @iva = iva
	from products
	where id = @idProducto

	insert into purchases_details(product_id, purchase_id, quantity, unit_cost, iva)
	values(@idProducto, @idCompra, @cantidad, @precio_unitario, @iva);

	update purchases set 
		total = total + (@cantidad * @precio_unitario),
		total_iva = total_iva + (@cantidad *  @iva)
	where id = @idCompra

create or alter procedure EditarDetalleCompra
@idProducto int, @idCompra int, @cantidad int, @id int
as
	/*Declarar variables*/
	declare @precio_unitario as decimal, 
			@iva as decimal,

			@precio_anterior as decimal,
			@iva_anterior as decimal,
			@cantidad_anterior as int,
			@idCompra_anterior as int

	/*Obtener Iva y precio anterior */
	select @precio_anterior = purchases_details.unit_cost,
			@iva_anterior = purchases_details.iva,
			@cantidad_anterior = quantity,
			@idCompra_anterior = purchase_id
	from purchases_details
	where id = @id

	/*Deshacer cambios en Compras*/
	update purchases set 
		total = total - (@cantidad_anterior * @precio_anterior),
		total_iva = total_iva - (@cantidad_anterior *  @iva_anterior)
		where id = @idCompra_anterior;

	/*Obtener nuevos datos de producto*/
	select @precio_unitario = unit_cost, 
		   @iva = iva
	from products
	where id = @idProducto
	
	/*Actualizar Compra*/
	update purchases set 
		total = total + (@cantidad * @precio_unitario),
		total_iva = total_iva + (@cantidad *  @iva)
		where id = @idCompra;
	
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
	/*Declarar variables*/
	declare
			@precio_anterior as decimal,
			@iva_anterior as decimal,
			@cantidad_anterior as int,
			@idCompra_anterior as int

	/*Obtener Iva y precio anterior */
	select @precio_anterior = purchases_details.unit_cost,
			@iva_anterior = purchases_details.iva,
			@cantidad_anterior = quantity,
			@idCompra_anterior = purchase_id
	from purchases_details
	where id = @id

	/*Deshacer cambios en Compras*/
	update purchases set 
		total = total - (@cantidad_anterior * @precio_anterior),
		total_iva = total_iva - (@cantidad_anterior *  @iva_anterior)
		where id = @idCompra_anterior;

	/*Eliminar Detalle*/
	delete purchases_details where id = @id;

/*Uno de los informes solicitados. (1)*/
/*Monto del importe total de compras realizadas en un rango de fechas (entre dos 
fechas), desplegar los atributos: fecha, código y nombre de depósito, importe total 
de compras para esa fecha y depósito.*/

create or alter procedure ImporteTotalPorFechas
@fechaInicial Date, @fechaFinal Date
as
	select purchases.dat, deposits.name, deposits.id,  SUM( purchases.total) as total
	from deposits
	inner join purchases on purchases.deposit_id = deposits.id
	where purchases.dat between  @fechaInicial and @fechaFinal
	group by deposits.name, purchases.dat, deposits.id
	 
exec ImporteTotalPorFechas '2022-11-10',  '2022-12-30'

