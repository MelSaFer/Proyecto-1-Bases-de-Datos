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
        idEmpleado INT NOT NULL,
        idTipoEnvio INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS TipoEnvio;
CREATE TABLE TipoEnvio (
		idTipoEnvio INT PRIMARY KEY AUTO_INCREMENT,
        descripcion VARCHAR(10) NOT NULL,
        porcentajeAdicional DECIMAL(5,2) NOT NULL
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
        idCanton INT NOT NULL,
        idSucursal INT NOT NULL
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
		idSucursal INT NOT NULL,
        cantidad INT NULL,
        idProducto INT NOT NULL, 
        idProveedor INT NOT NULL
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
ALTER TABLE Pedido ADD CONSTRAINT PedidoXTipoEnvio_fk FOREIGN KEY(idTipoEnvio) REFERENCES TipoEnvio(idTipoEnvio);
ALTER TABLE Tarjeta ADD CONSTRAINT TarjetaXCliente_fk FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente);
ALTER TABLE Criptomoneda ADD CONSTRAINT CriptomonedaXCliente_fk FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente);
ALTER TABLE Cheque ADD CONSTRAINT ChequeXCliente_fk FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente);
ALTER TABLE Cliente ADD CONSTRAINT ClienteXCanton_fk FOREIGN KEY(idCanton) REFERENCES Canton(idCanton);
ALTER TABLE Cliente ADD CONSTRAINT ClienteXSucursal_fk FOREIGN KEY(idSucursal) REFERENCES Sucursal(idSucursal);
ALTER TABLE Encargo ADD CONSTRAINT EncargoXSucursal_fk FOREIGN KEY(idSucursal) REFERENCES Sucursal(idSucursal);
ALTER TABLE Encargo ADD CONSTRAINT EncargoXProducto_fk FOREIGN KEY(idProducto) REFERENCES Producto(idProducto);
ALTER TABLE Encargo ADD CONSTRAINT EncargoXProveedor_fk FOREIGN KEY(idProveedor) REFERENCES Proveedor(idProveedor);
ALTER TABLE Bono ADD CONSTRAINT BonoXEmpleado_fk FOREIGN KEY(idEmpleado) REFERENCES Empleado(idEmpleado); #888888888888888
ALTER TABLE ProductoXProveedor ADD CONSTRAINT ProductoXProveedor_XProducto_fk FOREIGN KEY(idProducto) REFERENCES Producto(idProducto);
ALTER TABLE ProductoXProveedor ADD CONSTRAINT ProductoXProveedor_XProveedor_fk FOREIGN KEY(idProveedor) REFERENCES Proveedor(idProveedor);
ALTER TABLE Categoria ADD CONSTRAINT CategoriaXImpuesto_fk FOREIGN KEY(idImpuesto) REFERENCES Impuesto(idImpuesto);
ALTER TABLE Detalle ADD CONSTRAINT DetalleXPedido_fk FOREIGN KEY(idPedido) REFERENCES Pedido(idPedido);
ALTER TABLE Detalle ADD CONSTRAINT DetalleXProducto_fk FOREIGN KEY(idProducto) REFERENCES Producto(idProducto);
ALTER TABLE SucursalXProducto ADD CONSTRAINT SucursalXProducto_XProducto_fk FOREIGN KEY(idProducto) REFERENCES Producto(idProducto);
ALTER TABLE SucursalXProducto ADD CONSTRAINT SucursalXProducto_XSucursal_fk FOREIGN KEY(idSucursal) REFERENCES Sucursal(idSucursal);
#---------------------------------------------------------------------------------------------------








