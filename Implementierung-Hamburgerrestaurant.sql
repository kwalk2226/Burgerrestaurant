SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS 
    `mydb`.`Abrechnung`, 
    `mydb`.`Bestellposition_has_Zutat`, 
    `mydb`.`Bestellposition`, 
    `mydb`.`Gericht_has_Zutat`, 
    `mydb`.`Bestellung`, 
    `mydb`.`Bestellungsverlauf`,
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

-- Table Status
CREATE TABLE IF NOT EXISTS `mydb`.`Status` (
  `StatusID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Bezeichner` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`StatusID`))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb3;

-- Table Kunden
CREATE TABLE IF NOT EXISTS `mydb`.`Kunden` (
  `KundenID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Nachname` VARCHAR(45) NOT NULL,
  `Vorname` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`KundenID`))
ENGINE = InnoDB
AUTO_INCREMENT = 49
DEFAULT CHARACTER SET = utf8mb3;

-- Table Mitarbeiter
CREATE TABLE IF NOT EXISTS `mydb`.`Mitarbeiter` (
  `MitarbeiterID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Nachname` VARCHAR(45) NOT NULL,
  `Vorname` VARCHAR(45) NOT NULL,
  `Rolle` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`MitarbeiterID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- Table Bestellung
CREATE TABLE IF NOT EXISTS `mydb`.`Bestellung` (
  `BestellungID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `TischNr` INT UNSIGNED NULL DEFAULT NULL,
  `Kunden_KundenID` INT UNSIGNED NOT NULL,
  `Mitarbeiter_MitarbeiterID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`BestellungID`),
  FOREIGN KEY (`Kunden_KundenID`) REFERENCES `mydb`.`Kunden` (`KundenID`),
  FOREIGN KEY (`Mitarbeiter_MitarbeiterID`) REFERENCES `mydb`.`Mitarbeiter` (`MitarbeiterID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- Table Bestellungsverlauf
CREATE TABLE IF NOT EXISTS `mydb`.`Bestellungsverlauf`(
  `BestellungsverlaufID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Zeitstempel` DATETIME NOT NULL,
  `Status_StatusID` INT UNSIGNED NOT NULL,
  `Bestellung_BestellungID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`BestellungsverlaufID`),
  FOREIGN KEY (`Bestellung_BestellungID`) REFERENCES `mydb`.`Bestellung` (`BestellungID`),
  FOREIGN KEY (`Status_StatusID`) REFERENCES `mydb`.`Status` (`StatusID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- Table Abrechnung
CREATE TABLE IF NOT EXISTS `mydb`.`Abrechnung` (
  `AbrechnungID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Betrag` DECIMAL(10,2) UNSIGNED NOT NULL,
  `Trinkgeld` DECIMAL(10,2) UNSIGNED NULL DEFAULT NULL,
  `Zeitstempel` DATETIME NOT NULL,
  `BestellungID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`AbrechnungID`),
  FOREIGN KEY (`BestellungID`) REFERENCES `mydb`.`Bestellung` (`BestellungID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- Table Gericht
CREATE TABLE IF NOT EXISTS `mydb`.`Gericht` (
  `GerichtID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Preis` DECIMAL(10,2) UNSIGNED NOT NULL,
  PRIMARY KEY (`GerichtID`))
ENGINE = InnoDB
AUTO_INCREMENT = 37
DEFAULT CHARACTER SET = utf8mb3;

-- Table Bestellposition
CREATE TABLE IF NOT EXISTS `mydb`.`Bestellposition` (
  `BestellpositionID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `BestellungID` INT UNSIGNED NOT NULL,
  `GerichtID` INT UNSIGNED NOT NULL,
  `Menge` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`BestellpositionID`),
  FOREIGN KEY (`BestellungID`) REFERENCES `mydb`.`Bestellung` (`BestellungID`),
  FOREIGN KEY (`GerichtID`) REFERENCES `mydb`.`Gericht` (`GerichtID`)) 
ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- Table Zutat
CREATE TABLE IF NOT EXISTS `mydb`.`Zutat` (
  `ZutatID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Lagerbestand` DOUBLE UNSIGNED NOT NULL,
  `Preis` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`ZutatID`))
ENGINE = InnoDB
AUTO_INCREMENT = 97
DEFAULT CHARACTER SET = utf8mb3;

-- Table Bestellposition_has_Zutat
CREATE TABLE IF NOT EXISTS `mydb`.`Bestellposition_has_Zutat` (
  `BestellpositionID` INT UNSIGNED NOT NULL,
  `ZutatID` INT UNSIGNED NOT NULL,
  `Menge` INT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`BestellpositionID`, `ZutatID`),
  FOREIGN KEY (`BestellpositionID`) REFERENCES `mydb`.`Bestellposition` (`BestellpositionID`),
  FOREIGN KEY (`ZutatID`) REFERENCES `mydb`.`Zutat` (`ZutatID`)) 
ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- Table Gericht_has_Zutat
CREATE TABLE IF NOT EXISTS `mydb`.`Gericht_has_Zutat` (
  `Gericht_GerichtID` INT UNSIGNED NOT NULL,
  `Zutat_ZutatID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Gericht_GerichtID`, `Zutat_ZutatID`),
  CONSTRAINT `fk_Gericht_has_Zutat_Gericht1` FOREIGN KEY (`Gericht_GerichtID`) REFERENCES `mydb`.`Gericht` (`GerichtID`),
  CONSTRAINT `fk_Gericht_has_Zutat_Zutat1` FOREIGN KEY (`Zutat_ZutatID`) REFERENCES `mydb`.`Zutat` (`ZutatID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Stammdaten einfügen
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
-- Bun
("Sesam Bun", 25, 1.00),
("Vollkorn Bun", 20,1.00),
("Laugen-Brioche-Bun", 45, 1.50),
-- Käse
("Gouda", 20, 0.50),
("Cheddar", 15, 0.50),
("Mozarella", 24, 0.50),
("Ziegenkäse", 24, 1.00),
("Veganer Gouda", 12, 1.00),
("Brie", 12, 1.00),
-- Salat 
("Salat", 3, 0.25),
("Tomaten", 15, 0.10),
("Gewürzgurke", 30, 0.20),
("Rucola", 43, 0.30),
("Zwiebeln", 43, 0.10),
-- Patty
("Veganes Patty", 34, 2.00),
("Vegetraisches Patty", 20, 2.00),
("Crispy Chicken Patty", 30, 3.00),
("Rindfleischpatty", 25, 4.00),
-- Saucen 
("Ketchup", 50, 0.50),
("Sour Cream", 30, 0.50),
("Tomatencreme", 30, 0.50),
("Honey-Mustard-Sauce", 30, 1.00),
("Mayo", 50, 0.50),
("BBQ-Sauce", 30, 0.50),
("Curry-Sauce", 26, 0.50),
("Cocktailsauce",34, 0.50),

-- Burgerextras
("Bacon", 50, 0.50),
("Spiegelei", 30, 0.50),
("Guacamole", 30, 1.00),
("Jalapenos", 20, 0.50),
-- Beilagen
("Kartoffeln", 10, 1.50),
("Süßkartoffeln", 8, 2.00);


INSERT IGNORE INTO mydb.Gericht(Name, Preis) VALUES 
-- Beilagen
("Pommes", 2.50),
("Süßkartoffel Pommes", 3.50),

-- Burger fertig kombiniert
("Klassik Rind Burger", 8.50),
("Veggie Cheese Burger", 9.50),
("Crispy Chicken Burger", 10.00),
("Brotloser Burger", 10.0),
("Dreikäsehoch Burger", 11.00),
("BBQ Cheese Burger", 11.00),
("Laugen Brie Burger", 11.00),
("Ziegenkäse Burger", 11.00),
("Hamburger", 9.50),
("Cheeseburger", 10.00),
-- Getränke
("Fanta", 4.50),
("Cola", 4.50),
("Sprite", 4.50),
("Wasser", 3.50),
("Maracuja-Schorle", 5.50),
("Apfel-Schorle", 5.50),
("Veltins vom Fass", 5.00),
("Aperol Spritz", 7.50), 
("Lillet", 7.50), 
("Ouzo", 3.00);



-- Rezepte Verknüpfen (Standard-Rezepte)
INSERT IGNORE INTO `mydb`.`Gericht_has_Zutat` (`Gericht_GerichtID`, `Zutat_ZutatID`) VALUES
-- Klassik Rind Burger
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Gouda')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Salat')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Ketchup')),

-- Veggie Cheese Burger
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Cheese Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Veganes Patty')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Cheese Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Veganer Gouda')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Cheese Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Salat')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Cheese Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Cheese Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Tomatencreme')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Cheese Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Guacamole')),

-- Crispy Chicken Burger
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Chicken Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Vollkorn Bun')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Chicken Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Salat')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Chicken Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Honey-Mustard-Sauce')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Chicken Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Tomaten')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Chicken Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Gewürzgurke')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Chicken Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Crispy Chicken Patty')),

