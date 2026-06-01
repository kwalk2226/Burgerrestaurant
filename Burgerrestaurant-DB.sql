-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Kunden`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Kunden` (
  `KundenID` INT NOT NULL,
  `Nachname` VARCHAR(45) NOT NULL,
  `Vorname` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`KundenID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Status` (
  `StatusID` INT NOT NULL AUTO_INCREMENT,
  `Bezeichner` VARCHAR(45) NOT NULL,
  `Zeitstempel` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`StatusID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Abrechnung`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Abrechnung` (
  `AbrechnungID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Betrag` DECIMAL UNSIGNED NOT NULL,
  `Trinkgeld` DECIMAL UNSIGNED NULL,
  `Zeitstempel` DATETIME NOT NULL,
  PRIMARY KEY (`AbrechnungID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Bestellung`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Bestellung` (
  `BestellungID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `TischNr` INT UNSIGNED NULL,
  `Zeitstempel` DATETIME NOT NULL,
  `Status_idStaus` INT UNSIGNED NOT NULL,
  `Kunden_KundenID` INT UNSIGNED NOT NULL,
  `Abrechnung_AbrechnungID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`BestellungID`),
  INDEX `Status_idStatus_idx` (`Status_idStaus` ASC) VISIBLE,
  INDEX `fk_Bestellung_Kunden1_idx` (`Kunden_KundenID` ASC) VISIBLE,
  INDEX `fk_Bestellung_Abrechnung1_idx` (`Abrechnung_AbrechnungID` ASC) VISIBLE,
  CONSTRAINT `Status_idStatus`
    FOREIGN KEY (`Status_idStaus`)
    REFERENCES `mydb`.`Status` (`StatusID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bestellung_Kunden1`
    FOREIGN KEY (`Kunden_KundenID`)
    REFERENCES `mydb`.`Kunden` (`KundenID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bestellung_Abrechnung1`
    FOREIGN KEY (`Abrechnung_AbrechnungID`)
    REFERENCES `mydb`.`Abrechnung` (`AbrechnungID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Zutat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Zutat` (
  `ZutatID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Lagerbestand` DOUBLE UNSIGNED NOT NULL,
  PRIMARY KEY (`ZutatID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Kellner`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Kellner` (
  `KellnerID` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Bestellung_idBestellung` INT NOT NULL,
  `Kunden_idKunden` INT NOT NULL,
  `Vorname` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`KellnerID`),
  INDEX `Bestellung_idBestellung_idx` (`Bestellung_idBestellung` ASC) VISIBLE,
  INDEX `Kunden_idKunden_idx` (`Kunden_idKunden` ASC) VISIBLE,
  CONSTRAINT `Bestellung_idBestellung`
    FOREIGN KEY (`Bestellung_idBestellung`)
    REFERENCES `mydb`.`Bestellung` (`BestellungID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Kunden_idKunden`
    FOREIGN KEY (`Kunden_idKunden`)
    REFERENCES `mydb`.`Kunden` (`KundenID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Gericht`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Gericht` (
  `GerichtID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `Preis` DECIMAL NULL,
  PRIMARY KEY (`GerichtID`))
ENGINE = InnoDB;


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
    REFERENCES `mydb`.`Gericht` (`GerichtID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Gericht_has_Zutat_Zutat1`
    FOREIGN KEY (`Zutat_ZutatID`)
    REFERENCES `mydb`.`Zutat` (`ZutatID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Bestellung_has_Gericht`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Bestellung_has_Gericht` (
  `Bestellung_idBestellung` INT UNSIGNED NOT NULL,
  `Gericht_GerichtID` INT UNSIGNED NOT NULL,
  `Menge` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Bestellung_idBestellung`, `Gericht_GerichtID`),
  INDEX `fk_Bestellung_has_Gericht_Gericht1_idx` (`Gericht_GerichtID` ASC) VISIBLE,
  INDEX `fk_Bestellung_has_Gericht_Bestellung1_idx` (`Bestellung_idBestellung` ASC) VISIBLE,
  CONSTRAINT `fk_Bestellung_has_Gericht_Bestellung1`
    FOREIGN KEY (`Bestellung_idBestellung`)
    REFERENCES `mydb`.`Bestellung` (`BestellungID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bestellung_has_Gericht_Gericht1`
    FOREIGN KEY (`Gericht_GerichtID`)
    REFERENCES `mydb`.`Gericht` (`GerichtID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
