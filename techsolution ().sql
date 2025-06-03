-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 03-06-2025 a las 04:23:29
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `techsolution`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `buscar_reparaciones` (IN `termino` VARCHAR(100))   BEGIN
    SELECT * FROM vista_reparaciones_completa 
    WHERE cliente_nombre LIKE CONCAT('%', termino, '%')
       OR dispositivo LIKE CONCAT('%', termino, '%')
       OR marca LIKE CONCAT('%', termino, '%')
       OR modelo LIKE CONCAT('%', termino, '%')
    ORDER BY fecha_registro DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_estadisticas_dashboard` ()   BEGIN
    SELECT 
        (SELECT COUNT(*) FROM reparaciones) as total_reparaciones,
        (SELECT COUNT(*) FROM reparaciones WHERE estado = 'Pendiente') as pendientes,
        (SELECT COUNT(*) FROM reparaciones WHERE estado = 'En proceso') as en_proceso,
        (SELECT COUNT(*) FROM reparaciones WHERE estado = 'Completado') as completadas,
        (SELECT COUNT(*) FROM clientes WHERE activo = TRUE) as total_clientes,
        (SELECT COUNT(*) FROM productos WHERE stock <= stock_minimo) as productos_stock_bajo;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `dni` varchar(20) DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `nombre`, `telefono`, `email`, `direccion`, `dni`, `fecha_registro`, `activo`) VALUES
(1, 'Carlos Rodríguez', '123456789', 'carlos@email.com', 'Av. Principal 123', '12345678', '2025-05-26 16:52:30', 1),
(2, 'Ana López', '987654321', 'ana@email.com', 'Calle Secundaria 456', '87654321', '2025-05-26 16:52:30', 1),
(3, 'Pedro Martínez', '555666777', 'pedro@email.com', 'Plaza Central 789', '11223344', '2025-05-26 16:52:30', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion`
--

