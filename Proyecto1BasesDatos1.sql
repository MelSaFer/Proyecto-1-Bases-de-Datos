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
DROP TABLE IF EXISTS Sucursal;
CREATE TABLE Sucursal (
		idSucursal INT PRIMARY KEY AUTO_INCREMENT,
        nombreSucursal VARCHAR(30) NOT NULL,
        direccion VARCHAR(30) NOT NULL,
        idCanton INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Pedido;
CREATE TABLE Pedido (
		idPedido INT PRIMARY KEY AUTO_INCREMENT,
        fecha DATE NOT NULL,
        cedula INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Producto;
CREATE TABLE Producto (
		idProducto INT PRIMARY KEY AUTO_INCREMENT,
        precio DECIMAL(15,2) NOT NULL,
        fechaProduccion DATE NOT NULL,
        fechaExpiracion DATE NOT NULL,
        cantMin INT NOT NULL,
        cantMax INT NOT NULL,
        #estado
        porcGanancia DECIMAL(5,5) NOT NULL DEFAULT 0.0,
        idSucursal INT NOT NULL,
        idCategoria INT NOT NULL,
        idProveedor INT NOT NULL
        #idPromocion
);
#-------------------------------------------------
DROP TABLE IF EXISTS ProductoXPedido;
CREATE TABLE ProductoXPedido (
		idProducto INT,
		idPedido INT,
        cantidad INT NOT NULL,
        precio DECIMAL(15,2) NOT NULL,
        PRIMARY KEY (idProducto, idPedido)
);
#-------------------------------------------------
DROP TABLE IF EXISTS Categoria;
CREATE TABLE Categoria(
		idCategoria INT PRIMARY KEY AUTO_INCREMENT,
        descripcion VARCHAR(30) NOT NULL,
        procImpuesto DECIMAL(2,2) NOT NULL DEFAULT 0.0
);
#-------------------------------------------------
DROP TABLE IF EXISTS Proveedor;
CREATE TABLE Proveedor(
		idProveedor INT PRIMARY KEY AUTO_INCREMENT,
        nombre VARCHAR(30) NOT NULL,
        telefono INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Empleado;
CREATE TABLE Empleado (
		cedula INT PRIMARY KEY,
        nombre INT NOT NULL,
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
        porcentajeDesc DECIMAL(5,5) NOT NULL,
        idProducto INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Cliente;
CREATE TABLE Cliente (
		cedula INT PRIMARY KEY,
        nombre VARCHAR(30) NOT NULL,
        telefono INT NOT NULL,
        direccion VARCHAR(30) NOT NULL,
        idCanton INT NOT NULL
);

DROP TABLE IF EXISTS tipoPago;
CREATE TABLE tipoPago (
		idTipoPago INT PRIMARY KEY AUTO_INCREMENT,
        descripcion VARCHAR(15) NOT NULL,
        idCliente INT NOT NULL
);

DROP TABLE IF EXISTS Tarjeta;
CREATE TABLE Tarjeta (
		numTarjeta INT PRIMARY KEY,
        ccv INT NOT NULL,
        tipo VARCHAR(15) NOT NULL,
        fechaCaducidad DATE NOT NULL,
        idCliente INT NOT NULL
);

DROP TABLE IF EXISTS Criptomoneda;
CREATE TABLE Criptomoneda (
		direccionCripto VARCHAR(30) PRIMARY KEY,
        tipo VARCHAR(15) NOT NULL,
        idCliente INT NOT NULL
);

DROP TABLE IF EXISTS Cheque;
CREATE TABLE Cheque (
		numCheque INT PRIMARY KEY,
        rutaBancaria INT NOT NULL,
        fechaApertura DATE NOT NULL,
        cuentaBancaria INT NOT NULL,
        idCliente INT NOT NULL
);

#ALTER TABLES---------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------


#PROCEDURES-----------------------------------------------------------------------------------------
/*------------------------------------------------------------------
1 - Procedimiento para

ENTRADAS: 
SALIDAS: 
------------------------------------------------------------------*/








