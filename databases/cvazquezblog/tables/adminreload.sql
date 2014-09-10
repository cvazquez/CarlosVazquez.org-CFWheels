CREATE TABLE `adminreloads` (
	`id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`password` VARCHAR(15) NOT NULL,
	
	`createdAt` DATETIME NULL DEFAULT NULL,
	`createdBy` MEDIUMINT(8) UNSIGNED NULL DEFAULT NULL,
	`updatedAt` DATETIME NULL DEFAULT NULL,
	`updatedBy` MEDIUMINT(8) UNSIGNED NULL DEFAULT NULL,
	`deletedAt` DATETIME NULL DEFAULT NULL,
	`deletedBy` MEDIUMINT(8) UNSIGNED NULL DEFAULT NULL,
	`timestampAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`)
)
COMMENT='Password used to reload the wheels framework'
COLLATE='utf8_general_ci'
ENGINE=InnoDB;
