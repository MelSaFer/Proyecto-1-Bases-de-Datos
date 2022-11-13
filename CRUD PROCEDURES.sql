#USE proyectoBases;
USE proyectoBasesmel;
#PROCEDURES-----------------------------------------------------------------------------------------

#------------------------------CRUDS--------------------------------
/*------------------------------------------------------------------
1 - Procedimientos para crud de la tabla país
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createPais;
DELIMITER $$
CREATE PROCEDURE createPais (nombreV VARCHAR(30))
BEGIN
	DECLARE message VARCHAR(60);
    
    IF nombreV IS NULL THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	#Validacion para que el nombre del país no se repita
    ELSEIF ((SELECT count(*) FROM Pais WHERE nombre = nombreV) != 0) THEN
		SET message = "ERROR - El pais ya existe";
    ELSE
		INSERT INTO Pais (nombre)
					VALUES (nombreV);
		SET message = "Se ha insertado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$

#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deletePais;
DELIMITER $$
CREATE PROCEDURE deletePais (idPaisV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el país" AS Resultado;
    
    IF (idPaisV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Pais WHERE idPais = idPaisV) = 0 THEN
		SET message = "ERROR - No existe un pais con el id ingresado ";
	ELSE
		DELETE FROM Pais WHERE idPais = idPaisV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$

/*------------------------------------------------------------------
2 - Procedimientos para crud de la tabla Provincia
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createProvincia;
DELIMITER $$
CREATE PROCEDURE createProvincia (nombreV VARCHAR(30), idPaisV INT, nombrePaisV VARCHAR(30))
BEGIN
	DECLARE message VARCHAR(60);
    
    IF nombreV IS NULL OR (idPaisV IS NULL AND nombrePaisV IS NULL) THEN
		SET message = "ERROR - Los datos necesarios para agregar son null";
	ELSEIF ((SELECT count(*) FROM Provincia WHERE nombre = nombreV) != 0) THEN
		SET message = "ERROR - El nombre no es valido, ya existe";
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

#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteProvincia;
DELIMITER $$
CREATE PROCEDURE deleteProvincia (idProvinciaV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar la Provincia" AS Resultado;
        
    IF (idProvinciaV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Provincia WHERE idProvincia = idProvinciaV) = 0 THEN
		SET message = "ERROR - No existe una Provincia con el id ingresado ";
	ELSE
		DELETE FROM Provincia WHERE idProvincia = idProvinciaV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$

/*------------------------------------------------------------------
3 - Procedimientos para crud de la tabla Cantón
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createCanton;
DELIMITER $$
CREATE PROCEDURE createCanton (nombreV VARCHAR(30), idProvinciaV VARCHAR(30))
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (nombreV IS NULL OR idProvinciaV IS NULL) THEN
		SET message = "ERROR - Para crear un cantón los datos no deben ser null";
	ELSEIF ((SELECT COUNT(*) FROM Provincia 
		WHERE Provincia.idProvincia =idProvinciaV) = 0) THEN
        SET message = "ERROR - El cantón debe tener una provincia válida";
	ELSEIF ((SELECT count(*) FROM Canton WHERE nombre = nombreV) != 0) THEN
			SET message = "ERROR - Ya existe un cantón con ese nombre";
	ELSE
		INSERT INTO Canton (nombre, idProvincia)
					VALUES (nombreV, idProvinciaV);
		SET message = "Se ha creado el cantón con éxito";
    END IF;
    SELECT message AS Resultado;
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteCanton;
DELIMITER $$
CREATE PROCEDURE deleteCanton (idCantonV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el Cantón" AS Resultado;
    
    IF (idCantonV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Canton WHERE idCanton = idCantonV) = 0 THEN
		SET message = "ERROR - No existe un Cantón con el id ingresado ";
	ELSE
		DELETE FROM Canton WHERE idCanton = idCantonV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$

/*------------------------------------------------------------------
4 - Procedimientos para crud de la tabla país
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createGerenteGeneral;
DELIMITER $$
CREATE PROCEDURE createGerenteGeneral (nombreV VARCHAR(30), telefonoV VARCHAR(13), salarioBase DECIMAL(15,2))
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (nombreV IS NULL OR telefonoV IS NULL OR SalarioBase IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos null para crear un gerente";
	ELSE 
		INSERT INTO GerenteGeneral (nombre, telefono, salarioBase)
					VALUES(nombreV,telefonoV,salarioBase);
		SET message = "Se ha creado el nuevo gerente general";
	END IF;
    SELECT message AS Resultado;
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteGerenteGeneral;
DELIMITER $$
CREATE PROCEDURE deleteGerenteGeneral (idGerenteGeneralV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el Gerente General" AS Resultado;
    
    IF (idGerenteGeneralV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM GerenteGeneral WHERE idGerenteGeneral = idGerenteGeneralV) = 0 THEN
		SET message = "ERROR - No existe un Gerente General con el id ingresado ";
	ELSE
		DELETE FROM GerenteGeneral WHERE idGerenteGeneral = idGerenteGeneralV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$

/*------------------------------------------------------------------
5 - Procedimientos para crud de la tabla Sucursal
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createSucursal;
DELIMITER $$
CREATE PROCEDURE createSucursal (nombreV VARCHAR(30), direccionV VARCHAR(30),
								idCantonV INT, idGerenteGeneralV INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (nombreV IS NULL OR direccionV IS NULL OR idCantonV IS NULL OR 
		idGerenteGeneralV IS NULL) THEN
        SET message = "ERROR - Los datos no deben ser NULL";
	ELSEIF ((SELECT COUNT(*) FROM Canton WHERE idCanton = idCantonV) = 0) THEN
		SET message = "ERROR - Debe tener un Cantón válido";
	ELSEIF ((SELECT COUNT(*) FROM gerenteGeneral 
		WHERE idGerenteGeneral = idGerenteGeneralV) = 0) THEN
		SET message = "ERROR - Debe tener un gerente general válido";
	ELSEIF ((SELECT COUNT(*) FROM Sucursal WHERE nombreSucursal = nombreV)!= 0) THEN
		SET message = "ERROR - Ya existe una Sucursal con el nombre ingresado";
	ELSE
		INSERT INTO Sucursal (nombreSucursal, direccion, idCanton, idGerenteGeneral)
					VALUES (nombreV, direccionV, idCantonV, idGerenteGeneralV);
		SET message = "Se ha creado la sucursal de manera exitosa";
    END IF;
    SELECT message AS Resultado;
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteSucursal;
DELIMITER $$
CREATE PROCEDURE deleteSucursal (idSucursalV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar la Sucursal" AS Resultado;
    
    IF (idSucursalV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Sucursal WHERE idSucursal = idSucursalV) = 0 THEN
		SET message = "ERROR - No existe un Sucursal con el id ingresado ";
	ELSE
		DELETE FROM Sucursal WHERE idSucursal = idSucursalV;
		SET message = "Se ha borrado la Sucursal con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$

/*------------------------------------------------------------------
6 - Procedimientos para crud de la tabla Cargo
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createCargo;
DELIMITER $$
CREATE PROCEDURE createCargo (descripcionV VARCHAR(30))
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (descripcionV IS NULL) THEN
		SET message = "ERROR - La descripcion del cargo no puede ser NULL";
	ELSEIF ((SELECT COUNT(*) FROM Cargo WHERE descripcion = descripcionV) != 0) THEN
		SET message = "ERROR - Ya existe cargo con esa descripción";
	ELSE
		INSERT INTO Cargo (descripcion) VALUES (descripcionV);
        SET message = "Se ha insertado el cargo con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteCargo;
DELIMITER $$
CREATE PROCEDURE deleteCargo (idCargoV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el Cargo" AS Resultado;
    
    IF (idCargoV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Cargo WHERE idCargo = idCargoV) = 0 THEN
		SET message = "ERROR - No existe un Cargo con el id ingresado ";
	ELSE
		DELETE FROM Cargo WHERE idCargo = idCargoV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;

/*------------------------------------------------------------------
7 - Procedimientos para crud de la tabla Empleado
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createEmpleado;
DELIMITER $$
CREATE PROCEDURE createEmpleado (nombreV VARCHAR(30), fechaContratacionV DATE, 
								salarioBaseV DECIMAL(15,2),idSucursalV INT, idCargoV INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (nombreV IS NULL OR fechaContratacionV IS NULL OR salarioBaseV IS NULL OR idSucursalV IS NULL
		OR idCargoV IS NULL) THEN
        SET message = "ERROR - No ingreso los datos necesarios para crear un empleado";
	ELSEIF ((SELECT COUNT(*) FROM Sucursal WHERE idSucursal = idSucursalV) = 0) THEN
		SET message = "ERROR - La sucursal ingresada no existe";
	ELSEIF ((SELECT COUNT(*) FROM Cargo WHERE idCargo = idCargoV) = 0) THEN
		SET message = "ERROR - El cargo ingresado no existe";
	ELSEIF (salarioBaseV < 0) THEN
		SET message = "ERROR - El salario debe ser mayor a 0";
	ELSEIF(fechaContratacionV > (SELECT CURDATE())) THEN
		SET message = "ERROR - La fecha de contratacion no puede ser en el futuro";
	ELSE 
		INSERT INTO Empleado (nombre, fechaContratacion, salarioBase, idSucursal, idCargo)
					VALUES (nombreV, fechaContratacionV, salarioBaseV, idSucursalV, idCargoV);
		SET message = "Se ha ingresado el empleado con éxito";
    END IF;
    SELECT message AS Resultado;
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteEmpleado;
DELIMITER $$
CREATE PROCEDURE deleteEmpleado (idEmpleadoV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el Empleado" AS Resultado;
    
    IF (idEmpleadoV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Empleado WHERE idEmpleado = idEmpleadoV) = 0 THEN
		SET message = "ERROR - No existe un Empleado con el id ingresado ";
	ELSE
		DELETE FROM Empleado WHERE idEmpleado = idEmpleadoV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$

/*------------------------------------------------------------------
8 - Procedimientos para crud de la tabla Bono
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createBono;
DELIMITER $$
CREATE PROCEDURE createBono (montoV DECIMAL(15,2), fechaV DATE, idEmpleadoV INT)
BEGIN
	DECLARE message VARCHAR(60);
	
    IF (montoV IS NULL OR fechaV IS NULL OR idEmpleadoV IS NULL) THEN
		SET message = "Los datos ingresados no pueden ser null";
	ELSEIF ((SELECT COUNT(*) FROM Empleado WHERE idEmpleado = idEmpleadoV) = 0) THEN
		SET message = "El empleado no existe";
	ELSEIF (montoV <= 0) THEN
		SET message = "El valor del monto en incorrecto";
	ELSEIF (fechaV > (SELECT CURDATE())) THEN
		SET message = "ERROR - No puede colocar fechas futuras en el bono";
	ELSE
		INSERT INTO Bono (monto, fecha, idEmpleado)
					VALUES (montoV, fechaV, idEmpleadoV);
		SET message = "El bono se ha insertado con éxito";
	END IF;
	SELECT message AS Resultado;
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteBono;
DELIMITER $$
CREATE PROCEDURE  deleteBono(idBonoV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el Bono" AS Resultado;
    
    IF (idBonoV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Bono WHERE idBono = idBonoV) = 0 THEN
		SET message = "ERROR - No existe un X con el id ingresado ";
	ELSE
		DELETE FROM Bono WHERE idBono = idBonoV;
		SET message = "Se ha borrado el Bono con éxito";
	END IF;
SELECT message AS Resultado;
END;
$$

/*------------------------------------------------------------------
9 - Procedimientos para crud de la tabla 
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createEncargo;
DELIMITER $$
CREATE PROCEDURE createEncargo (fechaV DATE, idSucursalV INT)
BEGIN
	DECLARE message VARCHAR(60);
	
    IF (fechaV IS NULL OR idSucursalV IS NULL) THEN
		SET message = "ERROR - Los datos ingresados no pueden ser NULL";
	ELSEIF ((SELECT COUNT(*) FROM Sucursal WHERE idSucursal= idSucursalV) = 0) THEN
		SET message = "ERROR - La sucursal ingresada no existe";
	ELSEIF (fechaV > (SELECT CURDATE())) THEN
		SET message = "ERROR - No puede colocar fechas futuras en el Encargo";
	ELSE
		INSERT INTO Encargo (fecha, idSucursal)
					VALUES (fechaV, idSucursalV);
		SET message = "El encargo se ha ingresado con éxito";
    END IF;
	SELECT message AS Resultado;
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteEncargo;
DELIMITER $$
CREATE PROCEDURE deleteEncargo (idEncargoV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el Encargo" AS Resultado;
    
    IF (idEncargoV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Encargo WHERE idEncargo = idEncargoV) = 0 THEN
		SET message = "ERROR - No existe un Encargo con el id ingresado ";
	ELSE
		DELETE FROM Encargo WHERE idEncargo = idEncargoV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$

/*------------------------------------------------------------------
10 - Procedimientos para crud de la tabla 
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
#CREATE IMPUESTO
DROP PROCEDURE IF EXISTS createImpuesto;
DELIMITER $$
CREATE PROCEDURE createImpuesto (descripcionV VARCHAR(30), porcImpuestoV DECIMAL(5,2))
BEGIN
	DECLARE message VARCHAR(60);
	
    IF (descripcionV IS NULL OR porcImpuestoV IS NULL) THEN
		SET message = "ERROR - Los datos ingresados son null";
	ELSEIF (porcImpuestoV < 0)THEN
		SET message = "ERROR - El porcentaje de impuesto debe ser mayor a 0";
	ELSE 
		INSERT INTO Impuesto (descripcion, porcImpuesto)
					VALUES (descripcionV, porcImpuestoV);
		SET message = "Se ha creado el nuevo impuesto con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteImpuesto;
DELIMITER $$
CREATE PROCEDURE deleteImpuesto (idImpuestoV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el Impuesto" AS Resultado;
    
    IF (idImpuestoV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Impuesto WHERE idImpuesto = idImpuestoV) = 0 THEN
		SET message = "ERROR - No existe un Impuesto con el id ingresado";
	ELSE
		DELETE FROM Impuesto WHERE idImpuesto = idImpuestoV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$

/*------------------------------------------------------------------
11 - Procedimientos para crud de la tabla Categoria
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createCategoria;
DELIMITER $$
CREATE PROCEDURE createCategoria ( descripcionV VARCHAR(30),idImpuestoV INT)
BEGIN
	DECLARE message VARCHAR(60);
	
    IF (descripcionV IS NULL OR idImpuestoV IS NULL) THEN
		SET message = "ERROR-Los datos ingresados no pueden ser NULL";
	ELSEIF (SELECT COUNT(*) FROM IMPUESTO WHERE idImpuesto = idImpuestoV) = 0 THEN
		SET message = "ERROR-El impuesto ingresado no existe";
	ELSEIF ((SELECT COUNT(*) FROM Categoria WHERE descripcion = descripcionV)!=0) THEN
		SET message = "ERROR-La categoria ya existe";
	ELSE
		INSERT INTO Categoria (descripcion, idImpuesto)
					VALUES (descripcionV, idImpuestoV);
		SET message = "Se ha creado la categoria éxitosamente";
	END IF;
    SELECT message AS Resultado;
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteCategoria;
DELIMITER $$
CREATE PROCEDURE deleteCategoria (idCategoriaV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar la Categoria" AS Resultado;
    
    IF (idCategoriaV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Categoria WHERE idCategoria = idCategoriaV) = 0 THEN
		SET message = "ERROR - No existe un Categoria con el id ingresado ";
	ELSE
		DELETE FROM Categoria WHERE idCategoria = idCategoriaV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$

/*------------------------------------------------------------------
12 - Procedimientos para crud de la tabla Proveedor
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createProveedor;
DELIMITER $$
CREATE PROCEDURE createProveedor (nombreV VARCHAR(30), telefonoV VARCHAR(13), porcGananciaV DECIMAL(5,2))
BEGIN
	DECLARE message VARCHAR(60);
	
    IF (nombreV IS NULL OR telefonoV IS NULL OR porcGananciaV IS NULL) THEN
		SET message = "ERROR- Los datos ingresados no pueden ser null";
	ELSEIF (PorcGanaNciaV <= 0) THEN
		SET message = "ERROR- El procentaje de ganancia no puede ser menor que 0";
	ELSEIF (SELECT COUNT(*) FROM Proveedor WHERE telefono = telefonoV) != 0 THEN
		SET message = "ERROR - El telefono ingresado ya existe";
	ELSE 
		INSERT INTO Proveedor (Nombre, telefono, porcGanancia)
					VALUES (nombreV, telefonoV, porcGananciaV);
		SET message = "El proveedor se ha creado con éxito";
	END IF;
    SELECT message AS resultado;
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteProveedor;
DELIMITER $$
CREATE PROCEDURE deleteProveedor (idProveedorV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el Proveedor" AS Resultado;
    
    IF (idProveedorV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Proveedor WHERE idProveedor = idProveedorV) = 0 THEN
		SET message = "ERROR - No existe un Proveedor con el id ingresado ";
	ELSE
		DELETE FROM Proveedor WHERE idProveedor = idProveedorV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$

/*------------------------------------------------------------------
13 - Procedimientos para crud de la tabla TipoPago
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createTipoPago;
DELIMITER $$
CREATE PROCEDURE createTipoPago (descripcionV VARCHAR(30))
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (descripcionV IS NULL) THEN
		SET message = "ERROR - Los datos ingresados no pueden ser NULL";
	ELSEIF (SELECT COUNT(*) FROM TipoPago WHERE descripcion = descripcionV) != 0 THEN
		SET message = "ERROR - Ya existe el tipo de pago con esa descripcion";
	ELSE
		INSERT INTO TipoPago (descripcion)
					VALUES (descripcionV);
		SET message = "Se ha creado el nuevo tipo de pago";
	END IF;
    SELECT message AS Resultado;  
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteTipoPago;
DELIMITER $$
CREATE PROCEDURE deleteTipoPago (idTipoPagoV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el TipoPago" AS Resultado;
    
    IF (idTipoPagoV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM TipoPago WHERE idTipoPago = idTipoPagoV) = 0 THEN
		SET message = "ERROR - No existe un TipoPago con el id ingresado ";
	ELSE
		DELETE FROM TipoPago WHERE idTipoPago = idTipoPagoV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$

/*------------------------------------------------------------------
14 - Procedimientos para crud de la tabla Cliente
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
#CREATE Cliente
DROP PROCEDURE IF EXISTS createCliente;
DELIMITER $$
CREATE PROCEDURE createCliente (nombreV VARCHAR(30), telefonoV VARCHAR(13), correoV VARCHAR(30),
								direccionV VARCHAR(30), idCantonV INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (nombreV IS NULL OR telefonoV IS NULL OR correoV IS NULL OR direccionV IS NULL 
		OR idCantonV IS NULL) THEN
		SET message = "ERROR - No puede ingresas datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Canton WHERE idCanton = idCantonV) = 0 THEN
		SET message = "ERROR - El cantón ingresado no es válido";
	ELSEIF (SELECT COUNT(*) FROM Cliente WHERE telefono = telefonoV OR correo = correoV) THEN
		SET message = "ERROR - El telefono o el correo ingresado ya existe";
	ELSE 
		INSERT INTO Cliente (nombre, telefono, correo, direccion, idCanton)
					VALUES (nombreV, telefonoV, correoV, direccionV, idCantonV);
		SET message = "El cliente ha sido insertado con éxito";
	END IF;
    SELECT message AS Resultado;	
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteCliente;
DELIMITER $$
CREATE PROCEDURE deleteCliente (idClienteV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el Cliente" AS Resultado;
    
    IF (idClienteV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Cliente WHERE idCliente = idClienteV) = 0 THEN
		SET message = "ERROR - No existe un Cliente con el id ingresado ";
	ELSE
		DELETE FROM Cliente WHERE idCliente = idClienteV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
/*------------------------------------------------------------------
15 - Procedimientos para crud de la tabla Producto
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createProducto;
DELIMITER $$
CREATE PROCEDURE createProducto (nombreV VARCHAR(30), idCategoriaV INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (nombreV IS NULL OR idCategoriaV IS NULL) THEN
		SET message = "ERROR - Los datos ingresados no deben ser NULL";
	ELSEIF((SELECT COUNT(*) FROM Categoria WHERE idCategoria = idCategoriaV)=0) THEN
		SET message = "ERROR - La categoria de producto ingresada no es válida";
	ELSEIF ((SELECT COUNT(*) FROM Producto WHERE nombreProducto = nombreV) != 0) THEN
		SET message = "ERROR - El producto ya existe";
	ELSE
		INSERT INTO Producto (nombreProducto, idCategoria)
					VALUES(nombreV, idCategoriaV);
		SET message = "El producto ha sido creado éxitosamente";
	END IF;
    SELECT message AS resultado;	
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteProducto;
DELIMITER $$
CREATE PROCEDURE deleteProducto (idProductoV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el Producto" AS Resultado;
    
    IF (idProductoV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Producto WHERE idProducto = idProductoV) = 0 THEN
		SET message = "ERROR - No existe un Producto con el id ingresado ";
	ELSE
		DELETE FROM Producto WHERE idProducto = idProductoV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$

/*------------------------------------------------------------------
16 - Procedimientos para crud de la tabla Promocion
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createPromocion;
DELIMITER $$
CREATE PROCEDURE createPromocion (fechaInicialV DATE, fechaFinalV DATE, 
								  porcDescuentoV DECIMAL(5,2), idProductoV INT)
BEGIN
	DECLARE message VARCHAR(60);
	
    IF (fechaInicialV IS NULL OR fechaFinalV IS NULL OR porcDescuentoV IS NULL OR
		idProductoV IS NULL) THEN
        SET message = "ERROR - Los datos ingresados no pueden ser NULL";
	ELSEIF(fechaInicialV > fechaFinalV) THEN 
		SET message = "ERROR - La fecha inicial debe ser mas reciente que la final";
	ELSEIF (porcDescuentoV <= 0) THEN
		SET message = "ERROR - El procentaje de descuento debe ser mayor a 0";
	ELSEIF ((SELECT COUNT(*) FROM Producto WHERE idProducto = idProductoV) = 0) THEN
		SET message = "ERROR - El id producto ingresado no es valido";
	ELSE
		INSERT INTO Promocion (fechaInicial, fechaFinal, porcentajeDesc, idProducto)
					VALUES (fechaInicialV, fechaFinalV, porcDescuentoV, idProductoV);
		SET message = "La promocion se ha agregado con exito";
	END IF;
    SELECT message AS Resultado;
END;			
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deletePromocion;
DELIMITER $$
CREATE PROCEDURE deletePromocion (idPromocionV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar la Promocion" AS Resultado;
    
    IF (idPromocionV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Promocion WHERE idPromocion = idPromocionV) = 0 THEN
		SET message = "ERROR - No existe una Promocion con el id ingresado ";
	ELSE
		DELETE FROM Promocion WHERE idPromocion = idPromocionV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
/*------------------------------------------------------------------
17 - Procedimientos para crud de la tabla Pedido
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createPedido;
DELIMITER $$
CREATE PROCEDURE createPedido (fechaV DATE, idTipoPagoV INT, idClienteV INT)
BEGIN
	DECLARE message VARCHAR(60);
	
    IF (fechaV IS NULL OR idTipoPagoV IS NULL OR idClienteV IS NULL) THEN
		SET message = "ERROR - Los datos ingresados no pueden ser null";
	ELSEIF ((SELECT COUNT(*) FROM cliente WHERE idCliente = idClienteV) = 0) THEN
		SET message = "ERROR -El id cliente no es valido";
	ELSEIF ((SELECT COUNT(*) FROM TipoPago WHERE idTipoPago = idTipoPagoV) = 0) THEN
		SET message = "ERROR -El id de tipo de pago no es valido";
	ELSE
		INSERT INTO Pedido (fecha, idCliente, idTipoPago)
					VALUES(fechaV, idClienteV, idTipoPagoV);
		SET message = "El pedido se ha creado con éxito";
	END IF;
    SELECT message AS Resultado;        
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteX;
DELIMITER $$
CREATE PROCEDURE X (idX INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el X" AS Resultado;
    
    IF (idX IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM X WHERE idX = idX) = 0 THEN
		SET message = "ERROR - No existe un X con el id ingresado ";
	ELSE
		DELETE FROM X WHERE idX = idX;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
/*------------------------------------------------------------------
18 - Procedimientos para crud de la tabla Detalle
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createDetalle;
DELIMITER $$
CREATE PROCEDURE createDetalle (cantidadV INT, idPedidoV INT, idProductoV INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (cantidadV IS NULL OR idPedidoV IS NULL OR idProductoV IS NULL) THEN
		SET message = "ERROR - Los datos ingresados no pueden ser NULL";
	ELSEIF cantidadV < 0 THEN
		SET message = "ERROR - La cantidad nu puede ser un dato negativo";
	ELSEIF ((SELECT COUNT(*) FROM Pedido WHERE idPedido = idPedidoV) = 0) THEN
		SET message = "ERROR - El id del pedido ingresado no es válido";
	ELSEIF ((SELECT COUNT(*) FROM Producto WHERE idProducto = idProductoV) = 0) THEN
		SET message = "ERROR - El id del producto ingresado no es válido";
	ELSE
		INSERT INTO Detalle(cantidad, idPedido, idProducto)
					VALUES (cantidadV, idPedidoV, idProductoV);
		SET message = "Se ha agregado el detalle";
	END IF;
	SELECT message AS resultado;
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteDetalle;
DELIMITER $$
CREATE PROCEDURE deleteDetalle (idDetalleV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el Detalle" AS Resultado;
    
    IF (idDetalleV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Detalle WHERE idDetalle = idDetalleV) = 0 THEN
		SET message = "ERROR - No existe un Detalle con el id ingresado ";
	ELSE
		DELETE FROM Detalle WHERE idDetalle = idDetalleV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
/*------------------------------------------------------------------
19 - Procedimientos para crud de la tabla EncargoXProducto
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createEncargoXProducto;
DELIMITER $$
CREATE PROCEDURE createEncargoXProducto (idEncargoV INT, idProductoV INT, cantidadV INT, precioV DECIMAL(15,2))
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idEncargoV IS NULL OR idProductoV IS NULL OR cantidadV IS NULL
		OR precioV IS NULL) THEN
        SET message = "ERROR - Los datos ingresados no pueden ser NULL";
	ELSEIF ((SELECT COUNT(*) FROM Encargo WHERE idEncargo = idEncargoV) = 0) THEN
		SET message = "ERROR - El id del encargo es invalido";
	ELSEIF ((SELECT COUNT(*) FROM Producto WHERE idProducto = idProductoV) = 0) THEN
		SET message = "ERROR - El id del producto es invalido";
	ELSEIF (CantidadV < 0) OR (precioV < 0) THEN
		SET message = "ERROR - Ni la cantidad, ni el precio, deben ser menores a 0";
	ELSE
		INSERT INTO EncargoXProducto(idProducto, idEncargo,cantidad, precio)
					VALUES(idProductoV, idEncargoV,cantidadV, precioV);
		SET message = "ERROR - Se ha insertado el EncargoXProducto con éxito";
	END IF;
    SELECT message AS resultado;
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteEncargoXProducto;
DELIMITER $$
CREATE PROCEDURE deleteEncargoXProducto (idEncargoXProductoV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el V" AS Resultado;
    
    IF (idEncargoXProductoV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM EncargoXProducto WHERE idEncargoXProducto = idEncargoXProductoV) = 0 THEN
		SET message = "ERROR - No existe el EncargoXProducto con el id ingresado ";
	ELSE
		DELETE FROM EncargoXProducto WHERE idEncargoXProducto = idEncargoXProductoV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
/*------------------------------------------------------------------
20 - Procedimientos para crud de la tabla ProductoXProveedor
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createProductoXProveedor;
DELIMITER $$
CREATE PROCEDURE createProductoXProveedor (idProductoV INT, idProveedorV INT,
											existenciasV INT, fechaProduccionV DATE,
                                            fechaExpiracionV DATE)
BEGIN
	DECLARE message VARCHAR(90);
    
    IF (idProductoV IS NULL OR idProveedorV IS NULL OR existenciasV IS NULL
		OR fechaProduccionV IS NULL OR fechaExpiracionV IS NULL) THEN
        SET message = "ERROR - Los datos ingresados no pueden ser NULL";
	ELSEIF ((SELECT COUNT(*) FROM Producto WHERE idProducto = idProductoV) = 0) THEN
		SET message = "ERROR - El id Producto no es valido";
	ELSEIF ((SELECT COUNT(*) FROM Proveedor WHERE idProveedor = idProveedorV) = 0) THEN
		SET message = "ERROR - El id Proveedor no es valido";
	ELSEIF (existenciasV < 0) THEN
		SET message = "ERROR - Las existencias no pueden ser negativas";
	ELSEIF (fechaProduccionV > fechaExpiracionV) THEN
		SET message = "ERROR - La fecha de prodducion no puede ser despues de la de expiracion";
	ELSE
		INSERT INTO Productoxproveedor(idProducto, idProveedor,existencias,fechaProduccion, fechaExpiracion)
					VALUES(idProductoV, idProveedorV,existenciasV,fechaProduccionV, fechaExpiracionV);
		SET message = "Se agregó el Productoxproveedor con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteProductoXProveedor;
DELIMITER $$
CREATE PROCEDURE deleteProductoXProveedor (idProductoXProveedorV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el ProductoXProveedor" AS Resultado;
    
    IF (idProductoXProveedorV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM ProductoXProveedor WHERE idProductoXProveedor = idProductoXProveedorV) = 0 THEN
		SET message = "ERROR - No existe un ProductoXProveedor con el id ingresado ";
	ELSE
		DELETE FROM ProductoXProveedor WHERE idProductoXProveedor = idProductoXProveedorV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
/*------------------------------------------------------------------
21 - Procedimientos para crud de la tabla SucursalXProducto
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createSucursalXProducto;
DELIMITER $$
CREATE PROCEDURE createSucursalXProducto (idSucursalV INT, idProductoV INT, cantidadV INT,
										  cantidadMinV INT, cantidadMaxV INT, fechaProduccionV DATE,
                                          fechaExpiracionV DATE, estadoV INT)
BEGIN
	DECLARE message VARCHAR(90);
    
    IF (idSucursalV IS NULL OR idProductoV IS NULL OR cantidadV IS NULL
		OR cantidadMinV IS NULL OR cantidadMaxV IS NULL OR fechaProduccionV IS NULL 
        OR fechaExpiracionV IS NULL OR estadoV IS NULL) THEN
        SET message = "ERROR - Los datos ingresados no pueden ser NULL";
	ELSEIF ((SELECT COUNT(*) FROM Producto WHERE idProducto = idProductoV) = 0) THEN
		SET message = "ERROR - El id Producto no es valido";
	ELSEIF ((SELECT COUNT(*) FROM Sucursal WHERE idSucursal = idSucursalV) = 0) THEN
		SET message = "ERROR - El id Sucursal no es valido";
	ELSEIF (cantidadV < 0 OR cantidadMinV < 0 OR cantidadMaxV < 0) THEN
		SET message = "ERROR - Las cantidades no pueden ser negativas";
	ELSEIF (cantidadMaxV < cantidadMinV) THEN
		SET message = "ERROR - La cantidad minima no puede ser mayor a la maxima";
	ELSEIF (fechaProduccionV > fechaExpiracionV) THEN
		SET message = "La fecha de prodducion no puede ser despues de la de expiracion";
	#FALTA VALIDAR ESTADO
	ELSE
		INSERT INTO Sucursalxproducto(idSucursal, idProducto, cantidad, cantidadMin, 
										cantidadMax, fechaProduccion, fechaExpiracion, 
                                        estado)
									VALUES(idSucursalV, idProductoV, cantidadV, cantidadMinV, 
										cantidadMaxV, fechaProduccionV, fechaExpiracionV, 
                                        estadoV);
		SET message = "Se agregó la Sucursalxproducto con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteSucursalXProducto;
DELIMITER $$
CREATE PROCEDURE deleteSucursalXProducto (idSucursalXProductoV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar la SucursalXProducto" AS Resultado;
    
    IF (idSucursalXProductoV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM SucursalXProducto WHERE idSucursalXProducto = idSucursalXProductoV) = 0 THEN
		SET message = "ERROR - No existe una SucursalXProducto con el id ingresado ";
	ELSE
		DELETE FROM SucursalXProducto WHERE idSucursalXProducto = idSucursalXProductoV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
/*------------------------------------------------------------------
22 - Procedimientos para crud de la tabla Tarjeta
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createTarjeta;
DELIMITER $$
CREATE PROCEDURE createTarjeta (numTarjetaV VARCHAR(16), ccvV INT, tipoV VARCHAR(15),
								fechaCaducidadV DATE, idClienteV INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (numTarjetaV IS NULL OR ccvV IS NULL OR  tipoV IS NULL
		OR fechaCaducidadV IS NULL OR  idClienteV IS NULL) THEN
        SET message = "ERROR - Los datos ingresados no pueden ser NULL";
	ELSEIF (SELECT COUNT(*) FROM Cliente WHERE idCliente = idClienteV) = 0 THEN
		SET message = "ERROR - El idCliente no es valido";
	ELSEIF (SELECT COUNT(*) FROM Tarjeta WHERE numTarjeta = numTarjetaV) != 0 THEN
		SET message = "ERROR - El Número de tarjeta no es válido";
	ELSEIF (fechaCaducidadV < (SELECT CURDATE())) THEN
		SET message = "ERROR - La tarjeta ya ha expirado";
	ELSEIF ((tipoV != "CRÉDITO") AND (tipoV != "CREDITO")
		AND (tipoV != "DÉBITO") AND (tipoV != "DEBITO")) THEN
		SET message = "ERROR - La tarjeta debe tener tipo crédito o débito";
	ELSE 
		INSERT INTO Tarjeta (numTarjeta, ccv, tipo, fechaCaducidad, idCliente)
							VALUES(numTarjetaV, ccvV, tipoV, fechaCaducidadV, idClienteV);
		SET message = "ERROR - Se ha insertado la tarjeta con éxito";
	END IF;
    SELECT message AS Resultado;	
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteTarjeta;
DELIMITER $$
CREATE PROCEDURE deleteTarjeta (idTarjetaV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar la Tarjeta" AS Resultado;
    
    IF (idTarjetaV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Tarjeta WHERE idTarjeta = idTarjetaV) = 0 THEN
		SET message = "ERROR - No existe una Tarjeta con el id ingresado ";
	ELSE
		DELETE FROM Tarjeta WHERE idTarjeta = idTarjetaV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
/*------------------------------------------------------------------
23 - Procedimientos para crud de la tabla Cheque
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createCheque;
DELIMITER $$
CREATE PROCEDURE createCheque (numChequeV VARCHAR(9), rutaBancariaV VARCHAR(23), 
								fechaAperturaV DATE, cuentaBancariaV VARCHAR(20), 
                                idClienteV INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF(numChequeV IS NULL OR rutaBancariaV IS NULL OR fechaAperturaV IS NULL OR
		cuentaBancariaV IS NULL OR idClienteV IS NULL) THEN
        SET message = "ERROR - Los datos ingresados no pueden ser NULL";
	ELSEIF (SELECT COUNT(*) FROM Cheque WHERE numCheque = numChequeV) != 0 THEN
		SET message = "ERROR - El número de cheque no es válido";
	ELSEIF (SELECT COUNT(*) FROM Cliente WHERE idCliente = idClienteV) = 0 THEN
		SET message = "ERROR - El idCliente no es valido";
	ELSE
		INSERT INTO Cheque (numCheque, rutaBancaria, fechaApertura, cuentaBancaria, idCliente)
				VALUES(numChequeV, rutaBancariaV, fechaAperturaV, cuentaBancariaV, idClienteV);
		SET message = "ERROR - El cheque se ha agregado exitosamente";
	END IF;
    SELECT message AS Resultado;	
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteCheque;
DELIMITER $$
CREATE PROCEDURE deleteCheque (idChequeV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el Cheque" AS Resultado;
    
    IF (idChequeV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Cheque WHERE idCheque = idChequeV) = 0 THEN
		SET message = "ERROR - No existe un Cheque con el id ingresado ";
	ELSE
		DELETE FROM Cheque WHERE idCheque = idChequeV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
/*------------------------------------------------------------------
24 - Procedimientos para crud de la tabla Criptomoneda
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS createCriptomoneda;
DELIMITER $$
CREATE PROCEDURE createCriptomoneda (direccionCriptoV VARCHAR(30), tipoV VARCHAR(15), idClienteV INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (direccionCriptoV IS NULL OR tipoV IS NULL OR idClienteV IS NULL) THEN
		SET message = "ERROR - Los datos ingresados no pueden ser NULL";
	ELSEIF (SELECT COUNT(*) FROM Cliente WHERE idCliente = idClienteV) = 0 THEN
		SET message = "ERROR - El idCliente no es valido";
    ELSEIF (SELECT COUNT(*) FROM Criptomoneda WHERE direccionCripto = direccionCriptoV ) != 0 THEN
		SET message = "ERROR - La direccion de la criptomoneda no es valida";
	ELSE
		INSERT INTO Criptomoneda (direccionCripto, tipo, idCliente)
				VALUES (direccionCriptoV, tipoV, idClienteV);
		SET message = "Se ha creado la criptomoneda con éxito";
	END IF;
    SELECT message AS Resultado;	
END;
$$
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteCriptomoneda;
DELIMITER $$
CREATE PROCEDURE deleteCriptomoneda (idCriptomonedaV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar la Criptomoneda" AS Resultado;
    
    IF (idCriptomonedaV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Criptomoneda WHERE idCriptomoneda = idCriptomonedaV) = 0 THEN
		SET message = "ERROR - No existe la Criptomoneda con el id ingresado ";
	ELSE
		DELETE FROM Criptomoneda WHERE idCriptomoneda = idCriptomonedaV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
/*
#DELETE-------------------------------------------------------------
DROP PROCEDURE IF EXISTS deleteV;
DELIMITER $$
CREATE PROCEDURE deleteV (idV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el V" AS Resultado;
    
    IF (idV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM V WHERE idV = idV) = 0 THEN
		SET message = "ERROR - No existe un V con el id ingresado ";
	ELSE
		DELETE FROM V WHERE idV = idV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
*/



