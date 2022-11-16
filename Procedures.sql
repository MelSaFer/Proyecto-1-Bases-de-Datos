USE proyectoBases;

#PROCEDURES-----------------------------------------------------------------------------------------
#DROPS
DROP PROCEDURE IF EXISTS reportesGerenteGeneral;
DROP PROCEDURE IF EXISTS consultarEmpleados;
DROP PROCEDURE IF EXISTS consultarProveedores;
DROP PROCEDURE IF EXISTS revisarProductosSucursal;
DROP PROCEDURE IF EXISTS hacerPedidoProveedor;
DROP PROCEDURE IF EXISTS crearPedido;
DROP PROCEDURE IF EXISTS agregarDetalle;
DROP PROCEDURE IF EXISTS bonoEmpleados;
DROP PROCEDURE IF EXISTS montoEnvios;
DROP PROCEDURE IF EXISTS productosMasVendidos;
DROP PROCEDURE IF EXISTS clientesFrecuentes;
DROP PROCEDURE IF EXISTS reporteExpiradosSucursal;
DROP PROCEDURE IF EXISTS gananciasNetas;
DROP PROCEDURE IF EXISTS ConsultarPreciosProductos;
DROP PROCEDURE IF EXISTS consultaProductosProveedor;
DROP PROCEDURE IF EXISTS informacionBonos;
DROP PROCEDURE IF EXISTS sacarVencidosInvProveedor;
/*------------------------------------------------------------------
1 - Procedimiento para estadísticas de ventas x país, producto y/o 
	fechas; a nivel de sucursal, todas las sucursales y/o proveedores  
ENTRADAS: id del pais, id del producto, fecha final, fecha inicial
			id de la sucursal, id del proveedor, todos opcionales
SALIDAS: Datos de las ventas por sucursal, pais, producto...
------------------------------------------------------------------*/
DELIMITER $$
CREATE PROCEDURE reportesGerenteGeneral (idPaisV INT, idProducto INT,
										fechaFinal DATE, fechaInicial DATE,
                                        idSucursalV INT, idProveedorV INT)
BEGIN
    SELECT Producto.nombreProducto AS "Producto", 
		Detalle.Costo AS "Precio individual", Detalle.cantidad,
		SUM(Detalle.Cantidad*Detalle.Costo) totalPorProducto
		FROM Detalle
		INNER JOIN Producto ON Producto.idProducto = Detalle.idProducto
		INNER JOIN Pedido ON Pedido.idPedido = Detalle.idPedido
        INNER JOIN Sucursal ON Sucursal.idSucursal = Pedido.idSucursal
        INNER JOIN Canton ON Canton.idCanton = Sucursal.idCanton
		INNER JOIN Provincia ON Provincia.idProvincia = Canton.idProvincia
		INNER JOIN Pais ON Pais.idPais = Provincia.idPais
        INNER JOIN Encargo ON Encargo.idProducto = Producto.idProducto
		WHERE Pedido.idSucursal = IFNULL(idSucursalV, Pedido.idSucursal)
		AND Detalle.idProducto = IFNULL(idProducto, Detalle.idProducto)
		AND Pedido.fecha <= IFNULL(fechaFinal,Pedido.fecha)
		AND Pedido.fecha >= IFNULL(fechaInicial, Pedido.fecha)
        AND Encargo.idProveedor = IFNULL(idProveedorV, Encargo.idProveedor)
        AND Pais.idPais = IFNULL(idPaisV, Pais.idPais)
        GROUP BY Detalle.idProducto;
END
$$

/*------------------------------------------------------------------
2 - Consultar empleado por sucursal, puesto y fecha de contratación 
Busca en la tabla empleado de acuerdo a los parametros recibidos
ENTRADAS: el id de las sucursal o el nombre de la sucursal,
		el id del puedo, el nombre del puesto y la fecha de contratacion
SALIDAS: El conjunto de empleados que comparten las caracteristicas 
		recibidas-*
------------------------------------------------------------------*/
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
SALIDAS: Conjunto de productos que comparten las caracteristicas
		recibidas