-- Brotlosser Burger 
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Brotloser Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Salat')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Brotloser Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Cheddar')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Brotloser Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Spiegelei')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Brotloser Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Brotloser Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Bacon')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Brotloser Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Curry-Sauce')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Brotloser Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Tomaten')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Brotloser Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Gewürzgurke')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Brotloser Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Guacamole')),

-- Dreikäsehoch Burger
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Dreikäsehoch Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Dreikäsehoch Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Cocktailsauce')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Dreikäsehoch Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Salat')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Dreikäsehoch Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Dreikäsehoch Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Jalapenos')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Dreikäsehoch Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Gouda')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Dreikäsehoch Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Cheddar')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Dreikäsehoch Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Mozarella')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Dreikäsehoch Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Tomaten')),

-- BBQ Cheese Burger
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'BBQ Cheese Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'BBQ Cheese Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'BBQ Cheese Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Salat')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'BBQ Cheese Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Bacon')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'BBQ Cheese Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Cheddar')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'BBQ Cheese Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Tomaten')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'BBQ Cheese Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Gewürzgurke')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'BBQ Cheese Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'BBQ-Sauce')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'BBQ Cheese Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Zwiebeln')),

-- Laugen Brie Burger
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Laugen Brie Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Laugen-Brioche-Bun')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Laugen Brie Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Laugen Brie Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rucola')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Laugen Brie Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Gewürzgurke')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Laugen Brie Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Tomaten')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Laugen Brie Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Brie')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Laugen Brie Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Cocktailsauce')),

