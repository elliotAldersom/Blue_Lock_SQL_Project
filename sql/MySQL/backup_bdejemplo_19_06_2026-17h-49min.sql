-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: bdejemplo
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `departamento`
--

DROP TABLE IF EXISTS `departamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departamento` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `edificio` varchar(50) NOT NULL,
  `piso` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departamento`
--

LOCK TABLES `departamento` WRITE;
/*!40000 ALTER TABLE `departamento` DISABLE KEYS */;
INSERT INTO `departamento` VALUES (1,'Recursos Humanos','Edificio Central',3),(2,'Contabilidad','Edificio Central',2),(3,'Finanzas','Torre Norte',5),(4,'Marketing','Edificio A',4),(5,'Ventas','Edificio A',6),(6,'Sistemas','Torre Tecnológica',8),(7,'Soporte Técnico','Torre Tecnológica',2),(8,'Logística','Almacén Central',1),(9,'Compras','Edificio B',3),(10,'Dirección General','Torre Ejecutiva',10);
/*!40000 ALTER TABLE `departamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empleados`
--

DROP TABLE IF EXISTS `empleados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleados` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  `edad` int NOT NULL,
  `estado` tinyint(1) DEFAULT '1',
  `email` varchar(100) NOT NULL,
  `num_telefono` varchar(11) NOT NULL,
  `cargo` varchar(30) NOT NULL DEFAULT 'Obrero',
  `id_departamento` int NOT NULL,
  `dni` varchar(15) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `num_telefono` (`num_telefono`),
  UNIQUE KEY `dni` (`dni`),
  KEY `id_departamento` (`id_departamento`),
  CONSTRAINT `empleados_ibfk_1` FOREIGN KEY (`id_departamento`) REFERENCES `departamento` (`id`),
  CONSTRAINT `empleados_chk_1` CHECK ((`edad` >= 18))
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empleados`
--

