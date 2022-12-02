/*Trigger de inserción de detalle compra*/
create or alter trigger t_nuevoDetalleCompra
on purchases_details
for insert
as begin
	declare @cantidad int,
			@costo_unitario decimal,
			@iva decimal,
			@idCompra int,
			@idProducto int,
			@idDeposito int

	select 
		@cantidad = quantity,
		@costo_unitario = unit_cost,
		@iva = iva,
		@idCompra= purchase_id,
		@idProducto = product_id
	from inserted purchases_details;

	select @idDeposito = deposit_id
	from purchases
	where purchases.id = @idCompra;
	
	if @cantidad < 1
	begin
	 RAISERROR ('La cantidad no puede ser menor de 1.',1,1);  
	 ROLLBACK TRANSACTION;  
	end

	update purchases set
		total = total + @cantidad*@costo_unitario,
		total_iva = total_iva + @cantidad*@iva
	where purchases.id = @idCompra;

	if exists(select 1 from stocks where deposit_id = @idDeposito and product_id = @idProducto )
		begin
			update stocks set
				stocks.quantity = stocks.quantity + @cantidad
			where deposit_id = @idDeposito and product_id = @idProducto
		end
	else
		begin
			insert into stocks(deposit_id,product_id,quantity)
			values(@idDeposito,@idProducto,@cantidad);
		end
end

/*Trigger de edicion de detalle compra*/
create or alter trigger t_editarDetalleCompra
on purchases_details
for update
as begin
	declare @cantidad int,
			@costo_unitario decimal,
			@iva decimal,
			@idCompra int,
			@idProducto int,
			@idDeposito int

	declare @cantidad_anterior int,
			@costo_unitario_anterior decimal,
			@iva_anterior decimal,
			@idCompra_anterior int,
			@idProducto_anterior int,
			@idDeposito_anterior int

	select 
		@cantidad = quantity,
		@costo_unitario = unit_cost,
		@iva = iva,
		@idCompra= purchase_id,
		@idProducto = product_id
	from inserted purchases_details;

	select @idDeposito = deposit_id
	from purchases
	where purchases.id = @idCompra;

	select 
		@cantidad_anterior = quantity,
		@costo_unitario_anterior = unit_cost,
		@iva_anterior = iva,
		@idCompra_anterior= purchase_id,
		@idProducto_anterior = product_id
	from deleted purchases_details;

	select @idDeposito_anterior = deposit_id
	from purchases
	where purchases.id = @idCompra_anterior;
	
	if @cantidad < 1
	begin
	 RAISERROR ('La cantidad no puede ser menor de 1.',1,1);  
	 ROLLBACK TRANSACTION;  
	end

	/*Dehaciendo cambios en Compra anterior*/
	update purchases set
		total = total - @cantidad_anterior*@costo_unitario_anterior,
		total_iva = total_iva -  @cantidad_anterior*@iva_anterior
	where purchases.id = @idCompra_anterior;

	/*Dehaciendo cambios de stock anterior*/
	update stocks set
		stocks.quantity = stocks.quantity - @cantidad_anterior
	where deposit_id = @idDeposito_anterior and product_id = @idProducto_anterior


	/*Actualizando Nueva compra*/
	update purchases set
		total = total + @cantidad*@costo_unitario,
		total_iva = total_iva + @cantidad*@iva
	where purchases.id = @idCompra;

	if exists(select 1 from stocks where deposit_id = @idDeposito and product_id = @idProducto )
		begin
			update stocks set
				stocks.quantity = stocks.quantity + @cantidad
			where deposit_id = @idDeposito and product_id = @idProducto
		end
	else
		begin
			insert into stocks(deposit_id,product_id,quantity)
			values(@idDeposito,@idProducto,@cantidad);
		end
end

/*Trigger de Eliminacion de detalle compra*/
create or alter trigger t_eliminarDetalleCompra
on purchases_details
for delete
as begin

	declare @cantidad_anterior int,
			@costo_unitario_anterior decimal,
			@iva_anterior decimal,
			@idCompra_anterior int,
			@idProducto_anterior int,
			@idDeposito_anterior int

	select 
		@cantidad_anterior = quantity,
		@costo_unitario_anterior = unit_cost,
		@iva_anterior = iva,
		@idCompra_anterior= purchase_id,
		@idProducto_anterior = product_id
	from deleted purchases_details;

	select @idDeposito_anterior = deposit_id
	from purchases
	where purchases.id = @idCompra_anterior;
	

	/*Dehaciendo cambios en Compra anterior*/
	update purchases set
		total = total - @cantidad_anterior*@costo_unitario_anterior,
		total_iva = total_iva - @cantidad_anterior*@iva_anterior
	where purchases.id = @idCompra_anterior;

	/*Dehaciendo cambios de stock anterior*/
	update stocks set
		stocks.quantity = stocks.quantity - @cantidad_anterior
	where deposit_id = @idDeposito_anterior and product_id = @idProducto_anterior
end