------------------------------------------------------------------*/
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

/*------------------------------------------------------------------
4 -  Procedimiento para revisar los productos que van a expirar y 
	se ponen en descuento, si está vencido se saca del mostrador
ENTRADAS: El porcentaje de descuento que se va a aplicar, en caso
			que se necesite aplicarlo
SALIDAS: NONE, Notifica que se modifica
------------------------------------------------------------------*/
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

/*------------------------------------------------------------------
5 -  Procedimiento para hacer el pedido del producto a los 
	proveedores, buscando llegar a la máxima cantidad en el
    inventario, se busca el proveedor que tengo el producto más 
    barato y con existencias 
ENTRADAS: El id de la sucursal, id del producto  
SALIDAS: None- notifica de los cambios
------------------------------------------------------------------*/
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
	#select sumProductosEnInventario;
    IF sumProductosEnInventario IS NULL THEN
		SET sumProductosEnInventario = 0;
	END IF;
	SET minInv = (SELECT DISTINCT cantidadMin FROM Producto
		WHERE idProducto = idProductoV);
	SET maxInv = (SELECT DISTINCT cantidadMax FROM Producto
		WHERE idProducto = idProductoV);
	#IF (idProducto IS NULL)]
    #SELECT sumProductosEnInventario AS Resultado;
    IF (sumProductosEnInventario <= minInv) THEN
        
        SET idProveedorSeleccionado = (SELECT DISTINCT proveedor.idProveedor FROM proveedor 
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
            IF(sumProductosEnInventario + sumadorVendidos) < maxInv AND (idProveedor_VAR = idProveedorSeleccionado)
				AND (existencias_VAR != 0) THEN
				IF (existencias_VAR >= (maxInv - (sumProductosEnInventario + sumadorVendidos))) THEN
					#SELECT precio_VAR+(precio_VAR*porcGananciaP) AS "2";
					CALL createLote(idSucursalV, idProductoV, 
                    (maxInv - (sumProductosEnInventario + sumadorVendidos)),
                    fechaProduccion_VAR, fechaExpiracion_VAR, 
                    "En mostrador", (precio_VAR+(precio_VAR*porcGananciaP)));
                                        
                    CALL updateProductoXProveedor(idProductoXProveedor_VAR, NULL, NULL,
						(existencias_VAR - (maxInv - (sumProductosEnInventario + sumadorVendidos))),
                        NULL, NULL, NULL);	
					SET sumadorVendidos = sumadorVendidos + (maxInv - sumProductosEnInventario);
					LEAVE bucle;
				ELSE
					#SELECT precio_VAR+(precio_VAR*porcGananciaP) AS "1";
					CALL createLote(idSucursalV, idProductoV, existencias_VAR,
						fechaProduccion_VAR, fechaExpiracion_VAR, 
						"En mostrador", (precio_VAR+(precio_VAR*porcGananciaP)));
					 CALL updateProductoXProveedor(idProductoXProveedor_VAR, NULL, NULL,
						0, NULL, NULL, NULL);
					SET sumadorVendidos = sumadorVendidos + existencias_VAR;
				END IF;
            END IF;
        END LOOP bucle;
        CLOSE cursorPP;
        #select idProveedorSeleccionado;
		call createEncargo (curdate(), idSucursalV, sumadorVendidos, idProductoV, idProveedorSeleccionado);
	END IF;
    
END;
$$

/*------------------------------------------------------------------
6 -  Procedimiento para que el cliente haga el pedido, puede pedir 
	entrega a domicilio y el costo de envío es un 0,1% del monto pagado. 
    Puede pagar con diferentes métodos de pago
Usa un procedure para crear el pedido y se complementa con el de agregar 
detalle
ENTRADAS: id del tipo de pago, idCliente, idEmpleado, idTipo de envio
		idSucursal
SALIDAS: Mensajes de resultado
------------------------------------------------------------------*/
DELIMITER $$
CREATE PROCEDURE crearPedido(idTipoPagoV INT, idClienteV INT, idEmpleadoV INT, idTipoEnvioV INT, idSucursalV INT)
BEGIN

	IF (idEmpleadoV IS NOT NULL AND (select cargo.descripcion from empleado 
		INNER JOIN Cargo on empleado.idCargo = cargo.idCargo
		where empleado.idEmpleado = idEmpleadoV) != "facturador") THEN
		SELECT "ERROR- El empleado no es facturador" AS Resultado;
	ELSEIF (SELECT COUNT(*) FROM sucursalxcliente 
		WHERE sucursalxcliente.idCliente = idClienteV AND
        sucursalxcliente.idSucursal = idSucursalV) = 0 THEN
        SELECT "ERROR- El cliente no se encuentra registrado en la sucursal" AS Resultado;
	ELSEIF (SELECT COUNT(*) FROM Empleado WHERE idEmpleado = idEmpleadoV AND idSucursal = idSucursalV) = 0
		THEN
        SELECT "ERROR- El empleado no trabaja en la sucursal" AS Resultado;
    ELSE 
		call createPedido(curdate(), idTipoPagoV,idClienteV, idEmpleadoV, idTipoEnvioV, idSucursalV);
    
    END IF;
END
$$
/*------------------------------------------------------------------
6.1 -  Procedimiento para agregar detalles al pedido
ENTRADAS: 
SALIDAS: 
------------------------------------------------------------------*/
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
    DECLARE porcPromocion DECIMAL(5,2);
    DECLARE contadorProducto INT DEFAULT 0;
    
    DECLARE idSucursalSeleccionado INT;
    
    DECLARE cursorLote CURSOR FOR SELECT idLote, 
    idSucursal, idProducto, cantidad, estado, precio FROM Lote;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET resultadoV = 1;
    
    SET idSucursalSeleccionado = (SELECT DISTINCT sucursal.idSucursal FROM Pedido 
    INNER JOIN Sucursal ON Pedido.idSucursal = Sucursal.idSucursal
    WHERE sucursal.idSucursal = pedido.idSucursal AND Pedido.idPedido = idPedidoV);
    
    SET porcPromocion = (SELECT promocion.porcentajeDesc FROM promocion INNER JOIN Lote
						ON promocion.idLote = lote.idLote);
	IF (porcPromocion IS NULL) THEN
		SET porcPromocion = 0.0;
	END IF;
    
    IF (idPedidoV IS NULL) THEN
		SELECT "El pedido no puede ser null" as Resultado;
	
    ELSEIF(SELECT SUM(Lote.cantidad) FROM Lote 
			INNER JOIN Sucursal ON Lote.idSucursal = sucursal.idSucursal
            INNER JOIN Pedido ON Sucursal.idSucursal = pedido.idSucursal
            INNER JOIN Producto ON Lote.idProducto = Producto.idProducto
            WHERE pedido.idPedido = idPedidoV
            AND Producto.idProducto = idProductoV) = 0 THEN
            SELECT "No hay existencias del producto solicitado" as Resultado;
	ELSEIF(SELECT SUM(Lote.cantidad) FROM Lote 
			INNER JOIN Sucursal ON Lote.idSucursal = sucursal.idSucursal
            INNER JOIN Pedido ON Sucursal.idSucursal = pedido.idSucursal
            INNER JOIN Producto ON Lote.idProducto = Producto.idProducto
            WHERE pedido.idPedido = idPedidoV
            AND Producto.idProducto = idProductoV) IS NULL THEN
            SELECT "La sucursal no cuenta con el producto" as Resultado;
    ELSE 
	
		OPEN cursorLote;
		bucle: LOOP
			FETCH cursorLote INTO idLoteV, 
			idSucursalV, idProducto_VAR, cantidad_VAR, estadoV, precioV;
            
            IF resultadoV = 1 THEN
				LEAVE bucle;
			END IF;
            
            if((idProducto_VAR = idProductoV) AND estadoV != "vencido" 
            AND cantidad_VAR > 0 AND idSucursalV = idSucursalSeleccionado) THEN
				
                IF (cantidad_Var >= cantidadV) THEN
					CALL updateLote(idLoteV, null,
                    null, cantidad_Var - cantidadV, null, null, null, null);
                    
                    SET contadorProducto = contadorProducto + cantidadV;
                    call createDetalle(contadorProducto, (precioV - (precioV * (SELECT categoria.porcImpuesto FROM Lote
						INNER JOIN Producto ON Lote.idProducto = Producto.idProducto INNER JOIN Categoria ON Producto.idCategoria
                        = Categoria.idCategoria WHERE lote.idLote = IFNULL(idLoteV, lote.idlote) and producto.idProducto =
                        IFNULL(idProductoV, producto.idProducto)) ) + (precioV * porcPromocion)), idPedidoV, idProductoV);
                    LEAVE BUCLE;
                ELSE
					CALL updateLote(idLoteV, null,
                    null, 0, null, null, null, null);
                    
                    SET contadorProducto = contadorProducto + (cantidad_Var);
                    call createDetalle(cantidad_Var, (precioV - (precioV * (SELECT categoria.porcImpuesto FROM Lote
						INNER JOIN Producto ON Lote.idProducto = Producto.idProducto INNER JOIN Categoria ON Producto.idCategoria
                        = Categoria.idCategoria WHERE lote.idLote = IFNULL(idLoteV, lote.idlote) and producto.idProducto =
                        IFNULL(idProductoV, producto.idProducto)) ) + (precioV * porcPromocion)), idPedidoV, idProductoV);
				END IF;
			END IF;
		END LOOP bucle;
		CLOSE cursorLote;
        
	END IF;
END
$$
/*------------------------------------------------------------------
7 -  Consultar montos recolectados por envíos, fechas, sucursal y/o cliente 
ENTRADAS: idTipoEnvioV, fechI, fechF, idSucursalV, idClienteV 
------------------------------------------------------------------*/
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

/*------------------------------------------------------------------
8 -  Procedimiento para dar bonos a los empleados que superen 1000 ventas
ENTRADAS: NONE
------------------------------------------------------------------*/
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
        WHERE Pedido.fecha >= curdate()-7) > 1000 AND (SELECT cargo.descripcion FROM Empleado INNER JOIN
        Cargo on Empleado.idCargo = cargo.idCargo WHERE Empleado.idEmpleado = idEmpleadoV) = "facturador" THEN
        
        call createBono(100000, curdate(), idEmpleadoV);
        
        END IF;
		
	END LOOP bucle;
    CLOSE cursorEmpleado;

