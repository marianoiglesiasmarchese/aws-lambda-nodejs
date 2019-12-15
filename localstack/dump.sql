-- IF NOT EXIST lambda_user CREATE USER 'lambda_user'@'%' IDENTIFIED BY 'lambda_pass';
-- CREATE DATABASE IF NOT EXISTS lambda_db;
-- GRANT ALL PRIVILEGES ON DATABASE lambda_db TO lambda_user;

USE lambda_db;

DROP TABLE IF EXISTS `Cat_Portfolios`;

CREATE TABLE `Cat_Portfolios` (
  `PortfolioID` int(11) NOT NULL AUTO_INCREMENT,
  `PortfolioName` varchar(64) NOT NULL,
  `UploadedUserID` int(11) NOT NULL COMMENT 'Super_Under_Writer_User_ID, only super underwriter can upload the portfolio',
  `UploadedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedDate` datetime DEFAULT NULL,
  `Active` tinyint(1) NOT NULL,
  `ImportSuccess` tinyint(1) DEFAULT NULL,
  `ImportJobID` int(11) DEFAULT NULL,
  `DataQuality` int(11) DEFAULT NULL,
  `NumContracts` int(11) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `TSI` text,
  `IsTemplate` tinyint(1) DEFAULT '0',
  `PortfolioType` varchar(32) NOT NULL,
  `MatchedCompanies` text NOT NULL,
  `VersionId` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`PortfolioID`)
  -- KEY `uploaded_user_id_fk_idx` (`UploadedUserID`),
  -- KEY `VersionMap_portfolioVersiodId_fk` (`VersionId`),
  -- CONSTRAINT `VersionMap_portfolioVersiodId_fk` FOREIGN KEY (`VersionId`) REFERENCES `Versions` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  -- CONSTRAINT `uploaded_userid_fk_idx` FOREIGN KEY (`UploadedUserID`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB AUTO_INCREMENT=1442 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `Cat_PortfolioAccounts`;

CREATE TABLE `Cat_PortfolioAccounts` (
  `AccountID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `PortfolioID` int(11) NOT NULL,
  `OrganizationName` varchar(255) NOT NULL COMMENT 'Organization Name; Up to 255 characters',
  `OrganizationWebsite` varchar(255) DEFAULT NULL,
  `CountryCode` varchar(2) NOT NULL COMMENT 'Organization Geography (Country Code); From list of ISO Alpha-2 Country Codes',
  `OrganizationSize` enum('Micro','Small','Medium','Large') NOT NULL COMMENT 'Organization Size; Large / Medium / Small /Micro User can define size breakdown but recommended ranges are (based on annual revenue): * Large ($5B+) * Medium ($1B-$5B) * Small (<$1B-5M) * Micro (<$5M)',
  `UserIndustry` varchar(64) NOT NULL,
  `Industry` varchar(64) NOT NULL DEFAULT '' COMMENT 'Industry Sector or Division; Valid industry form Cat supported industry list: * Agriculture, Forestry and Fishing * Mining * Construction * Manufacturing * Transportation, * Communications, Utilities * Wholesale Trade * Retail Trade * Finance, Insurance and Real Estate * Services * Public Administration * Nonclassifiable, ...',
  `Revenue` decimal(24,6) DEFAULT NULL COMMENT 'Organization Revenue (Annual, Most Recent); If populated, must use positive whole integer',
  `EmployeeCount` int(11) DEFAULT NULL COMMENT 'Number of employees;  Valid values- If populated, must use positive whole integer',
  `RevenuePercentInternet` decimal(3,2) DEFAULT NULL COMMENT '% of revenue that comes from the Internet;  Valid values- If populated, must use whole percentage between 0% and 100% ',
  `DataBackupType` enum('Tapes','Servers') DEFAULT NULL COMMENT 'Data back up type;  Valid values- If populated, must be one of the following values: * Tapes * Servers ',
  `DataBackupFrequency` enum('Daily','Weekly','Monthly','NoBackup') DEFAULT NULL COMMENT 'Data back up frequency;  Valid values- If populated, must be one of the following values: * Daily * Weekly * Monthly * No Backup',
  `ParentType` enum('Public','Private','NonProfit') DEFAULT NULL COMMENT 'Data back up type;  Valid values- If populated, must be one of the following values: * Public * Private * Non-Profit',
  `ExposureSetID` varchar(255) DEFAULT NULL COMMENT 'Unique user-defined name for the exposure set.;  Valid values- Can contain up to 255 characters',
  `CustomID1` varchar(255) DEFAULT NULL,
  `CustomID2` varchar(255) DEFAULT NULL,
  `ContractID` varchar(255) NOT NULL DEFAULT '' COMMENT 'User-defined, unique identifier of the contract;  Valid values- Can contain up to 100 characters',
  `ContractTypeCode` enum('StandaloneCyber','EO','DO','GL','Property','KR','WC','Aviation','CC','PL','AL','PRL','CM','Fidelity','Other') DEFAULT NULL COMMENT 'Code for type of contract ;  Valid values- Must be one of the following: * Standalone Cyber * E&O * D&O * GL * Property * Kidnap & Ransom * WC * Aviation * Commercial Crime * Product Liability * Auto Liability * Professional Liability * Cargo & Marine * Fidelity * Other',
  `EnteredDate` date DEFAULT NULL COMMENT 'Date and time when the contract was created.  ;  Valid values- If populated, must use MM/DD/YYYY format',
  `EditedDate` date DEFAULT NULL COMMENT 'Date and time when the contract was last modified ;  Valid values- If populated, must use MM/DD/YYYY format',
  `CurrencyCode` varchar(3) NOT NULL COMMENT 'Currency for the contract T&Cs;  Valid values- Must be a value from list of Currency Codes',
  `InceptionDate` date NOT NULL COMMENT 'Date of the first day on which coverage is effective. You must use one of the following formats.  ;  Valid values- Must use MM/DD/YYYY format',
  `ExpirationDate` date NOT NULL COMMENT 'Date of the last day on which coverage is effective ;  Valid values- Must use MM/DD/YYYY format',
  `PolicyAttachmentPoint` decimal(24,6) DEFAULT NULL COMMENT 'The amount of original risk above which your limit attaches.;  Valid values- If populated, must be a numeric value between 0 and 999999999999999, inclusive',
  `PolicyDeductibleType` enum('Dollar','Time','Percentage') DEFAULT NULL COMMENT 'Deductible type ;  Valid values- If populated, must be one of the following deductible types: * Dollar * Time * Percentage ',
  `PolicyOccurrenceDeductible` decimal(24,6) NOT NULL COMMENT 'Deductible amount;  Valid values- Must be a numeric value between 0 and 999999999999999, inclusive',
  `PolicyOccurrenceLimit` decimal(24,6) NOT NULL COMMENT 'Occurrence limit amount;  Valid values- Must be a numeric value between 0 and 999999999999999, inclusive',
  `ParticipationPercent` decimal(24,6) NOT NULL COMMENT 'Occurrence participation;  Valid values- Whole percentage between 0% and 100% ',
  `PolicyAggregateLimit` decimal(24,6) NOT NULL COMMENT 'Aggregate limit amount;  Valid values- Must be a numeric value between 0 and 999999999999999, inclusive',
  `PolicyPremium` decimal(24,6) DEFAULT NULL COMMENT 'Policy/Endorsement Premium ;  Valid values- If populated, must be a numeric value between 0 and 999999999999999, inclusive',
  `RI_ProgramID` varchar(128) DEFAULT NULL COMMENT 'Unique system-generated sequential identifier for the reinsurance program record.;  Valid values- Can contain up to 100 characters',
  `RI_TypeCode` enum('FAC','QS','SS','XOL','SL') DEFAULT NULL COMMENT 'Code that represents the reinsurance treaty type.;  Valid values- Must be one of the following: * FAC (Facultative) * QS (Quota Share) * SS (Surplus Share) * XOL (Excess of Loss) * SL (Stop Loss)',
  `RI_InuringSequenceNumber` int(2) DEFAULT NULL COMMENT 'Insuring order for the reinsurance treaty.;  Valid values- Can include up to 2 characters',
  `RI_CedantName` varchar(255) DEFAULT NULL COMMENT 'Name of the primary insurer, which is the insurance company that purchases reinsurance.;  Valid values- Can include up to 60 characters',
  `RI_ReinsurerName` varchar(255) DEFAULT NULL COMMENT 'Name of the insurer or reinsurer who assumes the cedant’s risk under the contract (treaty).;  Valid values- Can include up to 60 characters',
  `RI_InceptionDate` date DEFAULT NULL COMMENT 'Inception date of the reinsurance treaty.  Also referred to as the Effective FROM Date.;  Valid values- Must use MM/DD/YYYY format',
  `RI_ExpirationDate` date DEFAULT NULL COMMENT 'Reinsurance treaty expiration date. Also referred to as the Effective TO Date;  Valid values- Must use MM/DD/YYYY format',
  `RI_EnteredDate` date DEFAULT NULL COMMENT 'Date and time when the reinsurance treaty was created.;  Valid values- If populated, must use MM/DD/YYYY format',
  `RI_EditedDate` date DEFAULT NULL COMMENT 'Date and time when the reinsurance treaty was last modified.;  Valid values- If populated, must use MM/DD/YYYY format',
  `RI_CurrencyCode` varchar(3) DEFAULT NULL COMMENT 'Currency for the contract T&Cs;  Valid values- Must be a value from list of Currency Codes',
  `RI_OccurrenceRetention` decimal(24,6) DEFAULT NULL COMMENT 'Deductible amount 1. The treaty does not assume losses below the specified value.;  Valid values- Must be a numeric value between 0 and 999999999999999, inclusive',
  `RI_OccurrenceLimit` decimal(24,6) DEFAULT NULL COMMENT 'Maximum loss that the treaty can occur from each occurrence.;  Valid values- Must be a numeric value between 0 and 999999999999999, inclusive',
  `RI_RiskRetention` decimal(24,6) DEFAULT NULL COMMENT 'Treaty retention per single risk, or per layer for policies including layers.;  Valid values- Must be a numeric value between 0 and 999999999999999, inclusive',
  `RI_RiskLimit` decimal(24,6) DEFAULT NULL COMMENT 'Treaty limit for a single risk or layer.;  Valid values- Must be a numeric value between 0 and 999999999999999, inclusive',
  `RI_CededPercent` decimal(24,6) DEFAULT NULL COMMENT 'Ceded percentage;  Valid values- Whole percentage between 0% and 100% ',
  `RI_CededPremium` decimal(24,6) DEFAULT NULL COMMENT 'Ceded treaty premium;  Valid values- If populated, must be a numeric value between 0 and 999999999999999, inclusive',
  `RI_NumReinstatements` int(3) DEFAULT NULL COMMENT 'The maximum number of times the risk limit can be reinstated, where 999 represents unlimited reinstatements.;  Valid values- Can include 1 character',
  `RI_ReinstProvisionalAmount` decimal(24,6) DEFAULT NULL COMMENT 'Reinstatement Premium (% of Total Premium or Pro Rata);  Valid values- If populated, must be whole percentage between 0% and 100% ',
  `CustomizedCoverage` text,
  `BusinessInterruptionLossBasis` enum('Revenue','Profit') DEFAULT NULL,
  `BusinessInterruptionProfitMargin` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`AccountID`)
  -- KEY `portfolio_fk_idx_temp` (`PortfolioID`),
  -- CONSTRAINT `portfolioid_fk_idx` FOREIGN KEY (`PortfolioID`) REFERENCES `Cat_Portfolios` (`PortfolioID`)
) ENGINE=InnoDB AUTO_INCREMENT=5091214 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `Cat_PortfolioAccountsExt`;

CREATE TABLE `Cat_PortfolioAccountsExt` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `AccountID` int(11) unsigned NOT NULL,
  `TypeID` int(11) NOT NULL COMMENT '1, 2, 3 to represent Type1, Type2, Type3',
  `DataCode` enum('PHI','PII','PCI','PCII','UNK') DEFAULT NULL COMMENT 'Code for the data type;  Valid values- If populated, must be one of the following values: * PHI * PII * PCI * PCII * UNK ',
  `DataRecordCount` int(11) DEFAULT NULL COMMENT 'Number of records;  Valid values- If populated, must use positive whole integer',
  `Description` varchar(255) DEFAULT NULL COMMENT 'Unique user-defined name for Type 1.;  Valid values- Can contain up to 255 characters',
  `DeductibleCode` enum('Dollar','Time','Percentage') DEFAULT NULL COMMENT 'Deductible type ;  Valid values- If populated, must be one of the following deductible types: * Dollar * Time * Percentage',
  `Deductible` decimal(24,6) DEFAULT NULL COMMENT 'Deductible 1 amount;  Valid values- If populated, must be a numeric value between 0 and 999999999999999, inclusive',
  `Sublimit` decimal(24,6) DEFAULT NULL COMMENT 'Limit for Breach Cost/Business Interruption;  Valid values- If populated, must be a numeric value between 0 and 999999999999999, inclusive',
  PRIMARY KEY (`ID`)
  -- KEY `accountid_fk_idx` (`AccountID`),
  -- CONSTRAINT `accountid_fk_idx` FOREIGN KEY (`AccountID`) REFERENCES `Cat_PortfolioAccounts` (`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=7332807 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sic_codes_major`;

CREATE TABLE `sic_codes_major` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `sic_2_code` varchar(2) NOT NULL,
  `description` varchar(128) NOT NULL,
  PRIMARY KEY (`ID`,`sic_2_code`)
  -- UNIQUE KEY `SICCode_UNIQUE` (`sic_2_code`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 ;

--
-- Dumping data for table `sic_codes_major`
--
LOCK TABLES `sic_codes_major` WRITE;
/*!40000 ALTER TABLE `sic_codes_major` DISABLE KEYS */;
INSERT INTO `sic_codes_major` VALUES (1,'01','Unlisted'),(2,'02','Unlisted'),(3,'07','Unlisted'),(4,'08','Unlisted'),(5,'09','Unlisted'),(6,'10','Industrials'),(7,'11','Unlisted'),(8,'12','Industrials'),(9,'13','Energy'),(10,'14','Industrials'),(11,'15','Industrials'),(12,'16','Industrials'),(13,'17','Industrials'),(14,'20','Industrials'),(15,'21','Industrials'),(16,'22','Industrials'),(17,'23','Industrials'),(18,'24','Industrials'),(19,'25','Industrials'),(20,'26','Industrials'),(21,'27','Industrials'),(22,'28','Industrials'),(23,'29','Industrials'),(24,'30','Industrials'),(25,'31','Industrials'),(26,'32','Industrials'),(27,'33','Industrials'),(28,'34','Industrials'),(29,'35','Industrials'),(30,'36','Industrials'),(31,'37','Industrials'),(32,'38','Industrials'),(33,'39','Industrials'),(34,'40','Unlisted'),(35,'41','Unlisted'),(36,'42','Unlisted'),(37,'43','Unlisted'),(38,'44','Marine'),(39,'45','Aviation'),(40,'46','Energy'),(41,'47','Unlisted'),(42,'48','Unlisted'),(43,'49','Utilities'),(44,'50','Consumer Discretionary'),(45,'51','Consumer Staples'),(46,'52','Retail'),(47,'53','Retail'),(48,'54','Retail'),(49,'55','Retail'),(50,'56','Retail'),(51,'57','Retail'),(52,'58','Retail'),(53,'59','Retail'),(54,'60','Financials'),(55,'61','Financials'),(56,'62','Financials'),(57,'63','Financials'),(58,'64','Financials'),(59,'65','Financials'),(60,'67','Financials'),(61,'70','Unlisted'),(62,'72','Unlisted'),(63,'73','Information Technology'),(64,'75','Unlisted'),(65,'76','Unlisted'),(66,'78','Unlisted'),(67,'79','Unlisted'),(68,'80','Healthcare'),(69,'81','Unlisted'),(70,'82','Unlisted'),(71,'83','Unlisted'),(72,'84','Unlisted'),(73,'86','Unlisted'),(74,'87','Unlisted'),(75,'88','Unlisted'),(76,'89','Unlisted'),(77,'91','Unlisted'),(78,'92','Unlisted'),(79,'93','Unlisted'),(80,'94','Unlisted'),(81,'95','Unlisted'),(82,'96','Unlisted'),(83,'97','Unlisted'),(84,'98','Unlisted'),(85,'99','Unlisted'),(86,'-1','Unlisted');
/*!40000 ALTER TABLE `sic_codes_major` ENABLE KEYS */;
UNLOCK TABLES;