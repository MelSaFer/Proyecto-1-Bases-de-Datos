USE proyectoBases;

#DATOS DE PRUEBA
#CREAR PAISES----------------------------------------
#CREATE- Recibe el nombre del país
CALL createPais ("Costa Rica"); #id=1
CALL createPais ("Panamá");		#id=2
CALL createPais ("Alemania");	#id=3

#CREAR PROVINCIAS-----------------------------------
#CREATE- Recibe: Nombre de  provincia, id del pais o nombre del pais
CALL createProvincia("San Jose", NULL, "Costa Rica"); 	#id=1
CALL createProvincia("Ciudad de panamá", 2, NULL);	  	#id=2
CALL createProvincia("Cartago", NULL, "Costa Rica");	#id=3

#CREAR CANTONES-----------------------------------
#CREATE- Recibe: Nombre y id de la provincia
CALL createCanton("Tarrazú", 1);		#id=1
CALL createCanton("León Cortes", 1);	#id=2
CALL createCanton("Colón", 2);			#id=3

#GERENTE GENERAL-----------------------------------
#CREATE- Recibe: Nombre, telefono, salario base
CALL createGerenteGeneral ("Juan Cascante", "57281923", 1000000); #id=1

#SUCURSALES---------------------------------------
#CREATE- Recibe: nombre, direccion en otras señas, idcanton y idGerente
CALL createSucursal("Super de Juan", "150m del Parque Central", 1, 1);		#id=1
CALL createSucursal("Super de Juan 2", "150m del Parque Central", 2, 1);	#id=2

#CARGOS-------------------------------------------
CALL CreateCargo("Administracion"); 	#id= 1
CALL CreateCargo("Facturadores");		#id= 2
CALL CreateCargo("Acomodadores");		#id= 3
CALL CreateCargo("Carniceros");			#id= 4
CALL CreateCargo("Verdureros");			#id= 5
CALL CreateCargo("Secretaria");			#id= 6
CALL CreateCargo("Gerencia");			#id= 7
CALL CreateCargo("Conserje");			#id= 8

#EMPLEADOS-------------------------------------
#CREATE- Recibe: nombre, fecha contratacion, salario base, id sucursal, id cargo
CALL CreateEmpleado("Maria Vargas", "2022-11-12", 400000, 1, 1); 		#id = 1
CALL CreateEmpleado("Esteban Cordero", "2020-11-12", 500000, 1, 2); 	#id = 2
CALL CreateEmpleado("Juan Venegas", "2021-10-9", 500000, 1, 2); 		#id = 3
CALL CreateEmpleado("Esmeralda Cordero", "2019-11-17", 550000, 1, 3); 	#id = 4
CALL CreateEmpleado("Mariana Monge", "2019-01-6", 600000, 2, 6); 		#id = 5
CALL CreateEmpleado("Juan Cordero", "2019-8-12", 550000, 2, 5); 		#id = 6
CALL CreateEmpleado("Melissa Montero", "2015-11-12", 550000, 2, 7); 	#id = 7

#BONOS---------------------------------------------------
#CREATE: Recibe: Monto, fecha y id Empleado
CALL CreateBono(10000, "2022-7-15", 2);

#IMPUESTOS-----------------------------------------------
#CREATE- Recibe: Descripcion y porcentaje
CALL createImpuesto("Productos de la canasta básica", 0.0);	#id= 1
CALL createImpuesto("Yogurts, leches...", 0.05);    		#id= 2
CALL createImpuesto("Bebidas con licor", 0.09);    			#id= 3

#CATEGORIAS----------------------------------------------
#CREATE- Recibe: descripcion y id del impuesto
CALL createCategoria ("Lacteos", 2);	#id= 1
CALL createCategoria ("Frijoles", 1);	#id= 2
CALL createCategoria ("Licor", 3);		#id= 3
CALL createCategoria ("Arroz", 1);		#id= 4

#PROVEEDORES--------------------------------------------
#CREATE- Recibe: nombre, telefono, porcentaje ganancia
CALL CreateProveedor ("Juan Verduras", "8162-1629", 0.6);	#id=1
CALL CreateProveedor ("Dos Pinos", "2567-1629", 0.4);		#id=2
CALL CreateProveedor ("Tropical", "1782-1629", 0.5);		#id=3
CALL CreateProveedor ("Distribuidor AyR", "1829-2927", 0.3);#id=4

