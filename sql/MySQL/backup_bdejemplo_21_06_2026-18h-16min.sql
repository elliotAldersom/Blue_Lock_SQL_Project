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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departamento`
--

LOCK TABLES `departamento` WRITE;
/*!40000 ALTER TABLE `departamento` DISABLE KEYS */;
INSERT INTO `departamento` VALUES (1,'Recursos Humanos','Edificio Central',3),(2,'Contabilidad','Edificio Central',2),(3,'Finanzas','Torre Norte',5),(4,'Marketing','Edificio A',4),(5,'Ventas','Edificio A',6),(6,'Sistemas','Torre Tecnológica',8),(7,'Soporte Técnico','Torre Tecnológica',2),(8,'Logística','Almacén Central',1),(9,'Compras','Edificio B',3),(10,'Dirección General','Torre Ejecutiva',10),(11,'Comida','Edificio B',8);
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
  `dni` varchar(15) NOT NULL,
  `edad` int NOT NULL,
  `estado` tinyint(1) DEFAULT '1',
  `cargo` varchar(30) NOT NULL DEFAULT 'Obrero',
  `sueldo` decimal(12,2) NOT NULL,
  `email` varchar(100) NOT NULL,
  `num_telefono` varchar(11) NOT NULL,
  `id_departamento` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `num_telefono` (`num_telefono`),
  UNIQUE KEY `dni` (`dni`),
  UNIQUE KEY `dni_2` (`dni`),
  KEY `id_departamento` (`id_departamento`),
  CONSTRAINT `empleados_ibfk_1` FOREIGN KEY (`id_departamento`) REFERENCES `departamento` (`id`),
  CONSTRAINT `empleados_chk_1` CHECK ((`edad` >= 18))
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empleados`
--