LOCK TABLES `empleados` WRITE;
/*!40000 ALTER TABLE `empleados` DISABLE KEYS */;
INSERT INTO `empleados` VALUES (1,'Carlos Rojas',29,1,'crojas2@empresa.com','987650001','Analista',1,'74251896'),(2,'María López',34,1,'mlopez2@empresa.com','987650002','Asistente',2,'71548963'),(3,'José Ramírez',41,0,'jramirez2@empresa.com','987650003','Contador',2,'70123654'),(4,'Ana Torres',26,1,'atorres2@empresa.com','987650004','RRHH',1,'74589632'),(5,'Luis García',38,1,'lgarcia2@empresa.com','987650005','Finanzas',3,'70984512'),(6,'Pedro Sánchez',45,1,'psanchez2@empresa.com','987650006','Gerente',10,'69874512'),(7,'Lucía Fernández',30,0,'lfernandez2@empresa.com','987650007','Marketing',4,'71236589'),(8,'Miguel Díaz',27,1,'mdiaz2@empresa.com','987650008','Vendedor',5,'73451289'),(9,'Elena Vargas',32,1,'evargas2@empresa.com','987650009','Vendedora',5,'72145698'),(10,'Jorge Castillo',36,0,'jcastillo2@empresa.com','987650010','Supervisor',5,'70891234'),(11,'Sofía Morales',25,1,'smorales2@empresa.com','987650011','Soporte Técnico',7,'74561239'),(12,'Raúl Peña',40,1,'rpena2@empresa.com','987650012','Administrador Sistemas',6,'70123458'),(13,'Daniela Cruz',28,0,'dcruz2@empresa.com','987650013','Logística',8,'73214589'),(14,'Fernando Ortiz',31,1,'fortiz2@empresa.com','987650014','Compras',9,'71984563'),(15,'Andrea Salazar',29,1,'asalazar2@empresa.com','987650015','Logística',8,'74512368'),(16,'Kevin Reyes',24,1,'kreyes2@empresa.com','987650016','Soporte',7,'73498512'),(17,'Valeria Jiménez',33,0,'vjimenez2@empresa.com','987650017','Marketing',4,'71239845'),(18,'Ricardo Medina',37,1,'rmedina2@empresa.com','987650018','Analista',3,'70127845'),(19,'Paola Núñez',26,1,'pnunez2@empresa.com','987650019','RRHH',1,'74561287'),(20,'Héctor Flores',42,0,'hflores2@empresa.com','987650020','Jefe Área',2,'69871234'),(21,'Camila Ríos',27,1,'crios2@empresa.com','987650021','Ventas',5,'73459812'),(22,'Andrés Vargas',35,1,'avargas2@empresa.com','987650022','Supervisor',6,'70129845'),(23,'Natalia Herrera',30,0,'nherrera2@empresa.com','987650023','Marketing',4,'71234567'),(24,'Sebastián León',39,1,'sleon2@empresa.com','987650024','Finanzas',3,'70987654'),(25,'Gabriela Paredes',28,1,'gparedes2@empresa.com','987650025','RRHH',1,'74567891'),(26,'Diego Castro',31,0,'dcastro2@empresa.com','987650026','Soporte',7,'73456789'),(27,'Laura Mendoza',29,1,'lmendoza2@empresa.com','987650027','Compras',9,'71234987'),(28,'Francisco Vega',44,1,'fvega2@empresa.com','987650028','Director',10,'69874532'),(29,'Isabel Romero',26,1,'iromero2@empresa.com','987650029','Logística',8,'74561230'),(30,'Carlos Huamán',32,0,'chuaman2@empresa.com','987650030','Ventas',5,'70124567'),(31,'Brenda Soto',27,1,'bsoto2@empresa.com','987650031','Marketing',4,'73451267'),(32,'Óscar Díaz',38,1,'odiaz2@empresa.com','987650032','Finanzas',3,'70981234'),(33,'Mariana Quispe',25,0,'mquispe2@empresa.com','987650033','RRHH',1,'74561234'),(34,'José Pacheco',41,1,'jpacheco2@empresa.com','987650034','Contador',2,'70123469'),(35,'Elías Rojas',36,1,'erojas2@empresa.com','987650035','Supervisor',6,'71234589'),(36,'Karen Huerta',29,0,'khuerta2@empresa.com','987650036','Soporte',7,'73451290'),(37,'Miguel Flores',33,1,'mflores2@empresa.com','987650037','Logística',8,'70129876'),(38,'Sergio Aguilar',40,1,'saguilar2@empresa.com','987650038','Compras',9,'71239876'),(39,'Luciana Vega',27,0,'lvega2@empresa.com','987650039','Marketing',4,'74569812'),(40,'Alberto Núñez',45,1,'anunez2@empresa.com','987650040','Gerente General',10,'69871290'),(41,'Paulo Rojas',28,1,'projas2@empresa.com','987650041','Ventas',5,'73451234'),(42,'Valentina Cruz',31,0,'vcruz2@empresa.com','987650042','RRHH',1,'74561298'),(43,'Javier Peña',37,1,'jpena2@empresa.com','987650043','Finanzas',3,'70127890'),(44,'Nicolás Torres',30,1,'ntorres2@empresa.com','987650044','Soporte',7,'71234560'),(45,'Estefanía Ruiz',26,0,'eruiz2@empresa.com','987650045','Asistente',2,'73459876'),(46,'Tomás Rivas',28,1,'trivas2@empresa.com','987650046','Analista Sistemas',6,'71234599'),(47,'Diana Salinas',32,0,'dsalinas2@empresa.com','987650047','Marketing',4,'74561299'),(48,'Erick Mendoza',35,1,'emendoza2@empresa.com','987650048','Logística',8,'70123999'),(49,'Patricia León',29,1,'pleon2@empresa.com','987650049','RRHH',1,'73459999'),(50,'Bruno Cabrera',41,1,'bcabrera2@empresa.com','987650050','Finanzas',3,'70989999');
/*!40000 ALTER TABLE `empleados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  `precio` decimal(12,3) NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `descripcion` varchar(120) NOT NULL,
  `categoria` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'Laptop MSI',4750.900,600,'Laptop Gamer','TECH'),(2,'Valeton GP200X',1850.750,120,'Pedalera Multiefectos','Multiefectos'),(4,'Les Paul Standart',7150.000,590,'Guitarra Les Paul Gibson Original','Guitarra'),(5,'Alvaro N20',850.000,75,'Guitarra Española','Guitarra'),(6,'Laptop',899.990,10,'Laptop de alto rendimiento','Electrónica'),(7,'Mouse inalámbrico',25.500,50,'Mouse óptico con conexión inalámbrica','Accesorios'),(8,'Teclado mecánico',79.990,25,'Teclado mecánico retroiluminado','Accesorios'),(9,'Monitor 24\"',150.750,15,'Monitor Full HD 24 pulgadas','Electrónica'),(10,'Silla ergonómica',199.900,5,'Silla ergonómica con soporte lumbar','Mobiliario'),(11,'Impresora láser',249.990,8,'Impresora láser de alta velocidad','Oficina'),(12,'Webcam HD',45.000,30,'Webcam con resolución HD','Accesorios'),(13,'Disco SSD 512GB',120.000,12,'Disco SSD rápido','Almacenamiento'),(14,'Cámara deportiva',199.990,20,'Cámara compacta resistente al agua','Electrónica'),(15,'Parlantes Bluetooth',65.750,40,'Parlantes inalámbricos Bluetooth','Accesorios'),(16,'Router WiFi',89.990,18,'Router dual band WiFi','Oficina'),(17,'Auriculares gaming',59.990,25,'Auriculares con micrófono para gaming','Accesorios'),(18,'Tablet 10\"',299.990,12,'Tablet de 10 pulgadas con Android','Electrónica'),(19,'Lámpara LED',35.990,22,'Lámpara LED de escritorio','Mobiliario'),(20,'Ratón gamer',49.990,15,'Ratón gamer con iluminación RGB','Accesorios'),(21,'Guitarra acústica',150.000,10,'Guitarra acústica de madera','Música'),(22,'Piano digital',550.000,5,'Piano digital con múltiples sonidos','Música'),(23,'Batería electrónica',400.000,7,'Batería electrónica con pads sensibles','Música'),(24,'Violín eléctrico',300.000,8,'Violín eléctrico con amplificación','Música'),(25,'Saxofón alto',250.000,6,'Saxofón alto de latón','Música'),(26,'Trompeta',180.000,12,'Trompeta clásica de latón','Música'),(27,'Acordeón',220.000,4,'Acordeón con botones cromáticos','Música'),(28,'Flauta traversa',120.000,15,'Flauta de metal cromada','Música'),(29,'Guitarra eléctrica',250.000,9,'Guitarra eléctrica con pastillas activas','Música'),(30,'Bajo eléctrico',300.000,10,'Bajo eléctrico de 4 cuerdas','Música'),(31,'Cajón peruano',80.000,20,'Cajón de percusión tradicional','Música'),(32,'Arpa',700.000,3,'Arpa de concierto con cuerdas de nylon','Música'),(33,'Batería acústica',450.000,6,'Batería acústica completa','Música'),(34,'Teclado Casio',220.000,10,'Teclado portátil Casio con ritmos','Música'),(35,'Trombón',260.000,7,'Trombón con varas de latón','Música'),(36,'Ocarina',45.000,25,'Ocarina de cerámica decorada','Música'),(37,'Banjo',300.000,5,'Banjo de 5 cuerdas','Música'),(38,'Clarinete',190.000,12,'Clarinete de madera con llave','Música'),(39,'Tambores africanos',120.000,18,'Tambores djembe de origen africano','Música'),(40,'Ukelele',90.000,20,'Ukelele de 4 cuerdas','Música'),(41,'Armónica',35.000,30,'Armónica cromática de 10 hoyos','Música');
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  `telefono` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-19 17:49:56
