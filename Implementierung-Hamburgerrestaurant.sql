SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS 
    `mydb`.`Abrechnung`, 
    `mydb`.`Bestellung_has_Gericht`, 
    `mydb`.`Gericht_has_Zutat`, 
    `mydb`.`Bestellung`, 
    `mydb`.`Gericht`, 
    `mydb`.`Zutat`, 
    `mydb`.`Mitarbeiter`, 
    `mydb`.`Kunden`, 
    `mydb`.`Status`;

SET FOREIGN_KEY_CHECKS = 1;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb3 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Abrechnung`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Abrechnung` (
  `AbrechnungID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Betrag` DECIMAL(10,2) UNSIGNED NOT NULL,
  `Trinkgeld` DECIMAL(10,2) UNSIGNED NULL DEFAULT NULL,
  `Zeitstempel` DATETIME NOT NULL,
  `BestellungID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`AbrechnungID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb`.`Bestellung`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Bestellung` (
  `BestellungID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `TischNr` INT UNSIGNED NULL DEFAULT NULL,
  `Zeitstempel` DATETIME NOT NULL,
  `Status_StatusID` INT UNSIGNED NOT NULL,
  `Kunden_KundenID` INT UNSIGNED NOT NULL,
  `Mitarbeiter_MitarbeiterID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`BestellungID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb`.`Gericht`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Gericht` (
  `GerichtID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Preis` DECIMAL(10,2) UNSIGNED NOT NULL,
  PRIMARY KEY (`GerichtID`))
ENGINE = InnoDB
AUTO_INCREMENT = 37
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb`.`Bestellung_has_Gericht`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Bestellung_has_Gericht` (
  `Bestellung_BestellungID` INT UNSIGNED NOT NULL,
  `Gericht_GerichtID` INT UNSIGNED NOT NULL,
  `Menge` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Bestellung_BestellungID`, `Gericht_GerichtID`),
  INDEX `fk_Bestellung_has_Gericht_Gericht1_idx` (`Gericht_GerichtID` ASC) VISIBLE,
  INDEX `fk_Bestellung_has_Gericht_Bestellung1_idx` (`Bestellung_BestellungID` ASC) VISIBLE,
  CONSTRAINT `fk_Bestellung_has_Gericht_Bestellung1`
    FOREIGN KEY (`Bestellung_BestellungID`)
    REFERENCES `mydb`.`Bestellung` (`BestellungID`),
  CONSTRAINT `fk_Bestellung_has_Gericht_Gericht1`
    FOREIGN KEY (`Gericht_GerichtID`)
    REFERENCES `mydb`.`Gericht` (`GerichtID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb`.`Zutat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Zutat` (
  `ZutatID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Lagerbestand` DOUBLE UNSIGNED NOT NULL,
  `Preis` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`ZutatID`))
ENGINE = InnoDB
AUTO_INCREMENT = 97
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb`.`Gericht_has_Zutat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Gericht_has_Zutat` (
  `Gericht_GerichtID` INT UNSIGNED NOT NULL,
  `Zutat_ZutatID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Gericht_GerichtID`, `Zutat_ZutatID`),
  INDEX `fk_Gericht_has_Zutat_Zutat1_idx` (`Zutat_ZutatID` ASC) VISIBLE,
  INDEX `fk_Gericht_has_Zutat_Gericht1_idx` (`Gericht_GerichtID` ASC) VISIBLE,
  CONSTRAINT `fk_Gericht_has_Zutat_Gericht1`
    FOREIGN KEY (`Gericht_GerichtID`)
    REFERENCES `mydb`.`Gericht` (`GerichtID`),
  CONSTRAINT `fk_Gericht_has_Zutat_Zutat1`
    FOREIGN KEY (`Zutat_ZutatID`)
    REFERENCES `mydb`.`Zutat` (`ZutatID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb`.`Mitarbeiter`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Mitarbeiter` (
  `MitarbeiterID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Nachname` VARCHAR(45) NOT NULL,
  `Vorname` VARCHAR(45) NOT NULL,
  `Rolle` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`MitarbeiterID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb`.`Kunden`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Kunden` (
  `KundenID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Nachname` VARCHAR(45) NOT NULL,
  `Vorname` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`KundenID`))
ENGINE = InnoDB
AUTO_INCREMENT = 49
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb`.`Status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Status` (
  `StatusID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Bezeichner` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`StatusID`))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb3;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- STAMMDATEN EINFÜGEN
-- -----------------------------------------------------
INSERT IGNORE INTO Status (StatusID, Bezeichner) VALUES
(1, "Bestellung empfangen"),
(2, "Bestellung in Zubereitung"),
(3, "Bestellung zubereitet"),
(4, "Bestellung serviert"),
(5, "Bestellung bezahlt");

INSERT IGNORE INTO Kunden (KundenID, Nachname, Vorname) VALUES
(1, "Grande", "Ariana"),
(2, "M'Barek", "Elias"),
(3, "Holland", "Tom"),
(4, "Müller","Thomas"),
(5, "Merkel", "Angela"),
(6, "Paschedag", "Mia"),
(7, "Allouch", "Mouna"),
(8, "Rolke", "Finja"),
(9, "Karius", "Loris"),
(10, "Dzeko", "Edin");

INSERT IGNORE INTO Mitarbeiter (MitarbeiterID, Nachname, Vorname, Rolle) VALUES
(1, "Peters", "Christian", "Kellner"),
(2, "Fischer", "Helene", "Kellner"),
(3, "Schöwerling", "Lina", "Koch"),
(4, "Habbe","Ronja", "Restaurantmanager"),
(5, "Walkenfort", "Kim", "Kellner"),
(6, "Franke", "Ulrike", "Restaurantmanager"),
(7, "Muslic", "Miron", "Kellner"),
(8, "Heitbrede", "Uwe", "Koch"),
(9, "Behrens", "Julian", "Koch"),
(10, "Menacher", "Anna-Lena", "Koch");

INSERT IGNORE INTO mydb.Zutat (Name, Lagerbestand, Preis) VALUES 
("Sesam Bun", 25, 1.00),
("Vollkorn Bun", 20,1.00),
("Gouda", 5, 0.50),
("Salat", 3, 0.25),
("Tomaten", 15, 0.10),
("Speck", 50, 0.50),
("Vegetraisches Patty", 20, 2.00),
("Crispy Chicken Patty", 30, 3.00),
("Rinder Patty", 25, 4.00),
("Spiegelei", 30, 0.50),
("Kartoffeln", 10, 1.50),
("Süßkartoffeln", 8, 2.00),
("Ketchup", 50, 0.50),
("Mayo", 50, 0.50),
("Guacamole", 30, 1.00),
("Sour Cream", 30, 0.50);

INSERT IGNORE INTO mydb.Gericht(Name, Preis) VALUES 
("Pommes", 2.50),
("Süßkartoffel Pommes", 3.50),
('Klassik Rind Burger', 8.50),
('Veggie Guacamole Burger', 9.50),
('Crispy Bacon Chicken Burger', 10.00),
('Cola 0,4l', 3.50);

-- -----------------------------------------------------
-- REZEPTE VERKNÜPFEN
-- -----------------------------------------------------
INSERT IGNORE INTO `mydb`.`Gericht_has_Zutat` (`Gericht_GerichtID`, `Zutat_ZutatID`) VALUES
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Gouda')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Salat')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rinder Patty')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Ketchup'));