END
$$

/*------------------------------------------------------------------
9 -  Productos mas vendidos
ENTRADAS: la sucursal, rango de fechas
SALIDAS: Top 03 productos mas vendidos
------------------------------------------------------------------*/
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
10 -  Clientes frecuentes, top 10
ENTRADAS: id de la sucursal
SALIDAS: top 10 clientes que han hecho mas pedidos
------------------------------------------------------------------*/
DELIMITER $$
CREATE PROCEDURE clientesFrecuentes(idSucursalV INT)
BEGIN
	SELECT Cliente.nombre, Cliente.correo,COUNT(*) totalPedidos FROM Pedido
    INNER JOIN Cliente ON Pedido.idCliente = Cliente.idCliente
    WHERE Pedido.idSucursal = IFNULL(idSucursalV,Pedido.idSucursal)
    GROUP BY Cliente.idCliente
    ORDER BY totalPedidos DESC
    LIMIT 10;
END;
$$

/*------------------------------------------------------------------
11 -  Productos que han expirado en la sucursal
ENTRADAS: idSucursal
SALIDAS: Productos/lotes de producto con estado expirado
------------------------------------------------------------------*/
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
			WHERE Lote.estado = "Vencido" AND Lote.cantidad != 0
			AND Lote.idSucursal = IFNULL(idSucursal, Lote.idSucursal);
	END IF;
