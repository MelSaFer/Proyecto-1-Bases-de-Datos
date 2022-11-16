USE proyectoBases;
#DATOS DE PRUEBA
#CREAR PAISES----------------------------------------
#CREATE- Recibe el nombre del país
CALL createPais ("Costa Rica"); #id=1
CALL createPais ("Panamá");		#id=2
CALL createPais ("Alemania");	#id=3

#CALL readPais(10);
# (IdPais, nombre)
#CALL updatePais(null, null);
#CALL DeletePais(1);

#CREAR PROVINCIAS-----------------------------------
#CREATE- Recibe: Nombre de  provincia, id del pais o nombre del pais
CALL createProvincia("San Jose", NULL, "Costa Rica"); 	#id=1
CALL createProvincia("Ciudad de panamá", 2, NULL);	  	#id=2
CALL createProvincia("Cartago", NULL, "Costa Rica");	#id=3
CALL readProvincia(1);
# (idProvincia, nombre, idPais)
#CALL updateProvincia(null,null,null);
#CALL DeletePais(1);

#CREAR CANTONES-----------------------------------
#CREATE- Recibe: Nombre y id de la provincia
CALL createCanton("Tarrazú", 1);		#id=1
CALL createCanton("León Cortes", 1);	#id=2
CALL createCanton("Colón", 2);			#id=3
#CALL readCanton(1);
#(idCanton, nombre, idProvincia)
#CALL updateCanton(null, null, null);
#CALL DeleteCanton(2);

#GERENTE GENERAL-----------------------------------
#CREATE- Recibe: Nombre, telefono, salario base
CALL createGerenteGeneral ("Juan Cascante", "57281923", 1000000); #id=1
#CALL readGerenteGeneral(1);
# (idGerente, nombre, telefono, salario)
#CALL updateGerenteGeneral(null, null, null, null);
#CALL DeleteGerenteGeneral(2);

#SUCURSALES---------------------------------------
#CREATE- Recibe: nombre, direccion en otras señas, idcanton y idGerente
CALL createSucursal("Super de Juan", "150m del Parque Central", 1, 1);		#id=1
CALL createSucursal("Super de Juan 2", "150m del Parque Central", 2, 1);	#id=2
CALL createSucursal("Supermercado Colón", "15Om de la iglesia", 3, 1);	#id=3
#CALL readSucursal(1);
# (idSucursal, nombre, direccion, idCanton, idGerenteGeneral)
#CALL updateSucursal(null, null, null, null, null);
#CALL deleteSucursal(3);

#CARGOS-------------------------------------------
CALL CreateCargo("Administracion"); 	#id= 1
CALL CreateCargo("Facturador");			#id= 2
CALL CreateCargo("Acomodador");			#id= 3
CALL CreateCargo("Carnicero");			#id= 4
CALL CreateCargo("Verdurero");			#id= 5
CALL CreateCargo("Secretaria");			#id= 6
CALL CreateCargo("Gerencia");			#id= 7
CALL CreateCargo("Conserje");			#id= 8

#CALL readCargo(1);
# (idCargp, decripcion)
#CALL updateCargo(null, null);
#CALL deleteCargo(2);


#EMPLEADOS-------------------------------------
#CREATE- Recibe: nombre, fecha contratacion, salario base, id sucursal, id cargo
CALL CreateEmpleado("Maria Vargas", "2022-11-12", 400000, 1, 1); 		#id = 1
CALL CreateEmpleado("Esteban Cordero", "2020-11-12", 500000, 1, 2); 	#id = 2
CALL CreateEmpleado("Juan Venegas", "2021-10-9", 500000, 1, 2); 		#id = 3
CALL CreateEmpleado("Esmeralda Cordero", "2019-11-17", 550000, 1, 3); 	#id = 4
CALL CreateEmpleado("Mariana Monge", "2019-01-6", 600000, 2, 6); 		#id = 5
CALL CreateEmpleado("Juan Cordero", "2019-8-12", 550000, 2, 5); 		#id = 6
CALL CreateEmpleado("Melissa Montero", "2015-11-12", 550000, 2, 7); 	#id = 7
CALL CreateEmpleado("Carlos Montero", "2016-11-12", 500000, 1, 2); 		#id = 8
CALL CreateEmpleado("Carlos Ureña", "2016-11-12", 500000, 3, 2); 		#id = 9
#CALL readEmpleado(1);
# (idEmpleado, nombre, fechaContratacion, salario, idSucursal, idCargo)
#CALL updateEmpleado(null, null, null, null, null, null);
#CALL deleteEmpleado(2);

#BONOS---------------------------------------------------
#CREATE: Recibe: Monto, fecha y id Empleado
CALL CreateBono(10000, "2022-7-15", 2);
#CALL readBono(1);
# (idBono, monto, fecha, idEmpleado)
#CALL updateBono(null, null, null, null);
#CALL deleteBono(2);