LOCK TABLES `empleados` WRITE;
/*!40000 ALTER TABLE `empleados` DISABLE KEYS */;
INSERT INTO `empleados` VALUES (1,'Carlos Rojas','74251896',29,1,'Analista',2670.00,'crojas2@empresa.com','987650001',1),(2,'María López','71548963',34,1,'Asistente',6408.00,'mlopez2@empresa.com','987650002',2),(3,'José Ramírez','70123654',41,0,'Contador',2533.00,'jramirez2@empresa.com','987650003',2),(4,'Ana Torres','74589632',26,1,'RRHH',9939.00,'atorres2@empresa.com','987650004',1),(5,'Luis García','70984512',38,1,'Finanzas',11099.00,'lgarcia2@empresa.com','987650005',3),(6,'Pedro Sánchez','69874512',45,1,'Gerente',4179.00,'psanchez2@empresa.com','987650006',10),(7,'Lucía Fernández','71236589',30,0,'Marketing',4098.00,'lfernandez2@empresa.com','987650007',4),(8,'Miguel Díaz','73451289',27,1,'Vendedor',5454.00,'mdiaz2@empresa.com','987650008',5),(9,'Elena Vargas','72145698',32,1,'Vendedora',2974.00,'evargas2@empresa.com','987650009',5),(10,'Jorge Castillo','70891234',36,0,'Supervisor',5509.00,'jcastillo2@empresa.com','987650010',5),(11,'Sofía Morales','74561239',25,1,'Soporte Técnico',6626.00,'smorales2@empresa.com','987650011',7),(12,'Raúl Peña','70123458',40,1,'Administrador Sistemas',4602.00,'rpena2@empresa.com','987650012',6),(13,'Daniela Cruz','73214589',28,0,'Logística',10131.00,'dcruz2@empresa.com','987650013',8),(14,'Fernando Ortiz','71984563',31,1,'Compras',5851.00,'fortiz2@empresa.com','987650014',9),(15,'Andrea Salazar','74512368',29,1,'Logística',5862.00,'asalazar2@empresa.com','987650015',8),(16,'Kevin Reyes','73498512',24,1,'Soporte',9256.00,'kreyes2@empresa.com','987650016',7),(17,'Valeria Jiménez','71239845',33,0,'Marketing',7195.00,'vjimenez2@empresa.com','987650017',4),(18,'Ricardo Medina','70127845',37,1,'Analista',5706.00,'rmedina2@empresa.com','987650018',3),(19,'Paola Núñez','74561287',26,1,'RRHH',4448.00,'pnunez2@empresa.com','987650019',1),(20,'Héctor Flores','69871234',42,0,'Jefe Área',2620.00,'hflores2@empresa.com','987650020',2),(21,'Camila Ríos','73459812',27,1,'Ventas',6759.00,'crios2@empresa.com','987650021',5),(22,'Andrés Vargas','70129845',35,1,'Supervisor',4433.00,'avargas2@empresa.com','987650022',6),(23,'Natalia Herrera','71234567',30,0,'Marketing',8890.00,'nherrera2@empresa.com','987650023',4),(24,'Sebastián León','70987654',39,1,'Finanzas',9652.00,'sleon2@empresa.com','987650024',3),(25,'Gabriela Paredes','74567891',28,1,'RRHH',9589.00,'gparedes2@empresa.com','987650025',1),(26,'Diego Castro','73456789',31,0,'Soporte',6989.00,'dcastro2@empresa.com','987650026',7),(27,'Laura Mendoza','71234987',29,1,'Compras',3680.00,'lmendoza2@empresa.com','987650027',9),(28,'Francisco Vega','69874532',44,1,'Director',4433.00,'fvega2@empresa.com','987650028',10),(29,'Isabel Romero','74561230',26,1,'Logística',8624.00,'iromero2@empresa.com','987650029',8),(30,'Carlos Huamán','70124567',32,0,'Ventas',8323.00,'chuaman2@empresa.com','987650030',5),(31,'Brenda Soto','73451267',27,1,'Marketing',3745.00,'bsoto2@empresa.com','987650031',4),(32,'Óscar Díaz','70981234',38,1,'Finanzas',10253.00,'odiaz2@empresa.com','987650032',3),(33,'Mariana Quispe','74561234',25,0,'RRHH',9034.00,'mquispe2@empresa.com','987650033',1),(34,'José Pacheco','70123469',41,1,'Contador',11911.00,'jpacheco2@empresa.com','987650034',2),(35,'Elías Rojas','71234589',36,1,'Supervisor',10951.00,'erojas2@empresa.com','987650035',6),(36,'Karen Huerta','73451290',29,0,'Soporte',7025.00,'khuerta2@empresa.com','987650036',7),(37,'Miguel Flores','70129876',33,1,'Logística',9273.00,'mflores2@empresa.com','987650037',8),(38,'Sergio Aguilar','71239876',40,1,'Compras',3788.00,'saguilar2@empresa.com','987650038',9),(39,'Luciana Vega','74569812',27,0,'Marketing',7624.00,'lvega2@empresa.com','987650039',4),(40,'Alberto Núñez','69871290',45,1,'Gerente General',5256.00,'anunez2@empresa.com','987650040',10),(41,'Paulo Rojas','73451234',28,1,'Ventas',10409.00,'projas2@empresa.com','987650041',5),(42,'Valentina Cruz','74561298',31,0,'RRHH',5276.00,'vcruz2@empresa.com','987650042',1),(43,'Javier Peña','70127890',37,1,'Finanzas',11656.00,'jpena2@empresa.com','987650043',3),(44,'Nicolás Torres','71234560',30,1,'Soporte',11450.00,'ntorres2@empresa.com','987650044',7),(45,'Estefanía Ruiz','73459876',26,0,'Asistente',10284.00,'eruiz2@empresa.com','987650045',2),(46,'Tomás Rivas','71234599',28,1,'Analista Sistemas',5070.00,'trivas2@empresa.com','987650046',6),(47,'Diana Salinas','74561299',32,0,'Marketing',10998.00,'dsalinas2@empresa.com','987650047',4),(48,'Erick Mendoza','70123999',35,1,'Logística',8779.00,'emendoza2@empresa.com','987650048',8),(49,'Patricia León','73459999',29,1,'RRHH',8404.00,'pleon2@empresa.com','987650049',1),(50,'Bruno Cabrera','70989999',41,1,'Finanzas',3683.00,'bcabrera2@empresa.com','987650050',3),(51,'Mario Pineda','80000001',30,1,'Analista',9702.00,'mpineda@empresa.com','987660001',21),(52,'Rosa Chávez','80000002',27,1,'Asistente',6462.00,'rchavez@empresa.com','987660002',12),(53,'Julio Vega','80000003',35,0,'Supervisor',10203.00,'jvega@empresa.com','987660003',13),(54,'Patricia Ruiz','80000004',29,1,'Marketing',10131.00,'pruiz@empresa.com','987660004',14),(55,'César León','80000005',41,1,'Ventas',8046.00,'cleon@empresa.com','987660005',15),(56,'Verónica Soto','80000006',32,0,'Contadora',7339.00,'vsoto@empresa.com','987660006',16),(57,'Jhon Mendoza','80000007',25,1,'Soporte',10058.00,'jmendoza@empresa.com','987660007',17),(58,'Natalia Castro','80000008',38,1,'Logística',6774.00,'ncastro@empresa.com','987660008',18),(59,'Renzo Flores','80000009',33,1,'Compras',10696.00,'rflores@empresa.com','987660009',19),(60,'Silvia Torres','80000010',45,0,'Gerente',11658.00,'storres@empresa.com','987660010',20);
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

-- Dump completed on 2026-06-21 18:16:46
