/*
Monto del importe total de compras realizadas en un rango de fechas (entre dos
fechas), desplegar los atributos: fecha, código y nombre de depósito, importe total
de compras para esa fecha y depósito.
*/

select purchases.dat, deposits.name, deposits.id,  SUM( purchases.total) as total
from deposits
inner join purchases on deposit_id = deposits.id
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
