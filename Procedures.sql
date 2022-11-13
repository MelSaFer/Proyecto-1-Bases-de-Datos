USE proyectoBases;

#PROCEDURES-----------------------------------------------------------------------------------------
/*------------------------------------------------------------------
1 - Procedimiento paraque el administrador de la sucursal le genere 
	reportes al gerente general
No se que reportes hace :o
ENTRADAS: 
SALIDAS: 
------------------------------------------------------------------*/

/*------------------------------------------------------------------
2 - Consultar empleado por sucursal, puesto y fecha de contratación 
Busca en la tabla empleado de acuerdo a los parametros recibidos
ENTRADAS: el id de las sucursal o el nombre de la sucursal,
		el id del puedo, el nombre del puesto y la fecha de contratacion
SALIDAS: El conjunto de empleados que comparten las caracteristicas 
		recibidas-*
------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS consultarEmpleados;
DELIMITER $$
CREATE PROCEDURE consultarEmpleados (idSucursalV INT, nombreSucursalV VARCHAR(30),
									idPuestoV INT, descripcionV VARCHAR(30), 
                                    fechaContratacionIV DATE, fechaContratacionFV DATE)
BEGIN
    
    IF (fechaContratacionIV IS NOT NULL AND fechaContratacionFV IS NOT NULL AND
		(fechaContratacionFV < fechaContratacionIV)) THEN
        SELECT "El rango de fechas no es correcto" AS ERRORM;
    ELSE
		SELECT Empleado.nombre, Empleado.fechaContratacion, empleado.salarioBase,
			Sucursal.nombreSucursal, Cargo.descripcion FROM Empleado
		INNER JOIN Sucursal ON Sucursal.idSucursal = Empleado.idSucursal
		INNER JOIN Cargo ON Cargo.idCargo = Empleado.idCargo
		WHERE empleado.idSucursal = IFNULL(idSucursalV, Empleado.idSucursal) AND
			Sucursal.nombreSucursal = IFNULL(nombreSucursalV, Sucursal.nombreSucursal)
			AND Empleado.idCargo = IFNULL(idPuestoV, Empleado.idCargo) AND
			Cargo.descripcion = IFNULL(descripcionV, Cargo.descripcion) AND
			(Empleado.fechaContratacion >= IFNULL(fechaContratacionIV, Empleado.fechaContratacion))
			AND (Empleado.fechaContratacion <= IFNULL(fechaContratacionFV, Empleado.fechaContratacion));
	END IF;
END;
$$

/*------------------------------------------------------------------
3 -  Consultar Proveedor por nombre de producto o nombre de proveedor
ENTRADAS: Nombre del producto o nombre de proveedor
SALIDAS: 
------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS cosultaProveedores;
DELIMITER $$
CREATE PROCEDURE cosultaProveedores (nombreProductoV VARCHAR(30),
									 nombreProveedorV VARCHAR(30))
BEGIN
	SELECT Proveedor.nombre, Proveedor.telefono, Proveedor.porcGanancia,
		Producto.nombreProducto FROM Proveedor
	INNER JOIN ProductoXProveedor ON ProductoXProveedor.idProveedor = Proveedor.idProveedor
    INNER JOIN Producto ON Producto.idProducto = ProductoXProveedor.idProveedor
    WHERE Proveedor.nombre = IFNULL(nombreProveedorV,Proveedor.nombre) 
    AND Producto.nombreProducto = IFNULL(nombreProductoV,Producto.nombreProducto);
END;
$$

/*------------------------------------------------------------------
4 -  Procedimiento para revisar los productos que van a expirar y 
	se ponen en descuento, si está vencido se saca del mostrador
ENTRADAS: 
SALIDAS: 
------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS revisarProductosSucursal;
DELIMITER $$
CREATE PROCEDURE revisarProductosSucursal(porcDescuentoV DECIMAL(5,2))
BEGIN
	DECLARE resultadoV INTEGER DEFAULT 0;
    DECLARE estadoV VARCHAR(30);
    DECLARE idSucursalXProductoV INT;
    DECLARE idProductoV INT;
    DECLARE fechaExpiracionV DATE;
    
	DECLARE cursorPromo CURSOR FOR SELECT idSucursalXProducto, idProducto, 
		fechaExpiracion, estado FROM SucursalXProducto;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET resultadoV = 1;
    
    OPEN cursorPromo;
    
    bucle: LOOP
		FETCH cursorPromo INTO idSucursalXProductoV, idProductoV, 
			fechaExpiracionV, estadoV;
            
		IF resultadoV = 1 THEN
			LEAVE bucle;
		END IF;
        
        IF (fechaExpiracionV >= (SELECT CURDATE()) AND 
			fechaExpiracionV <= (SELECT DATE_ADD((SELECT CURDATE()), INTERVAL 7 DAY))
            AND estadoV != "En Promocion") THEN
            UPDATE SucursalXProducto SET estado = "En Promocion" 
				WHERE idProducto = idProductoV AND idSucursalXProducto = idSucursalXProductoV;
			CALL createPromocion((SELECT CURDATE()), (SELECT DATE_ADD((SELECT CURDATE()), INTERVAL 7 DAY)),
				porcDescuentoV, idProductoV);
                SELECT "Se ha puesto en promo";
		ELSEIF(fechaExpiracionV < (SELECT CURDATE())) THEN
			UPDATE SucursalXProducto SET SucursalXProducto.estado = "Vencido" 
				WHERE idProducto = idProductoV AND idSucursalXProducto = idSucursalXProductoV;
			 SELECT "Se Vencio:(";
		END IF;
	END LOOP bucle;
    CLOSE cursorPromo;
END;
/*------------------------------------------------------------------
N -  
ENTRADAS: 
SALIDAS: 
------------------------------------------------------------------*/



