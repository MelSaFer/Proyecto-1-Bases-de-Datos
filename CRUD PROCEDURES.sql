USE proyectoBases;

#PROCEDURES-----------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS createPais;
DROP PROCEDURE IF EXISTS readPais;
DROP PROCEDURE IF EXISTS updatePais;
DROP PROCEDURE IF EXISTS deletePais;
DROP PROCEDURE IF EXISTS createProvincia;
DROP PROCEDURE IF EXISTS readProvincia;
DROP PROCEDURE IF EXISTS updateProvincia;
DROP PROCEDURE IF EXISTS deleteProvincia;
DROP PROCEDURE IF EXISTS createCanton;
DROP PROCEDURE IF EXISTS readCanton;
DROP PROCEDURE IF EXISTS updateCanton;
DROP PROCEDURE IF EXISTS deleteCanton;
DROP PROCEDURE IF EXISTS createGerenteGeneral;
DROP PROCEDURE IF EXISTS readGerenteGeneral;
DROP PROCEDURE IF EXISTS updateGerenteGeneral;
DROP PROCEDURE IF EXISTS deleteGerenteGeneral;
DROP PROCEDURE IF EXISTS createSucursal;
DROP PROCEDURE IF EXISTS readSucursal;
DROP PROCEDURE IF EXISTS updateSucursal;
DROP PROCEDURE IF EXISTS deleteSucursal;
DROP PROCEDURE IF EXISTS createCargo;
DROP PROCEDURE IF EXISTS readCargo;
DROP PROCEDURE IF EXISTS updateCargo;
DROP PROCEDURE IF EXISTS deleteCargo;
DROP PROCEDURE IF EXISTS createEmpleado;
DROP PROCEDURE IF EXISTS readEmpleado;
DROP PROCEDURE IF EXISTS updateEmpleado;
DROP PROCEDURE IF EXISTS deleteEmpleado;
DROP PROCEDURE IF EXISTS createBono;
DROP PROCEDURE IF EXISTS readBono;
DROP PROCEDURE IF EXISTS updateBono;
DROP PROCEDURE IF EXISTS deleteBono;
DROP PROCEDURE IF EXISTS createEncargo;
DROP PROCEDURE IF EXISTS readEncargo;
DROP PROCEDURE IF EXISTS updateEncargo;
DROP PROCEDURE IF EXISTS deleteEncargo;
DROP PROCEDURE IF EXISTS createImpuesto;
DROP PROCEDURE IF EXISTS readImpuesto;
DROP PROCEDURE IF EXISTS updateImpuesto;
DROP PROCEDURE IF EXISTS deleteImpuesto;
DROP PROCEDURE IF EXISTS createCategoria;
DROP PROCEDURE IF EXISTS readCategoria;
DROP PROCEDURE IF EXISTS updateCategoria;
DROP PROCEDURE IF EXISTS deleteCategoria;
DROP PROCEDURE IF EXISTS createProveedor;
DROP PROCEDURE IF EXISTS readProveedor;
DROP PROCEDURE IF EXISTS updateProveedor;
DROP PROCEDURE IF EXISTS deleteProveedor;
DROP PROCEDURE IF EXISTS createTipoPago;
DROP PROCEDURE IF EXISTS readTipoPago;
DROP PROCEDURE IF EXISTS updateTipoPago;
DROP PROCEDURE IF EXISTS deleteTipoPago;
DROP PROCEDURE IF EXISTS createCliente;
DROP PROCEDURE IF EXISTS readCliente;
DROP PROCEDURE IF EXISTS updateCliente;
DROP PROCEDURE IF EXISTS deleteCliente;
DROP PROCEDURE IF EXISTS createProducto;
DROP PROCEDURE IF EXISTS readProducto;
DROP PROCEDURE IF EXISTS updateProducto;
DROP PROCEDURE IF EXISTS deleteProducto;
DROP PROCEDURE IF EXISTS createPromocion;
DROP PROCEDURE IF EXISTS readPromocion;
DROP PROCEDURE IF EXISTS updatePromocion;
DROP PROCEDURE IF EXISTS deletePromocion;
DROP PROCEDURE IF EXISTS createPedido;
DROP PROCEDURE IF EXISTS readPedido;
DROP PROCEDURE IF EXISTS updatePedido;
DROP PROCEDURE IF EXISTS deletePedido;
DROP PROCEDURE IF EXISTS createDetalle;
DROP PROCEDURE IF EXISTS readDetalle;
DROP PROCEDURE IF EXISTS updateDetalle;
DROP PROCEDURE IF EXISTS deleteDetalle;
DROP PROCEDURE IF EXISTS createProductoXProveedor;
DROP PROCEDURE IF EXISTS readProductoXProveedor;
DROP PROCEDURE IF EXISTS updateProductoXProveedor;
DROP PROCEDURE IF EXISTS deleteProductoXProveedor;
DROP PROCEDURE IF EXISTS createSucursalXProducto;
DROP PROCEDURE IF EXISTS readSucursalXProducto;
DROP PROCEDURE IF EXISTS updateSucursalXProducto;
DROP PROCEDURE IF EXISTS deleteSucursalXProducto;
DROP PROCEDURE IF EXISTS createTarjeta;
DROP PROCEDURE IF EXISTS readTarjeta;
DROP PROCEDURE IF EXISTS updateTarjeta;
DROP PROCEDURE IF EXISTS deleteTarjeta;
DROP PROCEDURE IF EXISTS createCheque;
DROP PROCEDURE IF EXISTS readCheque;
DROP PROCEDURE IF EXISTS udpdateCheque;
DROP PROCEDURE IF EXISTS deleteCheque;
DROP PROCEDURE IF EXISTS createCriptomoneda;
DROP PROCEDURE IF EXISTS readCriptomoneda;
DROP PROCEDURE IF EXISTS updateCriptomoneda;
DROP PROCEDURE IF EXISTS deleteCriptomoneda;
DROP PROCEDURE IF EXISTS createTipoEnvio;
DROP PROCEDURE IF EXISTS readTipoEnvio;
DROP PROCEDURE IF EXISTS updateTipoEnvio;
DROP PROCEDURE IF EXISTS deleteTipoEnvio;
DROP PROCEDURE IF EXISTS createSucursalXCliente;
DROP PROCEDURE IF EXISTS readSucursalXCliente;
DROP PROCEDURE IF EXISTS updateSucursalXCliente;
DROP PROCEDURE IF EXISTS deleteSucursalXCliente;

