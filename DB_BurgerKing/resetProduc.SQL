DELETE FROM producto;
ALTER SEQUENCE producto_producto_id_seq RESTART 1;
insert into producto values (default,'combo1', 73.00);
insert into producto values (default,'combo2', 86.00);
insert into producto values (default,'combo3', 87.00);
insert into producto values (default,'combo4', 83.00);
insert into producto values (default,'combo5', 84.00);
insert into producto values (default,'combo6', 62.00);
insert into producto values (default,'combo7', 99.00);
insert into producto values (default,'refresco', 20.00);
insert into producto values (default,'papas', 25.00);
insert into producto values (default,'pay', 15.00);