#CATEGORIAS----------------------------------------------
#CREATE- Recibe: descripcion y % del impuesto
CALL createCategoria ("Lacteos", 0.02);			#id= 1
CALL createCategoria ("Canasta básica", 0.00);	#id= 2
CALL createCategoria ("Licores", 0.03);			#id= 3
CALL createCategoria ("Papeleria", 0.0);		#id= 4
#CALL readCategoria(1);
# (idCategoria, descripcion, porcImpuesto)
#CALL updateCategoria(null, null, null);
#CALL deleteCategoria(2);

#PROVEEDORES--------------------------------------------
#CREATE- Recibe: nombre, telefono, porcentaje ganancia
CALL CreateProveedor ("Juan Verduras", "8162-1629", 0.6);	#id=1
CALL CreateProveedor ("Dos Pinos", "2567-1629", 0.4);		#id=2
CALL CreateProveedor ("Tropical", "1782-1629", 0.5);		#id=3
CALL CreateProveedor ("Distribuidor AyR", "1829-2927", 0.3);#id=4
#CALL readProveedor(1);
# (idProveedor, nombre, telefono, porcGanancia)
#CALL updateProveedor(null, null, null, null);
#CALL deleteProveedor(2);

#TIPOS DE PAGO------------------------------------------
#CREATE- Recibe: Descripcion
CALL CreateTipoPago ("Tarjeta");		#id= 1
CALL CreateTipoPago ("Cheque");			#id= 2
CALL CreateTipoPago ("Efectivo");		#id= 3
CALL CreateTipoPago ("Criptomoneda");	#id= 4
#CALL readTipoPago(1);
# (idTipoPago, descripcion)
#CALL updateTipopago(null, null);
#CALL deleteTipoPago(4);

#CLIENTES------------------------------------------------
#CREATE- Recibe: Nombre, numero de telefono, correo, direccion otras señas, idCanton
CALL createCliente("Melissa Monge", "87117264", "meli2@gmail.com", "50 norte del comercial M", 1);		#id= 1
CALL createCliente("Mario Naranjo", "71729172", "mariNar@gmail.com", "125 sur de la floristeria A", 1);	#id= 2
CALL createCliente("Camila Cordero", "65627183", "camiiiC@gmail.com", "200 sureste del comercial M", 2);#id= 3
CALL createCliente("Estefania Mora", "52971823", "tefaMora@gmail.com", "50 sur de la Escuela A", 1);	#id= 4
CALL createCliente("Armando Ortega", "25638163", "armandOrtega@gmail.com", "150 oeste de la Escuela B", 3);	#id= 5
#CALL deleteCliente(4);

#SUCURSALXPRODUCTO--------------------------------------
#Esto funciona como el usuario del cliente en la sucursal
#CREATE- Recibe: idSucursal, idCliente
CALL createSucursalXCliente(1,1);
CALL createSucursalXCliente(1,2);
CALL createSucursalXCliente(2,3);
CALL createSucursalXCliente(1,4);
CALL createSucursalXCliente(3,5);

#PRODUCTOS------------------------------------------------
#CREATE- Recibe: Nombre, Categoria, minimo y máximo
CALL CreateProducto("Leche dos pinos 200ml", 1, 10, 50);	#id= 1
CALL CreateProducto("Leche dos pinos 500ml", 1, 10, 50);	#id= 2
CALL CreateProducto("Frijoles Tio Pelón 800g", 2, 15, 35);	#id= 3
CALL CreateProducto("Arroz Tío Pelón 1k", 4, 20, 60);		#id= 4
CALL CreateProducto("Arroz Luisiana 1k", 4, 20, 60);		#id= 5
#CALL deleteProducto(1);

#SUCURSALXPRODUCTO---------------------------------------------
#CREATE- Recibe: idSucursal, idProducto, cantidad de productos, cantidad minima, cantidad maxima
#				fecha produccion, fecha expiracion, estado y precio
CALL createLote (1, 1, 10, "2022-11-9", "2022-11-18", "En Mostrador", 1000); #id= 1
CALL createLote (1, 2, 5, "2022-11-9", "2022-11-18", "En Mostrador", 1200); #id= 2
CALL createLote (1, 4, 5, "2022-10-9", "2024-11-18", "En Mostrador", 1500); #id= 3
CALL createLote (1, 4, 5, "2022-10-9", "2022-10-18", "En Mostrador", 1500); #id= 3
#call updateLote(1,null,null,11,null,null,null,null);
#CALL deleteSucursalXProducto(1);

#PROMOCION------------------------------------------------
#CREATE- Recibe: Fecha inicial, fecha final, porcentaje, idLote
#Se puede probar con uno de los procedures
CALL createPromocion("2022-09-16", "2022-10-20", 0.05, 1);