INSERT IGNORE INTO `mydb`.`Gericht_has_Zutat` (`Gericht_GerichtID`, `Zutat_ZutatID`) VALUES
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Guacamole Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Vollkorn Bun')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Guacamole Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Salat')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Guacamole Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Vegetraisches Patty')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Guacamole Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Guacamole')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Guacamole Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sour Cream'));

INSERT IGNORE INTO `mydb`.`Gericht_has_Zutat` (`Gericht_GerichtID`, `Zutat_ZutatID`) VALUES
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Bacon Chicken Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Bacon Chicken Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Salat')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Bacon Chicken Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Speck')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Bacon Chicken Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Crispy Chicken Patty')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Bacon Chicken Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Mayo'));

-- -----------------------------------------------------
-- TRANSAKTIONSDATEN BEFÜLLEN
-- -----------------------------------------------------
INSERT INTO `mydb`.`Bestellung` (`BestellungID`, `TischNr`, `Zeitstempel`, `Status_StatusID`, `Kunden_KundenID`, `Mitarbeiter_MitarbeiterID`) VALUES
(1, 5, '2026-06-01 12:30:00', 5, 1, 1), 
(2, 3, '2026-06-01 13:15:00', 5, 2, 2), 
(3, 2, '2026-06-02 18:00:00', 5, 3, 5), 
(4, 8, '2026-06-02 19:30:00', 5, 4, 1), 
(5, 1, '2026-06-03 20:15:00', 4, 5, 7); 

INSERT INTO `mydb`.`Bestellung_has_Gericht` (`Bestellung_BestellungID`, `Gericht_GerichtID`, `Menge`) VALUES
(1, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), 2),
(1, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Pommes'), 2),
(1, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Cola 0,4l'), 2),
(2, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Guacamole Burger'), 1),
(2, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Süßkartoffel Pommes'), 1),
(3, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Bacon Chicken Burger'), 3),
(3, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Cola 0,4l'), 3), -- Hier korrigiert!
(4, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), 1),
(4, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Guacamole Burger'), 1),
(4, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Pommes'), 2),
(5, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Bacon Chicken Burger'), 1),
(5, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Süßkartoffel Pommes'), 1);

INSERT INTO `mydb`.`Abrechnung` (`Betrag`, `Trinkgeld`, `Zeitstempel`, `BestellungID`) VALUES
(29.00, 3.00, '2026-06-01 13:15:00', 1),
(13.00, 2.00, '2026-06-01 13:50:00', 2),
(40.50, 4.50, '2026-06-02 19:00:00', 3),
(23.00, 2.00, '2026-06-02 20:20:00', 4);