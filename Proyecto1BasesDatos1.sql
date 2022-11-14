/*
	INSTITUTO TECNOLÓGICO DE COSTA RICA
		CAMPUS TECNOLÓGICO CARTAGO
	ESCUELA DE INGENIERIA EN COMPUTACION
		BASES DE DATOS 1 - IC4301 
				PROYECTO 1
                
	Profesora: Alicia Salazar Hernández
    
			   Estudiantes: 
Melany Dahiana Salas Fernández - 2021121147
	Moises Solano Espinoza - 2021144322
    
			II SEMESTRE, 2022
*/

DROP DATABASE IF EXISTS proyectoBases;
CREATE DATABASE proyectoBases;
USE proyectoBases;

#TABLES----------------------------------------------------------------------------------
#Tabla para la sucursal
DROP TABLE IF EXISTS GerenteGeneral;
CREATE TABLE GerenteGeneral (
		idGerenteGeneral INT PRIMARY KEY AUTO_INCREMENT,
        nombre VARCHAR(30) NOT NULL,
        telefono VARCHAR(13) NOT NULL,
        salarioBase DECIMAL(15,2) NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Sucursal;
CREATE TABLE Sucursal (
		idSucursal INT PRIMARY KEY AUTO_INCREMENT,
        nombreSucursal VARCHAR(30) NOT NULL,
        direccion VARCHAR(30) NOT NULL,
        idCanton INT NOT NULL,
        idGerenteGeneral INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Pedido;
CREATE TABLE Pedido (
		idPedido INT PRIMARY KEY AUTO_INCREMENT,
        fecha DATE NOT NULL,
        idCliente INT NOT NULL,
        idTipoPago INT NOT NULL,
        idEmpleado INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Producto;
CREATE TABLE Producto (
		idProducto INT PRIMARY KEY AUTO_INCREMENT,
        nombreProducto VARCHAR(30) NOT NULL,
        idCategoria INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Impuesto;
CREATE TABLE Impuesto(
		idImpuesto INT PRIMARY KEY AUTO_INCREMENT,
        descripcion VARCHAR(30) NOT NULL,
        porcImpuesto DECIMAL(5,2) NOT NULL DEFAULT 0.0
);
#-------------------------------------------------
DROP TABLE IF EXISTS Categoria;
CREATE TABLE Categoria(
		idCategoria INT PRIMARY KEY AUTO_INCREMENT,
        descripcion VARCHAR(30) NOT NULL,
        idImpuesto INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Proveedor;
CREATE TABLE Proveedor(
		idProveedor INT PRIMARY KEY AUTO_INCREMENT,
        nombre VARCHAR(30) NOT NULL,
        telefono VARCHAR(13) NOT NULL,
        porcGanancia DECIMAL(5,2) NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Empleado;
CREATE TABLE Empleado (
		idEmpleado INT PRIMARY KEY AUTO_INCREMENT,
        nombre VARCHAR(30) NOT NULL,
        fechaContratacion DATE NOT NULL,
        salarioBase DECIMAL(15,2) NOT NULL,
        idSucursal INT NOT NULL,
        idCargo INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Cargo;
CREATE TABLE Cargo (
		idCargo INT PRIMARY KEY AUTO_INCREMENT,
        descripcion VARCHAR (30)
);
#-------------------------------------------------
DROP TABLE IF EXISTS Bono;
CREATE TABLE Bono (
		idBono INT PRIMARY KEY AUTO_INCREMENT,
        monto DECIMAL(15,2) NOT NULL,
        fecha DATE NOT NULL,
        idEmpleado INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Canton;
CREATE TABLE Canton (
		idCanton INT PRIMARY KEY AUTO_INCREMENT,
        nombre VARCHAR(30) NOT NULL,
        idProvincia INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Provincia;
CREATE TABLE Provincia (
		idProvincia INT PRIMARY KEY AUTO_INCREMENT,
        nombre VARCHAR(30) NOT NULL,
        idPais INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Pais;
CREATE TABLE Pais (
		idPais INT PRIMARY KEY AUTO_INCREMENT,
        nombre VARCHAR(30) NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Promocion;
CREATE TABLE Promocion (
		idPromocion INT PRIMARY KEY AUTO_INCREMENT,
        fechaInicial DATE NOT NULL,
        fechaFinal DATE NOT NULL,
        porcentajeDesc DECIMAL(5,2) NOT NULL,
        idProducto INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Cliente;
CREATE TABLE Cliente (
		idCliente INT PRIMARY KEY AUTO_INCREMENT,
        nombre VARCHAR(30) NOT NULL,
        telefono VARCHAR(13) NOT NULL,
        correo VARCHAR(30) NOT NULL,
        direccion VARCHAR(30) NOT NULL,
        idCanton INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS tipoPago;
CREATE TABLE tipoPago (
		idTipoPago INT PRIMARY KEY AUTO_INCREMENT,
        descripcion VARCHAR(15) NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Tarjeta;
CREATE TABLE Tarjeta (
		idTarjeta INT PRIMARY KEY AUTO_INCREMENT,
		numTarjeta VARCHAR(16) NOT NULL,
        ccv INT NOT NULL,
        tipo VARCHAR(15) NOT NULL,
        fechaCaducidad DATE NOT NULL,
        idCliente INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Criptomoneda;
CREATE TABLE Criptomoneda (
		idCriptomoneda INT PRIMARY KEY AUTO_INCREMENT,
		direccionCripto VARCHAR(30),
        tipo VARCHAR(15) NOT NULL,
        idCliente INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Cheque;
CREATE TABLE Cheque (
		idCheque INT PRIMARY KEY AUTO_INCREMENT,
		numCheque VARCHAR(9) NOT NULL,
        rutaBancaria VARCHAR(23) NOT NULL,
        fechaApertura DATE NOT NULL,
        cuentaBancaria VARCHAR(20) NOT NULL,
        idCliente INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS SucursalXProducto;
CREATE TABLE SucursalXProducto (
		idSucursalXProducto INT PRIMARY KEY AUTO_INCREMENT,
        idSucursal INT NOT NULL,
        idProducto INT NOT NULL,
        cantidad INT NOT NULL,
        cantidadMin INT NOT NULL,
        cantidadMax INT NOT NULL,
        fechaProduccion DATE NOT NULL,
        fechaExpiracion DATE NOT NULL,
		estado VARCHAR(30) NOT NULL,  #Para saber si el producto vencio, esta en promo...
        precio DECIMAL(15,2) NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Encargo;
CREATE TABLE Encargo (
		idEncargo INT PRIMARY KEY AUTO_INCREMENT,
		fecha DATE NOT NULL,
		idSucursal INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS EncargoXProducto;
CREATE TABLE EncargoXProducto (
		idEncargoXProducto INT PRIMARY KEY AUTO_INCREMENT,
		idProducto INT NOT NULL,
        idEncargo INT NOT NULL,
        cantidad INT NOT NULL,
        precio DECIMAL(15,2) NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS ProductoXProveedor;
CREATE TABLE ProductoXProveedor (
		idProductoXProveedor INT PRIMARY KEY AUTO_INCREMENT,
        idProducto INT NOT NULL,
        idProveedor INT NOT NULL,
        existencias INT NOT NULL,
        fechaProduccion DATE NOT NULL,
        fechaExpiracion DATE NOT NULL,
        precio DECIMAL(15,2) NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Detalle;
CREATE TABLE Detalle (
		idDetalle INT PRIMARY KEY AUTO_INCREMENT,
        cantidad INT NOT NULL,
        idPedido INT NOT NULL,
        idProducto INT NOT NULL
);


#ALTER TABLES---------------------------------------------------------------------------------------
ALTER TABLE Sucursal ADD CONSTRAINT SucursalXCanton_fk FOREIGN KEY(idCanton) REFERENCES Canton(idCanton);
ALTER TABLE Sucursal ADD CONSTRAINT SucursalXGerenteG_fk FOREIGN KEY(idGerenteGeneral) REFERENCES GerenteGeneral(idGerenteGeneral);
ALTER TABLE Canton ADD CONSTRAINT CantonXProvincia_fk FOREIGN KEY(idProvincia) REFERENCES Provincia(idProvincia);
ALTER TABLE Provincia ADD CONSTRAINT ProvinciaXPais_fk FOREIGN KEY(idPais) REFERENCES Pais(idPais);
ALTER TABLE Empleado ADD CONSTRAINT EmpleadoXSucursal_fk FOREIGN KEY(idSucursal) REFERENCES Sucursal(idSucursal);
ALTER TABLE Empleado ADD CONSTRAINT EmpleadoXCargo_fk FOREIGN KEY(idCargo) REFERENCES Cargo(idCargo);
ALTER TABLE Promocion ADD CONSTRAINT PromocionXProducto_fk FOREIGN KEY(idProducto) REFERENCES Producto(idProducto);
ALTER TABLE Producto ADD CONSTRAINT ProductoXCategoria_fk FOREIGN KEY(idCategoria) REFERENCES Categoria(idCategoria);
ALTER TABLE Pedido ADD CONSTRAINT PedidoXTipoPago_fk FOREIGN KEY(idTipoPago) REFERENCES tipoPago(idTipoPago);
ALTER TABLE Pedido ADD CONSTRAINT PedidoXCliente_fk FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente);
ALTER TABLE Pedido ADD CONSTRAINT PedidoXEmpleado_fk FOREIGN KEY(idEmpleado) REFERENCES Empleado(idEmpleado);
ALTER TABLE Tarjeta ADD CONSTRAINT TarjetaXCliente_fk FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente);
ALTER TABLE Criptomoneda ADD CONSTRAINT CriptomonedaXCliente_fk FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente);
ALTER TABLE Cheque ADD CONSTRAINT ChequeXCliente_fk FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente);
ALTER TABLE Cliente ADD CONSTRAINT ClienteXCanton_fk FOREIGN KEY(idCanton) REFERENCES Canton(idCanton);
ALTER TABLE Encargo ADD CONSTRAINT EncargoXSucursal_fk FOREIGN KEY(idSucursal) REFERENCES Sucursal(idSucursal);
ALTER TABLE Bono ADD CONSTRAINT BonoXEmpleado_fk FOREIGN KEY(idEmpleado) REFERENCES Empleado(idEmpleado); #888888888888888
ALTER TABLE EncargoXProducto ADD CONSTRAINT EncargoXProducto_XEncargo_fk FOREIGN KEY(idEncargo) REFERENCES Encargo(idEncargo);
ALTER TABLE EncargoXProducto ADD CONSTRAINT EncargoXProducto_XProducto_fk FOREIGN KEY(idProducto) REFERENCES Producto(idProducto);
ALTER TABLE ProductoXProveedor ADD CONSTRAINT ProductoXProveedor_XProducto_fk FOREIGN KEY(idProducto) REFERENCES Producto(idProducto);
ALTER TABLE ProductoXProveedor ADD CONSTRAINT ProductoXProveedor_XProveedor_fk FOREIGN KEY(idProveedor) REFERENCES Proveedor(idProveedor);
ALTER TABLE Categoria ADD CONSTRAINT CategoriaXImpuesto_fk FOREIGN KEY(idImpuesto) REFERENCES Impuesto(idImpuesto);
ALTER TABLE Detalle ADD CONSTRAINT DetalleXPedido_fk FOREIGN KEY(idPedido) REFERENCES Pedido(idPedido);
ALTER TABLE Detalle ADD CONSTRAINT DetalleXProducto_fk FOREIGN KEY(idProducto) REFERENCES Producto(idProducto);
ALTER TABLE SucursalXProducto ADD CONSTRAINT SucursalXProducto_XProducto_fk FOREIGN KEY(idProducto) REFERENCES Producto(idProducto);
ALTER TABLE SucursalXProducto ADD CONSTRAINT SucursalXProducto_XSucursal_fk FOREIGN KEY(idSucursal) REFERENCES Sucursal(idSucursal);
#---------------------------------------------------------------------------------------------------


#################################################################################
######### READS
#################################################################################
DROP PROCEDURE IF EXISTS readPais;
DELIMITER $$
CREATE PROCEDURE readPais (idPaisV INT)
BEGIN
	IF(idPaisV IS NULL) THEN
		SELECT "Ingrese el id del país" AS ERROR;
	ELSEIF(SELECT COUNT(*) FROM Pais 
		WHERE Pais.idPais = IFNULL(idPaisV, Pais.idPais)) = 0 THEN
		SELECT "No existe pais con ese id" AS ERROR;
	ELSE
		SELECT Pais.idPais, Pais.nombre FROM Pais
		WHERE Pais.idPais = IFNULL(idPaisV, Pais.idPais);
	END IF;
END;
$$
CALL readPais (4);
SELECT * FROM PAIS

#=========================================================
DROP PROCEDURE IF EXISTS readProvincia;
DELIMITER $$
CREATE PROCEDURE readProvincia (idProvinciaV INT)
BEGIN

	IF(idProvinciaV IS NULL) THEN
		SELECT "Ingrese el id de la provincia" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Provincia 
		WHERE Provincia.idProvincia = IFNULL(idProvinciaV, Provincia.idProvincia)) = 0 THEN
		SELECT "No existe pais con ese id" AS ERROR;
	ELSE
		SELECT Provincia.idProvincia, Provincia.nombre FROM Provincia
		WHERE Provincia.idProvincia = IFNULL(idProvinciaV, Provincia.idProvincia);
	END IF;
END;
$$
CALL readProvincia (3);
select * from provincia

#========================================================
DROP PROCEDURE IF EXISTS readCanton;
DELIMITER $$
CREATE PROCEDURE readCanton (idCantonV INT)
BEGIN

	IF(idCantonV IS NULL) THEN
		SELECT "Ingrese el id del canton" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Canton 
		WHERE Canton.idCanton = IFNULL(idCantonV, Canton.idCanton)) = 0 THEN
		SELECT "No existe canton con ese id" AS ERROR;
	ELSE
		SELECT Canton.idCanton, Canton.nombre FROM Canton
		WHERE Canton.idCanton = IFNULL(idCantonV, Canton.idCanton);
	END IF;
END;
$$
CALL readCanton (1);

INSERT INTO Canton(nombre, idProvincia) VALUES ("Dota", 1)
select * from canton

#========================================================
DROP PROCEDURE IF EXISTS readCargo;
DELIMITER $$
CREATE PROCEDURE readCargo (idCargoV INT)
BEGIN

	IF(idCargoV IS NULL) THEN
		SELECT "Ingrese el id del cargo" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM cargo 
		WHERE cargo.idCargo = IFNULL(idCargoV, cargo.idCargo)) = 0 THEN
		SELECT "No existe cargo con ese id" AS ERROR;
	ELSE
		SELECT cargo.idCargo, cargo.descripcion FROM cargo
		WHERE cargo.idCargo = IFNULL(idCargoV, cargo.idCargo);
	END IF;
END;
$$
CALL readCargo (1);

INSERT INTO Cargo(descripcion) VALUES ("Cajero");
select * from cargo

#========================================================
DROP PROCEDURE IF EXISTS readGerenteGeneral;
DELIMITER $$
CREATE PROCEDURE readGerenteGeneral (idGerenteGeneralV INT)
BEGIN

	IF(idGerenteGeneralV IS NULL) THEN
		SELECT "Ingrese el id del gerente general" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM gerentegeneral 
		WHERE gerentegeneral.idGerenteGeneral = IFNULL(idGerenteGeneralV, gerentegeneral.idGerenteGeneral)) = 0 THEN
		SELECT "No existe gerente general con ese id" AS ERROR;
	ELSE
		SELECT gerentegeneral.idGerenteGeneral, gerentegeneral.nombre, gerentegeneral.telefono, gerentegeneral.salarioBase FROM gerentegeneral
		WHERE gerentegeneral.idGerenteGeneral = IFNULL(idGerenteGeneralV, gerentegeneral.idGerenteGeneral);
	END IF;
END;
$$
CALL readGerenteGeneral (1);

INSERT INTO gerentegeneral(nombre, telefono, salarioBase) VALUES ("Moises", "88888888", 250000);
select * from gerentegeneral

#========================================================
DROP PROCEDURE IF EXISTS readTipoPago;
DELIMITER $$
CREATE PROCEDURE readTipoPago (idTipoPagoV INT)
BEGIN

	IF(idTipoPagoV IS NULL) THEN
		SELECT "Ingrese el id del tipo de pago" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM TipoPago 
		WHERE TipoPago.idTipoPago = IFNULL(idTipoPagoV, TipoPago.idTipoPago)) = 0 THEN
		SELECT "No existe tipo de pago con ese id" AS ERROR;
	ELSE
		SELECT TipoPago.idTipoPago, TipoPago.descripcion FROM TipoPago
		WHERE TipoPago.idTipoPago = IFNULL(idTipoPagoV, TipoPago.idTipoPago);
	END IF;
END;
$$
CALL readTipoPago (1);

INSERT INTO tipopago(descripcion) VALUES ("Tarjeta");
select * from TipoPago

#========================================================
DROP PROCEDURE IF EXISTS readCliente;
DELIMITER $$
CREATE PROCEDURE readCliente (idClienteV INT)
BEGIN

	IF(idClienteV IS NULL) THEN
		SELECT "Ingrese el id del cliente" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM cliente 
		WHERE cliente.idCliente = IFNULL(idClienteV, cliente.idCliente)) = 0 THEN
		SELECT "No existe cliente con ese id" AS ERROR;
	ELSE
		SELECT cliente.idCliente, cliente.nombre, cliente.telefono, cliente.correo, cliente.direccion, cliente.idCanton FROM cliente
		WHERE cliente.idCliente = IFNULL(idClienteV, cliente.idCliente);
	END IF;
END;
$$
CALL readCliente (1);

INSERT INTO cliente(idCliente, nombre, telefono, correo, direccion, idCanton) VALUES (1, "Juan", "99999999", "juan@gmail.com", "Hola", 1)
select * from TipoPago

#========================================================
DROP PROCEDURE IF EXISTS readTarjeta;
DELIMITER $$
CREATE PROCEDURE readTarjeta (idTarjetaV INT)
BEGIN

	IF(idTarjetaV IS NULL) THEN
		SELECT "Ingrese el id de la tarjeta" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Tarjeta 
		WHERE tarjeta.idTarjeta = IFNULL(idTarjetaV, tarjeta.idTarjeta)) = 0 THEN
		SELECT "No existe tarjeta con ese id" AS ERROR;
	ELSE
		SELECT tarjeta.idTarjeta, tarjeta.numTarjeta, tarjeta.ccv, tarjeta.tipo, tarjeta.fechaCaducidad, tarjeta.idCliente FROM tarjeta
		WHERE tarjeta.idTarjeta = IFNULL(idTarjetaV, Tarjeta.idTarjeta);
	END IF;
END;
$$
CALL readTarjeta (1);

INSERT INTO Tarjeta(numTarjeta, ccv, tipo, fechaCaducidad, idCliente) VALUES ("6321594986987125", 555, "debito", "2024-06-01", 1)
select * from Tarjeta

#========================================================
DROP PROCEDURE IF EXISTS readCriptomoneda;
DELIMITER $$
CREATE PROCEDURE readCriptomoneda (idCriptomonedaV INT)
BEGIN

	IF(idCriptomonedaV IS NULL) THEN
		SELECT "Ingrese el id de la criptomoneda" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Criptomoneda 
		WHERE Criptomoneda.idCriptomoneda = IFNULL(idCriptomonedaV, Criptomoneda.idCriptomoneda)) = 0 THEN
		SELECT "No existe criptomoneda con ese id" AS ERROR;
	ELSE
		SELECT Criptomoneda.idCriptomoneda, Criptomoneda.direccionCripto, Criptomoneda.tipo, Criptomoneda.idCliente FROM Criptomoneda
		WHERE Criptomoneda.idCriptomoneda = IFNULL(idCriptomonedaV, Criptomoneda.idCriptomoneda);
	END IF;
END;
$$
CALL readCriptomoneda (1);

INSERT INTO Criptomoneda(direccionCripto, tipo, idCliente) VALUES ("2165112315949816219564", "bitcoin", 1)
select * from Criptomoneda

#========================================================
DROP PROCEDURE IF EXISTS readCheque;
DELIMITER $$
CREATE PROCEDURE readCheque (idChequeV INT)
BEGIN

	IF(idChequeV IS NULL) THEN
		SELECT "Ingrese el id del cheque" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Cheque 
		WHERE Cheque.idCheque = IFNULL(idChequeV, Cheque.idCheque)) = 0 THEN
		SELECT "No existe cheque con ese id" AS ERROR;
	ELSE
		SELECT Cheque.numCheque, Cheque.rutaBancaria, Cheque.fechaApertura, Cheque.cuentaBancaria, Cheque.idCliente FROM Cheque
		WHERE Cheque.idCheque = IFNULL(idChequeV, Cheque.idCheque);
	END IF;
END;
$$
CALL readCheque (1);

INSERT INTO Cheque(numCheque, rutaBancaria, fechaApertura, cuentaBancaria, idCliente) 
VALUES ("123456789", "12345678912345678912345", "2020-05-25", "48963548231597896423", 1);
select * from Cheque

#========================================================
DROP PROCEDURE IF EXISTS readSucursal;
DELIMITER $$
CREATE PROCEDURE readSucursal (idSucursalV INT)
BEGIN

	IF(idSucursalV IS NULL) THEN
		SELECT "Ingrese el id de la sucursal" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Sucursal 
		WHERE Sucursal.idSucursal = IFNULL(idSucursalV, Sucursal.idSucursal)) = 0 THEN
		SELECT "No existe sucursal con ese id" AS ERROR;
	ELSE
		SELECT Sucursal.idSucursal, Sucursal.nombreSucursal, Sucursal.direccion, Sucursal.idCanton, Sucursal.idGerenteGeneral FROM Sucursal
		WHERE Sucursal.idSucursal = IFNULL(idSucursalV, Sucursal.idSucursal);
	END IF;
END;
$$
CALL readSucursal (1);

INSERT INTO Sucursal(nombreSucursal, direccion, idCanton, idGerenteGeneral) 
VALUES ("Cartago", "Centro", 1, 1);

select * from sucursal

#========================================================
DROP PROCEDURE IF EXISTS readEmpleado;
DELIMITER $$
CREATE PROCEDURE readEmpleado (idEmpleadoV INT)
BEGIN

	IF(idEmpleadoV IS NULL) THEN
		SELECT "Ingrese el id del empleado" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Empleado 
		WHERE Empleado.idEmpleado = IFNULL(idEmpleadoV, Empleado.idEmpleado)) = 0 THEN
		SELECT "No existe empleado con ese id" AS ERROR;
	ELSE
		SELECT Empleado.idEmpleado, Empleado.nombre, Empleado.fechaContratacion, Empleado.salarioBase, 
        Empleado.idSucursal, Empleado.idCargo FROM Empleado
		WHERE Empleado.idEmpleado = IFNULL(idEmpleadoV, Empleado.idEmpleado);
	END IF;
END;
$$
CALL readEmpleado (1);

INSERT INTO Empleado(nombre, fechaContratacion, salarioBase, idSucursal, idCargo) 
VALUES ("Rebeca", "2015-09-02", 500000, 1, 1);

select * from empleado

#========================================================
DROP PROCEDURE IF EXISTS readBono;
DELIMITER $$
CREATE PROCEDURE readBono (idBonoV INT)
BEGIN

	IF(idBonoV IS NULL) THEN
		SELECT "Ingrese el id del bono" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Bono 
		WHERE Bono.idBono = IFNULL(idBonoV, Bono.idBono)) = 0 THEN
		SELECT "No existe bono con ese id" AS ERROR;
	ELSE
		SELECT Bono.monto, Bono.fecha, Bono.idEmpleado FROM Bono
		WHERE Bono.idBono = IFNULL(idBonoV, Bono.idBono);
	END IF;
END;
$$
CALL readBono (1);

INSERT INTO Bono(monto, fecha, idEmpleado) 
VALUES (250000, "2022-11-12", 1);
select * from Bono

#========================================================
DROP PROCEDURE IF EXISTS readEncargo;
DELIMITER $$
CREATE PROCEDURE readEncargo (idEncargoV INT)
BEGIN

	IF(idEncargoV IS NULL) THEN
		SELECT "Ingrese el id del encargo" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Encargo 
		WHERE Encargo.idEncargo = IFNULL(idEncargoV, Encargo.idEncargo)) = 0 THEN
		SELECT "No existe encargo con ese id" AS ERROR;
	ELSE
		SELECT Encargo.idEncargo, Encargo.Fecha, Encargo.idSucursal FROM encargo
		WHERE Encargo.idEncargo = IFNULL(idEncargoV, Encargo.idEncargo);
	END IF;
END;
$$
CALL readEncargo (1);

INSERT INTO Encargo(fecha, idSucursal) VALUES ("2022-12-11", 1)
select * from encargo

#========================================================
DROP PROCEDURE IF EXISTS readProveedor;
DELIMITER $$
CREATE PROCEDURE readProveedor (idProveedorV INT)
BEGIN

	IF(idProveedorV IS NULL) THEN
		SELECT "Ingrese el id del Proveedor" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Proveedor 
		WHERE Proveedor.idProveedor = IFNULL(idProveedorV, Proveedor.idProveedor)) = 0 THEN
		SELECT "No existe Proveedor con ese id" AS ERROR;
	ELSE
		SELECT Proveedor.idProveedor, Proveedor.nombre, Proveedor.telefono, Proveedor.porcGanancia FROM Proveedor
		WHERE Proveedor.idProveedor = IFNULL(idProveedorV, Proveedor.idProveedor);
	END IF;
END;
$$
CALL readProveedor (1);

INSERT INTO Proveedor(nombre, telefono, porcGanancia) VALUES ("Terranova", "25634895", 9)
select * from proveedor

#========================================================
DROP PROCEDURE IF EXISTS readImpuesto;
DELIMITER $$
CREATE PROCEDURE readImpuesto (idImpuestoV INT)
BEGIN

	IF(idImpuestoV IS NULL) THEN
		SELECT "Ingrese el id del Impuesto" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Impuesto 
		WHERE Impuesto.idImpuesto = IFNULL(idImpuestoV, Impuesto.idImpuesto)) = 0 THEN
		SELECT "No existe Impuesto con ese id" AS ERROR;
	ELSE
		SELECT Impuesto.idImpuesto, Impuesto.descripcion, Impuesto.porcImpuesto FROM Impuesto
		WHERE Impuesto.idImpuesto = IFNULL(idImpuestoV, Impuesto.idImpuesto);
	END IF;
END;
$$

#========================================================
DROP PROCEDURE IF EXISTS readCategoria;
DELIMITER $$
CREATE PROCEDURE readCategoria (idCategoriaV INT)
BEGIN

	IF(idCategoriaV IS NULL) THEN
		SELECT "Ingrese el id del Categoria" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Categoria 
		WHERE Categoria.idCategoria = IFNULL(idCategoriaV, Categoria.idCategoria)) = 0 THEN
		SELECT "No existe Categoria con ese id" AS ERROR;
	ELSE
		SELECT Categoria.idCategoria, Categoria.descripcion, Categoria.idImpuesto FROM Categoria
		WHERE Categoria.idCategoria = IFNULL(idCategoriaV, Categoria.idCategoria);
	END IF;
END;
$$

#========================================================
DROP PROCEDURE IF EXISTS readPedido;
DELIMITER $$
CREATE PROCEDURE readPedido (idPedidoV INT)
BEGIN

	IF(idPedidoV IS NULL) THEN
		SELECT "Ingrese el id del Pedido" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Pedido 
		WHERE Pedido.idPedido = IFNULL(idPedidoV, Pedido.idPedido)) = 0 THEN
		SELECT "No existe Pedido con ese id" AS ERROR;
	ELSE
		SELECT Pedido.idPedido, Pedido.fecha, Pedido.idCliente, Pedido.idTipoPago FROM Pedido
		WHERE Pedido.idPedido = IFNULL(idPedidoV, Pedido.idPedido);
	END IF;