#TIPOS DE PAGO------------------------------------------
#CREATE- Recibe: Descripcion
CALL CreateTipoPago ("Tarjeta");		#id= 1
CALL CreateTipoPago ("Cheque");			#id= 2
CALL CreateTipoPago ("Efectivo");		#id= 3
CALL CreateTipoPago ("Criptomoneda");	#id= 4

#CLIENTES------------------------------------------------
#CREATE- Recibe: Nombre, numero de telefono, correo, direccion otras señas, idCanton
CALL createCliente("Melissa Monge", "87117264", "meli2@gmail.com", "50 norte del comercial M", 1);		#id= 1
CALL createCliente("Mario Naranjo", "71729172", "mariNar@gmail.com", "125 sur de la floristeria A", 1);	#id= 2
CALL createCliente("Camila Cordero", "65627183", "camiiiC@gmail.com", "200 sureste del comercial M", 2);#id= 3
CALL createCliente("Estefania Mora", "52971823", "tefaMora@gmail.com", "50 sur de la Escuela A", 1);	#id= 4

#PRODUCTOS------------------------------------------------
#CREATE- Recibe: Nombre y Categoria
CALL CreateProducto("Leche dos pinos 200ml", 1);	#id= 1
CALL CreateProducto("Leche dos pinos 500ml", 1);	#id= 2
CALL CreateProducto("Frijoles Tio Pelón 800g", 2);	#id= 3
CALL CreateProducto("Arroz Tío Pelón 1k", 4);		#id= 4
CALL CreateProducto("Arroz Luisiana 1k", 4);		#id= 5

#PROMOCION------------------------------------------------
#CREATE- Recibe: Fecha inicial, fecha final, porcentaje, idProducto
CALL createPromocion("2022-09-16", "2022-10-20", 0.05, 1);

#TIPO ENVIO----------------------------------------------
#Create- Recibe:Descripcion y cobro extra
CALL CreateTipoEnvio("fisico", 0.0);		#id= 3
CALL CreateTipoEnvio("domicilio", 0.01);	#id= 2

#INVENTARIO PROVEEDOR------------------------------------
#CREATE- Recibe: idProducto, idProveedor, existencias, fecha produccion, fecha expiracion
#				precio por unidad
#Agregar productos al proveedor 2
CALL createProductoXProveedor(1, 2, 50, "2022-11-14", "2022-11-25", 800.0);
CALL createProductoXProveedor(2, 2, 80, "2022-11-14", "2022-11-25", 1200.0);
#Agregar productos al proveedor 4
CALL createProductoXProveedor(1, 4, 30, "2022-11-15", "2022-11-22", 700.0);
CALL createProductoXProveedor(2, 4, 30, "2022-11-15", "2022-11-23", 900.0);
CALL createProductoXProveedor(3, 4, 50, "2022-10-14", "2023-11-25", 1000.0);
CALL createProductoXProveedor(4, 4, 28, "2022-10-14", "2023-11-25", 1500.0);
CALL createProductoXProveedor(5, 4, 30, "2022-10-14", "2023-11-25", 1350.0);

#PEDIDOS(ClienteXSucusal)------------------------------------------------
#CREATE- Recibe: Fecha, idTipoPago, idCliente, idEmpleado, TipoEnvio, idSucursal
CALL CreatePedido("2022-11-15", 1, 1, 1, 1, 1);

#SUCURSALXPRODUCTO---------------------------------------------
#CREATE- Recibe: idSucursal, idProducto, cantidad de productos, cantidad minima, 
CALL createSucursalXProducto (1, 1, 10, 10, 50, "2003-8-9", "2004-7-10", "En Mostrador", 40);





#CRUDS


#CALL DeletePais(1);
#CALL DeletePais(3);
#CALL DeletePais(4);


#CALL createEncargo("2022-9-17", 1);



SELECT * FROM PROVEEDOR;






#CALL createEncargoXProducto(1, 1, 1, 5000);

