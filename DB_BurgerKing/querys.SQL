INSERT INTO VENDEDOR (AP_PAT, AP_MAT, NOMBRE, PASSWD) VALUES ('APATERNO', 'AMATERNO', 'NOMBRE', 'PASS');

insert into producto (producto_nombre, precio) values ('NOMBREPRODUC', PRECIOPRODUC);

insert into venta (vendedor_id) values (IDVEND);

insert into producto_venta (venta_id, producto_id, cantidad_producto, precio_venta) values (VENTAID, PRODUCTOID, CANTIDAD, (select precio from producto where producto_id=PRODUCTOID));


select pv.cantidad_producto, p.producto_nombre, pv.precio_venta 
from producto_venta pv 
	inner join producto p 
		on p.producto_id=pv.producto_id 
	inner join venta v 
		on v.venta_id=pv.venta_id;