#------------------------------CRUDS--------------------------------
/*------------------------------------------------------------------
1 - Procedimientos para crud de la tabla país
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
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
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updatePais (idPaisV INT, newName VARCHAR(30))
BEGIN
	DECLARE message VARCHAR(90);

	IF (idPaisV IS NULL) THEN
		SET message = "Para modificar debe colocar el codigo";
	#no existe el pais
	ELSEIF (SELECT COUNT(*) FROM Pais WHERE Pais.idPais = idPaisV) = 0 THEN
		SET message = "El codigo de pais no existe";
	# ya está ese nombre en un pais
	ELSEIF (SELECT COUNT(*) FROM Pais WHERE Pais.nombre = newName) > 0 THEN
		SET message = "Ya existe ese nombre de pais, no se pueden duplicar";
	ELSE
		UPDATE Pais SET Pais.nombre = IFNULL(newName, Pais.nombre) 
		WHERE Pais.idPais = idPaisV;
		SET message = "Se ha modificado con exito";
	END IF;
    SELECT message AS Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateProvincia (idProvinciaV INT, newNombre VARCHAR(30), newIdPais INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idProvinciaV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id de la provincia";
	# no existe la provincia
	ELSEIF (SELECT COUNT(*) FROM Provincia WHERE Provincia.idProvincia = idProvinciaV) = 0 THEN
		SET message = "No existe esa provincia";
    # en caso de que el nuevo idpais no sea null se verifica que exista   
	ELSEIF ((newIdPais IS NOT NULL AND (SELECT COUNT(*) FROM Pais where idPais = newIdPais) = 0)) THEN
		SET message = "No existe el pais al que se quiere asociar";
	# dos provincias no pueden tener el mismo nombre
	ELSEIF (select count(*) from provincia where provincia.nombre = newNombre) > 0 THEN
		SET message = "Ya existe una provincia con ese nombre";
	ELSE
		UPDATE Provincia SET Provincia.nombre = IFNULL(newNombre, Provincia.nombre),
        Provincia.idPais = IFNULL(newIdPais, Provincia.idPais)
        WHERE Provincia.idProvincia = idProvinciaV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateCanton (idCantonV INT, newNombre VARCHAR(30), newIdProvincia INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idCantonV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del canton";
	# no existe el canton
	ELSEIF (SELECT COUNT(*) FROM Canton WHERE Canton.idCanton = idCantonV) = 0 THEN
		SET message = "No existe ese canton";
    # en caso de que el nuevo idprovincia no sea null se verifica que exista   
	ELSEIF ((newIdProvincia IS NOT NULL AND (SELECT COUNT(*) FROM Provincia where idProvincia = newIdProvincia) = 0)) THEN
		SET message = "No existe la provincia a la que se quiere asociar";
	# dos cantones no pueden tener el mismo nombre
	ELSEIF (select count(*) from canton where canton.nombre = newNombre) > 0 THEN
		SET message = "Ya existe un canton con ese nombre";
	ELSE
		UPDATE Canton SET Canton.nombre = IFNULL(newNombre, Canton.nombre),
        Canton.idProvincia = IFNULL(newIdProvincia, Canton.idProvincia)
        WHERE Canton.idCanton = idCantonV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
4 - Procedimientos para crud del gerente general
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
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
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateGerenteGeneral (idGerenteGeneralV INT, newNombre VARCHAR(30), newTelefono VARCHAR(13), newSalarioBase decimal(15,2))
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idGerenteGeneralV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del gerente general";
	# no existe el gerente general
	ELSEIF (SELECT COUNT(*) FROM gerentegeneral WHERE gerentegeneral.idGerenteGeneral = idGerenteGeneralV) = 0 THEN
		SET message = "No existe el gerente general";
	# salario negativo
	ELSEIF (newSalarioBase IS NOT NULL AND newSalarioBase <= 0.0) THEN
		SET message = "El nuevo salario base no puede ser igual o menor a 0";
	ELSE
		UPDATE gerentegeneral SET gerentegeneral.nombre = IFNULL(newNombre, gerentegeneral.nombre),
        gerentegeneral.telefono = IFNULL(newTelefono, gerentegeneral.telefono),
        gerentegeneral.salarioBase = IFNULL(newSalarioBase, gerentegeneral.salarioBase)
        WHERE gerentegeneral.idGerenteGeneral = idGerenteGeneralV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateSucursal (idSucursalV INT, newNombreSucursal VARCHAR(30), newDireccion VARCHAR(30), 
								newIdCanton INT, newIdGerenteGeneral INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idSucursalV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id de la sucursal";
	# no existe la sucursal
	ELSEIF (SELECT COUNT(*) FROM Sucursal WHERE Sucursal.idSucursal = idSucursalV) = 0 THEN
		SET message = "No existe esa sucursal";
	# dos sucursales no pueden tener el mismo nombre
	ELSEIF (select count(*) from sucursal where sucursal.nombreSucursal = newNombreSucursal) > 0 THEN
		SET message = "Ya existe una sucursal con ese nombre";
	# en caso de que el nuevo idCanton no sea null se verifica que exista   
	ELSEIF ((newIdCanton IS NOT NULL AND (SELECT COUNT(*) FROM Canton where idCanton = newIdCanton) = 0)) THEN
		SET message = "No existe el canton al que se quiere asociar";
    # en caso de que el nuevo idGerenteGeneral no sea null se verifica que exista   
	ELSEIF ((newIdGerenteGeneral IS NOT NULL AND (SELECT COUNT(*) FROM GerenteGeneral where idGerenteGeneral = newIdGerenteGeneral) = 0)) THEN
		SET message = "No existe el gerente general al que se quiere asociar";
	ELSE
		UPDATE Sucursal SET Sucursal.nombreSucursal = IFNULL(newNombreSucursal, Sucursal.nombreSucursal),
        Sucursal.direccion = IFNULL(newDireccion, Sucursal.direccion),
        Sucursal.idCanton = IFNULL(newIdCanton, Sucursal.idCanton),
        Sucursal.idGerenteGeneral = IFNULL(newIdGerenteGeneral, Sucursal.idGerenteGeneral)
        WHERE Sucursal.idSucursal = idSucursalV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateCargo (idCargoV INT, newDescripcion VARCHAR(30))
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idCargoV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del cargo";
	# no existe el cargo
	ELSEIF (SELECT COUNT(*) FROM Cargo WHERE Cargo.idCargo = idCargoV) = 0 THEN
		SET message = "No existe el cargo";
	# dos cargos no pueden tener el mismo nombre
	ELSEIF (select count(*) from cargo where cargo.descripcion = newDescripcion) > 0 THEN
		SET message = "Ya existe un cargo con esa descripcion";
	ELSE
		UPDATE Cargo SET Cargo.descripcion = IFNULL(newDescripcion, Cargo.descripcion)
        WHERE Cargo.idCargo = idCargoV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
$$
/*------------------------------------------------------------------
7 - Procedimientos para crud de la tabla Empleado
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
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
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateEmpleado (idEmpleadoV INT, newNombre VARCHAR(30), newFechaContratacion DATE, 
								newSalarioBase decimal(15,2), newIdSucursal INT, newIdCargo INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idEmpleadoV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del empleado";
	# no existe el empleado
	ELSEIF (SELECT COUNT(*) FROM Empleado WHERE Empleado.idEmpleado = idEmpleadoV) = 0 THEN
		SET message = "No existe el empleado";
	# se intenta agregar una fecha que no ha llegao
	ELSEIF (newFechaContratacion > curdate()) THEN
		SET message = "La fecha de contratacion no puede ser futura";
	# salario negativo
	ELSEIF (newSalarioBase IS NOT NULL AND newSalarioBase <= 0.0) THEN
		SET message = "El salario base no puede ser igual o menor a 0";
	# en caso de que el nuevo idSucursal no sea null se verifica que exista   
	ELSEIF ((newidSucursal IS NOT NULL AND (SELECT COUNT(*) FROM Sucursal where idSucursal = newIdSucursal) = 0)) THEN
		SET message = "No existe la sucursal a la que se quiere asociar";
    # en caso de que el nuevo idCargo no sea null se verifica que exista   
	ELSEIF ((newIdCargo IS NOT NULL AND (SELECT COUNT(*) FROM Cargo where idCargo = newIdCargo) = 0)) THEN
		SET message = "No existe el cargo al que se quiere asociar";
	ELSE
		UPDATE Empleado SET Empleado.nombre = IFNULL(newNombre, Empleado.nombre),
        Empleado.fechaContratacion = IFNULL(newFechaContratacion, Empleado.fechaContratacion),
        Empleado.salarioBase = IFNULL(newSalarioBase, Empleado.salarioBase),
        Empleado.idSucursal = IFNULL(newIdSucursal, Empleado.idSucursal),
        Empleado.idCargo = IFNULL(newIdCargo, Empleado.idCargo)
        WHERE Empleado.idEmpleado = idEmpleadoV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
	ELSEIF (SELECT max(fechaV) FROM Bono where idEmpleado = idEmpleadoV) >= curdate()-7 THEN
		SET message = "ERROR - Este empleado ya recibió un bono esta semana";
	ELSE
		INSERT INTO Bono (monto, fecha, idEmpleado)
					VALUES (montoV, fechaV, idEmpleadoV);
		SET message = "El bono se ha insertado con éxito";
	END IF;
	SELECT message AS Resultado;
END;
$$

#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateBono (idBonoV INT, newMonto decimal(15,2), newFecha DATE, 
								newIdEmpleado INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idBonoV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del bono";
	# no existe el bono
	ELSEIF (SELECT COUNT(*) FROM Bono WHERE Bono.idBono = idBonoV) = 0 THEN
		SET message = "No existe el bono";
	# bono negativo
	ELSEIF (newMonto IS NOT NULL AND newMonto <= 0.0) THEN
		SET message = "El monto del bono no puede ser igual o menor a 0";
	# se intenta agregar una fecha que no ha llegado
	ELSEIF (newFecha > curdate()) THEN
		SET message = "La fecha no puede ser futura";
	# en caso de que el nuevo idEmpleado no sea null se verifica que exista   
	ELSEIF ((newIdEmpleado IS NOT NULL AND (SELECT COUNT(*) FROM Empleado where idEmpleado = newIdEmpleado) = 0)) THEN
		SET message = "No existe el empleado al que se quiere asociar";
	ELSE
		UPDATE Bono SET Bono.monto = IFNULL(newMonto, Bono.monto),
        Bono.fecha = IFNULL(newFecha, Bono.fecha),
        Bono.idEmpleado = IFNULL(newIdEmpleado, Bono.idEmpleado)
        WHERE Bono.idBono = idBonoV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
9 - Procedimientos para crud de la tabla encargo
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE createEncargo (fechaV DATE, idSucursalV INT, cantidadV INT, idProductoV INT, idProveedorV INT)
BEGIN
	DECLARE message VARCHAR(60);
	
    IF (fechaV IS NULL OR idSucursalV IS NULL OR cantidadV IS NULL OR idProductoV IS NULL OR idProveedorV IS NULL) THEN
		SET message = "ERROR - Los datos ingresados no pueden ser NULL";
	ELSEIF ((SELECT COUNT(*) FROM Sucursal WHERE idSucursal= idSucursalV) = 0) THEN
		SET message = "ERROR - La sucursal ingresada no existe";
	ELSEIF ((SELECT COUNT(*) FROM Producto WHERE idProducto= idProductoV) = 0) THEN
		SET message = "ERROR - El producto ingresado no existe";
	ELSEIF ((SELECT COUNT(*) FROM Proveedor WHERE idProveedor= idProveedorV) = 0) THEN
		SET message = "ERROR - El proveedor ingresado no existe";
	ELSEIF (cantidadV <= 0) THEN
		SET message = "ERROR - La cantidad no puede ser menor a 0";
	ELSEIF (fechaV > (SELECT CURDATE())) THEN
		SET message = "ERROR - No puede colocar fechas futuras en el Encargo";
	ELSE
		INSERT INTO Encargo (fecha, idSucursal, cantidad, idProducto, idProveedor)
					VALUES (fechaV, idSucursalV, cantidadV, idProductoV, idProveedorV);
		SET message = "El encargo se ha ingresado con éxito";
    END IF;
	SELECT message AS Resultado;
END;
$$
#READ-------------------------------------------------------------
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
		SELECT Encargo.idEncargo, Encargo.Fecha, Encargo.idSucursal, 
        Encargo.cantidad, Encargo.idProducto, Encargo.idProveedor FROM encargo
		WHERE Encargo.idEncargo = IFNULL(idEncargoV, Encargo.idEncargo);
	END IF;
END;
$$
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateEncargo (idEncargoV INT, newFecha DATE, newIdSucursal INT, 
								newCantidad INT, newIdProducto INT, newIdProveedor INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idEncargoV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del encargo";
	# no existe el canton
	ELSEIF (SELECT COUNT(*) FROM Encargo WHERE Encargo.idEncargo = idEncargoV) = 0 THEN
		SET message = "No existe ese encargo";
    # en caso de que el nuevo idsucursal no sea null se verifica que exista   
	ELSEIF ((newIdSucursal IS NOT NULL AND (SELECT COUNT(*) FROM Sucursal where IdSucursal = newIdSucursal) = 0)) THEN
		SET message = "No existe la sucursal a la que se quiere asociar";
	# en caso de que el nuevo idProducto no sea null se verifica que exista   
	ELSEIF ((newIdProducto IS NOT NULL AND (SELECT COUNT(*) FROM Producto where IdProducto = newIdProducto) = 0)) THEN
		SET message = "No existe el producto al que se quiere asociar";
	# en caso de que el nuevo idProveedor no sea null se verifica que exista   
	ELSEIF ((newIdProveedor IS NOT NULL AND (SELECT COUNT(*) FROM Proveedor where idPoveedor = newIdProveedor) = 0)) THEN
		SET message = "No existe el proveedor al que se quiere asociar";
	ELSEIF (newFecha > (SELECT CURDATE())) THEN
		SET message = "ERROR - No puede colocar fechas futuras en el Encargo";
	ELSE
		UPDATE Encargo SET Encargo.fecha = IFNULL(newFecha, Encargo.fecha),
        Encargo.idSucursal = IFNULL(newIdSucursal, Encargo.idSucursal)
        WHERE Encargo.idEncargo = idEncargoV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
10 - Procedimientos para crud de la tabla impuesto
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
#CREATE IMPUESTO
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
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateImpuesto (idImpuestoV INT, newDescripcion varchar(30), newPorcImpuesto decimal(5,2))
BEGIN
	DECLARE message VARCHAR(70);
    
    IF (idImpuestoV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del impuesto";
	# no existe el impuesto
	ELSEIF (SELECT COUNT(*) FROM impuesto WHERE impuesto.idImpuesto = idImpuestoV) = 0 THEN
		SET message = "No existe el impuesto";
	# parametros vacios
	ELSEIF (newDescripcion = "") THEN
		SET message = "La descripcion del impuesto no puede estar vacio";
	# newDescripcion repetido
    ELSEIF (SELECT count(*) from impuesto where descripcion = newDescripcion) THEN
		SET message = "Ya existe un impuesto con esa descripcion";
	#
    ELSEIF (newPorcIGanancia < 0.0 or newPorcGanancia > 100.0) THEN
		SET message = "El porcentaje de ganancia no puede ser negativo o mayor a 100.0";
    
	ELSE
		UPDATE impuesto SET impuesto.descripcion = IFNULL(newDescripcion, impuesto.descripcion),
        impuesto.porcImpuesto = IFNULL(newPorcImpuesto, impuesto.porcImpuesto)
        WHERE impuesto.idImpuesto = idImpuestoV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateCategoria (idCategoriaV INT, newDescripcion varchar(30), newIdImpuesto INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idCategoriaV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id de la categoria";
	# no existe la categoria
	ELSEIF (SELECT COUNT(*) FROM categoria WHERE categoria.idCategoria = idCategoriaV) = 0 THEN
		SET message = "No existe la categoria";
	# parametros vacios
	ELSEIF (newDescripcion = "") THEN
		SET message = "La descripcion de la categoria no puede estar vacio";
	# newDescripcion repetido
    ELSEIF (SELECT count(*) from categoria where descripcion = newDescripcion) THEN
		SET message = "Ya existe una categoria con esa descripcion";
	# en caso de que el nuevo idCategoria no sea null se verifica que exista   
	ELSEIF ((newIdImpuesto IS NOT NULL AND (SELECT COUNT(*) FROM impuesto where idImpuesto = newIdImpuesto) = 0)) THEN
		SET message = "No existe el impuesto al que se quiere asociar";
    
	ELSE
		UPDATE categoria SET categoria.descripcion = IFNULL(newDescripcion, categoria.descripcion),
        categoria.idImpuesto = IFNULL(newIdImpuesto, categoria.idImpuesto)
        WHERE categoria.idCategoria = idCategoriaV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateProveedor (idProveedorV INT, newNombre varchar(30), newTelefono varchar(13),
								newPorcGanancia decimal(5,2))
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idProveedorV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del proveedor";
	# no existe el proveedor
	ELSEIF (SELECT COUNT(*) FROM proveedor WHERE proveedor.idProveedor = idProveedorV) = 0 THEN
		SET message = "No existe el proveedor";
	# parametros vacios
	ELSEIF (newNombre = "") THEN
		SET message = "El nombre del proveedor no puede estar vacio";
	# newNombre repetido
    ELSEIF (SELECT count(*) from proveedor where nombre = newNombre) THEN
		SET message = "Ya existe un proveedor con ese nombre";
	# telefono repetido
    ELSEIF (SELECT count(*) from proveedor where telefono = newTelefono) THEN
		SET message = "El telefono ya lo utiliza otro proveedor";
    
	ELSE
		UPDATE proveedor SET proveedor.nombre = IFNULL(newNombre, proveedor.nombre),
        proveedor.telefono = IFNULL(newTelefono, proveedor.telefono),
        proveedor.porcGanancia = IFNULL(newPorcGanancia, proveedor.porcGanancia)
        WHERE proveedor.idProveedor = idProveedorV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateTipoPago (idTipoPagoV INT, newDescripcion VARCHAR(15))
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idTipoPagoV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del tipoPago";
	# no existe el tipoPago
	ELSEIF (SELECT COUNT(*) FROM tipoPago WHERE tipoPago.idTipoPago = idTipoPagoV) = 0 THEN
		SET message = "No existe el tipoPago";
    
	ELSE
		UPDATE TipoPago SET TipoPago.descripcion = IFNULL(newDescripcion, TipoPago.descripcion)
        WHERE TipoPago.idTipoPago = idTipoPagoV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
#READ-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE readCliente (idClienteV INT)
BEGIN

	IF(idClienteV IS NULL) THEN
		SELECT "Ingrese el id del cliente" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM cliente 
		WHERE cliente.idCliente = IFNULL(idClienteV, cliente.idCliente)) = 0 THEN
		SELECT "No existe cliente con ese id" AS ERROR;
	ELSE
		SELECT cliente.idCliente, cliente.nombre, cliente.telefono, cliente.correo, 
        cliente.direccion, cliente.idCanton FROM cliente
		WHERE cliente.idCliente = IFNULL(idClienteV, cliente.idCliente);
	END IF;
END;
$$
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateCliente (idClienteV INT, newNombre VARCHAR(30), newTelefono varchar(13), newCorreo varchar(30), 
								newDireccion varchar(30), newIdCanton INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idClienteV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del cliente";
	# no existe el cliente
	ELSEIF (SELECT COUNT(*) FROM cliente WHERE cliente.idCliente = idClienteV) = 0 THEN
		SET message = "No existe el cliente";
	# nombre vacio
	ELSEIF (newNombre IS NOT NULL and newNombre = "") THEN
		SET message = "El nombre del cliente no puede ser vacio";
	# correo o telefono repetido
    ELSEIF (SELECT count(*) from cliente where telefono = newTelefono or correo = newCorreo) THEN
		SET message = "El telefono o el correo ya lo utiliza otro cliente";
	# en caso de que el nuevo idCanton no sea null se verifica que exista   
	ELSEIF ((newIdCanton IS NOT NULL AND (SELECT COUNT(*) FROM canton where idCanton = newIdCanton) = 0)) THEN
		SET message = "No existe el canton al que se quiere asociar";
    
	ELSE
		UPDATE cliente SET cliente.nombre = IFNULL(newNombre, cliente.nombre),
        cliente.telefono = IFNULL(newTelefono, cliente.telefono),
        cliente.correo = IFNULL(newCorreo, cliente.correo),
        cliente.direccion = IFNULL(newCorreo, cliente.direccion),
        cliente.idCanton = IFNULL(newIdCanton, cliente.idCanton)
        
        WHERE cliente.idCliente = idClienteV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateProducto (idProductoV INT, newNombreProducto varchar(30), newIdCategoria INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idProductoV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del producto";
	# no existe el producto
	ELSEIF (SELECT COUNT(*) FROM producto WHERE producto.idProducto = idProductoV) = 0 THEN
		SET message = "No existe el producto";
	# parametros vacios
	ELSEIF (newNombreProducto = "") THEN
		SET message = "El nombre del producto no pueden estar vacio";
	# newNombreProducto repetido
    ELSEIF (SELECT count(*) from producto where nombreProducto = newNombreProducto) THEN
		SET message = "Ya existe un producto con ese nombre";
	# en caso de que el nuevo idCategoria no sea null se verifica que exista   
	ELSEIF ((newIdCategoria IS NOT NULL AND (SELECT COUNT(*) FROM categoria where idCategoria = newIdCategoria) = 0)) THEN
		SET message = "No existe la categoria a la que se quiere asociar";
    
	ELSE
		UPDATE producto SET producto.nombreProducto = IFNULL(newNombreProducto, producto.nombreProducto),
        producto.idCategoria = IFNULL(newIdCategoria, producto.idCategoria)
        WHERE producto.idProducto = idProductoV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updatePromocion (idPromocionV INT, newFechaInicial DATE, newFechaFinal DATE, 
				newPorcentajeDesc decimal(5,2), newIdProducto INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idPromocionV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id de la promocion";
	# no existe la promocion
	ELSEIF (SELECT COUNT(*) FROM promocion WHERE promocion.idPromocion = idPromocionV) = 0 THEN
		SET message = "No existe la promocion";
	# fechaInicial > fechaFinal
	ELSEIF (newFechaInicial IS NOT NULL AND (SELECT fechaFinal FROM promocion WHERE idPromocion = idPromocionV) < newFechaInicial ) THEN
		SET message = "La fechaInicial no puede ser mayor a la FechaExpiracion";
	# fechaFinal < fechaInicial
	ELSEIF (newFechaFinal IS NOT NULL AND (SELECT fechaInicial FROM promocion WHERE idPromocion = idPromocionV) > newFechaFinal ) THEN
		SET message = "La fechaFinal no puede ser menor a la fechaInicial";
	# porcDescuento negativo
	ELSEIF (newPorcentajeDesc IS NOT NULL AND newPorcentajeDesc <= 0.0) THEN
		SET message = "El nuevo porcDescuento no puede ser igual o menor a 0";
	# en caso de que el nuevo idProducto no sea null se verifica que exista   
	ELSEIF ((newIdProducto IS NOT NULL AND (SELECT COUNT(*) FROM producto where idProducto = newIdProducto) = 0)) THEN
		SET message = "No existe el producto al que se quiere asociar";
    
	ELSE
		UPDATE promocion SET promocion.fechaInicial = IFNULL(newFechaInicial, promocion.fechaInicial),
        promocion.fechaFinal = IFNULL(newFechaFinal, promocion.fechaFinal),
        promocion.porcentajeDesc = IFNULL(newPorcentajeDesc, promocion.porcentajeDesc),
        promocion.idProducto = IFNULL(newIdProducto, promocion.idProducto)
        WHERE promocion.idPromocion = idPromocionV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
DELIMITER $$
CREATE PROCEDURE createPedido (fechaV DATE, idTipoPagoV INT, idClienteV INT, idEmpleadoV INT, idTipoEnvioV INT)
BEGIN
	DECLARE message VARCHAR(60);
	
    IF (fechaV IS NULL OR idTipoPagoV IS NULL OR idClienteV IS NULL) THEN
		SET message = "ERROR - Los datos ingresados no pueden ser null";
	ELSEIF ((SELECT COUNT(*) FROM cliente WHERE idCliente = idClienteV) = 0) THEN
		SET message = "ERROR -El id cliente no es valido";
	ELSEIF ((SELECT COUNT(*) FROM TipoPago WHERE idTipoPago = idTipoPagoV) = 0) THEN
		SET message = "ERROR -El id de tipo de pago no es valido";
	ELSEIF ((SELECT COUNT(*) FROM Empleado WHERE idEmpleado = idEmpleadoV) = 0) THEN
		SET message = "ERROR -El id del empleado no es valido";
	ELSEIF ((SELECT COUNT(*) FROM TipoEnvio WHERE idTipoEnvio = idTipoEnvioV) = 0) THEN
		SET message = "ERROR -El id del tipoEnvio no es valido";
	ELSE
		INSERT INTO Pedido (fecha, idCliente, idTipoPago, idEmpleado, idTipoEnvio)
					VALUES(fechaV, idClienteV, idTipoPagoV, idEmpleadoV,idTipoEnvioV);
		SET message = "El pedido se ha creado con éxito";
	END IF;
    SELECT message AS Resultado;        
END;
$$
#READ-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE readPedido (idPedidoV INT)
BEGIN

	IF(idPedidoV IS NULL) THEN
		SELECT "Ingrese el id del Pedido" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Pedido 
		WHERE Pedido.idPedido = IFNULL(idPedidoV, Pedido.idPedido)) = 0 THEN
		SELECT "No existe Pedido con ese id" AS ERROR;
	ELSE
		SELECT Pedido.idPedido, Pedido.fecha, Pedido.idCliente, Pedido.idTipoPago, 
        Pedido.idEmpleado, Pedido.TipoEnvio FROM Pedido
		WHERE Pedido.idPedido = IFNULL(idPedidoV, Pedido.idPedido);
	END IF;
END;
$$
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updatePedido (idPedidoV INT, newFecha DATE, newIdCliente INT, newIdTipoPago INT, 
								newIdEmpleado INT, newIdTipoEnvio INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idPedidoV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del pedido";
	# no existe el pedido
	ELSEIF (SELECT COUNT(*) FROM pedido WHERE pedido.idPedido = idPedidoV) = 0 THEN
		SET message = "No existe el pedido";
	# se intenta agregar una fecha que no ha llegado
	ELSEIF (newFecha > curdate()) THEN
		SET message = "La fecha no puede ser futura";
	# en caso de que el nuevo idCliente no sea null se verifica que exista   
	ELSEIF ((newIdCliente IS NOT NULL AND (SELECT COUNT(*) FROM cliente where idCliente = newIdCliente) = 0)) THEN
		SET message = "No existe el cliente al que se quiere asociar";
	# en caso de que el nuevo idTipoPago no sea null se verifica que exista   
	ELSEIF ((newIdTipoPago IS NOT NULL AND (SELECT COUNT(*) FROM tipoPago where idTipoPago = newIdTipoPago) = 0)) THEN
		SET message = "No existe el tipoPago al que se quiere asociar";
	# en caso de que el nuevo idEmpleado no sea null se verifica que exista   
	ELSEIF ((newIdEmpleado IS NOT NULL AND (SELECT COUNT(*) FROM empleado where idEmpleado = newIdEmpleado) = 0)) THEN
		SET message = "No existe el empleado al que se quiere asociar";
	# en caso de que el nuevo idTipoEnvio no sea null se verifica que exista   
	ELSEIF ((newIdTipoEnvio IS NOT NULL AND (SELECT COUNT(*) FROM tipoEnvio where idTipoEnvio = newIdTipoEnvio) = 0)) THEN
		SET message = "No existe el tipoEnvio al que se quiere asociar";
    
	ELSE
		UPDATE pedido SET pedido.fecha = IFNULL(newFecha, pedido.fecha),
        pedido.idCliente = IFNULL(newIdCliente, pedido.idCliente),
        pedido.idTipoPago = IFNULL(newIdTipoPago, pedido.idTipoPago),
        pedido.idEmpleado = IFNULL(newIdEmpleado, pedido.idEmpleado),
        pedido.idTipoEnvio = IFNULL(newIdTipoEnvio, pedido.idTipoEnvio)
        WHERE pedido.idPedido = idPedidoV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE deletePedido (idPedidoV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el Pedido" AS Resultado;
    
    IF (idPedidoV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM Pedido WHERE idPedido = idPedidoV) = 0 THEN
		SET message = "ERROR - No existe un Pedido con el id ingresado ";
	ELSE
		DELETE FROM Pedido WHERE idPedido = idPedidoV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
/*------------------------------------------------------------------
18 - Procedimientos para crud de la tabla Detalle
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
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
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateDetalle (idDetalleV INT, newCantidad INT, newIdPedido INT, newIdProducto INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idDetalleV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del detalle";
	# no existe el detalle
	ELSEIF (SELECT COUNT(*) FROM detalle WHERE detalle.idDetalle = idDetalleV) = 0 THEN
		SET message = "No existe el detalle";
	# cantidad negativo
	ELSEIF (newCantidad IS NOT NULL AND newCantidad <= 0) THEN
		SET message = "La cantidad no puede ser igual o menor a 0";
	# en caso de que el nuevo idPedido no sea null se verifica que exista   
	ELSEIF ((newIdPedido IS NOT NULL AND (SELECT COUNT(*) FROM pedido where idPedido = newIdPedido) = 0)) THEN
		SET message = "No existe el pedido al que se quiere asociar";
	# en caso de que el nuevo idProducto no sea null se verifica que exista   
	ELSEIF ((newIdProducto IS NOT NULL AND (SELECT COUNT(*) FROM producto where idProducto = newIdProducto) = 0)) THEN
		SET message = "No existe el producto al que se quiere asociar";
    
	ELSE
		UPDATE detalle SET detalle.cantidad = IFNULL(newCantidad, detalle.cantidad),
        detalle.idPedido = IFNULL(newIdPedido, detalle.idPedido),
        detalle.idProducto = IFNULL(newIdProducto, detalle.idProducto)
        WHERE detalle.idDetalle = idDetalleV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
20 - Procedimientos para crud de la tabla ProductoXProveedor
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE createProductoXProveedor (idProductoV INT, idProveedorV INT,
											existenciasV INT, fechaProduccionV DATE,
                                            fechaExpiracionV DATE, precioV DECIMAL(15,2))
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
	ELSEIF (precioV < 0) THEN
		SET message = "ERROR - El el precio no debe ser menor a 0";
	ELSE
		INSERT INTO Productoxproveedor(idProducto, idProveedor,existencias,fechaProduccion, fechaExpiracion, precio)
					VALUES(idProductoV, idProveedorV,existenciasV,fechaProduccionV, fechaExpiracionV, precioV);
		SET message = "Se agregó el Productoxproveedor con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
#READ-------------------------------------------------------------
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
        ProductoXProveedor.existencias, ProductoXProveedor.fechaProduccion, ProductoXProveedor.fechaExpiracion, ProductoXProveedor.precio
        FROM ProductoXProveedor
		WHERE ProductoXProveedor.idProductoXProveedor = IFNULL(idProductoXProveedorV, ProductoXProveedor.idProductoXProveedor);
	END IF;
END;
$$
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateProductoXProveedor (idProductoXProveedorV INT, newIdProducto INT, 
				newIdProveedor INT, newExistencias INT,newFechaProduccion DATE, newFechaExpiracion DATE,
                newPrecio DECIMAL(15,2))
BEGIN
	DECLARE message VARCHAR(80);
    
    IF (idProductoXProveedorV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del ProductoXProveedor";
	# no existe ProductoXProveedor
	ELSEIF (SELECT COUNT(*) FROM ProductoXProveedor WHERE ProductoXProveedor.idProductoXProveedor = idProductoXProveedorV) = 0 THEN
		SET message = "No existe el ProductoXProveedor";
    # en caso de que el nuevo newIdProducto no sea null se verifica que exista   
	ELSEIF ((newIdProducto IS NOT NULL AND (SELECT COUNT(*) FROM producto where idProducto = newIdProducto) = 0)) THEN
		SET message = "No existe el producto al que se quiere asociar";
	# en caso de que el nuevo newIdProveedor no sea null se verifica que exista   
	ELSEIF ((newIdProveedor IS NOT NULL AND (SELECT COUNT(*) FROM proveedor where idProveedor = newIdProveedor) = 0)) THEN
		SET message = "No existe el proveedor al que se quiere asociar";
	# existencias negativa
	ELSEIF (newExistencias IS NOT NULL AND newExistencias < 0) THEN
		SET message = "Las existencias de producto no pueden ser menor a 0";   
	ELSEIF (newPrecio IS NOT NULL AND newPrecio < 0) THEN
		SET message = "El precio del producto no puede ser menor a 0";   
	# se intenta agregar una fecha que no ha llegado
	ELSEIF (newFechaProduccion > curdate()) THEN
		SET message = "La fechaProduccion no puede ser futura";
	# fecha expiracion tiene que ser futura
	ELSEIF (newFechaExpiracion <= curdate()) THEN
		SET message = "La FechaExpiracion no puede ser futura";
	# fecha produccion >= fecha expiracion
	ELSEIF (newFechaProduccion IS NOT NULL AND (SELECT FechaExpiracion FROM ProductoXProveedor WHERE idProductoXProveedor = idProductoXProveedorV) <= newFechaProduccion ) THEN
		SET message = "La FechaProduccion no puede ser mayor o igual a la FechaExpiracion";
	# fecha expiracion <= fecha produccion
	ELSEIF (newFechaExpiracion IS NOT NULL AND (SELECT FechaProduccion FROM ProductoXProveedor WHERE idProductoXProveedor = idProductoXProveedorV) >= newFechaExpiracion ) THEN
		SET message = "La FechaExpiracion no puede ser menor o igual a la FechaProduccion";
        
	ELSE
		UPDATE productoXProveedor SET productoXProveedor.idProducto = IFNULL(newIdProducto, productoXProveedor.idProducto),
        productoXProveedor.idProveedor = IFNULL(newIdProveedor, productoXProveedor.idProveedor),
        productoXProveedor.existencias = IFNULL(newExistencias, productoXProveedor.existencias),
        productoXProveedor.fechaProduccion = IFNULL(newFechaProduccion, productoXProveedor.fechaProduccion),
        productoXProveedor.fechaExpiracion = IFNULL(newFechaExpiracion, productoXProveedor.fechaExpiracion),
        productoXProveedor.precio = IFNULL(newPrecio, productoXProveedor.precio)
        WHERE productoXProveedor.idProductoXProveedor = idProductoXProveedorV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
DELIMITER $$
CREATE PROCEDURE createSucursalXProducto (idSucursalV INT, idProductoV INT, cantidadV INT,
										  cantidadMinV INT, cantidadMaxV INT, fechaProduccionV DATE,
                                          fechaExpiracionV DATE, estadoV VARCHAR(30), precioV DECIMAL(15,2))
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
	ELSEIF (cantidadV < 0 OR cantidadMinV < 0 OR cantidadMaxV < 0 OR precioV < 0) THEN
		SET message = "ERROR - Las cantidades no pueden ser negativas";
	ELSEIF (cantidadMaxV < cantidadMinV) THEN
		SET message = "ERROR - La cantidad minima no puede ser mayor a la maxima";
	ELSEIF (fechaProduccionV > fechaExpiracionV) THEN
		SET message = "La fecha de producion no puede ser despues de la de expiracion";
	#FALTA VALIDAR ESTADO
	ELSE
		INSERT INTO Sucursalxproducto(idSucursal, idProducto, cantidad, cantidadMin, 
										cantidadMax, fechaProduccion, fechaExpiracion, 
                                        estado, precio)
									VALUES(idSucursalV, idProductoV, cantidadV, cantidadMinV, 
										cantidadMaxV, fechaProduccionV, fechaExpiracionV, 
                                        estadoV, precioV);
		SET message = "Se agregó la Sucursalxproducto con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
#READ-------------------------------------------------------------
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
        SucursalXProducto.fechaProduccion, SucursalXProducto.fechaExpiracion, SucursalXProducto.estado, SucursalXProducto.precio
        FROM SucursalXProducto
		WHERE SucursalXProducto.idSucursalXProducto = IFNULL(idSucursalXProductoV, SucursalXProducto.idSucursalXProducto);
	END IF;
END;
$$
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateSucursalXProducto (idSucursalXProductoV INT, newIdSucursal INT, newIdProducto INT, newCantidad INT,
				newCantidadMin INT, newCantidadMax INT, newFechaProduccion DATE, newFechaExpiracion DATE, newEstado VARCHAR(30),
                newPrecio DECIMAL(15,2))
BEGIN
	DECLARE message VARCHAR(80);
    
    IF (idSucursalXProductoV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del SucursalXProducto";
	# no existe SucursalXProducto
	ELSEIF (SELECT COUNT(*) FROM SucursalXProducto WHERE SucursalXProducto.idSucursalXProducto = idSucursalXProductoV) = 0 THEN
		SET message = "No existe el SucursalXProducto";
    # en caso de que el nuevo newIdSucursal no sea null se verifica que exista   
	ELSEIF ((newIdSucursal IS NOT NULL AND (SELECT COUNT(*) FROM sucursal where idSucursal = newIdSucursal) = 0)) THEN
		SET message = "No existe la sucursal a la que se quiere asociar";
	# en caso de que el nuevo newIdProducto no sea null se verifica que exista   
	ELSEIF ((newIdProducto IS NOT NULL AND (SELECT COUNT(*) FROM producto where idProducto = newIdProducto) = 0)) THEN
		SET message = "No existe el producto al que se quiere asociar";
	# cantidad negativa
	ELSEIF (newCantidad IS NOT NULL AND newCantidad < 0) THEN
		SET message = "La cantidad de producto no puede ser igual o menor a 0";
	ELSEIF (newPrecio IS NOT NULL AND newPrecio <= 0) THEN
		SET message = "El precio del producto no puede ser igual o menor a 0";
    # cantidad negativa
	ELSEIF (newCantidad IS NOT NULL AND newCantidad > (Select cantidad FROM sucursalxproducto where idSucursalXProducto = idSucursalXProductoV)) THEN
		SET message = "La cantidad no puede superar el maximo ni ser menor al minimo";    
	# cantidadMin negativo
	ELSEIF ((newCantidadMin IS NOT NULL AND newCantidadMin <= 0) or (newCantidadMax IS NOT NULL AND newCantidadMax <= 0)) THEN
		SET message = "La cantidadMin y Max no pueden ser igual o menor a 0";
	# cantidadMin >= cantidadMax
    ELSEIF (newCantidadMin IS NOT NULL AND (SELECT cantidadMax FROM sucursalxproducto WHERE idSucursalXProducto = idSucursalXProductoV) <= newCantidadMin ) THEN
		SET message = "La cantidadMin no puede ser mayor o igual a la cantidadMax";
	# cantidadMax <= cantidadMin
	ELSEIF (newCantidadMax IS NOT NULL AND (SELECT cantidadMin FROM sucursalxproducto WHERE idSucursalXProducto = idSucursalXProductoV) >= newCantidadMax ) THEN
		SET message = "La cantidadMax no puede ser menor o igual a la cantidadMax";
	# se intenta agregar una fecha que no ha llegado
	ELSEIF (newFechaProduccion > curdate()) THEN
		SET message = "La fechaProduccion no puede ser futura";
	# fecha expiracion tiene que ser futura
	ELSEIF (newFechaExpiracion <= curdate()) THEN
		SET message = "La FechaExpiracion no puede ser futura";
	# fecha produccion >= fecha expiracion
	ELSEIF (newFechaProduccion IS NOT NULL AND (SELECT FechaExpiracion FROM sucursalxproducto WHERE idSucursalXProducto = idSucursalXProductoV) <= newFechaProduccion ) THEN
		SET message = "La FechaProduccion no puede ser mayor o igual a la FechaExpiracion";
	# fecha expiracion <= fecha produccion
	ELSEIF (newFechaExpiracion IS NOT NULL AND (SELECT FechaProduccion FROM sucursalxproducto WHERE idSucursalXProducto = idSucursalXProductoV) >= newFechaExpiracion ) THEN
		SET message = "La FechaExpiracion no puede ser menor o igual a la FechaProduccion";
        
	ELSE
		UPDATE sucursalxproducto SET sucursalxproducto.idSucursal = IFNULL(newIdSucursal, sucursalxproducto.idSucursal),
        sucursalxproducto.idProducto = IFNULL(newIdProducto, sucursalxproducto.idProducto),
        sucursalxproducto.cantidad = IFNULL(newCantidad, sucursalxproducto.cantidad),
        sucursalxproducto.cantidadMin = IFNULL(newCantidadMin, sucursalxproducto.cantidadMin),
        sucursalxproducto.cantidadMax = IFNULL(newCantidadMax, sucursalxproducto.cantidadMax),
        sucursalxproducto.fechaProduccion = IFNULL(newFechaProduccion, sucursalxproducto.fechaProduccion),
        sucursalxproducto.fechaExpiracion = IFNULL(newFechaExpiracion, sucursalxproducto.fechaExpiracion),
        sucursalxproducto.estado = IFNULL(newEstado, sucursalxproducto.estado),
        sucursalxproducto.precio = IFNULL(newPrecio, sucursalxproducto.precio)
        WHERE sucursalxproducto.idSucursalXProducto = idSucursalXProductoV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
		SET message = "Se ha insertado la tarjeta con éxito";
	END IF;
    SELECT message AS Resultado;	
END;
$$
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateTarjeta (idTarjetaV INT, newNumTarjeta varchar(16), newCcv INT, newTipo Varchar(15), 
								newFechaCaducidad DATE, newIdCliente INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idTarjetaV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id de la tarjeta";
	# no existe la tarjeta
	ELSEIF (SELECT COUNT(*) FROM tarjeta WHERE tarjeta.idTarjeta = idTarjetaV) = 0 THEN
		SET message = "No existe la tarjeta";
	# nombre vacio
	ELSEIF (newNumTarjeta = "" or newTipo = "") THEN
		SET message = "El numTarjeta o Tipo no puede estar vacio";
	# numtarjeta repetido
    ELSEIF (SELECT count(*) from tarjeta where numTarjeta = newNumTarjeta) THEN
		SET message = "El numero de tarjeta ya lo tiene otro usuario";
	# ccv
    ELSEIF (newCcv < 0 or newCcv > 999) THEN
		SET message = "El ccv debe ser positivo y tener 3 digitos";
	# tarjeta vencida
    ELSEIF (newFechaCaducidad < curdate()) THEN
		SET message = "La tarjeta esta vencida";
	# en caso de que el nuevo idCliente no sea null se verifica que exista   
	ELSEIF ((newIdCliente IS NOT NULL AND (SELECT COUNT(*) FROM cliente where idCliente = newIdCliente) = 0)) THEN
		SET message = "No existe el cliente al que se quiere asociar";
    
	ELSE
		UPDATE tarjeta SET tarjeta.numTarjeta = IFNULL(newNumTarjeta, tarjeta.numTarjeta),
        tarjeta.ccv = IFNULL(newCcv, tarjeta.ccv),
        tarjeta.tipo = IFNULL(newTipo, tarjeta.tipo),
        tarjeta.fechaCaducidad = IFNULL(newFechaCaducidad, tarjeta.fechaCaducidad),
        tarjeta.idCliente = IFNULL(newIdCliente, tarjeta.idCliente)
        
        WHERE tarjeta.idTarjeta = idTarjetaV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
		SET message = "El cheque se ha agregado exitosamente";
	END IF;
    SELECT message AS Resultado;	
END;
$$
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE udpdateCheque (idChequeV INT,newNumCheque varchar(9), newRutaBancaria varchar(23),
								newFechaApertura date, newCuentaBancaria varchar(20), newIdCliente INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idChequeV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del cheque";
	# no existe el cheque
	ELSEIF (SELECT COUNT(*) FROM cheque WHERE cheque.idCheque = idChequeV) = 0 THEN
		SET message = "No existe el cheque";
	# parametros vacios
	ELSEIF (newNumCheque = "" or newRutaBancaria = "" or newCuentaBancaria = "") THEN
		SET message = "El numCheque, rutaBancaria o cuenta no pueden estar vacio";
	# newNumCheque repetido
    ELSEIF (SELECT count(*) from cheque where idCliente = 
			newIdCliente and numCheque = newNumCheque) THEN
		SET message = "Este usuario ya tiene ese numero de cheque";
	# newRutaBancaria repetido
    ELSEIF (SELECT count(*) from cheque where rutaBancaria = newRutaBancaria) THEN
		SET message = "La ruta bancaria ya lo tiene otro usuario";
	# newCuentaBancaria repetido
    ELSEIF (SELECT count(*) from cheque where cuentaBancaria = newCuentaBancaria) THEN
		SET message = "La cuentaBancaria ya lo tiene otro usuario";
	# tarjeta vencida
    ELSEIF (newFechaApertura > curdate()) THEN
		SET message = "La fecha de apertura no puede ser futura";
	# en caso de que el nuevo idCliente no sea null se verifica que exista   
	ELSEIF ((newIdCliente IS NOT NULL AND (SELECT COUNT(*) FROM cliente where idCliente = newIdCliente) = 0)) THEN
		SET message = "No existe el cliente al que se quiere asociar";
    
	ELSE
		UPDATE cheque SET cheque.numCheque = IFNULL(newNumCheque, cheque.numCheque),
        cheque.rutaBancaria = IFNULL(newRutaBancaria, cheque.rutaBancaria),
        cheque.fechaApertura = IFNULL(newFechaApertura, cheque.fechaApertura),
        cheque.cuentaBancaria = IFNULL(newCuentaBancaria, cheque.cuentaBancaria),
        cheque.idCliente = IFNULL(newIdCliente, cheque.idCliente)
        
        WHERE cheque.idCheque = idChequeV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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
#READ-------------------------------------------------------------
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
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateCriptomoneda (idCriptomonedaV INT, newDireccionCripto VARCHAR(30), newTipo varchar(15), newIdCliente INT)
BEGIN
	DECLARE message VARCHAR(60);
    
    IF (idCriptomonedaV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id de la criptomoneda";
	# no existe la criptomoneda
	ELSEIF (SELECT COUNT(*) FROM criptomoneda WHERE criptomoneda.idCriptomoneda = idCriptomonedaV) = 0 THEN
		SET message = "No existe la criptomoneda";
	# nombre vacio
	ELSEIF (newDireccionCripto = "" or newTipo = "") THEN
		SET message = "El DireccionCripto o Tipo no puede estar vacio";
	# DireccionCripto repetido
    ELSEIF (SELECT count(*) from criptomoneda where direccionCripto = newDireccionCripto) THEN
		SET message = "La DireccionCripto ya lo tiene otro usuario";
	# en caso de que el nuevo idCliente no sea null se verifica que exista   
	ELSEIF ((newIdCliente IS NOT NULL AND (SELECT COUNT(*) FROM cliente where idCliente = newIdCliente) = 0)) THEN
		SET message = "No existe el cliente al que se quiere asociar";
    
	ELSE
		UPDATE criptomoneda SET criptomoneda.direccionCripto = IFNULL(newDireccionCripto, criptomoneda.direccionCripto),
        criptomoneda.tipo = IFNULL(newTipo, criptomoneda.tipo),
        criptomoneda.idCliente = IFNULL(newIdCliente, criptomoneda.idCliente)
        
        WHERE criptomoneda.idCriptomoneda = idCriptomonedaV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
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

/*------------------------------------------------------------------
24 - Procedimientos para crud de la tabla Criptomoneda
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
#CREATE TipoEnvio
DELIMITER $$
CREATE PROCEDURE createTipoEnvio (descripcionV VARCHAR(30), porcAdicionalV DECIMAL(5,2))
BEGIN
	DECLARE message VARCHAR(80);
	
    IF (descripcionV IS NULL OR porcAdicionalV IS NULL) THEN
		SET message = "ERROR - Los datos ingresados son null";
	ELSEIF (porcAdicionalV < 0.0 OR porcAdicionalV > 0.1)THEN
		SET message = "ERROR - El porcentaje adicional debe ser mayor o igual a 0 y menor que 0.1";
	ELSE 
		INSERT INTO TipoEnvio (descripcion, porcentajeAdicional)
					VALUES (descripcionV, porcAdicionalV);
		SET message = "Se ha creado el nuevo impuesto con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
#READ-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE readTipoEnvio (idTipoEnvioV INT)
BEGIN

	IF(idImpuestoV IS NULL) THEN
		SELECT "Ingrese el id del TipoEnvio" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM Impuesto 
		WHERE TipoEnvio.idTipoEnvio = IFNULL(idTipoEnvioV, tipoenvio.idTipoEnvio)) = 0 THEN
		SELECT "No existe TipoEnvio con ese id" AS ERROR;
	ELSE
		SELECT TipoEnvio.idTipoEnvio, TipoEnvio.descripcion, TipoEnvio.idTipoEnvio FROM TipoEnvio
		WHERE TipoEnvio.idTipoEnvio = IFNULL(idTipoEnvioV, TipoEnvio.idTipoEnvio);
	END IF;
END;
$$
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateTipoEnvio (idTipoEnvioV INT, newDescripcion varchar(30), newPorcentajeAdicional decimal(5,2))
BEGIN
	DECLARE message VARCHAR(70);
    
    IF (idTipoEnvioV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del TipoEnvio";
	# no existe el tipoEnvio
	ELSEIF (SELECT COUNT(*) FROM tipoEnvio WHERE tipoEnvio.idTipoEnvio = idTipoEnvioV) = 0 THEN
		SET message = "No existe el tipoEnvio";
	# parametros vacios
	ELSEIF (newDescripcion = "") THEN
		SET message = "La descripcion del tipoEnvio no puede estar vacio";
	# newDescripcion repetido
    ELSEIF (SELECT count(*) from tipoEnvio where descripcion = newDescripcion) THEN
		SET message = "Ya existe un tipoEnvio con esa descripcion";
	#
    ELSEIF (newPorcentajeAdicional < 0.0 or newPorcentajeAdicional > 0.1) THEN
		SET message = "El porcentaje adicional no puede ser negativo o mayor a 0.1";
    
	ELSE
		UPDATE tipoEnvio SET tipoEnvio.descripcion = IFNULL(newDescripcion, tipoEnvio.descripcion),
        tipoEnvio.porcentajeAdicional = IFNULL(newPorcentajeAdicional, tipoEnvio.porcentajeAdicional)
        WHERE tipoEnvio.idTipoEnvio = idTipoEnvioV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE deleteTipoEnvio (idTipoEnvioV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el TipoEnvio" AS Resultado;
    
    IF (idTipoEnvioV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM TipoEnvio WHERE idTipoEnvio = idTipoEnvioV) = 0 THEN
		SET message = "ERROR - No existe un TipoEnvio con el id ingresado";
	ELSE
		DELETE FROM TipoEnvio WHERE idTipoEnvio = idTipoEnvioV;
		SET message = "Se ha borrado con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$

/*------------------------------------------------------------------
24 - Procedimientos para crud de la tabla SucursalXCliente
------------------------------------------------------------------*/
#CREATE-------------------------------------------------------------
#CREATE TipoEnvio
DELIMITER $$
CREATE PROCEDURE createSucursalXCliente (idSucursalV INT, idClienteV INT)
BEGIN
	DECLARE message VARCHAR(80);
	
    IF (SELECT COUNT(*)  FROM Sucursal Where idSucursal = idSucursalV) = 0 THEN
		SET message = "No existe la sucursal";
	ELSEIF (SELECT COUNT(*)  FROM CLIENTE Where idCliente = idClienteV) = 0 THEN
		SET message = "No existe el cliente";
	ELSEIF (SELECT COUNT(*) FROM SucursalXCliente WHERE idSucursal = idSucursalV AND idCliente = idClienteV) > 0 THEN
		SET message = "Este cliente ya se encuentra registrado en la sucursal";
	ELSE 
		INSERT INTO SucursalXCliente (idSucursal, idCliente)
					VALUES (idSucursalV, idClienteV);
		SET message = "Se ha creado el nuevo sucursalXCliente con éxito";
	END IF;
    SELECT message AS Resultado;
