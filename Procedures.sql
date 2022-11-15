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

call consultarEmpleados (1,null,1,null,null,null);
/*------------------------------------------------------------------
3 -  Consultar Proveedor por nombre de producto o nombre de proveedor
ENTRADAS: Nombre del producto o nombre de proveedor
SALIDAS: 
------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS consultarProveedores;
DELIMITER $$
CREATE PROCEDURE consultarProveedores (nombreProductoV VARCHAR(30),
                                     nombreProveedorV VARCHAR(30))
BEGIN
    SELECT Proveedor.nombre, Proveedor.telefono, Proveedor.porcGanancia,
        Producto.nombreProducto FROM Proveedor
    INNER JOIN ProductoXProveedor ON ProductoXProveedor.idProveedor = Proveedor.idProveedor
    INNER JOIN Producto ON Producto.idProducto = ProductoXProveedor.idProducto
    WHERE Proveedor.nombre = IFNULL(nombreProveedorV,Proveedor.nombre) 
    AND Producto.nombreProducto = IFNULL(nombreProductoV,Producto.nombreProducto);
END;
$$

select * from proveedor
call consultarProveedores(null, "dos pinos");
/*------------------------------------------------------------------
4 -  Procedimiento para revisar los productos que van a expirar y 
	se ponen en descuento, si está vencido se saca del mostrador
ENTRADAS: 
SALIDAS: 
------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS revisarProductosSucursal;
DELIMITER $$
CREATE PROCEDURE revisarProductosSucursal(porcDescuentoV DECIMAL(5,2))
SP: BEGIN
	DECLARE resultadoV INTEGER DEFAULT 0;
    DECLARE estadoV VARCHAR(30);
    DECLARE idLoteV INT;
    DECLARE idProductoV INT;
    DECLARE fechaExpiracionV DATE;
    
	DECLARE cursorPromo CURSOR FOR SELECT idLote, idProducto, 
		fechaExpiracion, estado FROM Lote;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET resultadoV = 1;
    
    IF (porcDescuentoV IS NULL) THEN
		SELECT "El procentaje de descuento a los productos no puede ser null";
        LEAVE SP;
    END IF;
    
    OPEN cursorPromo;
    bucle: LOOP
		FETCH cursorPromo INTO idLoteV, idProductoV, 
			fechaExpiracionV, estadoV;
            
		IF resultadoV = 1 THEN
			LEAVE bucle;
		END IF;
        
        IF (fechaExpiracionV >= (SELECT CURDATE()) AND 
			fechaExpiracionV <= (SELECT DATE_ADD((SELECT CURDATE()), INTERVAL 7 DAY))
            AND estadoV != "En Promocion") THEN
            UPDATE Lote SET estado = "En Promocion" 
				WHERE idProducto = idProductoV AND idLote = idLoteV;
			CALL createPromocion((SELECT CURDATE()), (SELECT DATE_ADD((SELECT CURDATE()), INTERVAL 7 DAY)),
				porcDescuentoV, idProductoV);
                SELECT "Se ha puesto en promo";
		ELSEIF(fechaExpiracionV < (SELECT CURDATE()) AND  estadoV != "Vencido") THEN
			UPDATE Lote SET Lote.estado = "Vencido" 
				WHERE idProducto = idProductoV AND idLote = idLoteV;
			 SELECT "Se Vencio:(";
		END IF;
	END LOOP bucle;
    CLOSE cursorPromo;
END;
$$

call revisarProductosSucursal(0.03);

/*------------------------------------------------------------------
5 -  Procedimiento para hacer el pedido del producto a los 
	proveedores, buscando llegar a la máxima cantidad en el
    inventario, se busca el proveedor que tengo el producto más 
    barato y con existencias 
ENTRADAS: El id de la sucursal, id del producto  
SALIDAS: 
------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS hacerPedidoProveedor;
DELIMITER $$
CREATE PROCEDURE hacerPedidoProveedor ( idSucursalV INT, idProductoV INT)
MAIN : BEGIN
	DECLARE idProveedorSeleccionado INT;
    DECLARE sumProductosEnInventario INT;
    DECLARE resultado_VAR INTEGER DEFAULT 0;
    DECLARE idProductoXProveedor_VAR INT;
    DECLARE idProducto_VAR INT;
    DECLARE idProveedor_VAR INT;
    DECLARE existencias_VAR INT;
    DECLARE fechaProduccion_VAR DATE;
    DECLARE fechaExpiracion_VAR DATE;
    DECLARE precio_VAR DECIMAL(15,2);
    DECLARE sumadorVendidos INT DEFAULT 0;
    DECLARE minInv INT;
    DECLARE maxInv INT;
    DECLARE porcGananciaP DECIMAL (5,2);
    
    
    DECLARE cursorPP CURSOR FOR SELECT idProductoXProveedor, idProducto, idProveedor,
		existencias, fechaProduccion, fechaExpiracion, precio FROM ProductoXProveedor;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET resultado_VAR = 1;
    
    SET sumProductosEnInventario = (SELECT SUM(Lote.Cantidad) 
									FROM Lote
									WHERE Lote.idProducto = idProductoV AND
                                    Lote.idSucursal = idSucursalV AND
									Lote.Estado != "Vencido");
	select sumProductosEnInventario;
	SET minInv = (SELECT DISTINCT cantidadMin FROM Lote
		WHERE Lote.idProducto = idProductoV);
	SET maxInv = (SELECT DISTINCT cantidadMax FROM Lote
		WHERE Lote.idProducto = idProductoV);
	#IF (idProducto IS NULL)]
    #SELECT sumProductosEnInventario AS Resultado;
    IF (sumProductosEnInventario <= minInv) THEN
        
        SET idProveedorSeleccionado = (SELECT proveedor.idProveedor FROM proveedor 
			INNER JOIN  productoxproveedor ON productoxproveedor.idProveedor = proveedor.idProveedor
			WHERE productoxproveedor.precio = (SELECT MIN(precio) FROM productoxproveedor
			WHERE idProducto = idProductoV) AND productoXProveedor.idProducto = idProductoV
            AND (SELECT SUM(existencias) FROM productoXProveedor WHERE productoXProveedor.idProducto = idProductoV) > 0);
		#SELECT idProveedorSeleccionado;
        IF (idProveedorSeleccionado IS NULL) THEN
			SELECT "Los proveedores no tienen existencias del producto";
			LEAVE MAIN;
        END IF;
		SET porcGananciaP = (SELECT proveedor.porcGanancia FROM proveedor 
			WHERE proveedor.idProveedor = idProveedorSeleccionado);
		OPEN cursorPP;
        bucle: LOOP
			FETCH cursorPP INTO idProductoXProveedor_VAR, idProducto_VAR, idProveedor_VAR,
				existencias_VAR, fechaProduccion_VAR, fechaExpiracion_VAR, precio_VAR;
			IF resultado_VAR = 1 THEN
				LEAVE bucle;
			END IF;
			#aqui:)
            IF(sumProductosEnInventario + sumadorVendidos) < maxInv AND idProveedor_VAR = idProveedorSeleccionado THEN
				IF (existencias_VAR >= (maxInv - (sumProductosEnInventario + sumadorVendidos))) THEN
					SELECT precio_VAR+(precio_VAR*porcGananciaP) AS "2";
					CALL createLote(idSucursalV, idProductoV, 
                    (maxInv - (sumProductosEnInventario + sumadorVendidos)),
                    minInv, maxInv, fechaProduccion_VAR, fechaExpiracion_VAR, 
                    "En mostrador", (precio_VAR+(precio_VAR*porcGananciaP)));
                                        
                    CALL updateProductoXProveedor(idProductoXProveedor_VAR, NULL, NULL,
						(existencias_VAR - (maxInv - (sumProductosEnInventario + sumadorVendidos))),
                        NULL, NULL, NULL);
					SET sumadorVendidos = sumadorVendidos + (maxInv - sumProductosEnInventario);
					LEAVE bucle;
				ELSE
					SELECT precio_VAR+(precio_VAR*porcGananciaP) AS "1";
					CALL createLote(idSucursalV, idProductoV, existencias_VAR,
						minInv, maxInv, fechaProduccion_VAR, fechaExpiracion_VAR, 
						"En mostrador", (precio_VAR+(precio_VAR*porcGananciaP)));
					 CALL updateProductoXProveedor(idProductoXProveedor_VAR, NULL, NULL,
						0, NULL, NULL, NULL);
					SET sumadorVendidos = sumadorVendidos + existencias_VAR;
				END IF;
            END IF;
        END LOOP bucle;
        CLOSE cursorPP;
		
        select idProveedorSeleccionado;
		call createEncargo (curdate(), idSucursalV, sumadorVendidos, idProductoV, idProveedorSeleccionado);
	END IF;
    
END;
$$

call hacerPedidoProveedor(1, 1);
select * from proveedor;
select * from productoXProveedor;
select * from Lote;
call updateLote(3,null,null,0,null,null,null,null,"mostrador",null);
#PROCE. 6

/*------------------------------------------------------------------
N -  Productos que han expirado en la sucursal
ENTRADAS: NONE
SALIDAS: Productos/lotes de producto con estado expirado
------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS reporteExpiradosSucursal;
DELIMITER $$
CREATE PROCEDURE reporteExpiradosSucursal(idSucursal INT)
BEGIN
	IF (idSucursal IS NOT NULL AND (SELECT COUNT(*) FROM Sucursal
		WHERE Sucursal.idSucursal = idSucursal) = 0 ) THEN
        SELECT "ERROR- El id ingresado no existe";
	ELSE
		SELECT Producto.idProducto, Producto.nombreProducto, Categoria. descripcion,
			Lote.cantidad, Lote.estado FROM producto
			INNER JOIN Categoria ON Categoria.idCategoria = Producto.idCategoria
			INNER JOIN Lote ON Lote.idProducto = Producto.idProducto
			WHERE Lote.estado = "Vencido"
			AND Lote.idSucursal = IFNULL(idSucursal, Lote.idSucursal);
	END IF;
END
$$

/*------------------------------------------------------------------
N -  Procedimiento para dar bonos a los empleados que superen 1000 ventas
ENTRADAS: 
SALIDAS: 
------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS bonoEmpleados;
DELIMITER $$
CREATE PROCEDURE bonoEmpleados()
BEGIN

	DECLARE resultadoV INTEGER DEFAULT 0;
    DECLARE idEmpleadoV INT;
    DECLARE nombreV VARCHAR(30);
    DECLARE salarioBaseV DECIMAL(15,2);
    DECLARE idSucursalV INT;
    DECLARE idCargoV INT;

	DECLARE cursorEmpleado CURSOR FOR SELECT idEmpleado, nombre, 
		salarioBase, idSucursal, idCargo FROM Empleado;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET resultadoV = 1;

	
	OPEN cursorEmpleado;
    bucle: LOOP
		FETCH cursorEmpleado INTO idEmpleadoV, nombreV, 
		salarioBaseV, idSucursalV, idCargoV;
        
        IF resultadoV = 1 then 
			leave bucle;
		end if;
        
        
        IF (SELECT SUM(detalle.cantidad) FROM Empleado
        INNER JOIN Pedido on Empleado.idEmpleado = Pedido.idEmpleado
        INNER JOIN Detalle on Pedido.idPedido = Detalle.idPedido
        WHERE Pedido.fecha >= curdate()-7) > 100 AND (SELECT cargo.descripcion FROM Empleado INNER JOIN
        Cargo on Empleado.idCargo = cargo.idCargo WHERE Empleado.idEmpleado = idEmpleadoV) = "facturador" THEN
        
        call createBono(100000, curdate(), idEmpleadoV);
		
        #SELECT idEmpleadoV;
        
        END IF;
		
	END LOOP bucle;
    CLOSE cursorEmpleado;

END
$$

/*------------------------------------------------------------------
N -  Procedimiento para que el cliente haga el pedido, puede pedir 
	entrega a domicilio y el costo de envío es un 0,1% del monto pagado. 
    Puede pagar con diferentes métodos de pago
ENTRADAS: 
SALIDAS: 
------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS crearPedido;
DELIMITER $$
CREATE PROCEDURE crearPedido(idTipoPagoV INT, idClienteV INT, idEmpleadoV INT, idTipoEnvioV INT, idSucursalV INT)
BEGIN

	IF (idEmpleadoV IS NOT NULL AND (select cargo.descripcion from empleado 
		INNER JOIN Cargo on empleado.idCargo = cargo.idCargo
		where empleado.idEmpleado = idEmpleadoV) != "facturador") THEN
		SELECT "ERROR- El empleado no es facturador" AS Resultado;
    
    else 
		call createPedido(curdate(), idClienteV, idTipoPagoV, idEmpleadoV, idTipoEnvioV, idSucursalV);
    
    END IF;
END
$$
#---------------------------

DROP PROCEDURE IF EXISTS agregarDetalle;
DELIMITER $$
CREATE PROCEDURE agregarDetalle(idPedidoV INT, idProductoV INT, cantidadV INT)
BEGIN

	DECLARE resultadoV INTEGER DEFAULT 0;
    DECLARE idLoteV INT;
    DECLARE idSucursalV INT;
    DECLARE idProducto_VAR INT;
    DECLARE cantidad_VAR INT;
    DECLARE estadoV VARCHAR(30);
    DECLARE precioV DECIMAL(15,2);
    DECLARE contadorProducto INT DEFAULT 0;
    
    DECLARE idSucursalSeleccionado INT;
    
    DECLARE cursorLote CURSOR FOR SELECT idLote, 
    idSucursal, idProducto, cantidad, estado, precio FROM Lote;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET resultadoV = 1;
    
    SET idSucursalSeleccionado = (SELECT sucursal.idSucursal FROM Pedido 
    INNER JOIN Sucursal ON Pedido.idSucursal = Sucursal.idSucursal
    WHERE sucursal.idSucursal = pedido.idSucursal);
    
    IF (idPedidoV IS NULL) THEN
		SELECT "El pedido no puede ser null" as Resultado;
	
    ELSE 
	
		OPEN cursorLote;
		bucle: LOOP
			FETCH cursorLote INTO idLoteV, 
			idSucursalV, idProducto_VAR, cantidad_VAR, estadoV, precioV;
            
            if((idProducto_VAR = idProductoV) AND estadoV != "vencido" 
            AND cantidad_VAR > 0 AND idSucursalV = idSucursalSeleccionado) THEN
				
                IF (cantidad_Var >= cantidadV) THEN
					CALL updateLote(idLoteV, null,
                    null, cantidad_Var - cantidadV, null, null, null, null);
                    
                    SET contadorProducto = contadorProducto + cantidadV;
                    call createDetalle(contadorProducto, cantidadV * precioV, idPedidoV, idProductoV);
                    LEAVE BUCLE;
				
                ELSE
					CALL updateLote(idLoteV, null,
                    null, 0, null, null, null, null);
                    
                    SET contadorProducto = contadorProducto + (cantidad_Var);
                    call createDetalle(cantidad_Var, cantidad_Var * precioV, idPedidoV, idProductoV);
				END IF;
                
			END IF;
			

		END LOOP bucle;
		CLOSE cursorLote;
        
	END IF;
END
$$

#-------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS generarReportes;
DELIMITER $$
CREATE PROCEDURE generarReportes(nombrePais VARCHAR(30), nombreProducto VARCHAR(30),
								fechaInicial DATE, fechaFinal DATE, nombreSucursal VARCHAR(30),
                                idSucursal INT, idProveedor INT, nombreProveedor VARCHAR(30))
BEGIN
	DECLARE totalVentas INT;
    DECLARE totalGanancias DECIMAL(15,2);
    DECLARE promedioGanacias DECIMAL(15,2);
    
    #SET totalVentas = SELECT SUM(cantidad)
END
$$

#--------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS productosMasVendidos;
DELIMITER $$
CREATE PROCEDURE productosMasVendidos( idSucursalV INT, fechaInicial DATE, fechaFinal DATE)
BEGIN

	SELECT Producto.nombreProducto, SUM(Detalle.cantidad) total  FROM Detalle
    INNER JOIN Producto ON Producto.idProducto = Detalle.idProducto
    INNER JOIN Pedido ON Pedido.idPedido = Detalle.idPedido
    INNER JOIN Cliente ON Cliente.idCliente = Pedido.idCliente
    INNER JOIN SucursalXCliente ON SucursalXCliente.idCliente = Cliente.idCliente
    WHERE SucursalXCliente.idSucursal = IFNULL(idSucursalV, SucursalXCliente.idSucursal)
    AND Pedido.fecha <= IFNULL(fechaFinal,Pedido.fecha) AND
	Pedido.fecha >= IFNULL(fechaInicial,Pedido.fecha)
	GROUP BY Producto.idProducto
	ORDER BY (total) DESC
    LIMIT 3;
END
$$


/*------------------------------------------------------------------
N -  Consultar montos recolectados por envíos, fechas, sucursal y/o cliente 
ENTRADAS: 
SALIDAS: 
------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS montoEnvios;
DELIMITER $$
CREATE PROCEDURE montoEnvios(idTipoEnvioV INT, fechI DATE, fechF DATE, idSucursalV INT, idClienteV INT)
BEGIN

	SELECT SUM((detalle.cantidad*detalle.costo)*tipoEnvio.porcentajeAdicional) FROM Sucursal 
		INNER JOIN SucursalXCliente ON Sucursal.idsucursal = SucursalXCliente.idCliente
		INNER JOIN Pedido ON SucursalXCliente.idCliente = pedido.idCliente
        INNER JOIN Detalle ON Pedido.idpedido = detalle.idPedido
        INNER JOIN TipoEnvio on Pedido.idTipoEnvio = TipoEnvio.idTipoEnvio
        WHERE tipoEnvio.idTipoEnvio = IFNULL(idTipoEnvioV, tipoEnvio.idTipoEnvio)
        AND sucursal.idSucursal = IFNULL(idSucursalV, sucursal.idSucursal)
        AND SucursalXCliente.idCliente = IFNULL(idClienteV, SucursalXCliente.idCliente)
        AND pedido.fecha >= IFNULL(fechI, pedido.fecha)
        AND pedido.fecha <= IFNULL(fechF, pedido.fecha)
        group by tipoEnvio.idTipoEnvio;

END
$$


