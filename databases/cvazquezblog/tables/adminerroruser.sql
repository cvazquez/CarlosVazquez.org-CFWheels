CREATE TABLE `adminerroruser` (
	`id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`firstName` VARCHAR(50) NOT NULL,
	`lastname` VARCHAR(50) NOT NULL,
	`email` VARCHAR(150) NOT NULL,
	
	`createdAt` DATETIME NULL DEFAULT NULL,
	`createdBy` MEDIUMINT(8) UNSIGNED NULL DEFAULT NULL,
	`updatedAt` DATETIME NULL DEFAULT NULL,
	`updatedBy` MEDIUMINT(8) UNSIGNED NULL DEFAULT NULL,
	`deletedAt` DATETIME NULL DEFAULT NULL,
	`deletedBy` MEDIUMINT(8) UNSIGNED NULL DEFAULT NULL,
	`timestampAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`)
)
COMMENT='Users who recieve email errors'
CHARSET='utf8'
ENGINE=InnoDB;