SELECT * FROM productoxproveedor;
CALL CreateTarjeta("123", "123", "DEBITO", "2023-9-3", 1);
CALL CreateCheque("123", "167993", "2022-12-11", "ahsjks", 1);
CALL CreateCriptoMONEDA("ahjkdd","no see", 1 );
CALL createSucursalXProducto (1, 1, 10, 10, 50, "2003-8-9", "2020-7-10", "En Mostrador", 30);
CALL createSucursalXProducto (1, 1, 10, 10, 50, "2003-8-9", "2022-11-15", "En Mostrador", 90);

CALL createSucursalXProducto (1, 1, 1, 45, 50, "2003-8-9", "2020-11-15", "En Mostrador", 12);

CALL revisarProductosSucursal(20);
CALL reporteExpiradosSucursal(1);
SELECT * FROM Promocion;
select * from producto;
select * from sucursalxproducto;
select * from empleado;
DELETE FROM Promocion where idProducto = 1;

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

select * from cliente;
call createSucursalXCliente(1,1);
call updateSucursalXCliente(1,1,1);
call readSucursalXCliente(1);
select * from sucursalxcliente;


SELECT SUM(SucursalXProducto.Cantidad) FROM SucursalXProducto
	WHERE SucursalXProducto.idProducto = 1 AND 
    SucursalXProducto.Estado != "Vencido";
SELECT proveedor.idProveedor FROM proveedor 
        INNER JOIN  productoxproveedor ON productoxproveedor.idProveedor = proveedor.idProveedor
        WHERE productoxproveedor.precio = (SELECT MIN(precio) FROM productoxproveedor
        WHERE idProducto = 1) AND productoxproveedor.idProducto = 1;
SELECT * FROM PRODUCTO;
SELECT * FROM productoxproveedor;
SELECT * FROM SucursalXProducto;

select * from encargo;

CALL hacerPedidoProveedor(1, 1);
SELECT * FROM Proveedor;
SELECT * FROM productoxproveedor;


CALL bonoEmpleados();

SELECT * from empleado;

SELECT SUM(detalle.cantidad) FROM Empleado
        INNER JOIN Pedido on Empleado.idEmpleado = Pedido.idEmpleado
        INNER JOIN Detalle on Pedido.idPedido = Detalle.idPedido
        WHERE Pedido.fecha >= curdate()-7;
        
select * from pedido;
call updatePedido(1, "2022-11-11", null, null, null, null);
call createDetalle(50, 1, 1);
call createDetalle(20, 1, 1);

select * from bono;

SELECT cargo.descripcion FROM Empleado INNER JOIN
        Cargo on Empleado.idCargo = cargo.idCargo) = "facturador"

select * from detalle;


DELETE FROM SucursalXProducto WHERE IDSucursalXProducto=9;
SELECT DISTINCT cantidadMax FROM sucursalXProducto
		WHERE SucursalXProducto.idProducto = 1;
CALL deletesucursalXProducto(5);
CALL updateProductoXProveedor(1, NULL, NULL,
						30, NULL, NULL, NULL);

CALL updateSucursalXProducto(1, null, null, 1, null, null, null, null, null, null);
                        
                        
(SELECT proveedor.idProveedor FROM proveedor 
			INNER JOIN  productoxproveedor ON productoxproveedor.idProveedor = proveedor.idProveedor
			WHERE productoxproveedor.precio = (SELECT MIN(precio) FROM productoxproveedor
			WHERE idProducto = 1) AND productoXProveedor.idProducto = 1
            AND (SELECT SUM(existencias) FROM productoXProveedor WHERE productoXProveedor.idProducto = 1) > 0);
            
call agregarDetalle(1, 1, 5);
select * from detalle;
select * from sucursalxproducto;
select * from pedido;
select * from tipoEnvio;

(SELECT sucursal.idSucursal FROM Pedido INNER JOIN Cliente ON Pedido.idCliente = cliente.idCliente
    INNER JOIN Sucursal ON Cliente.idSucursal = sucursal.idSucursal
    WHERE 1 = pedido.idPedido);
    
select * from sucursal;

call crearPedido(1, 1, 2, 1, 1);
call createCargo("facturador");
call createEmpleado("Rosa", curdate(), 390000, 1, 2);
select * from empleado;
select * from cargo;
select * from pedido;
CALL productosMasVendidos( 1 ,NULL, "2023-11-15");

call createPedido(curdate(), 1, 1, 1, 1);

call createDetalle(5, 2, 2);