END
$$

/*------------------------------------------------------------------
12 -  Ganancias netas
ENTRADAS: idSucursal
SALIDAS: Productos/lotes de producto con estado expirado
------------------------------------------------------------------*/
DELIMITER $$
CREATE PROCEDURE gananciasNetas (fechI DATE, fechF DATE, idPaisV INT, idSucursalV INT, idCategoriaProductoV INT)
BEGIN
	DECLARE ganancias INT;
    DECLARE perdidas INT;
    
    SET ganancias = (
		SELECT SUM(Detalle.costo * Detalle.Cantidad) FROM Detalle 
			INNER JOIN Pedido ON Detalle.idPedido = Pedido.idPedido
            INNER JOIN Producto on Detalle.idProducto = Producto.idProducto
            INNER JOIN Sucursal ON Pedido.idSucursal = Sucursal.idSucursal
            INNER JOIN Canton ON Sucursal.idCanton = Canton.idCanton
            INNER JOIN Provincia ON Canton.idProvincia = Provincia.idProvincia
            INNER JOIN Pais ON Provincia.idpais = Pais.idPais
			WHERE Pedido.idSucursal = IFNULL(idSucursalV, Pedido.idSucursal)
            AND Producto.idCategoria = IFNULL(idCategoriaProductoV, Producto.idCategoria)
            AND Pais.idPais = IFNULL(idPaisV, Pais.idPais)
            AND Pedido.fecha >= IFNULL(fechI, Pedido.Fecha)
            AND Pedido.fecha <= IFNULL(fechF, Pedido.Fecha));
	IF ganancias IS NULL THEN
		SET ganancias = 0;
	END IF;
	select ProductoXProveedor.precio AS Resul FROM Encargo 
			INNER JOIN Producto ON Encargo.idProducto = Producto.idProducto 
            INNER JOIN Proveedor ON Encargo.idProveedor = Proveedor.idProveedor
            INNER Join ProductoXProveedor ON ProductoXProveedor.idProveedor = Encargo.idProveedor 
            AND ProductoXProveedor.idProducto = Encargo.idProducto;
    SET perdidas = (SELECT SUM(encargo.cantidad * (select ProductoXProveedor.precio FROM Encargo 
			INNER JOIN Producto ON Encargo.idProducto = Producto.idProducto 
            INNER JOIN Proveedor ON Encargo.idProveedor = Proveedor.idProveedor
            INNER Join ProductoXProveedor ON ProductoXProveedor.idProveedor = Encargo.idProveedor 
            AND ProductoXProveedor.idProducto = Encargo.idProducto))
            
            FROM Encargo INNER JOIN Sucursal ON Encargo.idSucursal = Sucursal.idSucursal
            INNER JOIN Canton ON Sucursal.idCanton = Canton.idCanton
            INNER JOIN Provincia ON Canton.idProvincia = Provincia.idProvincia
            INNER JOIN Pais ON Provincia.idpais = Pais.idPais
            
            INNER JOIN Producto ON Encargo.idProducto = Producto.idProducto
            
            WHERE Encargo.idSucursal = IFNULL(idSucursalV, Encargo.idSucursal)
            AND Producto.idCategoria = IFNULL(idCategoriaProductoV, Producto.idCategoria)
            AND Pais.idPais = IFNULL(idPaisV, Pais.idPais)
            AND Encargo.fecha >= IFNULL(fechI, Encargo.Fecha)
            AND Encargo.fecha <= IFNULL(fechF, Encargo.Fecha));
	IF Perdidas IS NULL THEN
		SET Perdidas = 0;
	END IF;
    
	Select ganancias - perdidas as GananciasNetas;

