USE proyectoBases;

#DATOS DE PRUEBA

#CRUDS
#PAIS-----------------------------------
CALL createPais ("Costa Rica");
CALL createPais ("Panamá");
CALL createPais ("Alemania");
SELECT * FROM Pais;

#CALL DeletePais(1);
#CALL DeletePais(3);
#CALL DeletePais(4);

#PROVINCIA-----------------------------
CALL createProvincia("San Jose", NULL, "Costa Rica");
CALL createProvincia("Ciudad de panamá", 2, NULL);
CALL createProvincia("Cartago", NULL, "Costa Rica");

#CALL DeleteProvincia(1);
#CALL DeleteProvincia(2);
#CALL DeleteProvincia(4);

#CANTON-----------------------------------------------


CALL createCanton("Tarrazú", 2);
CALL createCanton("San Pablo", 2);
CALL createGerenteGeneral ("Juanito", 51916271, 1000000);
CALL CREATESUCURSAL("Super de juanito", "San Marcos", 1, 1);
CALL CreateCargo("Administracion");
CALL CreateEmpleado("Maria Vargas", "2023/12/12", 1000, 1, 1);
CALL CreateBono(15000, "2022-7-15", 1);
CALL createEncargo("2022-9-17", 1);
CALL createImpuesto("Canasta básica", 5.2);
CALL createCategoria ("Lacteo3", 1);
CALL CreateProveedor ("Juancito", "8162-1629", 6.1);
CALL CreateTipoPago ("TARJETA");
CALL createCliente("Melissa", "87117264", "meli2@gmail.com", "50 norte de...", 1);
CALL CreateProducto("Leche dos pinos 200ml", 1);
CALL createPromocion("2008-09-16", "2008-09-20", 5, 1);
CALL CreatePedido("2008-8-16", 3, 1);
CALL createDetalle(9, 1, 1);
CALL createEncargoXProducto(1, 1, 1, 5000);
CALL createProductoXProveedor(1, 1, 1, "2003-8-9", "2004-7-10");
CALL createSucursalXProducto (1, 1, 10, 10, 50, "2003-8-9", "2004-7-10", 1);
CALL CreateTarjeta("123", "123", "DEBITO", "2023-9-3", 1);
CALL CreateCheque("123", "167993", "2022-12-11", "ahsjks", 1);
CALL CreateCriptoMONEDA("ahjkdd","no see", 1 );


CALL DeleteCanton(2);
CALL DeleteGerenteGeneral(2);
CALL deleteSucursal(3);
CALL deleteCargo(2);
CALL deleteEmpleado(2);
CALL deleteBono(2);
CALL deleteEncargo(2);
CALL deleteImpuesto(2);
CALL deleteCategoria(2);
CALL deleteProveedor(2);
CALL deleteTipoPago(4);
CALL deleteCliente(4);
CALL deleteProducto(1);
#select * from producto;
CALL deleteDetalle(1);
CALL deleteCriptomoneda(1);
CALL deleteCheque(1);
CALL deleteTarjeta(1);
CALL deleteSucursalXProducto(1);
CALL deleteEncargoXProducto(1);
CALL deleteProductoXProveedor(1);


/*

SELECT * FROM PROVINCIA; SELECT * FROM Canton;
CALL createCanton("Tarrazú", 2);
select * from canton;

CALL createGerenteGeneral ("Juanito", 51916271, 1000000);

CALL CREATESUCURSAL("Super de juanito", "San Marcos", 1, 1);

CALL CreateCargo("Administracion");
SELECT * FROM CARGO;

CALL CreateEmpleado("Maria Vargas", "2003/12/12", 1000, 1, 1);

CALL CreateBono(15000, "2005-7-15", 1);

CALL createEncargo("2008-9-17", 1);

CALL createImpuesto("Canasta básica", 5.2);
SELECT * FROM IMPUESTO;

CALL createCategoria ("Lacteos", 1);

CALL CreateProveedor ("Juancito", "7162-1629", 6.1);

CALL CreateTipoPago ("TARJETA");

CALL createCliente("Melissa", "87117263", "meli1@gmail.com", "50 norte de...", 1);

CALL CreateProducto("Leche dos pinos 500ml", 1);

CALL createPromocion("2008-09-16", "2008-09-20", 5, 1);

CALL CreatePedido("2008-8-16", 1, 1);

CALL createDetalle(9, 1, 1);

CALL createEncargoXProducto(1, 1, 1, 5000);
CALL createProductoXProveedor(1, 1, 1, "2003-8-9", "2004-7-10");

CALL createSucursalXProducto (1, 1, 10, 10, 50, "2003-8-9", "2004-7-10", 1);

INSERT INTO SucursalXProducto(idSucursalXProducto, idSucursal, idProducto, cantidad, cantidadMin, cantidadMax, fechaProduccion, fechaExpiracion, estado) 
VALUES (1, 1, 1, 15, 5, 50, "2022-05-01", "2022-12-17", 1);
select * from SucursalXProducto;

CALL updateProvincia (2, "Colon", null);
SELECT * from provincia;

CALL readEncargoXProducto (1);

INSERT INTO EncargoXProducto(idEncargoXProducto, idProducto, idEncargo, cantidad, precio) 
VALUES (1, 1, 1, 15, 23650);
select * from EncargoXProducto;

CALL readPromocion (1);

INSERT INTO promocion(fechaInicial, fechaFinal, porcentajeDesc, idProducto) 
VALUES ("2022-11-12", "2022-11-30", 1.1, 1);
select * from promocion;

CALL readProductoXProveedor (1);

INSERT INTO productoXProveedor(idProductoXProveedor, idProducto, idProveedor, existencias, fechaProduccion, fechaExpiracion) 
VALUES (1, 1, 1, 500, "2022-05-31", "2022-12-12");
select * from productoXProveedor;

CALL readDetalle (1);

INSERT INTO Detalle(cantidad, idPedido, idProducto) VALUES (50, 1, 1);
select * from Producto;

CALL readProducto (1);

INSERT INTO Producto(nombreProducto, idCategoria) VALUES ("Leche", 1);
select * from Producto;

CALL readPedido (3);

INSERT INTO Pedido(fecha, idCliente, idTipoPago) VALUES ("2022-11-12", 1, 1);
select * from Pedido;

CALL readCategoria (1);

INSERT INTO Categoria(descripcion, idImpuesto) VALUES ("Lacteo", 1);
select * from Categoria;

CALL readImpuesto (1);

INSERT INTO Impuesto(descripcion, porcImpuesto) VALUES ("IVA", 13);
select * from Impuesto;
*/