/*createdb burgerking -E 'UTF8' -T 'template0'*/

/*#CREATE DATABASE burgerking TEMPLATE template0 ENCODING 'UTF8';*/
CREATE ROLE ventas LOGIN INHERIT;

CREATE TABLE producto_venta (
  producto_venta_id serial NOT NULL, 
  venta_id          integer NOT NULL, 
  producto_id       integer NOT NULL, 
  cantidad_producto integer NOT NULL,
  precio_venta    numeric(10, 2) NOT NULL,
  PRIMARY KEY (producto_venta_id));

CREATE TABLE venta (
  venta_id    serial NOT NULL, 
  vendedor_id integer NOT NULL, 
  venta_fecha timestamp NOT NULL default current_timestamp,
  pagada char(2) NOT NULL constraint venta_pagada check(pagada in ('SI','NO')) default 'NO', 
  PRIMARY KEY (venta_id));

CREATE TABLE producto (
  producto_id     serial NOT NULL, 
  producto_nombre varchar(50) NOT NULL, 
  precio          numeric(10, 2) NOT NULL,  
  PRIMARY KEY (producto_id));

CREATE TABLE vendedor (
  vendedor_id serial NOT NULL,
  vendedor_correo varchar(100) NOT NULL, 
  ap_pat      varchar(30) NOT NULL, 
  ap_mat      varchar(30), 
  nombre      varchar(30) NOT NULL, 
  passwd      varchar(100) NOT NULL, 
  PRIMARY KEY (vendedor_id));

ALTER TABLE producto_venta ADD CONSTRAINT producto_venta_producto_fk FOREIGN KEY (producto_id) REFERENCES producto (producto_id) ON DELETE RESTRICT ON UPDATE RESTRICT;;

ALTER TABLE producto_venta ADD CONSTRAINT producto_venta_venta_fk FOREIGN KEY (venta_id) REFERENCES venta (venta_id) ON DELETE RESTRICT ON UPDATE RESTRICT;;

ALTER TABLE venta ADD CONSTRAINT venta_vendedor_fk FOREIGN KEY (vendedor_id) REFERENCES vendedor (vendedor_id) ON DELETE RESTRICT ON UPDATE RESTRICT;;

CREATE UNIQUE INDEX producto_venta_producto_venta_id 
  ON producto_venta (producto_venta_id);

CREATE INDEX producto_venta_venta_id 
  ON producto_venta (venta_id);

CREATE INDEX producto_venta_producto_id 
  ON producto_venta (producto_id);

CREATE UNIQUE INDEX venta_venta_id 
  ON venta (venta_id);

CREATE INDEX venta_vendedor_id 
  ON venta (vendedor_id);

CREATE UNIQUE INDEX producto_producto_id 
  ON producto (producto_id);

CREATE UNIQUE INDEX vendedor_vendedor_id 
  ON vendedor (vendedor_id);


REVOKE ALL ON vendedor FROM ventas;
GRANT SELECT ON vendedor TO ventas ;

REVOKE ALL ON producto FROM ventas ;
GRANT SELECT ON producto TO ventas ;

REVOKE ALL ON producto_venta FROM ventas;
GRANT INSERT, SELECT ON producto_venta TO ventas;

REVOKE ALL ON venta FROM ventas;
GRANT INSERT, SELECT ON venta TO ventas;