END
$$

/*------------------------------------------------------------------
13 -  Obtener información de bonos recibidos por empleado, fechas, 
	sucursal, y/o país
ENTRADAS: idSucursal, idPais, rango de fechas
------------------------------------------------------------------*/
DELIMITER $$
CREATE PROCEDURE informacionBonos (idSucursalV INT, idPaisV INT,
									FechaI DATE, FechaF DATE)
BEGIN
	SELECT Bono.idBono, Bono.fecha, Bono.monto, Empleado.Nombre
    FROM Bono
    INNER JOIN Empleado ON Empleado.idEmpleado = Bono.idEmpleado
    INNER JOIN Sucursal ON Sucursal.idSucursal = Empleado.idSucursal
    INNER JOIN Canton ON Canton.idCanton = Sucursal.idCanton
    INNER JOIN Provincia ON Provincia.idProvincia = Canton.idProvincia
    INNER JOIN Pais ON Pais.idPais = Provincia.idPais
    WHERE Sucursal.idSucursal = IFNULL(idSucursalV,Sucursal.idSucursal) AND
    Pais.idPais = IFNULL(idPaisV, Pais.idPais) AND
    Bono.Fecha >= IFNULL(FechaI, Bono.Fecha) AND 
    Bono.Fecha <= IFNULL(FechaF, Bono.Fecha);