create or alter trigger t_nuevoDetalleTransferencia
on transfer_details
for insert
as begin
	
	declare @id as int,
			@idStock as int,
			@idTransferencia as int,
			@cantidad as int,
			@cantidadStockActual as int,
			@producto as int,
			@DepositoDestino as int

	select @id = id,
			@idStock = stock_id,
			@idTransferencia = deposit_transfer_id,
			@cantidad = quantity
	from inserted transfer_details;

	select @DepositoDestino = deposit_transfers.destination_deposit_id
	from deposit_transfers where id = @idTransferencia;

	select @cantidadStockActual = quantity,
		   @producto = product_id
	from stocks where id = @idStock;


	if @cantidad < 1
	begin
		RAISERROR('No se pueden realizar transferencias nulas o menores a 0',1,1);
		rollback TRANSACTION;
	end

	if @cantidadStockActual < @cantidad
	begin
		RAISERROR('La cantidad transferida excede la cantidad de stock actual',1,1);
		rollback TRANSACTION;
	end

	/*Actualizar stock del deposito de origen*/
	update stocks set quantity = quantity - @cantidad where id = @idStock;

	/*Actualizar o crear stock de destino*/
	if exists(select 1 from stocks where deposit_id = @DepositoDestino and product_id = @producto)
		begin
				update stocks set quantity = quantity + @cantidad where deposit_id = @DepositoDestino and product_id = @producto
		end
	else
		begin
			insert into stocks(quantity, product_id, deposit_id)
			values(@cantidad, @producto, @DepositoDestino)
		end


end



create or alter trigger t_EditarDetalleTransferencia
on transfer_details
for update
as begin
	
	declare @id as int,
			@idStock as int,
			@idTransferencia as int,
			@cantidad as int,
			@cantidadStockActual as int,
			@producto as int,
			@DepositoDestino as int

	declare 
			@idStock_anterior as int,
			@idTransferencia_anterior as int,
			@cantidad_anterior as int,
			@producto_anterior as int,
			@DepositoDestino_anterior as int

	select @id = id,
			@idStock_anterior = stock_id,
			@idTransferencia_anterior = deposit_transfer_id,
			@cantidad_anterior = quantity
	from deleted transfer_details;

	select @DepositoDestino_anterior = deposit_transfers.destination_deposit_id
	from deposit_transfers where id = @idTransferencia_anterior;

	select @producto_anterior = product_id
	from stocks where id = @idStock_anterior;

	select @id = id,
			@idStock = stock_id,
			@idTransferencia = deposit_transfer_id,
			@cantidad = quantity
	from inserted transfer_details;

	select @DepositoDestino = deposit_transfers.destination_deposit_id
	from deposit_transfers where id = @idTransferencia;

	select @cantidadStockActual = quantity,
		   @producto = product_id
	from stocks where id = @idStock;

	/*Volver a cargar datos en el stock inicial*/
	update stocks set quantity = quantity + @cantidad_anterior where id = @idStock_anterior;

	/*Dehacer cambios en el nuevo stock*/
	update stocks set quantity = quantity - @cantidad_anterior where deposit_id = @DepositoDestino_anterior and product_id = @producto_anterior

	if @cantidad < 1
	begin
		RAISERROR('No se pueden realizar transferencias nulas o menores a 0',1,1);
		rollback TRANSACTION;
	end

	if @cantidadStockActual < @cantidad
	begin
		RAISERROR('La cantidad transferida excede la cantidad de stock actual',1,1);
		rollback TRANSACTION;
	end

	/*Actualizar stock del deposito de origen*/
	update stocks set quantity = quantity - @cantidad where id = @idStock;

	/*Actualizar o crear stock de destino*/
	if exists(select 1 from stocks where deposit_id = @DepositoDestino and product_id = @producto)
		begin
				update stocks set quantity = quantity + @cantidad where deposit_id = @DepositoDestino and product_id = @producto
		end
	else
		begin
			insert into stocks(quantity, product_id, deposit_id)
			values(@cantidad, @producto, @DepositoDestino)
		end
end

create or alter trigger t_EliminarDetalleTransferencia
on transfer_details
for delete
as begin
	declare @id as int,
			@idStock_anterior as int,
			@idTransferencia_anterior as int,
			@cantidad_anterior as int,
			@producto_anterior as int,
			@DepositoDestino_anterior as int

	select @id = id,
			@idStock_anterior = stock_id,
			@idTransferencia_anterior = deposit_transfer_id,
			@cantidad_anterior = quantity
	from deleted transfer_details;

	select @DepositoDestino_anterior = deposit_transfers.destination_deposit_id
	from deposit_transfers where id = @idTransferencia_anterior;

	select @producto_anterior = product_id
	from stocks where id = @idStock_anterior;

	/*Volver a cargar datos en el stock inicial*/
	update stocks set quantity = quantity + @cantidad_anterior where id = @idStock_anterior;

	/*Dehacer cambios en el nuevo stock*/
	update stocks set quantity = quantity - @cantidad_anterior where deposit_id = @DepositoDestino_anterior and product_id = @producto_anterior

end