-- Ziegenkäse Burger 
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Ziegenkäse Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Ziegenkäse Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Ziegenkäse Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rucola')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Ziegenkäse Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Ziegenkäse')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Ziegenkäse Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Zwiebeln')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Ziegenkäse Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Gewürzgurke')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Ziegenkäse Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Tomaten')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Ziegenkäse Burger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Cocktailsauce')),

-- Hamburger 
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Hamburger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Hamburger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Cocktailsauce')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Hamburger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Salat')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Hamburger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Hamburger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Tomaten')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Hamburger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Gewürzgurke')),

-- Cheeseburger
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Cheeseburger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Cheeseburger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Cheddar')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Cheeseburger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Salat')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Cheeseburger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Cheeseburger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Tomaten')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Cheeseburger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Gewürzgurke')),
((SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Cheeseburger'), (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Cocktailsauce'));

-- Bestellungen anlegen
INSERT INTO `mydb`.`Bestellung` (`BestellungID`, `TischNr`, `Kunden_KundenID`, `Mitarbeiter_MitarbeiterID`) VALUES
(1, 5, 1, 1),  -- Ariana bestellt bei Christian
(2, 3, 2, 2),  -- Elias bestellt bei Helene
(3, 2, 3, 5),  -- Tom bestellt bei Kim
(4, 8, 4, 1),  -- Thomas bestellt bei Christian
(5, 1, 5, 7),  -- Angela bestellt bei Miron
(6, 4, 9, 2), -- Loris Karius bestellt bei Helene
(7,  2, 3, 1),  -- Tom bei Christian
(8,  6, 6, 2),  -- Mia bei Helene
(9,  9, 7, 5),  -- Mouna bei Kim
(10, 4, 8, 7),  -- Finja bei Miron
(11, 7, 10, 1), -- Edin bei Christian
(12, 1, 2, 2),  -- Elias bei Helene
(13, 3, 4, 5),  -- Thomas bei Kim
(14, 5, 5, 7),  -- Angela bei Miron
(15, 8, 1, 1),  -- Ariana bei Christian
(16, 2, 6, 2),  -- Mia bei Helene
(17, 9, 2, 5),  -- Elias bei Kim
(18, 4, 3, 7),  -- Tom bei Miron
(19, 6, 7, 1),  -- Mouna bei Christian
(20, 1, 8, 2),  -- Finja bei Helene
(21, 3, 9, 5),  -- Loris bei Kim
(22, 5, 10, 7), -- Edin bei Miron
(23, 7, 4, 1),  -- Thomas bei Christian
(24, 8, 5, 2),  -- Angela bei Helene
(25, 2, 6, 5);  -- Mia bei Kim