END;
$$
#READ-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE readSucursalXCliente (idSucursalXClienteV INT)
BEGIN

	IF(idSucursalXClienteV IS NULL) THEN
		SELECT "Ingrese el id del SucursalXClienteV" AS ERROR;
    ELSEIF (SELECT COUNT(*) FROM SucursalXCliente 
		WHERE SucursalXCliente.idSucursalXCliente = IFNULL(idSucursalXClienteV, 
        SucursalXCliente.idSucursalXCliente)) = 0 THEN
		SELECT "No existe SucursalXCliente con ese id" AS ERROR;
	ELSE
		SELECT SucursalXCliente.idSucursalXCliente, SucursalXCliente.idSucursal, 
        SucursalXCliente.idCliente FROM SucursalXCliente
		WHERE SucursalXCliente.idSucursalXCliente = IFNULL(idSucursalXClienteV, SucursalXCliente.idSucursalXCliente);
	END IF;
END;
$$
#UPDATE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE updateSucursalXCliente (idSucursalXClienteV INT, newIdSucursal INT, newIdCliente INT)
BEGIN
	DECLARE message VARCHAR(70);
    
    IF (idSucursalXClienteV IS NULL) THEN
		SET message = "Para modificar debe ingresar el id del SucursalXCliente";
	# no existe el sucursalXCliente
	ELSEIF (SELECT COUNT(*) FROM sucursalXCliente WHERE sucursalXCliente.idSucursalXCliente = idSucursalXClienteV) = 0 THEN
		SET message = "No existe el sucursalXCliente";
	# no existe el idSucursal
	ELSEIF (SELECT COUNT(*) FROM sucursal WHERE sucursal.idSucursal = newIdSucursal) = 0 THEN
		SET message = "No existe el idSucursal";
	#
    # no existe el idCliente
	ELSEIF (SELECT COUNT(*) FROM cliente WHERE cliente.idCliente = newIdCliente) = 0 THEN
		SET message = "No existe el idCliente";
    ELSEIF (SELECT COUNT(*) FROM SucursalXCliente WHERE idSucursal = newIdSucursal AND idCliente = newIdCliente) > 0 THEN
		SET message = "Este cliente ya se encuentra registrado en la sucursal";
    
	ELSE
		UPDATE SucursalXCliente SET SucursalXCliente.idSucursal = IFNULL(newIdSucursal, SucursalXCliente.idSucursal),
        SucursalXCliente.idCliente = IFNULL(newIdCliente, SucursalXCliente.idCliente)
        WHERE SucursalXCliente.idSucursalXCliente = idSucursalXClienteV;
        SET message = "Se ha modificado con exito";
	END IF;
    SELECT message as Resultado;
END;
$$
#DELETE-------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE deleteSucursalXCliente (idSucursalXClienteV INT)
BEGIN
	DECLARE message VARCHAR(60);
    #Manejo de error- fk de otras tablas
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR- No se puede borrar el TipoEnvio" AS Resultado;
    
    IF (idSucursalXClienteV IS NULL) THEN
		SET message = "ERROR - No puede ingresar datos NULL";
	ELSEIF (SELECT COUNT(*) FROM SucursalXCliente WHERE idSucursalXCliente = idSucursalXClienteV) = 0 THEN
		SET message = "ERROR - No existe un SucursalXClienteV con el id ingresado";
	ELSE
		DELETE FROM SucursalXCliente WHERE idSucursalXCliente = idSucursalXClienteV;
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



