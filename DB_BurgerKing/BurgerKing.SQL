/*createdb -h localhost -p 5432 -U postgres burgerking -E 'UTF8' -T 'template0'*/

/*#CREATE DATABASE burgerking TEMPLATE template0 ENCODING 'UTF8';*/

CREATE TABLE venta (
  venta_id    serial NOT NULL, 
  vendedor_id integer NOT NULL, 
  venta_fecha timestamp NOT NULL default current_timestamp,
  pagada char(2) NOT NULL constraint venta_pagada check(pagada in ('SI','NO')) default 'NO',
  producto_id       integer NOT NULL, 
  cantidad_producto integer NOT NULL,
  precio_venta    numeric(10, 2) NOT NULL,
  PRIMARY KEY (venta_id));

CREATE TABLE producto (
  producto_id     serial NOT NULL, 
  producto_nombre varchar(50) NOT NULL, 
  precio          numeric(10, 2) NOT NULL,  
  PRIMARY KEY (producto_id));

CREATE TABLE vendedor (
  vendedor_id serial NOT NULL, 
  ap_pat      varchar(30) NOT NULL, 
  ap_mat      varchar(30) NOT NULL, 
  nombre      varchar(30) NOT NULL, 
  passwd      varchar(100) NOT NULL, 
  PRIMARY KEY (vendedor_id));

ALTER TABLE venta ADD CONSTRAINT venta_vendedor_fk FOREIGN KEY (vendedor_id) REFERENCES vendedor (vendedor_id) ON DELETE RESTRICT ON UPDATE RESTRICT;;

CREATE UNIQUE INDEX venta_venta_id 
  ON venta (venta_id);

CREATE INDEX venta_vendedor_id 
  ON venta (vendedor_id);

CREATE UNIQUE INDEX producto_producto_id 
  ON producto (producto_id);

CREATE UNIQUE INDEX vendedor_vendedor_id 
  ON vendedor (vendedor_id);

CREATE ROLE ventas;

REVOKE ALL ON vendedor FROM ventas;
GRANT SELECT ON vendedor TO ventas ;

REVOKE ALL ON producto FROM ventas ;
GRANT SELECT ON producto TO ventas ;

REVOKE ALL ON venta FROM ventas;
GRANT INSERT, SELECT ON venta TO ventas;