END;
$$

#========================================================
DROP PROCEDURE IF EXISTS readProducto;
DELIMITER $$
CREATE PROCEDURE readProducto (idProductoV INT)
BEGIN

	IF(idProductoV IS NULL) THEN
		SELECT "Ingrese el id del Producto" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Producto 
		WHERE Producto.idProducto = IFNULL(idProductoV, Producto.idProducto)) = 0 THEN
		SELECT "No existe Producto con ese id" AS ERROR;
	ELSE
		SELECT Producto.idProducto, Producto.nombreProducto, Producto.idCategoria FROM Producto
		WHERE Producto.idProducto = IFNULL(idProductoV, Producto.idProducto);
	END IF;
END;
$$

#========================================================
DROP PROCEDURE IF EXISTS readDetalle;
DELIMITER $$
CREATE PROCEDURE readDetalle (idDetalleV INT)
BEGIN

	IF(idDetalleV IS NULL) THEN
		SELECT "Ingrese el id del Detalle" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Detalle 
		WHERE Detalle.idDetalle = IFNULL(idDetalleV, Detalle.idDetalle)) = 0 THEN
		SELECT "No existe Detalle con ese id" AS ERROR;
	ELSE
		SELECT Detalle.idDetalle, Detalle.cantidad, Detalle.idPedido, Detalle.idProducto FROM Detalle
		WHERE Detalle.idDetalle = IFNULL(idDetalleV, Detalle.idDetalle);
	END IF;
