-- MySQL dump 10.13  Distrib 5.1.43, for apple-darwin10.2.0 (i386)
--
-- Host: localhost    Database: friskyfactory_development
-- ------------------------------------------------------
-- Server version	5.1.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin_tags`
--

DROP TABLE IF EXISTS `admin_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taggable_type` varchar(255) NOT NULL,
  `defective` varchar(255) NOT NULL,
  `corrected` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=667 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_tags`
--

LOCK TABLES `admin_tags` WRITE;
/*!40000 ALTER TABLE `admin_tags` DISABLE KEYS */;
INSERT INTO `admin_tags` VALUES (574,'UserInfo','\\b(AL|alabama)$','Alabama'),(575,'UserInfo','\\b(AK|alaska)$','Alaska'),(576,'UserInfo','\\bAS$','American Samoa'),(577,'UserInfo','\\b(AZ|arizona|phoenix|mesa)$','Arizona'),(578,'UserInfo','\\b(AR|arkansas)$','Arkansas'),(579,'UserInfo','\\bCA(\\s+USA)?$','California'),(580,'UserInfo','\\b(CO|colorado)$','Colorado'),(581,'UserInfo','\\b(CT|connecticut)$','Connecticut'),(582,'UserInfo','\\bDE$','Delaware'),(583,'UserInfo','\\bDC$','Washington DC'),(584,'UserInfo','\\b(FL|florida|jacksonville|sunshine\\sstate)$','Florida'),(585,'UserInfo','\\b(GA|georgia)$','Georgia'),(586,'UserInfo','\\bGU$','Guam'),(587,'UserInfo','\\bHI$','Hawaii'),(588,'UserInfo','\\b(ID|idaho|boise)$','Idaho'),(589,'UserInfo','\\b(IL|illinois|chicago|belleville)$','Illinois'),(590,'UserInfo','\\b(IN|indiana|indianapolis)$','Indiana'),(591,'UserInfo','\\bIA$','Iowa'),(592,'UserInfo','\\bKS$','Kansas'),(593,'UserInfo','\\b(KY|kentucky)$','Kentucky'),(594,'UserInfo','\\b(LA|louisiana)$','Louisiana'),(595,'UserInfo','\\b(ME|maine)$','Maine'),(596,'UserInfo','\\b(MD|maryland|baltimore)$','Maryland'),(597,'UserInfo','\\bMA$','Massachusetts'),(598,'UserInfo','\\b(MI|michigan)$','Michigan'),(599,'UserInfo','\\b(MN|minnesota)$','Minnesota'),(600,'UserInfo','\\b(MS|mississippi)$','Mississippi'),(601,'UserInfo','\\bMO$','Missouri'),(602,'UserInfo','\\b(MT|montana|great\\sfalls)$','Montana'),(603,'UserInfo','\\b(NE|nebraska|omaha)$','Nebraska'),(604,'UserInfo','\\bNV$','Nevada'),(605,'UserInfo','\\bNH$','New Hampshire'),(606,'UserInfo','\\b(NJ|new\\sjersey|jersey\\scity|clementon)$','New Jersey'),(607,'UserInfo','\\bNM$','New Mexico'),(608,'UserInfo','\\b(NY|new(\\s?)york|nyc)$','New York'),(609,'UserInfo','\\bNC|(north\\scarolina|charlotte)$','North Carolina'),(610,'UserInfo','\\bND$','North Dakota'),(611,'UserInfo','\\b(OH|ohio|cincinatti|cincinnati)$','Ohio'),(612,'UserInfo','\\b(OK|oklahoma)$','Oklahoma'),(613,'UserInfo','\\b(OR|oregon)$','Oregon'),(614,'UserInfo','\\b(PA|pennsylvania)$','Pennsylvania'),(615,'UserInfo','\\b(PR|puerto\\srico)$','Puerto Rico'),(616,'UserInfo','\\bRI$','Rhode Island'),(617,'UserInfo','\\bSC$','South Carolina'),(618,'UserInfo','\\bSD$','South Dakota'),(619,'UserInfo','\\b(TN|tennessee)$','Tennessee'),(620,'UserInfo','\\b(TX|texas)$','Texas'),(621,'UserInfo','\\b(UT|utah)$','Utah'),(622,'UserInfo','\\bVT$','Vermont'),(623,'UserInfo','\\bVI$','Virgin Islands'),(624,'UserInfo','\\b(VA|virginia)$','Virginia'),(625,'UserInfo','\\b(WA|washington|seattle)$','Washington'),(626,'UserInfo','\\bWV$','West Virginia'),(627,'UserInfo','\\b(WI|wisconsin)$','Wisconsin'),(628,'UserInfo','\\b(WY|wyoming)$','Wyoming'),(630,'UserInfo','^york$','United Kingdom'),(631,'UserInfo','\\b(south\\safrica|cape\\stown)\\b','South Africa'),(632,'UserInfo','\\bcalifornia\\b','California'),(633,'UserInfo','\\b(sydney|melbourne|brisbane|gold\\scoast)\\b','Australia'),(634,'UserInfo','^usa$','USA'),(635,'UserInfo','^honolulu$','Hawaii'),(636,'UserInfo','\\bbay\\sarea\\b','California'),(637,'UserInfo','\\b(canada|toronto|calgary)\\b','Canada'),(638,'UserInfo','\\b(U\\.?K\\.?|united\\skingdom)\\b','United Kingdom'),(639,'UserInfo','\\boregon\\b','Oregon'),(640,'UserInfo','\\bchicago(land)?\\b','Illinois'),(642,'UserInfo','\\bNC\\b','North Carolina'),(643,'UserInfo','\\b(santa\\smonica|san\\sfrancisco)\\b','California'),(644,'UserInfo','\\bSpain$','Spain'),(645,'UserInfo','\\bSpain$','Spain'),(646,'UserInfo','\\bst\\slouis\\.+mo\\b','St Louis'),(647,'UserInfo','\\binternational\\b',NULL),(648,'UserInfo','^indonesia$','Indonesia'),(649,'UserInfo','\\bbaltimore\\scity\\b','Maryland'),(650,'UserInfo','\\bbelgium$','Belgium'),(651,'UserInfo','\\bengland$','United Kingdom'),(652,'UserInfo','\\bmontana\\b','Montana'),(653,'UserInfo','\\bmexico$','Mexico'),(654,'UserInfo','\\b(glasgow|southampton|preston|midlands)\\b','United Kingdom'),(655,'UserInfo','\\blondon\\s+ontario\\b','Canada'),(656,'UserInfo','\\b(san\\sdiego|los\\sangeles)\\b','California'),(657,'UserInfo','\\bBC$','Canada'),(658,'UserInfo','\\b(essex|hertfordshire|lancaster|london)\\b','United Kingdom'),(659,'UserInfo','\\btampa\\s+fl\\b','Florida'),(660,'UserInfo','^SA$','South Africa'),(661,'UserInfo','\\bvienna\\b','Austria'),(662,'UserInfo','\\bkent$','United Kingdom'),(663,'UserInfo','\\bwales$','United Kingdom'),(664,'UserInfo','\\b(québec|quebec)\\b','Canada'),(665,'UserInfo','\\b(r)?deception bay\\b','Australia'),(666,'UserInfo','\\bst\\slouis\\s+mo\\b','Missouri');
/*!40000 ALTER TABLE `admin_tags` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-02-05  7:57:29
