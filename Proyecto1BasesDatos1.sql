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
        cedula INT NOT NULL,
        idTipoPago INT NOT NULL
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
        porcImpuesto DECIMAL(2,2) NOT NULL DEFAULT 0.0
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
#-------------------------------------------------
DROP TABLE IF EXISTS tipoPago;
CREATE TABLE tipoPago (
		idTipoPago INT PRIMARY KEY AUTO_INCREMENT,
        descripcion VARCHAR(15) NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Tarjeta;
CREATE TABLE Tarjeta (
		numTarjeta INT PRIMARY KEY,
        ccv INT NOT NULL,
        tipo VARCHAR(15) NOT NULL,
        fechaCaducidad DATE NOT NULL,
        cedula INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Criptomoneda;
CREATE TABLE Criptomoneda (
		direccionCripto VARCHAR(30) PRIMARY KEY,
        tipo VARCHAR(15) NOT NULL,
        cedula INT NOT NULL
);
#-------------------------------------------------
DROP TABLE IF EXISTS Cheque;
CREATE TABLE Cheque (
		numCheque INT PRIMARY KEY,
        rutaBancaria INT NOT NULL,
        fechaApertura DATE NOT NULL,
        cuentaBancaria INT NOT NULL,
        cedula INT NOT NULL
);

#ALTER TABLES---------------------------------------------------------------------------------------
ALTER TABLE Sucursal ADD CONSTRAINT SucursalXCanton_fk FOREIGN KEY(idCanton) REFERENCES Canton(idCanton);
ALTER TABLE Canton ADD CONSTRAINT CantonXProvincia_fk FOREIGN KEY(idProvincia) REFERENCES Provincia(idProvincia);
ALTER TABLE Provincia ADD CONSTRAINT ProvinciaXPais_fk FOREIGN KEY(idPais) REFERENCES Pais(idPais);
ALTER TABLE Empleado ADD CONSTRAINT EmpleadoXSucursal_fk FOREIGN KEY(idSucursal) REFERENCES Sucursal(idSucursal);
ALTER TABLE Empleado ADD CONSTRAINT EmpleadoXCargo_fk FOREIGN KEY(idCargo) REFERENCES Cargo(idCargo);
ALTER TABLE Promocion ADD CONSTRAINT PromocionXProducto_fk FOREIGN KEY(idProducto) REFERENCES Producto(idProducto);
ALTER TABLE Producto ADD CONSTRAINT ProductoXSucursal_fk FOREIGN KEY(idSucursal) REFERENCES Sucursal(idSucursal);
ALTER TABLE Producto ADD CONSTRAINT ProductoXCategoria_fk FOREIGN KEY(idCategoria) REFERENCES Categoria(idCategoria);
ALTER TABLE Producto ADD CONSTRAINT ProductoXProveedor_fk FOREIGN KEY(idProveedor) REFERENCES Proveedor(idProveedor);
ALTER TABLE ProductoXPedido ADD CONSTRAINT ProductoXPedido_XProducto_fk FOREIGN KEY(idProducto) REFERENCES Producto(idProducto);
ALTER TABLE ProductoXPedido ADD CONSTRAINT ProductoXPedido_XPedido_fk FOREIGN KEY(idPedido) REFERENCES Pedido(idPedido);
ALTER TABLE Pedido ADD CONSTRAINT PedidoXTipoPago_fk FOREIGN KEY(idTipoPago) REFERENCES tipoPago(idTipoPago);
ALTER TABLE Pedido ADD CONSTRAINT PedidoXCliente_fk FOREIGN KEY(cedula) REFERENCES Cliente(cedula);
ALTER TABLE Tarjeta ADD CONSTRAINT TarjetaXCliente_fk FOREIGN KEY(cedula) REFERENCES Cliente(cedula);
ALTER TABLE Criptomoneda ADD CONSTRAINT CriptomonedaXCliente_fk FOREIGN KEY(cedula) REFERENCES Cliente(cedula);
ALTER TABLE Cheque ADD CONSTRAINT ChequeXCliente_fk FOREIGN KEY(cedula) REFERENCES Cliente(cedula);
ALTER TABLE Cliente ADD CONSTRAINT ClienteXCanton_fk FOREIGN KEY(idCanton) REFERENCES Canton(idCanton);
#---------------------------------------------------------------------------------------------------


#PROCEDURES-----------------------------------------------------------------------------------------
/*------------------------------------------------------------------
1 - Procedimiento para

ENTRADAS: 
SALIDAS: 
------------------------------------------------------------------*/

#------------------------------CRUDS--------------------------------
/*------------------------------------------------------------------
1 - Procedimiento para crud de la tabla país
Hay un procedimiento diferente para cada opecacion
ENTRADAS: nombre del pais, el flag, el id del pais
SALIDAS: Mensaje con el resultado de la transaccion
------------------------------------------------------------------*/
#CREATE---------------------------------
DROP PROCEDURE IF EXISTS createPais;
DELIMITER $$
CREATE PROCEDURE createPais (nombreV VARCHAR(30))
BEGIN
	DECLARE message VARCHAR(60);
    
    IF nombreV IS NULL THEN
		SET message = "El nombre que ha ingresado no es valido";
        
    ELSEIF ((SELECT count(*) FROM Pais WHERE nombre = nombreV) != 0) THEN
		SET message = "El pais ya existe";
    ELSE
		INSERT INTO Pais (nombre)
					VALUES (nombreV);
		SET message = "Se ha insertado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
CALL createPais ("Panamá");
CALL createPais ("Costa Rica");
CALL createPais ("Alemania");

#READ----------------------------------
DROP PROCEDURE IF EXISTS readPais;
DELIMITER $$
CREATE PROCEDURE readPais (nombreV VARCHAR(30), idPaisV INT)
BEGIN
	IF(SELECT COUNT(*) FROM Pais 
		WHERE Pais.nombre = IFNULL(nombreV, Pais.nombre) 
		AND Pais.idPais = IFNULL(idPaisV, Pais.idPais)) = 0 THEN
		SELECT "No existe pais con esa descripcion" AS ERRORM;
	ELSE
		SELECT Pais.nombre, Pais.idPais FROM Pais
		WHERE Pais.nombre = IFNULL(nombreV, Pais.nombre) 
		AND Pais.idPais = IFNULL(idPaisV, Pais.idPais);
	END IF;
END;
$$
CALL readPais (null, 1);

#UPDATE-----------------------------------
DROP PROCEDURE IF EXISTS updatePais;
DELIMITER $$
CREATE PROCEDURE updatePais (nombreV VARCHAR(30), idPaisV INT, newName VARCHAR(30))
BEGIN
	DECLARE message VARCHAR(90);

	IF (nombreV IS NULL OR idPaisV IS NULL OR newName IS NULL) THEN
		SET message = "Para modificar debe colocar el nombre del pais y el codigo";
	ELSE
		UPDATE Pais SET Pais.nombre = IFNULL(newName, Pais.nombre) 
		WHERE Pais.idPais = idPaisV
		AND Pais.nombre = IFNULL(nombreV, Pais.nombre);
		SET message = "Se ha modificado con exito";
	END IF;
    SELECT message AS Resultado;
END;
$$
CALL updatePais ("Costa Rica", 1, "Alemania");

#DELETE--------------------------------
DROP PROCEDURE IF EXISTS deletePais;
DELIMITER $$
CREATE PROCEDURE deletePais (idPaisV INT)
BEGIN
	DECLARE message VARCHAR(90);
    
	IF (idPaisV IS NULL) THEN
		SET message = "Para eliminar debe colocar el codigo del país";
	ELSE
		DELETE FROM Pais WHERE Pais.idPais = idPaisV;
		SET message = "Se ha eliminado con éxito";
	END IF;
	SELECT message AS Resultado;
END;
$$
CALL deletePais (NULL);

/*------------------------------------------------------------------
1 - Procedimiento para crud de la tabla provincia
Si la Flag es 0 crea, si es 1 lee, si es 2 hace update y si es 4 borra
ENTRADAS: nombre del pais, el flag, el id del pais
SALIDAS: Mensaje con el resultado de la transaccion
------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS createProvincia;
DELIMITER $$
CREATE PROCEDURE createProvincia (nombreV VARCHAR(30), idPaisV INT, nombrePaisV VARCHAR(30))
BEGIN
	DECLARE message VARCHAR(60);
    
    IF nombreV IS NULL OR (idPaisV IS NULL AND nombrePaisV IS NULL) THEN
		SET message = "Los datos necesarios son null";
	ELSEIF ((SELECT count(*) FROM Provincia WHERE nombre = nombreV) != 0) THEN
		SET message = "El nombre no es valido, ya existe";
	ELSEIF ((SELECT COUNT(*) FROM Pais 
		WHERE Pais.idPais = IFNULL(idPaisV, Pais.idPais)
        AND Pais.nombre = IFNULL(nombrePaisV, Pais.nombre)) = 0) THEN
		SET message = "ERROR- El país no existe";
	ELSE 
		INSERT INTO Provincia (nombre, idPais) VALUES (nombreV, (SELECT Pais.idPais 
        FROM Pais WHERE Pais.idPais = IFNULL(idPaisV, Pais.idPais)
        AND Pais.nombre = IFNULL(nombrePaisV, Pais.nombre)));
		SET message = "Se ha insertado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
CALL createProvincia("San Jose", NULL, "Panamá");
CALL createProvincia("Ciudad de panamá", 1, NULL);
CALL createProvincia("Cartago", NULL, "Costa Rica");

#READ
DROP PROCEDURE IF EXISTS readProvincia;
DELIMITER $$
CREATE PROCEDURE readProvincia (nombreV VARCHAR(30), idProvinciaV INT, idPaisV INT, nombrePaisV VARCHAR(30))
BEGIN
	IF (SELECT COUNT(*) FROM Provincia
			INNER JOIN Pais ON Pais.idPais = Provincia.idPais
			WHERE Provincia.nombre = IFNULL(nombreV, Provincia.nombre) 
            AND Provincia.idProvincia = IFNULL(idProvinciaV, Provincia.idProvincia)
			AND Provincia.idPais = IFNULL(idPaisV, Provincia.idPais)
			AND Pais.nombre = IFNULL(nombrePaisV, Pais.nombre)) = 0 THEN
            SELECT "No existe una provincia con esos datos" AS Resultado;
	ELSE
		SELECT Provincia.nombre AS "Provincia", Pais.nombre AS "País" FROM Provincia
		INNER JOIN Pais ON Pais.idPais = Provincia.idPais
		WHERE Provincia.nombre = IFNULL(nombreV, Provincia.nombre) 
			AND Provincia.idProvincia = IFNULL(idProvinciaV, Provincia.idProvincia)
			AND Provincia.idPais = IFNULL(idPaisV, Provincia.idPais)
			AND Pais.nombre = IFNULL(nombrePaisV, Pais.nombre);
	END IF;
END;
$$
CALL readProvincia (NULL, NULL, NULL, NULL);

#UPDATE------------------------
DROP PROCEDURE IF EXISTS updateProvincia;
DELIMITER $$
CREATE PROCEDURE updateProvincia (nombreV VARCHAR(30), idProvinciaV INT, idPaisV INT,  nombrePaisV VARCHAR(30), 
								  newName VARCHAR(30), newIdProvincia INT, newNameProvincia VARCHAR(30))
BEGIN
	DECLARE message VARCHAR(60);
    
    #IF ((nombreV IS NULL OR idProvincia IS NULL) THEN
		#SET message AS "Debe ingresar el "
END;
$$
/*
DROP PROCEDURE IF EXISTS createProvincia;
DELIMITER $$
CREATE PROCEDURE createProvincia (nombreV VARCHAR(30), idPaisV INT, nombrePais VARCHAR(30))
BEGIN

END;
$$
*/







