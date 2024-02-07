-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-02-2024 a las 04:29:04
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `libros`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_DeleteLibro` (`_LibroId` INT)   BEGIN
 UPDATE tbl_ope_libro SET Libro_Activo=0 WHERE LibroId=_LibroId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_InsertLibro` (`_Libro_Libro` VARCHAR(50), `_Genero_Genero` VARCHAR(50), `_Idioma_Idioma` VARCHAR(50), `_Editorial_Editorial` VARCHAR(50), `_Ventas_Cantidad` INT, `_Ventas_Costo` INT)   BEGIN
declare _Libro_Libro int;
declare _Libro_Genero int;
declare _Libro_Editorial int;
declare _Libro_Idioma int;

INSERT INTO tbl_cat_genero VALUES (null,_Genero_Genero,1);
set _Libro_Genero=(SELECT MAX(GeneroId) FROM tbl_cat_genero);

INSERT INTO tbl_cat_editorial VALUES (null,_Editorial_Editorial,1);
set _Libro_Editorial=(SELECT MAX(EditorialId) FROM tbl_cat_editorial);

INSERT INTO tbl_cat_idioma VALUES (null,_Idioma_Idioma,1);
set _Libro_Idioma=(SELECT MAX(IdiomaId) FROM tbl_cat_idioma);

INSERT INTO tbl_ope_libro VALUES (null,_Libro_Libro,_Libro_Genero,_Libro_Editorial,_Libro_Idioma,1);
set _Libro_Libro=(SELECT MAX(LibroId) FROM tbl_ope_libro);

INSERT INTO tbl_hist_ventas VALUES (null,_Ventas_Cantidad,_Ventas_Costo,_Libro_Libro);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Mostrar` ()   BEGIN
 select
	LibroId as Id,
    Libro_Libro as Nombre,
	ed.Editorial_Editorial as Editorial,
    gen.Genero_Genero as Genero,
    ven.Ventas_Cantidad as Cantidad,
    ven.Ventas_Costo as Costo
    
 from tbl_ope_libro lib
 inner join tbl_cat_editorial ed on ed.EditorialId = lib.Libro_EditorialId
 inner join tbl_cat_genero gen on gen.GeneroId = lib.Libro_GeneroId
 inner join tbl_hist_ventas ven on lib.LibroId = ven.VentasId
 where lib.Libro_Activo=1
 ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_UpdateLibro` (`_LibroId` INT, `_Libro_Libro` VARCHAR(50), `_Libro_Genero` INT, `_Libro_Editorial` INT, `_Libro_Idioma` INT)   BEGIN
 UPDATE tbl_ope_libro SET Libro_Libro=_Libro_Libro ,Libro_GeneroId=_Libro_Genero,
 Libro_EditorialId=_Libro_Editorial ,Libro_IdiomaId=_Libro_Idioma
 WHERE LibroId=_LibroId;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_cat_editorial`
--

CREATE TABLE `tbl_cat_editorial` (
  `EditorialId` int(11) NOT NULL,
  `Editorial_Editorial` varchar(45) DEFAULT NULL,
  `Editorial_Activo` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `tbl_cat_editorial`
--

INSERT INTO `tbl_cat_editorial` (`EditorialId`, `Editorial_Editorial`, `Editorial_Activo`) VALUES
(1, 'La tremenda corte', '1'),
(2, 'editorial1', '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_cat_genero`
--

CREATE TABLE `tbl_cat_genero` (
  `GeneroId` int(11) NOT NULL,
  `Genero_Genero` varchar(45) DEFAULT NULL,
  `Genero_Activo` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `tbl_cat_genero`
--

INSERT INTO `tbl_cat_genero` (`GeneroId`, `Genero_Genero`, `Genero_Activo`) VALUES
(1, 'Informe', '1'),
(2, 'genero1', '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_cat_idioma`
--

CREATE TABLE `tbl_cat_idioma` (
  `IdiomaId` int(11) NOT NULL,
  `Idioma_Idioma` varchar(45) DEFAULT NULL,
  `Idioma_Activo` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `tbl_cat_idioma`
--

INSERT INTO `tbl_cat_idioma` (`IdiomaId`, `Idioma_Idioma`, `Idioma_Activo`) VALUES
(1, 'Español', '1'),
(2, 'Ingles', '1'),
(3, 'idioma1', '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_hist_ventas`
--

CREATE TABLE `tbl_hist_ventas` (
  `VentasId` int(11) NOT NULL,
  `Ventas_Cantidad` int(11) DEFAULT NULL,
  `Ventas_Costo` float DEFAULT NULL,
  `Ventas_LibroId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `tbl_hist_ventas`
--

INSERT INTO `tbl_hist_ventas` (`VentasId`, `Ventas_Cantidad`, `Ventas_Costo`, `Ventas_LibroId`) VALUES
(1, 23, 190, 1),
(2, 89, 280, 1),
(3, 18, 28, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_ope_libro`
--

CREATE TABLE `tbl_ope_libro` (
  `LibroId` int(11) NOT NULL,
  `Libro_Libro` varchar(45) DEFAULT NULL,
  `Libro_GeneroId` int(11) DEFAULT NULL,
  `Libro_EditorialId` int(11) DEFAULT NULL,
  `Libro_IdiomaId` int(11) DEFAULT NULL,
  `Libro_Activo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `tbl_ope_libro`
--

INSERT INTO `tbl_ope_libro` (`LibroId`, `Libro_Libro`, `Libro_GeneroId`, `Libro_EditorialId`, `Libro_IdiomaId`, `Libro_Activo`) VALUES
(1, 'La vida', 1, 1, 1, 1),
(2, 'la granja', 1, 1, 1, 1),
(3, NULL, 2, 2, 3, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `tbl_cat_editorial`
--
ALTER TABLE `tbl_cat_editorial`
  ADD PRIMARY KEY (`EditorialId`);

--
-- Indices de la tabla `tbl_cat_genero`
--
ALTER TABLE `tbl_cat_genero`
  ADD PRIMARY KEY (`GeneroId`);

--
-- Indices de la tabla `tbl_cat_idioma`
--
ALTER TABLE `tbl_cat_idioma`
  ADD PRIMARY KEY (`IdiomaId`);

--
-- Indices de la tabla `tbl_hist_ventas`
--
ALTER TABLE `tbl_hist_ventas`
  ADD PRIMARY KEY (`VentasId`);

--
-- Indices de la tabla `tbl_ope_libro`
--
ALTER TABLE `tbl_ope_libro`
  ADD PRIMARY KEY (`LibroId`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `tbl_cat_editorial`
--
ALTER TABLE `tbl_cat_editorial`
  MODIFY `EditorialId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tbl_cat_genero`
--
ALTER TABLE `tbl_cat_genero`
  MODIFY `GeneroId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tbl_cat_idioma`
--
ALTER TABLE `tbl_cat_idioma`
  MODIFY `IdiomaId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tbl_hist_ventas`
--
ALTER TABLE `tbl_hist_ventas`
  MODIFY `VentasId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tbl_ope_libro`
--
ALTER TABLE `tbl_ope_libro`
  MODIFY `LibroId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
