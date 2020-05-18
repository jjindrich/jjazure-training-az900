CREATE DATABASE MovieDb;

USE MovieDb;
CREATE TABLE `Movie` (
          `Id` int NOT NULL AUTO_INCREMENT,
          `Title` longtext NULL,
          `ReleaseDate` datetime(6) NOT NULL,
          `Genre` longtext NULL,
          `Price` decimal(65, 30) NOT NULL,
          CONSTRAINT `PK_Movie` PRIMARY KEY (`Id`)
      );