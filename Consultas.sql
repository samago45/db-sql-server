/*
Monto del importe total de compras realizadas en un rango de fechas (entre dos
fechas), desplegar los atributos: fecha, código y nombre de depósito, importe total
de compras para esa fecha y depósito.
*/

select purchases.dat, deposits.name, deposits.id,  SUM( purchases.total) as total
from deposits
inner join purchases on purchases.deposit_id = deposits.id
where purchases.dat between  '2022-11-10' and  '2022-12-30'
group by deposits.name, purchases.dat, deposits.id

/*Productos comprados a proveedores, el criterio de recuperación es por rango de
proveedores y rango de fechas, desplegar los siguientes atributos: Código y nombre
del Proveedor, código y descripción del producto, última fecha de compra, ultimo
costo unitario.*/
select providers.id, providers.name, products.id, products.description, MAX(PURchases.dat), products.unit_cost
from providers
inner join purchases on purchases.provider_id = providers.id
inner join purchases_details on purchases_details.purchase_id = purchases.id
inner join products on products.id = purchases_details.product_id
where providers.id between 1 and 10 and purchases.dat between '2022-11-01' and '2022-11-30'
group by  providers.id, providers.name, products.id, products.description, products.unit_cost


/*
Productos comprados a más de un proveedor por rango de proveedores, desplegar
los atributos: Código y descripción del Producto, código y nombre del proveedor. (2)
*/

select products.id, products.name, providers.id, providers.name
from purchases_details 
inner join products on products.id = purchases_details.product_id
inner join purchases on purchases.id = purchases_details.purchase_id
inner join providers on providers.id = purchases.provider_id
where products.id in (
	select products.id from products
	inner join purchases_details on purchases_details.product_id = products.id
	inner join purchases on purchases.id = purchases_details.purchase_id
	group by products.id
	having count(distinct purchases.provider_id) > 1
)



/*
Informe de facturas de compra vencidas aun no pagadas, desplegar los atributos:
Factura, fecha, código y nombre del proveedor, total de la factura y saldo de la
factura. (1)
*/
select purchases.dat, providers.id, providers.name, purchases.total, purchases.saldo
from purchases 
inner join providers on purchases.provider_id = providers.id
where purchases.invoice_expiration < GETDATE()

/*
Ranking de productos (Productos más comprados, por cantidad de productos). (2)
*/
select products.id, products.name, products.description, products.unit_cost, products.iva, SUM(purchases_details.quantity) as cantidad
from products
inner join purchases_details on purchases_details.product_id = products.id
group by products.id, products.name, products.description, products.unit_cost, products.iva
order by cantidad desc


/*
Ranking de proveedores (Proveedores a los que más se les compra, por monto de
facturación). (2)
*/
select providers.id, providers.name, providers.email, providers.phone, SUM(purchases.total) as total_comprado
from providers
inner join purchases on purchases.provider_id = providers.id 
group by providers.id, providers.name, providers.email, providers.phone
order by total_comprado desc


/*Productos que no se compraron por rango de fecha, desplegar los atributos: código y 
descripción del producto, precio de compra, ultima fecha de compra. (2) (Resolver 
con procedimiento almacenado*/
select products.id, products.name, products.unit_cost, max(purchases.dat)
from products 
inner join purchases_details on  purchases_details.product_id = products.id
inner join purchases on purchases_details.purchase_id = purchases.id
where products.id not in(
	select products.id from products
	inner join purchases_details on purchases_details.product_id = products.id
	inner join purchases on purchases.id = purchases_details.purchase_id
	where purchases.dat >= '2022-10-14' and purchases.dat <= '2022-11-01'