CREATE TABLE `configuracion` (
  `id` int(11) NOT NULL,
  `clave` varchar(100) NOT NULL,
  `valor` text DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `configuracion`
--

INSERT INTO `configuracion` (`id`, `clave`, `valor`, `descripcion`, `fecha_modificacion`) VALUES
(1, 'empresa_nombre', 'TechSolution', 'Nombre de la empresa', '2025-05-26 16:52:30'),
(2, 'empresa_telefono', '+1 234 567 8900', 'Teléfono principal', '2025-05-26 16:52:30'),
(3, 'empresa_email', 'info@techsolution.com', 'Email principal', '2025-05-26 16:52:30'),
(4, 'empresa_direccion', 'Av. Tecnología 123, Ciudad', 'Dirección de la empresa', '2025-05-26 16:52:30'),
(5, 'garantia_dias_default', '30', 'Días de garantía por defecto', '2025-05-26 16:52:30'),
(6, 'iva_porcentaje', '19', 'Porcentaje de IVA', '2025-05-26 16:52:30'),
(7, 'moneda', 'USD', 'Moneda utilizada', '2025-05-26 16:52:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas`
--

CREATE TABLE `facturas` (
  `id` int(11) NOT NULL,
  `numero_factura` varchar(20) NOT NULL,
  `reparacion_id` int(11) NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `fecha_emision` date NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `impuestos` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `estado` enum('Pendiente','Pagada','Vencida','Cancelada') DEFAULT 'Pendiente',
  `metodo_pago` varchar(50) DEFAULT NULL,
  `fecha_pago` timestamp NULL DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `intentos_login`
--

CREATE TABLE `intentos_login` (
  `id` int(11) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `exito` tinyint(1) DEFAULT 0,
  `user_agent` text DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `intentos_login`
--

INSERT INTO `intentos_login` (`id`, `ip`, `username`, `exito`, `user_agent`, `fecha`) VALUES
(1, '::1', 'admin', 1, NULL, '2025-05-30 18:33:20'),
(2, '::1', 'admin', 1, NULL, '2025-05-30 18:33:46'),
(3, '::1', 'admin', 0, NULL, '2025-05-31 03:26:21'),
(4, '::1', 'admin', 1, NULL, '2025-05-31 03:26:27'),
(5, '::1', 'admin', 1, NULL, '2025-05-31 03:56:03'),
(6, '::1', 'admin', 1, NULL, '2025-05-31 04:09:57'),
(7, '::1', 'admin', 1, NULL, '2025-06-02 19:16:29'),
(8, '::1', 'admin', 1, NULL, '2025-06-02 19:55:03'),
(9, '::1', 'admin', 0, NULL, '2025-06-02 22:01:14'),
(10, '::1', 'admin', 1, NULL, '2025-06-02 22:01:21'),
(11, '::1', 'admin', 1, NULL, '2025-06-02 22:31:29'),
(12, '::1', 'admin', 1, NULL, '2025-06-03 01:34:48');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ip_bloqueadas`
--

CREATE TABLE `ip_bloqueadas` (
  `id` int(11) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `razon` varchar(255) DEFAULT 'Múltiples intentos fallidos',
  `fecha_bloqueo` timestamp NOT NULL DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` int(11) NOT NULL,
  `codigo` varchar(50) DEFAULT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio_compra` decimal(10,2) DEFAULT 0.00,
  `precio_venta` decimal(10,2) DEFAULT 0.00,
  `stock` int(11) DEFAULT 0,
  `stock_minimo` int(11) DEFAULT 5,
  `categoria` varchar(50) DEFAULT NULL,
  `proveedor` varchar(100) DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `codigo`, `nombre`, `descripcion`, `precio_compra`, `precio_venta`, `stock`, `stock_minimo`, `categoria`, `proveedor`, `fecha_registro`, `activo`) VALUES
(1, 'SCR001', 'Pantalla iPhone 12', 'Pantalla LCD para iPhone 12', 80.00, 150.00, 10, 5, 'Pantallas', NULL, '2025-05-26 16:52:30', 1),
(2, 'BAT001', 'Batería Samsung S21', 'Batería original Samsung Galaxy S21', 25.00, 45.00, 15, 5, 'Baterías', NULL, '2025-05-26 16:52:30', 1),
(3, 'CAB001', 'Cable USB-C', 'Cable de carga USB-C 1.5m', 5.00, 12.00, 50, 5, 'Cables', NULL, '2025-05-26 16:52:30', 1),
(4, 'CHA001', 'Cargador Universal', 'Cargador universal 2.4A', 8.00, 18.00, 20, 5, 'Cargadores', NULL, '2025-05-26 16:52:30', 1),
(5, 'CAM001', 'Cámara Posterior Xiaomi', 'Cámara posterior Xiaomi Mi 11', 35.00, 65.00, 8, 5, 'Cámaras', NULL, '2025-05-26 16:52:30', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reparaciones`
--

CREATE TABLE `reparaciones` (
  `id` int(11) NOT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `cliente` varchar(100) DEFAULT NULL,
  `dispositivo` varchar(100) NOT NULL,
  `marca` varchar(50) DEFAULT NULL,
  `modelo` varchar(50) DEFAULT NULL,
  `numero_serie` varchar(100) DEFAULT NULL,
  `problema` text NOT NULL,
  `diagnostico` text DEFAULT NULL,
  `solucion` text DEFAULT NULL,
  `estado` enum('Pendiente','En proceso','Esperando repuesto','Completado','Entregado','Cancelado') DEFAULT 'Pendiente',
  `prioridad` enum('Baja','Media','Alta','Urgente') DEFAULT 'Media',
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_inicio` timestamp NULL DEFAULT NULL,
  `fecha_finalizacion` timestamp NULL DEFAULT NULL,
  `fecha_entrega` timestamp NULL DEFAULT NULL,
  `tecnico_asignado` int(11) DEFAULT NULL,
  `costo_mano_obra` decimal(10,2) DEFAULT 0.00,
  `costo_total` decimal(10,2) DEFAULT 0.00,
  `observaciones` text DEFAULT NULL,
  `garantia_dias` int(11) DEFAULT 30
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `reparaciones`
--

INSERT INTO `reparaciones` (`id`, `cliente_id`, `cliente`, `dispositivo`, `marca`, `modelo`, `numero_serie`, `problema`, `diagnostico`, `solucion`, `estado`, `prioridad`, `fecha_registro`, `fecha_inicio`, `fecha_finalizacion`, `fecha_entrega`, `tecnico_asignado`, `costo_mano_obra`, `costo_total`, `observaciones`, `garantia_dias`) VALUES
(1, 1, 'Carlos Rodríguez', 'iPhone 12', 'Apple', 'iPhone 12', NULL, 'Pantalla rota', NULL, NULL, 'En proceso', 'Alta', '2025-05-26 16:52:30', NULL, NULL, NULL, 2, 0.00, 0.00, NULL, 30),
(2, 2, 'Ana López', 'Samsung Galaxy S21', 'Samsung', 'Galaxy S21', NULL, 'No carga la batería', NULL, NULL, 'Pendiente', 'Media', '2025-05-26 16:52:30', NULL, NULL, NULL, NULL, 0.00, 0.00, NULL, 30),
(3, 3, 'Pedro Martínez', 'Xiaomi Mi 11', 'Xiaomi', 'Mi 11', NULL, 'Cámara no funciona', NULL, NULL, 'Completado', 'Baja', '2025-05-26 16:52:30', NULL, NULL, NULL, 2, 0.00, 0.00, NULL, 30);

--
-- Disparadores `reparaciones`
--
DELIMITER $$
CREATE TRIGGER `historial_estado_reparacion` AFTER UPDATE ON `reparaciones` FOR EACH ROW BEGIN
    IF OLD.estado != NEW.estado THEN
        INSERT INTO reparacion_historial (reparacion_id, estado_anterior, estado_nuevo, fecha_cambio)
        VALUES (NEW.id, OLD.estado, NEW.estado, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reparacion_historial`
--

CREATE TABLE `reparacion_historial` (
  `id` int(11) NOT NULL,
  `reparacion_id` int(11) NOT NULL,
  `estado_anterior` varchar(50) DEFAULT NULL,
  `estado_nuevo` varchar(50) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `comentario` text DEFAULT NULL,
  `fecha_cambio` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reparacion_productos`
--

CREATE TABLE `reparacion_productos` (
  `id` int(11) NOT NULL,
  `reparacion_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `precio_unitario` decimal(10,2) DEFAULT 0.00,
  `subtotal` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `reparacion_productos`
--
DELIMITER $$
CREATE TRIGGER `actualizar_stock_reparacion` AFTER INSERT ON `reparacion_productos` FOR EACH ROW BEGIN
    UPDATE productos 
    SET stock = stock - NEW.cantidad 
    WHERE id = NEW.producto_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `calcular_total_reparacion` AFTER INSERT ON `reparacion_productos` FOR EACH ROW BEGIN
    UPDATE reparaciones 
    SET costo_total = (
        SELECT COALESCE(SUM(rp.cantidad * rp.precio_unitario), 0) + costo_mano_obra
        FROM reparacion_productos rp 
        WHERE rp.reparacion_id = NEW.reparacion_id
    )
    WHERE id = NEW.reparacion_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `rol` enum('admin','tecnico','operador') DEFAULT 'operador',
  `activo` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `ultimo_acceso` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `username`, `password`, `nombre`, `email`, `rol`, `activo`, `fecha_creacion`, `ultimo_acceso`) VALUES
(1, 'admin', '0192023a7bbd73250516f069df18b500', 'Administrador', 'admin@techsolution.com', 'admin', 1, '2025-05-26 16:52:30', NULL),
(2, 'tecnico1', '48b6471d9da08de8dc27a4a54d1fcaf3', 'Juan Pérez', 'juan@techsolution.com', 'tecnico', 1, '2025-05-26 16:52:30', NULL),
(3, 'operador1', '07d430ce23ec43ba6a631dde9b17fc2d', 'María García', 'maria@techsolution.com', 'operador', 1, '2025-05-26 16:52:30', NULL);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_productos_stock_bajo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_productos_stock_bajo` (
`id` int(11)
,`codigo` varchar(50)
,`nombre` varchar(100)
,`stock` int(11)
,`stock_minimo` int(11)
,`categoria` varchar(50)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_reparaciones_completa`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_reparaciones_completa` (
`id` int(11)
,`dispositivo` varchar(100)
,`marca` varchar(50)
,`modelo` varchar(50)
,`problema` text
,`estado` enum('Pendiente','En proceso','Esperando repuesto','Completado','Entregado','Cancelado')
,`prioridad` enum('Baja','Media','Alta','Urgente')
,`fecha_registro` timestamp
,`fecha_finalizacion` timestamp
,`costo_total` decimal(10,2)
,`cliente_nombre` varchar(100)
,`cliente_telefono` varchar(20)
,`tecnico_nombre` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_productos_stock_bajo`
--
DROP TABLE IF EXISTS `vista_productos_stock_bajo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_productos_stock_bajo`  AS SELECT `productos`.`id` AS `id`, `productos`.`codigo` AS `codigo`, `productos`.`nombre` AS `nombre`, `productos`.`stock` AS `stock`, `productos`.`stock_minimo` AS `stock_minimo`, `productos`.`categoria` AS `categoria` FROM `productos` WHERE `productos`.`stock` <= `productos`.`stock_minimo` AND `productos`.`activo` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_reparaciones_completa`
--
DROP TABLE IF EXISTS `vista_reparaciones_completa`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_reparaciones_completa`  AS SELECT `r`.`id` AS `id`, `r`.`dispositivo` AS `dispositivo`, `r`.`marca` AS `marca`, `r`.`modelo` AS `modelo`, `r`.`problema` AS `problema`, `r`.`estado` AS `estado`, `r`.`prioridad` AS `prioridad`, `r`.`fecha_registro` AS `fecha_registro`, `r`.`fecha_finalizacion` AS `fecha_finalizacion`, `r`.`costo_total` AS `costo_total`, coalesce(`c`.`nombre`,`r`.`cliente`) AS `cliente_nombre`, `c`.`telefono` AS `cliente_telefono`, `u`.`nombre` AS `tecnico_nombre` FROM ((`reparaciones` `r` left join `clientes` `c` on(`r`.`cliente_id` = `c`.`id`)) left join `usuarios` `u` on(`r`.`tecnico_asignado` = `u`.`id`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `clave` (`clave`);

--
-- Indices de la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_factura` (`numero_factura`),
  ADD KEY `reparacion_id` (`reparacion_id`),
  ADD KEY `cliente_id` (`cliente_id`);

--
-- Indices de la tabla `intentos_login`
--
ALTER TABLE `intentos_login`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_intentos_login_ip` (`ip`,`fecha`);

--
-- Indices de la tabla `ip_bloqueadas`
--
ALTER TABLE `ip_bloqueadas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ip` (`ip`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `idx_productos_stock` (`stock`);

--
-- Indices de la tabla `reparaciones`
--
ALTER TABLE `reparaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tecnico_asignado` (`tecnico_asignado`),
  ADD KEY `idx_reparaciones_estado` (`estado`),
  ADD KEY `idx_reparaciones_fecha` (`fecha_registro`),
  ADD KEY `idx_reparaciones_cliente` (`cliente_id`);

--
-- Indices de la tabla `reparacion_historial`
--
ALTER TABLE `reparacion_historial`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reparacion_id` (`reparacion_id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `reparacion_productos`
--
ALTER TABLE `reparacion_productos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reparacion_id` (`reparacion_id`),
  ADD KEY `producto_id` (`producto_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `facturas`
--
ALTER TABLE `facturas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `intentos_login`
--
ALTER TABLE `intentos_login`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `ip_bloqueadas`
--
ALTER TABLE `ip_bloqueadas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `reparaciones`
--
ALTER TABLE `reparaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `reparacion_historial`
--
ALTER TABLE `reparacion_historial`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reparacion_productos`
--
ALTER TABLE `reparacion_productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`reparacion_id`) REFERENCES `reparaciones` (`id`),
  ADD CONSTRAINT `facturas_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`);

--
-- Filtros para la tabla `reparaciones`
--
ALTER TABLE `reparaciones`
  ADD CONSTRAINT `reparaciones_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `reparaciones_ibfk_2` FOREIGN KEY (`tecnico_asignado`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `reparacion_historial`
--
ALTER TABLE `reparacion_historial`
  ADD CONSTRAINT `reparacion_historial_ibfk_1` FOREIGN KEY (`reparacion_id`) REFERENCES `reparaciones` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reparacion_historial_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `reparacion_productos`
--
ALTER TABLE `reparacion_productos`
  ADD CONSTRAINT `reparacion_productos_ibfk_1` FOREIGN KEY (`reparacion_id`) REFERENCES `reparaciones` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reparacion_productos_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