END
$$

/*------------------------------------------------------------------
14 -  Consultar precios de producto
ENTRADAS: idPorducto a consultar
SALIDAS: Precio del producto
------------------------------------------------------------------*/
DELIMITER $$
CREATE PROCEDURE ConsultarPreciosProductos (idProductoV INT)
BEGIN
	SELECT ((Lote.Precio * Categoria.porcImpuesto) + Lote.precio) AS Precio,
    Producto.nombreProducto FROM Producto 
    INNER JOIN Lote ON Lote.idProducto = Producto.idProducto
	INNER JOIN Categoria ON Categoria.idCategoria = producto.idCategoria
    WHERE Producto.idProducto = IFNULL(idProductoV, Producto.idProducto)
    GROUP BY Producto.idProducto;
END
$$

/*------------------------------------------------------------------
15 -  Consultar productos por proveedor
ENTRADAS: idPorveedor
------------------------------------------------------------------*/
DELIMITER $$
CREATE PROCEDURE consultaProductosProveedor(idProveedorV INT)
BEGIN
	IF(SELECT COUNT(*) FROM Proveedor
		INNER JOIN ProductoXProveedor ON ProductoXProveedor.idProveedor = Proveedor.idProveedor
		INNER JOIN Producto ON Producto.idProducto = ProductoXProveedor.idProducto
		WHERE Proveedor.idProveedor = IFNULL(idProveedorV,Proveedor.idProveedor)) = 0 THEN
		SELECT "El proveedor no tiene productos" Resultado;
	ELSE
		SELECT DISTINCT Proveedor.nombre, Proveedor.telefono, Proveedor.porcGanancia,
			Producto.nombreProducto FROM Proveedor
		INNER JOIN ProductoXProveedor ON ProductoXProveedor.idProveedor = Proveedor.idProveedor
		INNER JOIN Producto ON Producto.idProducto = ProductoXProveedor.idProducto
		WHERE Proveedor.idProveedor = IFNULL(idProveedorV,Proveedor.idProveedor);
	END IF;
END
$$

/*------------------------------------------------------------------
16 -  Sacar los productos vendidos del inventario del proveedor
ENTRADAS: None
------------------------------------------------------------------*/
DELIMITER $$
CREATE PROCEDURE sacarVencidosInvProveedor()
BEGIN
	DECLARE resultadoV INTEGER DEFAULT 0;
    DECLARE idProductoXProveedorV INT;
    DECLARE idProductoV INT;
    DECLARE fechaExpiracionV DATE;
    
	DECLARE cursorPromo CURSOR FOR SELECT idProductoXProveedor, idProducto, 
		fechaExpiracion FROM productoxproveedor;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET resultadoV = 1;
    
    OPEN cursorPromo;
    bucle: LOOP
		FETCH cursorPromo INTO idProductoXProveedorV, idProductoV, 
		fechaExpiracionV;
        
		IF resultadoV = 1 THEN
			LEAVE bucle;
		END IF;
        IF(fechaExpiracionV < (SELECT CURDATE())) THEN
			CALL deleteProductoXProveedor(idProductoXProveedorV);
			SELECT "Se Vencio:(";
		END IF;
	END LOOP bucle;
    CLOSE cursorPromo;
END
$$