END;
$$

#========================================================
DROP PROCEDURE IF EXISTS readProductoXProveedor;
DELIMITER $$
CREATE PROCEDURE readProductoXProveedor (idProductoXProveedorV INT)
BEGIN

	IF(idProductoXProveedorV IS NULL) THEN
		SELECT "Ingrese el id del ProductoXProveedor" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM ProductoXProveedor 
		WHERE ProductoXProveedor.idProductoXProveedor = IFNULL(idProductoXProveedorV, ProductoXProveedor.idProductoXProveedor)) = 0 THEN
		SELECT "No existe ProductoXProveedor con ese id" AS ERROR;
	ELSE
		SELECT ProductoXProveedor.idProductoXProveedor, ProductoXProveedor.idProducto, ProductoXProveedor.idProveedor,
        ProductoXProveedor.existencias, ProductoXProveedor.fechaProduccion, ProductoXProveedor.fechaExpiracion FROM ProductoXProveedor
		WHERE ProductoXProveedor.idProductoXProveedor = IFNULL(idProductoXProveedorV, ProductoXProveedor.idProductoXProveedor);
	END IF;
END;
$$

#========================================================
DROP PROCEDURE IF EXISTS readPromocion;
DELIMITER $$
CREATE PROCEDURE readPromocion (idPromocionV INT)
BEGIN

	IF(idPromocionV IS NULL) THEN
		SELECT "Ingrese el id de la Promocion" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Promocion 
		WHERE Promocion.idPromocion = IFNULL(idPromocionV, Promocion.idPromocion)) = 0 THEN
		SELECT "No existe Promocion con ese id" AS ERROR;
	ELSE
		SELECT Promocion.idPromocion, Promocion.fechaInicial, Promocion.fechaFinal, 
        Promocion.porcentajeDesc, Promocion.idProducto FROM Promocion
		WHERE Promocion.idPromocion = IFNULL(idPromocionV, Promocion.idPromocion);
	END IF;