-- Zeitverlauf tracken für die Küche
INSERT INTO `mydb`.`Bestellungsverlauf` (`Bestellung_BestellungID`, `Status_StatusID`, `Zeitstempel`) VALUES
-- Bestellung 1: Abgeschlossen und bezahlt
(1, 1, '2026-06-01 12:30:00'), (1, 2, '2026-06-01 12:35:00'), (1, 4, '2026-06-01 12:50:00'), (1, 5, '2026-06-01 13:15:00'), 
-- Bestellung 2: Abgeschlossen und bezahlt
(2, 1, '2026-06-01 13:15:00'), (2, 2, '2026-06-01 13:20:00'), (2, 4, '2026-06-01 13:45:00'), (2, 5, '2026-06-01 13:50:00'),
-- Bestellung 3: Abgeschlossen und bezahlt
(3, 1, '2026-06-02 18:00:00'), (3, 2, '2026-06-02 18:10:00'), (3, 4, '2026-06-02 18:30:00'), (3, 5, '2026-06-02 19:00:00'),
-- Bestellung 4: Aktuell in der Küche (In Zubereitung)
(4, 1, '2026-06-14 11:15:00'),(4, 2, '2026-06-14 11:20:00'),
-- Bestellung 5: Frisch eingegangen (Noch nicht zubereitet)
(5, 1, '2026-06-14 11:40:00'),
-- Bestellung 6: Abgeschlossen und bezahlt
(6, 1, '2026-06-14 12:00:00'), (6, 2, '2026-06-14 12:05:00'), (6, 4, '2026-06-14 12:25:00'),(6, 5, '2026-06-14 12:45:00'),
(7, 1, '2026-06-02 19:15:00'), (7, 2, '2026-06-02 19:22:00'), (7, 4, '2026-06-02 19:40:00'), (7, 5, '2026-06-02 20:10:00'),
(8, 1, '2026-06-03 13:00:00'), (8, 2, '2026-06-03 13:05:00'), (8, 4, '2026-06-03 13:22:00'), (8, 5, '2026-06-03 13:45:00'),
(9, 1, '2026-06-03 18:30:00'), (9, 2, '2026-06-03 18:34:00'), (9, 4, '2026-06-03 18:55:00'), (9, 5, '2026-06-03 19:30:00'),
(10, 1, '2026-06-04 12:10:00'), (10, 2, '2026-06-04 12:15:00'), (10, 4, '2026-06-04 12:31:00'), (10, 5, '2026-06-04 12:50:00'),
(11, 1, '2026-06-05 20:00:00'), (11, 2, '2026-06-05 20:08:00'), (11, 4, '2026-06-05 20:30:00'), (11, 5, '2026-06-05 21:05:00'),
(12, 1, '2026-06-06 14:15:00'), (12, 2, '2026-06-06 14:19:00'), (12, 4, '2026-06-06 14:38:00'), (12, 5, '2026-06-06 15:00:00'),
(13, 1, '2026-06-07 19:00:00'), (13, 2, '2026-06-07 19:05:00'), (13, 4, '2026-06-07 19:24:00'), (13, 5, '2026-06-07 19:55:00'),
(14, 1, '2026-06-08 13:10:00'), (14, 2, '2026-06-08 13:14:00'), (14, 4, '2026-06-08 13:30:00'), (14, 5, '2026-06-08 13:50:00'),
(15, 1, '2026-06-09 18:45:00'), (15, 2, '2026-06-09 18:50:00'), (15, 4, '2026-06-09 19:12:00'), (15, 5, '2026-06-09 19:45:00'),
(16, 1, '2026-06-10 12:30:00'), (16, 2, '2026-06-10 12:35:00'), (16, 4, '2026-06-10 12:52:00'), (16, 5, '2026-06-10 13:15:00'),
(17, 1, '2026-06-11 20:15:00'), (17, 2, '2026-06-11 20:20:00'), (17, 4, '2026-06-11 20:41:00'), (17, 5, '2026-06-11 21:10:00'),
(18, 1, '2026-06-12 19:30:00'), (18, 2, '2026-06-12 19:36:00'), (18, 4, '2026-06-12 19:58:00'), (18, 5, '2026-06-12 20:30:00'),
(19, 1, '2026-06-13 13:45:00'), (19, 2, '2026-06-13 13:50:00'), (19, 4, '2026-06-13 14:09:00'), (19, 5, '2026-06-13 14:35:00'),
(20, 1, '2026-06-14 12:15:00'), (20, 2, '2026-06-14 12:20:00'), (20, 4, '2026-06-14 12:42:00'), (20, 5, '2026-06-14 13:10:00'),
(21, 1, '2026-06-14 13:00:00'), (21, 2, '2026-06-14 13:05:00'), (21, 4, '2026-06-14 13:23:00'), (21, 5, '2026-06-14 13:55:00'),
(22, 1, '2026-06-14 13:30:00'), (22, 2, '2026-06-14 13:34:00'), (22, 4, '2026-06-14 13:51:00'), (22, 5, '2026-06-14 14:20:00'),
(23, 1, '2026-06-14 14:00:00'), (23, 2, '2026-06-14 14:06:00'), (23, 4, '2026-06-14 14:25:00'), (23, 5, '2026-06-14 14:50:00'),
(24, 1, '2026-06-14 14:15:00'), (24, 2, '2026-06-14 14:21:00'), (24, 4, '2026-06-14 14:40:00'), (24, 5, '2026-06-14 15:10:00'),
(25, 1, '2026-06-14 14:30:00'), (25, 2, '2026-06-14 14:35:00'), (25, 4, '2026-06-14 14:54:00'), (25, 5, '2026-06-14 15:25:00');