#TIPO ENVIO----------------------------------------------
#Create- Recibe:Descripcion y cobro extra
CALL CreateTipoEnvio("fisico", 0.0);		#id= 1
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
CALL createProductoXProveedor(5, 4, 30, "2020-10-14", "2021-11-25", 1350.0);
#Agregar al proveedor 1
CALL createProductoXProveedor(1, 1, 30, "2020-10-14", "2023-11-25", 1300.0);
CALL createProductoXProveedor(2, 2, 24, "2010-10-14", "2023-11-25", 1200.0);
#CALL deleteProductoXProveedor(1);

#PEDIDOS(ClienteXSucusal)------------------------------------------------
#CREATE- Recibe: Fecha, idTipoPago, idCliente, idEmpleado, TipoEnvio, idSucursal
#Se puede probar con los procedures
CALL CreatePedido("2022-11-15", 1, 1, 1, 1, 1);
CALL CreatePedido("2022-11-15", 1, 1, 1, 1, 1);
#UPDATE
##call updatePedido(1, "2022-11-11", null, null, null, null);



#TARJETAS, CHEQUES Y CRIPTO-------------------------------
#Al cliente 1
CALL CreateTarjeta("1562514", "123", "DEBITO", "2024-9-3", 1);
CALL CreateCheque("123", "167993", "2022-12-11", "...", 1);
CALL CreateCriptoMONEDA("...","...", 1 );
#CALL deleteCriptomoneda(1);
#CALL deleteCheque(1);
#CALL deleteTarjeta(1);

#ENCARGO------------------------------------------
#CREATE- Recibe: Fecha, idsucursal, cantidad, idProducto, idProveedor
CALL createEncargo("2022-11-11", 1, 10, 1, 2);
#CALL deleteEncargo(2);

#DETALLE--------------------------------------------
#CALL deleteDetalle(1);


#-----------------------PRUEBAS PROCEDURES------------------------------------
#1- Porcedure para reportes, recibe id del pais, id del producto, fecha final, fecha inicial
#			id de la sucursal, id del proveedor, todos opcionales
CALL reportesGerenteGeneral(NULL, NULL, NULL, NULL, NULL, NULL);

#2- Consultar empleados, recibe el idsucursal, nombre, idPuesto, descripcion puesto, rango de fechas de contratacion
CALL consultarEmpleados(NULL, NULL, NULL, NULL, NULL, NULL);

#3- Consultar proveedores por nombre proveedor o nombre producto
CALL consultarProveedores(NULL, "Dos Pinos");

#4- Procedure para revisar el inventario de la sucursal (Si estan vencidos...),recibe el porcentaje de descuento
CALL revisarProductosSucursal(0.05);

#5- Hacer pedido al proveedor, recibe el id de la sucursal que va a comprar y el del producto a comprar
call hacerPedidoProveedor(2, 1);
call hacerPedidoProveedor(3, 2);


#6- Crear pedidos y agregar detalles, recibe tipo de pago, cliente, empleado, tipo de envio y id de la sucursal
CALL crearPedido(1, 2, 2, 1, 1);
CALL crearPedido(1, 5, 2, 1, 1);	#Pedido de cliente de sucursal si no tiene cuenta->Esta anotado en sucursal 3
CALL crearPedido(1, 3, 8, 1, 2); 	#Empleado no pertenece a la sucursal
CALL crearPedido(1, 5, 9, 1, 3);
#idpedido, idProducto,idcantidad
CALL Agregardetalle(1, 3, 2);
CALL Agregardetalle(2, 1, 10);

SELECT * FROM Lote;
SELECT * FROM Pedido;
SELECT * FROM Detalle;
SELECT * FROM Empleado;
#7- Consultar monto de envios, recibe el idTipoEnvioV, fechI, fechF, idSucursalV, idClienteV 
call montoEnvios(2,"2022-11-10","2022-11-30",1,1);

#8- Dar bonos a empleados con mas de 1000 ventas
CALL bonoEmpleados();

#9- Productos mas vendidos, recibe la sucursal y un rango de fechas
CALL productosMasVendidos(1, NULL, NULL);

#10- Clientes frecuentes, recibe la sucursal
CALL clientesFrecuentes(NULL);

#11- Procedure para ver los productos expirados, recibe la sucursal(opcional)
CALL reporteExpiradosSucursal(1);

#12- Ganancias netas, recibe idSucursal, rango de fechas, id pais, categoria de producto
call gananciasNetas("2007-01-01", "2022-12-31", 1,1,1);

#13- Informacion de bonos, recibe idSucursal, idPais, rango de fechas
CALL informacionBonos(1, NULL, NULL, NULL);

#14- Consultar los precios
CALL ConsultarPreciosProductos(2);

#15- Consultar productos por id del proveedor
CALL consultaProductosProveedor(NULL);

#16- Descartar productos vencidos de los proveedores
CALL sacarVencidosInvProveedor();


SELECT * from lote;
select * from productoXProveedor;
select * from detalle;
select * from pedido;
select * from proveedor;
select * from producto;
select * from empleado;
select * from cargo;