END;
$$

#========================================================
DROP PROCEDURE IF EXISTS readSucursalXProducto;
DELIMITER $$
CREATE PROCEDURE readSucursalXProducto (idSucursalXProductoV INT)
BEGIN

	IF(idSucursalXProductoV IS NULL) THEN
		SELECT "Ingrese el id de la SucursalXProducto" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM SucursalXProducto 
		WHERE SucursalXProducto.idSucursalXProducto = IFNULL(idSucursalXProductoV, SucursalXProducto.idSucursalXProducto)) = 0 THEN
		SELECT "No existe SucursalXProducto con ese id" AS ERROR;
	ELSE
		SELECT SucursalXProducto.idSucursalXProducto, SucursalXProducto.idSucursal, SucursalXProducto.idProducto,
        SucursalXProducto.cantidad, SucursalXProducto.cantidadMin, SucursalXProducto.cantidadMax, 
        SucursalXProducto.fechaProduccion, SucursalXProducto.fechaExpiracion, SucursalXProducto.estado FROM SucursalXProducto
		WHERE SucursalXProducto.idSucursalXProducto = IFNULL(idSucursalXProductoV, SucursalXProducto.idSucursalXProducto);
	END IF;
END;
$$


#========================================================
DROP PROCEDURE IF EXISTS readEncargoXProducto;
DELIMITER $$
CREATE PROCEDURE readEncargoXProducto (idEncargoXProductoV INT)
BEGIN

	IF(idEncargoXProductoV IS NULL) THEN
		SELECT "Ingrese el id del EncargoXProducto" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM EncargoXProducto 
		WHERE EncargoXProducto.idEncargoXProducto = IFNULL(idEncargoXProductoV, EncargoXProducto.idEncargoXProducto)) = 0 THEN
		SELECT "No existe EncargoXProducto con ese id" AS ERROR;
	ELSE
		SELECT EncargoXProducto.idEncargoXProducto, EncargoXProducto.idProducto, EncargoXProducto.idEncargo,
        EncargoXProducto.cantidad, EncargoXProducto.precio FROM EncargoXProducto
		WHERE EncargoXProducto.idEncargoXProducto = IFNULL(idEncargoXProductoV, EncargoXProducto.idEncargoXProducto);
	END IF;
END;
$$

#UPDATE------------------------
DROP PROCEDURE IF EXISTS updateProvincia;
DELIMITER $$
CREATE PROCEDURE updateProvincia (idProvinciaV INT, newNombre VARCHAR(30), newIdPais INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idProvinciaV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del pais";
        
	ELSEIF (SELECT COUNT(*) FROM Provincia WHERE Provincia.idProvincia = idProvinciaV) = 0 THEN
		SET message = "No existe esa provincia";
        
	ELSEIF ((newNombre IS NULL AND newIdPais IS NULL) OR (newIdPais IS NOT NULL AND (SELECT COUNT(*) FROM Pais where idPais = newIdPais) = 0)) THEN
		SET message = "Para modificar debe ingresar un nombre o idPais valido";
        
	ELSE
		UPDATE Provincia SET Provincia.nombre = IFNULL(newNombre, Provincia.nombre),
        Provincia.idPais = IFNULL(newIdPais, Provincia.idPais)
        WHERE Provincia.idProvincia = idProvinciaV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$


/*

#PRUEBAS
#Datos prueba


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
/
*/





