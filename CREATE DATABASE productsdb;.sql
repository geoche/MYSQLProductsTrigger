CREATE DATABASE productsdb;

USE productsdb;

CREATE TABLE ProductStatus (
    Id INT NOT NULL PRIMARY KEY,
    StatusName TEXT
);

INSERT INTO
    ProductStatus (Id, StatusName)
VALUES
    (100, 'NOT SOLD'),
    (200, 'SOLD');

CREATE TABLE Products (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(30) NOT NULL,
    Manufacturer VARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price DECIMAL NOT NULL,
    StatusId INT NOT NULL,
    INDEX (StatusId),
    FOREIGN KEY (StatusId) REFERENCES ProductStatus(Id)
);

CREATE TABLE SoldProducts (
    ProductId INT NOT NULL,
    ProductName VARCHAR(30) NOT NULL,
    Manufacturer VARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price DECIMAL NOT NULL,
    SaleDate DATETIME NOT NULL,
    INDEX (ProductId),
    FOREIGN KEY (ProductId) REFERENCES Products(Id)
);

DELIMITER $$ 
CREATE TRIGGER Products_OnSoldProducts
AFTER
UPDATE
    ON Products FOR EACH ROW BEGIN IF (NEW.StatusId = 200) THEN
INSERT
    SoldProducts (
        ProductId,
        ProductName,
        Manufacturer,
        ProductCount,
        Price,
        SaleDate
    )
VALUES
    (
        OLD.Id,
        OLD.ProductName,
        OLD.Manufacturer,
        OLD.ProductCount,
        OLD.Price,
        NOW()
    );
END IF;

END$$

DELIMITER;