-- Bestellpositionen
INSERT INTO `mydb`.`Bestellposition` (`BestellpositionID`, `BestellungID`, `GerichtID`, `Menge`) VALUES
-- Bestellung 1
(1, 1, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), 1),
(2, 1, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Pommes'), 2),
-- Bestellung 2
(3, 2, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Cheese Burger'), 1),
(4, 2, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Cola'), 1),
-- Bestellung 3
(5, 3, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Dreikäsehoch Burger'), 1),
(6, 3, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Süßkartoffel Pommes'), 1),
(7, 3, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veltins vom Fass'), 2),
-- Bestellung 4
(8, 4, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Chicken Burger'), 2),
(9, 4, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Fanta'), 2),
-- Bestellung 5
(10, 5, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Ziegenkäse Burger'), 1),
(11, 5, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Wasser'), 1),
-- Bestellung 6
(12, 6, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veltins vom Fass'), 1),
(13, 6, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Ouzo'), 2),
(14, 6, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Pommes'), 1),
(15, 6, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Chicken Burger'), 1),

(16, 7, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), 1),
(17, 7, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Cola'), 1),
(18, 8, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Hamburger'), 1),
(19, 8, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Wasser'), 1),
(20, 9, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Cheeseburger'), 1),
(21, 9, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Fanta'), 1),
(22, 10, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'BBQ Cheese Burger'), 1),
(23, 10, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Pommes'), 1),
(24, 11, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Laugen Brie Burger'), 1),
(25, 11, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Aperol Spritz'), 2),
(26, 12, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), 2),
(27, 13, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Cheese Burger'), 1),
(28, 14, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Chicken Burger'), 1),
(29, 14, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Apfel-Schorle'), 1),
(30, 15, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Brotloser Burger'), 1),
(31, 16, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Dreikäsehoch Burger'), 1),
(32, 17, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Hamburger'), 1),
(33, 17, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Süßkartoffel Pommes'), 1),
(34, 18, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Cheeseburger'), 1),
(35, 19, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Ziegenkäse Burger'), 1),
(36, 19, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Maracuja-Schorle'), 1),
(37, 20, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Klassik Rind Burger'), 1),
(38, 20, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Lillet'), 1),
(39, 21, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'BBQ Cheese Burger'), 1),
(40, 22, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Laugen Brie Burger'), 1),
(41, 23, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Veggie Cheese Burger'), 1),
(42, 24, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Crispy Chicken Burger'), 1),
(43, 25, (SELECT `GerichtID` FROM `mydb`.`Gericht` WHERE `Name` = 'Dreikäsehoch Burger'), 1);

-- Individuelle Burger-Zusammensetzung (Optionsmix)
INSERT INTO `mydb`.`Bestellposition_has_Zutat` (`BestellpositionID`, `ZutatID`, `Menge`) VALUES
-- Für Position 1 (Der Klassik Rind Burger aus Bestellung 1)
(1, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(1, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(1, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Gouda'), 2), 
(1, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Bacon'), 1), 
-- Für Position 3 (Der Veggie Cheese Burger aus Bestellung 2)
(3, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(3, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Veganes Patty'), 1),
(3, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Veganer Gouda'), 1),
-- Für Position 5 (Der Dreikäsehoch Burger aus Bestellung 3 mit Extra Jalapenos)
(5, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(5, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(5, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Gouda'), 1),
(5, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Cheddar'), 1),
(5, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Mozarella'), 1),
(5, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Jalapenos'), 2), -- Schön scharf!
-- Für Position 8 (Die zwei Crispy Chicken Burger aus Bestellung 4)
(8, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Vollkorn Bun'), 2),
(8, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Crispy Chicken Patty'), 2),
-- Für Position 10 (Der Ziegenkäse Burger aus Bestellung 5)
(10, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(10, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(10, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Ziegenkäse'), 1),
-- Bestellung 6
(15, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Vollkorn Bun'), 1),
(15, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Crispy Chicken Patty'), 1),
(16, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(16, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(18, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(18, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(20, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(20, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(20, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Cheddar'), 1),
(22, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(22, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(22, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Cheddar'), 1),
(22, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Bacon'), 1),
(24, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Laugen-Brioche-Bun'), 1),
(24, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(24, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Brie'), 1),
(26, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 2),
(26, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 2),
(27, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(27, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Veganes Patty'), 1),
(28, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Vollkorn Bun'), 1),
(28, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Crispy Chicken Patty'), 1),
(30, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(30, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Bacon'), 1),
(31, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(31, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(32, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(32, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(34, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(34, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(34, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Cheddar'), 1),
(35, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(35, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(35, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Ziegenkäse'), 1),
(37, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(37, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(39, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(39, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(40, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Laugen-Brioche-Bun'), 1),
(40, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1),
(41, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(41, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Veganes Patty'), 1),
(42, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Vollkorn Bun'), 1),
(42, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Crispy Chicken Patty'), 1),
(43, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Sesam Bun'), 1),
(43, (SELECT `ZutatID` FROM `mydb`.`Zutat` WHERE `Name` = 'Rindfleischpatty'), 1);

-- Abrechnungen abspeichern
INSERT INTO `mydb`.`Abrechnung` (`Betrag`, `Trinkgeld`, `Zeitstempel`, `BestellungID`) VALUES
(13.50, 1.50, '2026-06-01 13:15:00', 1), 
(14.00, 2.00, '2026-06-01 13:50:00', 2), 
(24.50, 2.50, '2026-06-02 19:00:00', 3),
(23.50, 1.50, '2026-06-14 12:45:00', 6),
(13.00, 2.00, '2026-06-02 20:10:00', 7),
(13.00, 1.00, '2026-06-03 13:45:00', 8),
(14.50, 1.50, '2026-06-03 19:30:00', 9),
(13.50, 1.50, '2026-06-04 12:50:00', 10),
(26.00, 3.00, '2026-06-05 21:05:00', 11),
(17.00, 2.00, '2026-06-06 15:00:00', 12),
(9.50,  1.50, '2026-06-07 19:55:00', 13),
(15.50, 2.00, '2026-06-08 13:50:00', 14),
(10.00, 1.00, '2026-06-09 19:45:00', 15),
(11.00, 2.00, '2026-06-10 13:15:00', 16),
(13.00, 1.00, '2026-06-11 21:10:00', 17),
(10.00, 1.50, '2026-06-12 20:30:00', 18),
(16.50, 2.50, '2026-06-13 14:35:00', 19),
(16.00, 2.00, '2026-06-14 13:10:00', 20),
(11.00, 1.50, '2026-06-14 13:55:00', 21),
(11.00, 1.00, '2026-06-14 14:20:00', 22),
(9.50,  1.50, '2026-06-14 14:50:00', 23),
(10.00, 2.00, '2026-06-14 15:10:00', 24),
(11.00, 1.00, '2026-06-14 15:25:00', 25);



-- Live Demo
-- Was hat Loris Karius gekauft und was hat es gekostet?
SELECT 
    k.Vorname,
    k.Nachname,
    g.Name AS Gerichtname,
    bp.Menge,
    g.Preis AS Einzelpreis,
    (bp.Menge * g.Preis) AS Gesamtpreis
FROM `mydb`.`Kunden` k
JOIN `mydb`.`Bestellung` b ON k.KundenID = b.Kunden_KundenID
JOIN `mydb`.`Bestellposition` bp ON b.BestellungID = bp.BestellungID
JOIN `mydb`.`Gericht` g ON bp.GerichtID = g.GerichtID
WHERE k.Vorname = 'Loris' AND k.Nachname = 'Karius';

-- Verkäufe pro Option und Monat
SELECT 
    z.Name AS Zutatname,
    DATE_FORMAT(bv.Zeitstempel, '%Y-%m') AS Monat,
    SUM(bhz.Menge * bp.Menge) AS Verkaufte_Menge
FROM `mydb`.`Zutat` z
JOIN `mydb`.`Bestellposition_has_Zutat` bhz ON z.ZutatID = bhz.ZutatID
JOIN `mydb`.`Bestellposition` bp ON bhz.BestellpositionID = bp.BestellpositionID
JOIN `mydb`.`Bestellung` b ON bp.BestellungID = b.BestellungID
JOIN `mydb`.`Bestellungsverlauf` bv ON b.BestellungID = bv.Bestellung_BestellungID
WHERE bv.Status_StatusID = 1
GROUP BY z.Name, DATE_FORMAT(bv.Zeitstempel, '%Y-%m')
ORDER BY z.Name ASC;
	
-- Verkäufe pro Optionsmix und Monat
SELECT 
    g.Name AS Gerichtname,
    DATE_FORMAT(bv.Zeitstempel, '%Y-%m') AS Monat,
    SUM(bp.Menge) AS Verkaufte_Menge
FROM `mydb`.`Gericht` g
JOIN `mydb`.`Bestellposition` bp ON g.GerichtID = bp.GerichtID
JOIN `mydb`.`Bestellung` b ON bp.BestellungID = b.BestellungID
JOIN `mydb`.`Bestellungsverlauf` bv ON b.BestellungID = bv.Bestellung_BestellungID
WHERE bv.Status_StatusID = 1
GROUP BY g.Name, DATE_FORMAT(bv.Zeitstempel, '%Y-%m')
ORDER BY g.Name ASC;

-- Umsatz pro Tag
SELECT 
    DATE(a.Zeitstempel) AS Tag,
    SUM(a.Betrag) AS Tagesumsatz_Euro 
FROM `mydb`.`Abrechnung` a
GROUP BY DATE(a.Zeitstempel)
ORDER BY Tag ASC;

-- Umsatz pro Tag
SELECT 
    DATE(a.Zeitstempel) AS Tag,
    SUM(a.Trinkgeld) AS Trinkgeld_AmTag 
FROM `mydb`.`Abrechnung` a
GROUP BY DATE(a.Zeitstempel)
ORDER BY Tag ASC;

-- Durchschnittliche Dauer von Bestellung bis zum Servieren
SELECT 
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, status_1.Zeitstempel, status_4.Zeitstempel)), 1) AS Avg_Wartezeit_Minuten
FROM (
    -- Zeitstempel für "Bestellung empfangen" pro Bestellung
    SELECT Bestellung_BestellungID, Zeitstempel 
    FROM `mydb`.`Bestellungsverlauf` 
    WHERE Status_StatusID = 1
) status_1
JOIN (
    -- Zeitstempel für "Bestellung serviert" pro Bestellung
    SELECT Bestellung_BestellungID, Zeitstempel
    FROM `mydb`.`Bestellungsverlauf`
    WHERE Status_StatusID = 4
) status_4 ON status_1.Bestellung_BestellungID = status_4.Bestellung_BestellungID;
	
-- Durchschnittliche Wartezeit aufgeteilt nach Optionsmix
SELECT 
    g.Name AS Gerichtname,
    COUNT(DISTINCT b.BestellungID) AS Anzahl_Bestellungen,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, status_1.Zeitstempel, status_4.Zeitstempel)), 1) AS Avg_Wartezeit_Minuten
FROM `mydb`.`Gericht` g
JOIN `mydb`.`Bestellposition` bp ON g.GerichtID = bp.GerichtID
JOIN `mydb`.`Bestellung` b ON bp.BestellungID = b.BestellungID
JOIN (
    -- Zeitstempel für Empfang
    SELECT Bestellung_BestellungID, Zeitstempel 
    FROM `mydb`.`Bestellungsverlauf` 
    WHERE Status_StatusID = 1
) status_1 ON b.BestellungID = status_1.Bestellung_BestellungID
JOIN (
    -- Zeitstempel für Serviert
    SELECT Bestellung_BestellungID, Zeitstempel 
    FROM `mydb`.`Bestellungsverlauf` 
    WHERE Status_StatusID = 4
) status_4 ON b.BestellungID = status_4.Bestellung_BestellungID
GROUP BY g.GerichtID, g.Name
ORDER BY Avg_Wartezeit_Minuten ASC;
	 