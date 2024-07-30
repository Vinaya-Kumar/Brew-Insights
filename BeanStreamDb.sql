SET NOCOUNT ON;

USE master;
GO

DROP DATABASE IF EXISTS BeanStreamDb;
GO

CREATE DATABASE BeanStreamDb;
GO

USE BeanStreamDb;
GO

-- Creating tables 
CREATE TABLE Gender (
	GenderId TINYINT IDENTITY(1,1) PRIMARY KEY,
	GenderType NVARCHAR(50) NOT NULL CHECK (GenderType IN ('male', 'female'))
);

CREATE TABLE Customer (
	CustomerId INT IDENTITY(1,1) PRIMARY KEY,
	FirstName NVARCHAR(100) NOT NULL,
	MiddleName NVARCHAR(100),
	LastName NVARCHAR(100) NOT NULL,
	DateOfBirth DATE NOT NULL,
	GenderId TINYINT NOT NULL REFERENCES Gender(GenderId),
	CountryName NVARCHAR(100) NOT NULL,
	CityName NVARCHAR(100) NOT NULL,
	StreetName NVARCHAR(100) NOT NULL,
	StreetNumber NVARCHAR(10) NOT NULL,
	Zipcode VARCHAR(10) NOT NULL CHECK (Zipcode NOT LIKE '%[^0-9]%'),
	PhoneNumber VARCHAR(20) NOT NULL CHECK (PhoneNumber NOT LIKE '%[^0-9]%'),
	EmailAddress NVARCHAR(255) UNIQUE NOT NULL CHECK (EmailAddress LIKE '%@%.%' AND EmailAddress NOT LIKE '%@%@%'),
	AccountCreated DATE NOT NULL,
	AccountDeleted DATE DEFAULT NULL
);

CREATE TABLE Supplier (
    SupplierId TINYINT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(100) NOT NULL,
	CountryName NVARCHAR(100) NOT NULL,
	CityName NVARCHAR(100) NOT NULL,
	StreetName NVARCHAR(100) NOT NULL,
	StreetNumber NVARCHAR(10) NOT NULL,
	Zipcode VARCHAR(10) NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL CHECK (PhoneNumber NOT LIKE '%[^0-9]%'),
	EmailAddress NVARCHAR(255) UNIQUE NOT NULL CHECK (EmailAddress LIKE '%@%.%' AND EmailAddress NOT LIKE '%@%@%'),
	LogoURL NVARCHAR(255)
);

CREATE TABLE Category (
    CategoryId TINYINT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(255) NOT NULL,
	LogoURL NVARCHAR(255)
);

CREATE TABLE Product (
    ProductId SMALLINT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(255) NOT NULL,
    SupplierId TINYINT NOT NULL REFERENCES Supplier(SupplierId),
    CategoryId TINYINT  NOT NULL REFERENCES Category(CategoryId),
	LogoURL NVARCHAR(255)
);


CREATE TABLE ProductRating (
	ProductRatingId INT IDENTITY(1,1) PRIMARY KEY,
	ProductId SMALLINT NOT NULL REFERENCES Product(ProductId),
	CustomerId INT NOT NULL REFERENCES Customer(CustomerId),
	Rating TINYINT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
	RatingDate DATE NOT NULL 
);

CREATE TABLE PriceHistory (
    PriceHistoryId INT IDENTITY(1,1) PRIMARY KEY,
    ProductId SMALLINT NOT NULL FOREIGN KEY REFERENCES Product(ProductId),
    EffectiveFromDate DATE NOT NULL,
    UnitCost MONEY NOT NULL,
    UnitPrice MONEY NOT NULL,
	UNIQUE (ProductId, EffectiveFromDate)
);

CREATE TABLE CustomerOrder (
    OrderId INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId INT NOT NULL REFERENCES Customer (CustomerId),
    OrderDate DATE NOT NULL
);

CREATE TABLE OrderDetail (
	OrderDetailId INT IDENTITY(1,1) PRIMARY KEY,
    OrderId INT NOT NULL REFERENCES CustomerOrder(OrderId),
    ProductId SMALLINT NOT NULL REFERENCES Product(ProductId),
    Quantity INT NOT NULL,
    DiscountPercentage DECIMAL(5, 2)
);

CREATE TABLE ReturnReason (
    ReturnReasonId TINYINT IDENTITY(1,1) PRIMARY KEY,
    ReasonDescription NVARCHAR(255) NOT NULL
);

CREATE TABLE OrderReturn (
    OrderReturnId INT IDENTITY(1,1) PRIMARY KEY,
    OrderId INT NOT NULL REFERENCES CustomerOrder(OrderId),
    ProductId SMALLINT NOT NULL REFERENCES Product(ProductId),
    ReturnDate DATE NOT NULL,
    ReturnReasonId TINYINT NOT NULL REFERENCES ReturnReason(ReturnReasonId),
	Quantity INT NOT NULL
);

-- Inserting data
INSERT INTO Gender (GenderType) VALUES
('male'),
('female');

INSERT INTO ReturnReason (ReasonDescription) VALUES
('Product Defective'),
('Wrong Item Delivered'),
('Better Price Found Elsewhere'),
('No Longer Needed'),
('Poor Quality'),
('Ordered by Mistake');

INSERT INTO Customer (FirstName, MiddleName, LastName, DateOfBirth, GenderId, CountryName, CityName, StreetName, StreetNumber, Zipcode, PhoneNumber, EmailAddress, AccountCreated)
VALUES
('Emma', 'Maria', 'Andersson', '1995-05-15', 2, 'Sweden', 'Stockholm', 'Storgatan', '12', '11122', '0761234567', 'emma.andersson@example.com', '2023-07-02'),
('Maria', NULL, 'Berg', '1985-09-20', 2, 'Denmark', 'Copenhagen', 'Lillgatan', '8', '11133', '0709876543', 'elias.berg@example.dk', '2022-10-13'),
('Alicia', 'Johanna', 'Carlsson', '1988-11-10', 2, 'Sweden', 'Malmö', 'Lundavägen', '45', '21150', '0731122334', 'alicia.carlsson@example.com', '2022-06-27'),
('Oscar', NULL, 'Dahl', '1975-03-18', 1, 'Finland', 'Helsinki', 'Östergatan', '23', '11144', '0765566778', 'oscar.dahl@example.fi', '2024-01-07'),
('Ella', 'Elisabeth', 'Eriksson', '1992-08-25', 2, 'Norway', 'Oslo', 'Västergatan', '7', '22310', '0723344556', 'ella.eriksson@example.no', '2022-08-25'),
('Liam', NULL, 'Falk', '1983-04-30', 1, 'Sweden', 'Göteborg', 'Södregatan', '31', '41120', '0708899222', 'liam.falk@example.com', '2022-03-28'),
('Julia', 'Kristina', 'Gustafsson', '1995-01-12', 2, 'Denmark', 'Aarhus', 'Norrstigen', '14', '11155', '0761122334', 'julia.gustafsson@example.dk', '2022-06-01'),
('William', NULL, 'Håkansson', '1978-07-08', 1, 'Sweden', 'Lund', 'Västergatan', '12', '22100', '0734455667', 'william.hakansson@example.com', '2022-11-06'),
('Maja', 'Louise', 'Isaksson', '1986-12-29', 2, 'Finland', 'Espoo', 'Norrgatan', '3', '50310', '0767788990', 'maja.isaksson@example.fi', '2023-01-16'),
('Noah', NULL, 'Jansson', '1980-10-05', 1, 'Norway', 'Stavanger', 'Södergatan', '20', '50321', '0722233445', 'noah.jansson@example.no', '2022-07-12'),
('Alice', 'Maria', 'Karlsson', '1993-06-15', 2, 'Sweden', 'Helsingborg', 'Södergatan', '8', '22320', '0701122334', 'alice.karlsson@example.com', '2022-05-29'),
('Adam', NULL, 'Lindgren', '1973-02-22', 1, 'Denmark', 'Odense', 'Nygatan', '5', '41122', '0763344556', 'adam.lindgren@example.dk', '2022-12-04'),
('Wilma', 'Nathalie', 'Månsson', '1987-04-18', 2, 'Finland', 'Tampere', 'Lindströmsgatan', '17', '11177', '0736677889', 'wilma.mansson@example.fi', '2022-03-29'),
('Lucas', NULL, 'Nilsson', '1981-09-10', 1, 'Sweden', 'Malmö', 'Östergatan', '10', '21155', '0709988776', 'lucas.nilsson@example.com', '2022-10-03'),
('Ella', 'Olivia', 'Olofsson', '1996-11-05', 2, 'Norway', 'Stavanger', 'Södergatan', '5', '50320', '0761122334', 'ella.olofsson@example.no', '2022-09-14'),
('Hugo', NULL, 'Persson', '1976-05-25', 1, 'Sweden', 'Stockholm', 'Kungsgatan', '30', '11188', '0703344556', 'hugo.persson@example.com', '2022-10-25'),
('Olivia', 'Paulina', 'Pettersson', '1984-07-20', 2, 'Finland', 'Vantaa', 'Östergatan', '20', '22120', '0765566778', 'olivia.pettersson@example.fi', '2022-05-12'),
('Liam', NULL, 'Svensson', '1990-03-15', 1, 'Sweden', 'Göteborg', 'Nygatan', '8', '41125', '0738899001', 'liam.svensson@example.com', '2022-12-18'),
('Ella', 'Rebecca', 'Sjöberg', '1983-12-10', 2, 'Norway', 'Trondheim', 'Götgatan', '25', '11199', '0706677889', 'ella.sjoberg@example.no', '2023-04-02'),
('Ella', 'Kristina', 'Håkansson', '1994-11-25', 2, 'Denmark', 'Frederiksberg', 'Södergatan', '15', '41135', '0731122334', 'ella.hakansson@example.dk', '2022-07-07'),
('Liam', NULL, 'Isaksson', '1978-08-15', 1, 'Finland', 'Kuopio', 'Kungsgatan', '18', '22340', '0709988776', 'liam.isaksson@example.fi', '2022-08-29'),
('Ella', 'Maria', 'Johansson', '1991-04-30', 2, 'Sweden', 'Stockholm', 'Södergatan', '10', '11188', '0763344556', 'ella.johansson@example.com', '2022-12-23'),
('Lucas', NULL, 'Karlsson', '1976-10-05', 1, 'Norway', 'Kristiansand', 'Västergatan', '35', '22150', '0706677889', 'lucas.karlsson@example.no', '2023-01-07'),
('Alicia', 'Nathalie', 'Lindgren', '1988-01-20', 2, 'Denmark', 'Esbjerg', 'Norrgatan', '18', '50350', '0768899001', 'alicia.lindgren@example.dk', '2024-02-12'),
('Oliver', NULL, 'Månsson', '1979-12-10', 1, 'Sweden', 'Uppsala', 'Götgatan', '28', '11199', '0731122334', 'oliver.mansson@example.com', '2023-11-22'),
('Maja', 'Olivia', 'Nilsson', '1985-07-05', 2, 'Finland', 'Lahti', 'Östergatan', '15', '21180', '0703344556', 'maja.nilsson@example.fi', '2022-06-25'),
('William', NULL, 'Olofsson', '1990-11-20', 1, 'Norway', 'Drammen', 'Södergatan', '12', '41140', '0765566778', 'william.olofsson@example.no', '2024-01-20'),
('Elsa', 'Paulina', 'Persson', '1983-02-15', 2, 'Denmark', 'Helsingør', 'Kungsgatan', '8', '11166', '0738899001', 'elsa.persson@example.dk', '2023-04-24'),
('Liam', NULL, 'Pettersson', '1977-04-10', 1, 'Finland', 'Oulu', 'Norrstigen', '12', '22350', '0701122334', 'liam.pettersson@example.fi', '2022-12-11'),
('Oliver', NULL, 'Svensson', '1980-12-10', 1, 'Sweden', 'Stockholm', 'Södergatan', '18', '11122', '0735566778', 'oliver.svensson@example.com', '2024-03-14'),
('Oliver', NULL, 'Dahl', '1985-05-05', 1, 'Norway', 'Fredrikstad', 'Nygatan', '20', '22360', '0705566778', 'oliver.dahl@example.no', '2023-07-05'),
('Maja', 'Elin', 'Eriksson', '1991-12-20', 2, 'Denmark', 'Aalborg', 'Norrgatan', '10', '50370', '0769988776', 'maja.eriksson@example.dk', '2022-12-27'),
('Wilma', 'Nathalie', 'Hansson', '1995-03-25', 2, 'Finland', 'Turku', 'Kungsgatan', '5', '11155', '0731122334', 'wilma.hansson@example.fi', '2022-07-12'),
('Lucas', NULL, 'Hermansson', '1983-08-10', 1, 'Sweden', 'Malmö', 'Södergatan', '12', '21150', '0703344556', 'lucas.hermansson@example.com', '2023-04-17'),
('Ella', 'Maria', 'Holm', '1980-01-05', 2, 'Norway', 'Alesund', 'Västergatan', '30', '41160', '0765566778', 'ella.holm@example.no', '2023-12-10'),
('Olivia', 'Paulina', 'Jonsson', '1989-07-15', 2, 'Denmark', 'Randers', 'Norrstigen', '20', '11155', '0761122334', 'olivia.jonsson@example.dk', '2022-11-10'),
('Elias', NULL, 'Karlsson', '1982-10-30', 1, 'Finland', 'Hämeenlinna', 'Södergatan', '22', '21160', '0733344556', 'elias.karlsson@example.fi', '2023-02-15'),
('Ella', 'Linnéa', 'Larsson', '1994-04-05', 2, 'Norway', 'Tromsø', 'Kungsgatan', '15', '41135', '0709988776', 'ella.larsson@example.no', '2023-06-03'),
('Liam', NULL, 'Lind', '1978-11-20', 1, 'Sweden', 'Linköping', 'Västergatan', '8', '11166', '0765566778', 'liam.lind@example.com', '2022-07-20'),
('Ella', 'Maria', 'Lund', '1987-01-15', 2, 'Denmark', 'Kolding', 'Norrgatan', '28', '22150', '0731122334', 'ella.lund@example.dk', '2023-04-11'),
('Oliver', NULL, 'Mårtensson', '1980-06-10', 1, 'Finland', 'Jyväskylä', 'Södergatan', '10', '50350', '0703344556', 'oliver.martensson@example.fi', '2024-01-26'),
('Maja', 'Nathalie', 'Nyström', '1985-03-25', 2, 'Sweden', 'Västerås', 'Östergatan', '18', '11199', '0769988776', 'maja.nystrom@example.com', '2023-08-19'),
('William', NULL, 'Persson', '1990-12-10', 1, 'Norway', 'Moss', 'Götgatan', '30', '21170', '0706677889', 'william.persson@example.no', '2022-11-04'),
('Elsa', 'Olivia', 'Petersson', '1983-07-05', 2, 'Finland', 'Kotka', 'Norrstigen', '10', '41140', '0738899001', 'elsa.petersson@example.fi', '2023-08-27'),
('Liam', NULL, 'Sjöberg', '1977-09-25', 1, 'Denmark', 'Slagelse', 'Södergatan', '18', '11122', '0763344556', 'liam.sjoberg@example.dk', '2022-07-11'),
('Ella', 'Rebecca', 'Svensson', '1994-12-10', 2, 'Sweden', 'Helsingborg', 'Lindströmsgatan', '22', '22360', '0705566778', 'ella.svensson@example.com', '2023-02-01'),
('Oliver', NULL, 'Wahlström', '1979-05-05', 1, 'Finland', 'Vaasa', 'Södergatan', '5', '50360', '0761122334', 'oliver.wahlstrom@example.fi', '2022-09-05'),
('Maja', 'Maria', 'Andersson', '1989-07-05', 2, 'Norway', 'Sarpsborg', 'Östergatan', '25', '21190', '0708899222', 'maja.andersson@example.no', '2022-09-08'),
('William', NULL, 'Berg', '1974-09-20', 1, 'Sweden', 'Umeå', 'Lundavägen', '35', '11133', '0761122334', 'william.berg@example.com', '2023-06-01'),
('Lucas', NULL, 'Magnusson', '1984-03-05', 1, 'Sweden', 'Karlstad', 'Lindströmsgatan', '11', '65230', '0734455667', 'lucas.magnusson@example.com', '2022-09-19');



INSERT INTO Category (CategoryName, Description, LogoURL) VALUES
('Beans', 'Whole coffee beans', 'https://i.postimg.cc/MKRnFmCY/beans.jpg'),
('Ground', 'Ground coffee for various brewing methods', 'https://i.postimg.cc/RZBW5n9x/ground.jpg'),
('Pods', 'Coffee pods for quick brewing machines', 'https://i.postimg.cc/qvxzkMMh/pods.jpg');

INSERT INTO Supplier (SupplierName, CountryName, CityName, StreetName, StreetNumber, Zipcode, PhoneNumber, EmailAddress, LogoURL) VALUES
('Brewtopia', 'Sweden', 'Stockholm', 'Bean Street', '1', '10001', '0123456789', 'contact@brewtopia.se', 'https://i.postimg.cc/KzkGgZF5/Brewtopia.png'),
('Java Estates', 'Norway', 'Oslo', 'Grind Lane', '2', '10002', '0123456790', 'info@javaestates.no', 'https://i.postimg.cc/4NbJc2Cj/Java-Estates.png'),
('Roasters Guild', 'Denmark', 'Copenhagen', 'Roast Road', '3', '10003', '0123456791', 'support@roastersguild.dk', 'https://i.postimg.cc/v8n8YH0Y/Roasters-Guild.png'),
('Bean There', 'Finland', 'Helsinki', 'Brew Avenue', '4', '10004', '0123456792', 'sales@beanthere.fi', 'https://i.postimg.cc/FKnFRftR/Bean-There.png'),
('Aroma Mocha', 'Germany', 'Berlin', 'Espresso Way', '5', '10005', '0123456793', 'hello@aromamocha.de', 'https://i.postimg.cc/mgj2vX87/Aroma-Mocha.png'),
('Daily Grind', 'France', 'Paris', 'Filter Street', '6', '10006', '0123456794', 'contact@dailygrind.fr', 'https://i.postimg.cc/C13FGWxp/Daily-Grind.png'),
('Pure Beans', 'Italy', 'Rome', 'Coffee Place', '7', '10007', '0123456795', 'info@purebeans.it', 'https://i.postimg.cc/7YyHf8Rg/Pure-Beans.png'),
('Urban Roast', 'Spain', 'Madrid', 'Caffeine Blvd', '8', '10008', '0123456796', 'support@urbanroast.es', 'https://i.postimg.cc/t4p4mQtX/Urban-Roast.png'),
('Espresso Lab', 'United Kingdom', 'London', 'Barista Court', '9', '10009', '0123456797', 'sales@espressolab.co.uk', 'https://i.postimg.cc/x8L9ttXJ/Espresso-Lab.png'),
('Cup ''o Joe', 'Ireland', 'Dublin', 'Brewer Lane', '10', '10010', '0123456798', 'hello@cupojoe.ie', 'https://i.postimg.cc/SKKNk6v3/Cup-o-Joe.png');

INSERT INTO Product (ProductName, SupplierId, CategoryId, LogoURL) VALUES
('Arabica Beans', 1, 1, 'https://i.postimg.cc/hPgSKXNJ/Arabica-Beans.jpg'),
('Robusta Beans', 2, 1, 'https://i.postimg.cc/yxC7gxdb/Robusta-Beans.jpg'),
('Columbian Ground', 3, 2, 'https://i.postimg.cc/vBgmxCvc/Columbian-Ground.jpg'),
('Espresso Roast', 4, 2, 'https://i.postimg.cc/dV63b21t/Espresso-Roast.jpg'),
('Italian Espresso Pods', 5, 3, 'https://i.postimg.cc/6pM6jBj8/Italian-Espresso-Pods.jpg'),
('French Vanilla Pods', 6, 3, 'https://i.postimg.cc/MK8GXPfp/French-Vanilla-Pods.jpg'),
('Brazilian Dark Roast', 7, 2, 'https://i.postimg.cc/CLNw5FVc/Brazilian-Dark-Roast.jpg'),
('Decaf Beans', 8, 1, 'https://i.postimg.cc/tgmTT9WK/Decaf-Beans.jpg'),
('Caramel Macchiato Pods', 9, 3, 'https://i.postimg.cc/133sNLms/Caramel-Macchiato-Pods.jpg'),
('Arabica Ground', 1, 2, 'https://i.postimg.cc/XN9jMf1S/Arabica-Ground.jpg'),
('Sumatra Beans', 2, 1, 'https://i.postimg.cc/pd7Wvqtx/Samatra-Bean.jpg'),
('Ethiopian Beans', 3, 1, 'https://i.postimg.cc/GtvhqYVR/Ethiopian-Beans.jpg'),
('Morning Blend Ground', 4, 2, 'https://i.postimg.cc/W4tNxxCX/Morning-Blend-Ground.jpg'),
('Irish Cream Pods', 5, 3, 'https://i.postimg.cc/T3dYJK98/Irish-Cream-Pods.jpg'),
('Hazelnut Ground', 6, 2, 'https://i.postimg.cc/1RFtmhtd/Hazelnut-Ground.jpg'),
('Mocha Java Beans', 7, 1, 'https://i.postimg.cc/bNHwnx1H/Mocha-Java-Beans.jpg'),
('Peaberry Beans', 8, 1, 'https://i.postimg.cc/3RvKxmKG/Peaberry-Beans.jpg'),
('Cinnamon Spice Ground', 9, 2, 'https://i.postimg.cc/QdhVY4jy/Cinnamon-Spice-Ground.jpg'),
('Espresso Blend Pods', 10, 3, 'https://i.postimg.cc/Zqqn4WBP/Espresso-Blend-Pods.jpg'),
('Gourmet Blend Beans', 10, 1, 'https://i.postimg.cc/852zRwyw/Gourmet-Blend-Beans.jpg'),
('Chocolate Flavored Ground', 10, 2, 'https://i.postimg.cc/PrmP4snD/Chocolate-Flavored-Ground.jpg'),
('Variety Pack Pods', 1, 3, 'https://i.postimg.cc/SRLkW4YN/Variety-Pack-Pods.jpg');

INSERT INTO PriceHistory (ProductId, EffectiveFromDate, UnitCost, UnitPrice) VALUES
(1, '2022-02-01', 80.00, 100.00),
(1, '2022-09-15', 86.00, 112.00),
(1, '2023-06-30', 92.00, 124.00),
(1, '2023-09-12', 98.00, 136.00),
(1, '2023-11-25', 104.00, 148.00),
(1, '2024-04-01', 110.00, 160.00),

(2, '2022-02-01', 80.00, 100.00),
(2, '2022-09-03', 85.50, 111.50),
(2, '2023-06-05', 91.00, 123.00),
(2, '2023-08-07', 96.50, 134.50),
(2, '2023-10-09', 102.00, 146.00),
(2, '2024-04-01', 107.50, 157.50),

(3, '2022-02-01', 80.00, 100.00),
(3, '2022-10-20', 86.00, 111.20),
(3, '2023-07-09', 92.00, 121.00),
(3, '2023-09-27', 98.00, 134.50),
(3, '2023-12-16', 104.00, 146.00),
(3, '2024-04-01', 110.00, 167.50),

(4, '2022-02-01', 80.00, 100.00),
(4, '2022-09-25', 84.50, 105.50),
(4, '2023-05-19', 90.00, 115.00),
(4, '2023-07-13', 95.50, 120.00),
(4, '2023-09-06', 100.00, 125.00),
(4, '2024-04-01', 105.50, 150.00),

(5, '2022-02-01', 80.00, 100.00),
(5, '2022-10-05', 85.50, 105.50),
(5, '2023-06-09', 91.00, 110.00),
(5, '2023-08-13', 96.50, 115.50),
(5, '2023-10-17', 102.00, 120.00),
(5, '2024-04-01', 107.50, 155.50),

(6, '2022-02-01', 80.00, 100.00),
(6, '2022-09-03', 82.50, 102.50),
(6, '2023-04-05', 85.00, 105.00),
(6, '2023-05-07', 87.50, 107.50),
(6, '2023-06-09', 90.00, 110.00),
(6, '2024-04-01', 92.50, 140.00),

(7, '2022-02-01', 80.00, 100.00),
(7, '2022-10-10', 83.00, 105.00),
(7, '2023-04-19', 86.00, 110.00),
(7, '2023-05-28', 89.00, 115.00),
(7, '2023-11-06', 92.00, 120.00),
(7, '2024-04-01', 95.00, 150.00),

(8, '2022-02-01', 80.00, 100.00),
(8, '2022-09-15', 83.50, 105.50),
(8, '2023-04-29', 87.00, 110.00),
(8, '2023-06-12', 90.50, 112.50),
(8, '2023-07-26', 94.00, 115.00),
(8, '2024-04-01', 97.50, 152.50),

(9, '2022-02-01', 80.00, 100.00),
(9, '2022-11-22', 84.00, 105.00),
(9, '2023-05-03', 88.00, 110.00),
(9, '2023-08-14', 92.00, 115.00),
(9, '2023-11-25', 96.00, 120.00),
(9, '2024-04-01', 100.00, 155.00),

(10, '2022-02-01', 80.00, 100.00),
(10, '2022-09-27', 84.00, 104.00),
(10, '2023-05-24', 88.00, 108.00),
(10, '2023-07-21', 92.00, 112.00),
(10, '2023-11-17', 96.00, 116.00),
(10, '2024-04-01', 100.00, 160.00),

(11, '2022-02-01', 80.00, 100.00),
(11, '2022-09-01', 85.00, 105.00),
(11, '2023-06-01', 90.00, 110.00),
(11, '2023-08-01', 95.00, 115.00),
(11, '2023-10-01', 100.00, 120.00),
(11, '2024-04-01', 105.00, 155.00),

(12, '2022-02-01', 80.00, 100.00),
(12, '2022-10-05', 85.50, 105.50),
(12, '2023-06-09', 91.00, 110.00),
(12, '2023-08-13', 96.50, 115.50),
(12, '2023-10-17', 102.00, 120.00),
(12, '2024-04-01', 105.00, 135.00),

(13, '2022-02-01', 80.00, 100.00),
(13, '2022-09-10', 85.00, 105.00),
(13, '2023-06-19', 90.00, 110.00),
(13, '2023-08-28', 95.00, 115.00),
(13, '2023-10-26', 100.00, 120.00),
(13, '2024-04-01', 105.00, 155.00),

(14, '2022-02-01', 80.00, 100.00),
(14, '2022-10-15', 85.50, 105.50),
(14, '2023-06-20', 91.00, 110.00),
(14, '2023-08-25', 96.50, 115.50),
(14, '2023-11-30', 102.00, 120.00),
(14, '2024-04-01', 107.50, 160.00),

(15, '2022-02-01', 80.00, 100.00),
(15, '2022-09-20', 85.50, 105.50),
(15, '2023-06-30', 91.00, 110.00),
(15, '2023-09-08', 96.50, 115.50),
(15, '2023-11-17', 102.00, 120.00),
(15, '2024-04-01', 107.50, 160.00),

(16, '2022-02-01', 80.00, 100.00),
(16, '2022-10-25', 85.50, 105.50),
(16, '2023-07-01', 91.00, 110.00),
(16, '2023-09-06', 96.50, 115.50),
(16, '2023-11-11', 102.00, 120.00),
(16, '2024-04-01', 107.50, 160.00),

(17, '2022-02-01', 80.00, 100.00),
(17, '2022-10-01', 85.50, 105.50),
(17, '2023-07-09', 91.00, 110.00),
(17, '2023-09-17', 96.50, 115.50),
(17, '2023-11-25', 102.00, 120.00),
(17, '2024-04-01', 107.50, 160.00),

(18, '2022-02-01', 80.00, 100.00),
(18, '2022-10-07', 85.50, 105.50),
(18, '2023-07-15', 91.00, 110.00),
(18, '2023-09-23', 96.50, 115.50),
(18, '2023-11-30', 102.00, 120.00),
(18, '2024-04-01', 107.50, 160.00),

(19, '2022-02-01', 80.00, 100.00),
(19, '2022-09-13', 85.50, 105.50),
(19, '2023-07-22', 91.00, 110.00),
(19, '2023-09-30', 96.50, 115.50),
(19, '2023-12-08', 102.00, 120.00),
(19, '2024-04-01', 107.50, 160.00),

(20, '2022-02-01', 80.00, 100.00),
(20, '2022-09-19', 85.50, 105.50),
(20, '2023-07-28', 91.00, 110.00),
(20, '2023-10-05', 96.50, 115.50),
(20, '2023-12-12', 102.00, 120.00),
(20, '2024-04-01', 107.50, 160.00),

(21, '2022-02-01', 80.00, 100.00),
(21, '2022-10-25', 85.50, 105.50),
(21, '2023-03-03', 91.00, 110.00),
(21, '2023-10-11', 96.50, 115.50),
(21, '2023-12-19', 102.00, 120.00),
(21, '2024-04-01', 107.50, 160.00),

(22, '2022-02-01', 80.00, 100.00),
(22, '2022-09-01', 85.50, 105.50),
(22, '2023-03-11', 91.00, 110.00),
(22, '2023-6-21', 96.50, 115.50),
(22, '2023-10-01', 102.00, 120.00),
(22, '2024-04-01', 107.50, 160.00);

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (1, '2023-08-17');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (1, '2023-07-02');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (1, '2023-11-22');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (1, '2023-12-22');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (1, '2024-01-22');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (1, '2023-08-22');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (2, '2023-04-30');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (2, '2022-10-15');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (3, '2022-06-27');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (3, '2023-03-14');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (3, '2022-09-11');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (3, '2024-03-29');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (4, '2024-01-07');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (4, '2024-02-07');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (5, '2022-08-25');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (5, '2024-03-19');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (6, '2023-06-10');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (6, '2022-03-28');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (6, '2024-01-12');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (7, '2022-12-09');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (7, '2023-10-04');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (7, '2023-02-18');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (7, '2022-06-01');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (7, '2024-02-14');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (7, '2024-03-14');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (7, '2024-03-22');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (8, '2023-01-28');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (8, '2024-03-15');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (8, '2022-11-06');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (8, '2023-09-20');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (9, '2023-08-03');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (9, '2023-01-16');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (10, '2023-12-22');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (10, '2022-07-12');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (10, '2024-03-06');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (10, '2023-10-01');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (11, '2022-05-29');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (11, '2023-03-11');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (11, '2024-01-27');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (11, '2022-09-15');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (12, '2023-08-17');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (12, '2022-12-04');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (12, '2023-05-20');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (12, '2024-03-08');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (13, '2022-11-26');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (13, '2023-10-13');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (13, '2022-03-29');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (13, '2024-01-14');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (14, '2023-07-09');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (14, '2023-04-21');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (14, '2022-10-03');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (14, '2024-03-18');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (15, '2023-01-31');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (15, '2022-09-14');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (15, '2023-05-02');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (15, '2024-03-17');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (16, '2023-12-11');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (16, '2023-06-24');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (16, '2024-01-08');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (16, '2022-10-25');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (17, '2023-08-30');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (17, '2022-05-12');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (17, '2024-03-26');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (18, '2022-12-18');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (18, '2023-09-29');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (18, '2023-05-13');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (19, '2023-04-02');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (19, '2023-11-17');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (20, '2023-10-11');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (20, '2024-02-24');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (20, '2022-07-07');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (21, '2023-05-01');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (21, '2024-01-15');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (21, '2022-08-29');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (21, '2023-02-12');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (21, '2023-02-12');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (22, '2022-12-23');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (22, '2023-08-05');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (22, '2024-02-20');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (23, '2023-01-07');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (23, '2022-05-21');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (23, '2023-10-05');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (24, '2024-01-16');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (24, '2024-03-29');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (24, '2024-02-12');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (24, '2024-03-14');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (24, '2024-03-12');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (24, '2023-09-01');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (24, '2024-01-22');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (25, '2024-02-06');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (25, '2023-11-22');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (26, '2023-03-13');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (26, '2022-06-25');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (26, '2024-02-07');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (27, '2024-03-24');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (27, '2024-03-05');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (27, '2024-01-20');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (28, '2024-02-10');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (28, '2023-04-24');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (28, '2023-11-06');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (28, '2024-03-19');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (29, '2023-06-28');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (29, '2022-12-11');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (29, '2024-01-25');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (29, '2024-02-25');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (29, '2023-11-25');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (29, '2023-11-21');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (29, '2023-10-25');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (30, '2023-03-22');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (30, '2022-03-21');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (30, '2024-03-14');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (31, '2023-07-05');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (31, '2023-10-19');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (31, '2024-03-04');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (32, '2022-12-27');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (32, '2023-09-09');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (32, '2023-02-23');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (32, '2024-02-23');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (32, '2024-01-13');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (32, '2023-06-23');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (32, '2024-01-22');


INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (33, '2023-08-14');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (33, '2024-01-28');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (33, '2022-07-12');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (34, '2024-03-03');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (34, '2023-04-17');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (34, '2023-11-01');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (34, '2024-03-16');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (35, '2023-12-10');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (35, '2024-03-24');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (35, '2024-01-07');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (35, '2024-03-22');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (35, '2024-01-07');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (35, '2024-01-08');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (35, '2024-02-07');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (35, '2024-03-07');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (35, '2024-01-17');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (35, '2024-03-22');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (35, '2024-03-07');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (36, '2023-07-29');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (36, '2022-11-10');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (36, '2024-03-25');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (37, '2023-02-15');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (37, '2024-01-28');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (37, '2023-11-12');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (37, '2024-01-26');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (37, '2024-03-26');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (37, '2024-03-26');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (38, '2023-06-03');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (38, '2023-02-17');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (38, '2024-03-02');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (38, '2024-01-02');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (38, '2024-03-02');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (39, '2023-10-22');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (39, '2023-02-04');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (39, '2022-07-20');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (40, '2023-04-11');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (40, '2023-11-25');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (41, '2024-03-30');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (41, '2024-03-12');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (41, '2024-01-26');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (41, '2024-03-12');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (42, '2023-08-19');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (42, '2024-02-01');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (42, '2023-10-15');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (43, '2023-12-08');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (43, '2023-05-21');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (43, '2022-11-04');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (43, '2024-01-04');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (43, '2023-11-04');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (43, '2022-11-14');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (44, '2023-08-27');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (44, '2024-03-10');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (44, '2023-02-24');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (45, '2023-02-14');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (45, '2023-10-28');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (45, '2022-07-11');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (45, '2024-01-25');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (46, '2023-12-03');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (46, '2023-09-17');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (46, '2023-02-01');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (47, '2023-05-23');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (47, '2022-09-05');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (47, '2024-02-18');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (47, '2024-02-11');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (47, '2024-03-19');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (48, '2023-12-12');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (48, '2023-05-26');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (48, '2022-09-08');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (49, '2023-06-01');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (49, '2023-07-15');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (49, '2023-11-29');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (49, '2024-03-12');

INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (50, '2023-07-18');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (50, '2023-03-02');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (50, '2023-11-16');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (50, '2024-01-30');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (50, '2024-03-21');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (50, '2024-02-20');
INSERT INTO CustomerOrder (CustomerId, OrderDate) VALUES (50, '2024-03-15');

INSERT INTO OrderDetail (OrderId, ProductId, Quantity, DiscountPercentage) VALUES
(1, 3, 8, 0), (1, 19, 5, 5.00), 
(2, 4, 2, 0), (2, 7, 1, 0), 
(3, 15, 6, 0), (3, 21, 4, 2.50), 
(4, 9, 3, 0), 
(5, 6, 1, 0), (5, 11, 2, 0), 
(6, 20, 2, 0), (6, 5, 3, 0), (6, 13, 4, 2.00), 
(7, 22, 5, 0), (7, 17, 2, 0), (7, 1, 1, 0), (7, 12, 6, 5.00), (7, 14, 3, 0), 
(8, 2, 4, 0), (8, 18, 1, 0), (8, 10, 3, 0), (8, 8, 2, 0), 
(9, 16, 7, 0), (9, 21, 2, 0), 
(10, 20, 1, 0), (10, 15, 4, 0), (10, 5, 3, 0), (10, 11, 2, 0), 
(11, 22, 3, 0), (11, 17, 1, 0), (11, 1, 2, 0), (11, 12, 4, 3.00), 
(12, 2, 5, 0), (12, 18, 2, 0), (12, 10, 3, 0), (12, 8, 1, 0), 
(13, 16, 6, 0), (13, 21, 4, 0), (13, 9, 3, 0), (13, 19, 2, 2.50), 
(14, 20, 1, 0), (14, 15, 4, 0), (14, 5, 3, 0), (14, 11, 2, 0), 
(15, 22, 3, 0), (15, 17, 1, 0), (15, 1, 2, 0), (15, 12, 4, 0), 
(16, 2, 5, 0), (16, 18, 2, 0), (16, 10, 3, 0), (16, 8, 1, 0), 
(17, 16, 6, 0), (17, 21, 4, 0), (17, 9, 3, 0), (17, 19, 2, 0), 
(18, 20, 1, 0), (18, 15, 4, 0), (18, 5, 3, 0), (18, 11, 2, 0), 
(19, 22, 3, 0), (19, 17, 1, 0), (19, 1, 2, 0), (19, 12, 4, 0), 
(20, 2, 5, 0), (20, 18, 2, 0), (20, 10, 3, 0), (20, 8, 1, 0), 
(21, 16, 6, 0), (21, 21, 4, 0), (21, 9, 3, 0), (21, 19, 2, 0),
(22, 20, 1, 0), (22, 15, 4, 0), (22, 5, 3, 0), (22, 11, 2, 0), 
(23, 22, 3, 0), (23, 17, 1, 0), (23, 1, 2, 0), (23, 12, 4, 0), 
(24, 2, 5, 0), (24, 18, 2, 0), (24, 10, 3, 0), (24, 8, 1, 0), 
(25, 16, 6, 0), (25, 21, 4, 0), (25, 9, 3, 0), (25, 19, 2, 0), 
(26, 20, 1, 0), (26, 15, 4, 0), (26, 5, 3, 0), (26, 11, 2, 0), 
(27, 22, 3, 0), (27, 17, 1, 0), (27, 1, 2, 0), (27, 12, 4, 0), 
(28, 2, 5, 0), (28, 18, 2, 0), (28, 10, 3, 0), (28, 8, 1, 0), 
(29, 16, 6, 0), (29, 21, 4, 0), (29, 9, 3, 0), (29, 19, 2, 0), 
(30, 20, 1, 0), (30, 15, 4, 0), (30, 5, 3, 0), (30, 11, 2, 0), 
(31, 22, 3, 0), (31, 17, 1, 0), (31, 1, 2, 0), (31, 12, 4, 0), 
(32, 2, 5, 0), (32, 18, 2, 0), (32, 10, 3, 0), (32, 8, 1, 0), 
(33, 16, 6, 0), (33, 21, 4, 0), (33, 9, 3, 0), (33, 19, 2, 0), 
(34, 20, 1, 0), (34, 15, 4, 0), (34, 5, 3, 0), (34, 11, 2, 0), 
(35, 22, 3, 0), (35, 17, 1, 0), (35, 1, 2, 0), (35, 12, 4, 0), 
(36, 2, 5, 0), (36, 18, 2, 0), (36, 10, 3, 0), (36, 8, 1, 0), 
(37, 16, 6, 0), (37, 21, 4, 0), (37, 9, 3, 0), (37, 19, 2, 0), 
(38, 20, 1, 0), (38, 15, 4, 0), (38, 5, 3, 0), (38, 11, 2, 0), 
(39, 22, 3, 0), (39, 17, 1, 0), (39, 1, 2, 0), (39, 12, 4, 0), 
(40, 2, 5, 0), (40, 18, 2, 0), (40, 10, 3, 0), (40, 8, 1, 0), 
(41, 16, 6, 0), (41, 21, 4, 0), (41, 9, 3, 0), (41, 19, 2, 0), 
(42, 20, 1, 0), (42, 15, 4, 0), (42, 5, 3, 0), (42, 11, 2, 0), 
(43, 22, 3, 0), (43, 17, 1, 0), (43, 1, 2, 0), (43, 12, 4, 0), 
(44, 2, 5, 0), (44, 18, 2, 0), (44, 10, 3, 0), (44, 8, 1, 0), 
(45, 16, 6, 0), (45, 21, 4, 0), (45, 9, 3, 0), (45, 19, 2, 0), 
(46, 20, 1, 0), (46, 15, 4, 0), (46, 5, 3, 0), (46, 11, 2, 0), 
(47, 22, 3, 0), (47, 17, 1, 0), (47, 1, 2, 0), (47, 12, 4, 0), 
(48, 2, 5, 0), (48, 18, 2, 0), (48, 10, 3, 0), (48, 8, 1, 0), 
(49, 16, 6, 0), (49, 21, 4, 0), (49, 9, 3, 0), (49, 19, 2, 0), 
(50, 20, 1, 0), (50, 15, 4, 0), (50, 5, 3, 0), (50, 11, 2, 0),
(51, 17, 2, 0), (51, 6, 4, 0),
(52, 21, 5, 0), (52, 2, 1, 3.00),
(53, 3, 7, 0), (53, 12, 2, 0),
(54, 11, 4, 5.00), (54, 8, 3, 0),
(55, 10, 6, 0), (55, 18, 2, 0),
(56, 22, 3, 0), (56, 13, 4, 2.50),
(57, 14, 5, 0), (57, 1, 2, 0),
(58, 9, 1, 0), (58, 20, 3, 0),
(59, 16, 4, 0), (59, 5, 2, 0),
(60, 15, 6, 0), (60, 7, 2, 0),
(61, 19, 4, 0), (61, 4, 1, 0),
(62, 22, 2, 0), (62, 3, 3, 0),
(63, 14, 5, 0), (63, 6, 1, 0),
(64, 11, 2, 0), (64, 18, 3, 0),
(65, 10, 1, 0), (65, 8, 4, 4.00),
(66, 5, 6, 0), (66, 12, 2, 0),
(67, 21, 3, 0), (67, 9, 4, 0),
(68, 17, 5, 0), (68, 20, 2, 0),
(69, 15, 1, 0), (69, 13, 3, 0),
(70, 7, 4, 0), (70, 19, 2, 0),
(71, 16, 2, 0), (71, 1, 3, 0),
(72, 22, 5, 0), (72, 2, 1, 0),
(73, 14, 6, 0), (73, 4, 2, 0),
(74, 11, 3, 0), (74, 5, 4, 5.00),
(75, 10, 2, 0), (75, 18, 3, 0),
(76, 9, 1, 0), (76, 21, 4, 0),
(77, 17, 2, 0), (77, 13, 3, 0),
(78, 20, 4, 0), (78, 7, 1, 0),
(79, 16, 6, 0), (79, 19, 2, 0),
(80, 15, 3, 0), (80, 3, 4, 0),
(81, 14, 2, 0), (81, 6, 1, 0),
(82, 12, 5, 0), (82, 8, 2, 0),
(83, 22, 4, 0), (83, 1, 3, 0),
(84, 9, 1, 0), (84, 20, 2, 0),
(85, 11, 3, 0), (85, 18, 4, 0),
(86, 10, 5, 0), (86, 21, 2, 0),
(87, 13, 6, 0), (87, 17, 1, 0),
(88, 7, 2, 0), (88, 19, 4, 0),
(89, 16, 1, 0), (89, 15, 3, 0),
(90, 4, 2, 0), (90, 2, 3, 0),
(91, 5, 4, 0), (91, 12, 1, 0),
(92, 9, 2, 0), (92, 22, 5, 0),
(93, 8, 1, 0), (93, 18, 3, 0),
(94, 11, 4, 0), (94, 20, 2, 0),
(95, 10, 1, 0), (95, 17, 3, 0),
(96, 13, 5, 0), (96, 14, 2, 0),
(97, 6, 1, 0), (97, 19, 4, 0),
(98, 21, 3, 0), (98, 7, 2, 0),
(99, 16, 4, 0), (99, 15, 1, 0),
(100, 2, 3, 0), (100, 5, 2, 0),
(101, 4, 2, 0), (101, 22, 3, 0), (101, 17, 1, 0),
(102, 13, 6, 0), (102, 1, 1, 0), (102, 5, 4, 0), (102, 21, 2, 0),
(103, 18, 2, 0), (103, 9, 4, 0), (103, 15, 3, 0),
(104, 12, 3, 0), (104, 21, 2, 0),
(105, 17, 5, 0), (105, 6, 1, 0), (105, 2, 7, 5.00),
(106, 20, 4, 0), (106, 10, 2, 0), (106, 3, 2, 0), (106, 14, 5, 0),
(107, 8, 1, 0), (107, 15, 3, 0), (107, 11, 4, 0),
(108, 11, 2, 0), (108, 19, 4, 0), (108, 22, 1, 0),
(109, 5, 6, 0), (109, 14, 1, 0), (109, 18, 3, 0),
(110, 7, 2, 0), (110, 16, 4, 0),
(111, 12, 5, 0), (111, 8, 2, 0),
(112, 21, 1, 0), (112, 4, 3, 0), (112, 9, 2, 0),
(113, 20, 4, 0), (113, 10, 1, 0),
(114, 13, 5, 0), (114, 1, 3, 0),
(115, 17, 2, 0), (115, 6, 4, 0),
(116, 22, 1, 0), (116, 19, 3, 0), (116, 15, 2, 0),
(117, 14, 6, 0), (117, 9, 2, 0),
(118, 11, 1, 0), (118, 18, 4, 0),
(119, 12, 3, 0), (119, 21, 2, 0),
(120, 16, 5, 0), (120, 5, 1, 0),
(121, 4, 2, 0), (121, 7, 3, 0), (121, 10, 2, 0),
(122, 13, 6, 0), (122, 1, 1, 0),
(123, 18, 2, 0), (123, 9, 4, 0),
(124, 12, 3, 0), (124, 21, 2, 0),
(125, 17, 5, 0), (125, 6, 1, 0),
(126, 20, 4, 0), (126, 10, 2, 0),
(127, 8, 1, 0), (127, 15, 3, 0),
(128, 11, 2, 0), (128, 19, 4, 0),
(129, 5, 6, 0), (129, 14, 1, 0),
(130, 7, 2, 0), (130, 16, 4, 0),
(131, 3, 4, 0), (131, 10, 2, 2.50), (131, 22, 1, 5.00),
(132, 7, 5, 0), (132, 14, 3, 0),
(133, 11, 2, 0), (133, 19, 4, 3.00), (133, 5, 1, 0),
(134, 20, 6, 0), (134, 8, 2, 0),
(135, 16, 3, 0), (135, 1, 4, 4.00),
(136, 12, 2, 0), (136, 9, 5, 0),
(137, 18, 1, 0), (137, 6, 3, 0), (137, 21, 1, 0),
(138, 15, 4, 0), (138, 2, 2, 0),
(139, 17, 5, 5.00), (139, 13, 2, 0),
(140, 4, 6, 0), (140, 21, 1, 0),
(141, 22, 2, 0), (141, 10, 3, 0),
(142, 14, 4, 0), (142, 7, 1, 0),
(143, 19, 2, 0), (143, 11, 3, 0),
(144, 5, 5, 0), (144, 20, 1, 0),
(145, 9, 3, 0), (145, 16, 2, 0),
(146, 1, 4, 0), (146, 12, 2, 2.50),
(147, 21, 6, 0), (147, 18, 1, 0),
(148, 15, 3, 0), (148, 8, 2, 0),
(149, 17, 5, 0), (149, 13, 2, 3.00),
(150, 4, 1, 0), (150, 19, 3, 0),
(151, 22, 4, 0), (151, 10, 1, 0),
(152, 14, 2, 0), (152, 7, 3, 0),
(153, 19, 1, 0), (153, 11, 4, 0),
(154, 5, 6, 0), (154, 20, 2, 0),
(155, 9, 2, 0), (155, 16, 5, 0),
(156, 1, 3, 0), (156, 12, 1, 0),
(157, 21, 4, 0), (157, 18, 2, 5.00),
(158, 15, 3, 0), (158, 8, 1, 0),
(159, 17, 2, 0), (159, 13, 4, 0),
(160, 4, 6, 0), (160, 20, 1, 0),
(161, 22, 2, 0), (161, 10, 5, 0),
(162, 14, 1, 0), (162, 7, 3, 0),
(163, 19, 4, 0), (163, 11, 2, 0),
(164, 5, 5, 0), (164, 20, 1, 0),
(165, 9, 3, 0), (165, 16, 4, 0),
(166, 1, 2, 0), (166, 12, 3, 0),
(167, 21, 1, 0), (167, 18, 6, 5.00),
(168, 15, 4, 0), (168, 8, 2, 0),
(169, 17, 3, 0), (169, 13, 1, 0),
(170, 4, 2, 0), (170, 21, 5, 0),
(171, 20, 3, 0), (171, 21, 2, 0), (171, 5, 4, 5.00),
(172, 21, 6, 0), (172, 5, 1, 0),
(173, 20, 2, 0), (173, 21, 3, 3.00), (173, 5, 2, 0),
(174, 20, 1, 0), (174, 5, 4, 0),
(175, 21, 3, 0), (175, 20, 2, 0), (175, 5, 1, 0),
(176, 20, 4, 5.00), (176, 21, 3, 0),
(177, 5, 2, 0), (177, 20, 1, 0), (177, 21, 4, 0),
(178, 20, 3, 0), (178, 5, 5, 0),
(179, 21, 4, 0), (179, 20, 2, 0), (179, 5, 1, 4.00),
(180, 20, 1, 0), (180, 21, 6, 0), (180, 5, 2, 0),
(181, 5, 3, 0), (181, 20, 4, 0),
(182, 21, 5, 0), (182, 20, 2, 0), (182, 5, 1, 0),
(183, 20, 4, 0), (183, 21, 2, 3.00),
(184, 5, 6, 0), (184, 20, 1, 0),
(185, 21, 3, 0), (185, 5, 2, 0), (185, 20, 4, 0),
(186, 20, 1, 0), (186, 21, 3, 5.00),
(187, 5, 5, 0), (187, 20, 2, 0), (187, 21, 1, 0),
(188, 20, 4, 0), (188, 21, 2, 0), (188, 5, 3, 0),
(189, 21, 6, 0), (189, 5, 1, 0),
(190, 20, 2, 0), (190, 21, 3, 0), (190, 5, 4, 4.00),
(191, 20, 5, 0), (191, 21, 2, 0),
(192, 5, 3, 0), (192, 20, 1, 0),
(193, 21, 4, 0), (193, 20, 2, 0), (193, 5, 1, 0),
(194, 20, 3, 0), (194, 21, 5, 5.00),
(195, 5, 2, 0), (195, 20, 4, 0),
(196, 21, 1, 0), (196, 20, 3, 0), (196, 5, 2, 0),
(197, 20, 4, 0), (197, 21, 3, 0), (197, 5, 1, 0),
(198, 20, 2, 0), (198, 21, 5, 0), (198, 5, 3, 3.00),
(199, 20, 1, 0), (199, 21, 4, 0), (199, 5, 2, 0),
(200, 20, 3, 0), (200, 21, 2, 0), (200, 5, 1, 0);

INSERT INTO ProductRating (ProductId, CustomerId, Rating, RatingDate) VALUES 
(15, 4, 1, '2022-11-06'), (22, 26, 1, '2022-02-05'), (12, 21, 3, '2022-11-24'), (5, 34, 4, '2024-01-17'), (1, 34, 2, '2023-06-19'),
(7, 27, 2, '2024-03-10'), (5, 2, 3, '2023-01-11'), (5, 27, 5, '2023-08-01'), (11, 2, 3, '2022-05-15'), (10, 7, 4, '2023-12-03'),
(20, 15, 5, '2022-12-27'), (8, 3, 3, '2024-01-22'), (2, 50, 3, '2023-04-21'), (18, 10, 2, '2023-07-06'), (15, 14, 5, '2023-08-27'),
(11, 17, 5, '2022-12-30'), (20, 12, 4, '2022-05-31'), (13, 38, 3, '2023-07-16'), (10, 19, 1, '2022-10-05'), (22, 27, 2, '2022-07-20'),
(18, 8, 4, '2023-12-26'), (5, 35, 1, '2022-12-08'), (7, 16, 1, '2023-06-06'), (6, 11, 4, '2023-04-10'), (10, 32, 5, '2023-11-01'),
(21, 37, 4, '2023-03-29'), (5, 12, 2, '2024-02-03'), (13, 22, 2, '2023-05-12'), (5, 8, 2, '2023-06-27'), (18, 11, 3, '2023-06-14'),
(13, 10, 2, '2024-01-26'), (7, 49, 3, '2022-12-03'), (14, 39, 2, '2023-10-30'), (17, 14, 1, '2022-03-31'), (22, 26, 1, '2024-02-14'),
(21, 39, 3, '2023-01-09'), (3, 20, 3, '2022-08-25'), (9, 8, 1, '2022-11-12'), (5, 41, 1, '2023-09-05'), (10, 41, 3, '2022-08-08'),
(16, 27, 5, '2023-09-14'), (22, 14, 4, '2023-11-17'), (10, 32, 5, '2022-09-06'), (7, 27, 4, '2022-07-03'), (7, 15, 3, '2022-12-29'),
(5, 47, 4, '2023-11-25'), (7, 11, 5, '2024-01-20'), (22, 5, 1, '2022-05-02'), (8, 32, 2, '2024-02-13'), (13, 6, 3, '2022-02-18'),
(15, 31, 1, '2022-05-01'), (10, 48, 5, '2023-08-10'), (11, 32, 3, '2023-12-08'), (9, 8, 1, '2023-08-15'), (8, 29, 4, '2023-04-22'),
(1, 16, 1, '2022-04-02'), (15, 19, 1, '2024-03-19'), (10, 2, 2, '2023-12-23'), (14, 38, 1, '2022-05-25'), (7, 11, 4, '2022-10-10'),
(3, 9, 5, '2024-03-20'), (3, 27, 2, '2022-11-24'), (15, 29, 4, '2022-04-02'), (22, 33, 4, '2022-07-25'), (19, 23, 2, '2023-09-08'),
(1, 29, 1, '2022-03-16'), (7, 1, 2, '2024-03-29'), (22, 13, 2, '2023-12-13'), (22, 18, 3, '2023-11-10'), (10, 15, 5, '2022-10-15'),
(2, 1, 5, '2024-01-22'), (5, 7, 1, '2022-04-29'), (14, 24, 1, '2022-06-06'), (10, 25, 1, '2023-05-15'), (15, 39, 1, '2022-11-07'),
(3, 29, 5, '2022-05-10'), (7, 3, 2, '2023-11-20'), (22, 21, 3, '2023-02-14'), (3, 47, 5, '2022-04-30'), (22, 15, 1, '2022-04-11'),
(2, 9, 5, '2023-08-02'), (15, 4, 4, '2022-05-18'), (17, 23, 5, '2023-04-12'), (14, 31, 1, '2023-07-10'), (3, 27, 2, '2023-03-05'),
(7, 18, 1, '2022-07-12'), (12, 18, 4, '2022-02-19'), (22, 7, 5, '2023-10-27'), (7, 38, 4, '2022-11-18'), (10, 23, 3, '2022-08-21'),
(3, 33, 4, '2022-08-21'), (20, 20, 2, '2022-02-27'), (8, 15, 3, '2022-11-20'), (3, 17, 1, '2022-09-30'), (22, 47, 5, '2023-11-19'),
(17, 18, 5, '2022-04-08'), (17, 14, 2, '2023-07-06'), (3, 30, 5, '2022-04-05'), (9, 26, 4, '2022-02-17'), (12, 50, 1, '2023-11-13'),
(22, 6, 3, '2022-08-25'), (15, 23, 5, '2023-12-25'), (2, 1, 5, '2022-11-03'), (3, 40, 4, '2022-03-12'), (8, 46, 2, '2023-06-22'),
(18, 19, 5, '2022-10-18'), (3, 4, 4, '2023-08-06'), (3, 48, 4, '2023-04-07'), (7, 40, 3, '2024-01-26'), (11, 46, 2, '2023-08-09'),
(10, 15, 4, '2023-09-22'), (4, 45, 5, '2022-03-18'), (16, 33, 4, '2023-12-24'), (12, 43, 2, '2023-10-07'), (10, 9, 2, '2022-09-03'),
(9, 35, 3, '2022-10-21'), (13, 24, 1, '2023-06-22'), (11, 30, 5, '2023-07-05'), (20, 31, 4, '2023-05-27'), (15, 28, 4, '2022-07-04'),
(17, 22, 2, '2022-09-15'), (5, 24, 5, '2022-10-03'), (13, 39, 3, '2023-05-09'), (5, 27, 4, '2022-11-08'), (22, 6, 4, '2023-09-14'),
(10, 8, 2, '2023-12-04'), (7, 39, 5, '2024-01-09'), (10, 45, 5, '2023-09-04'), (8, 35, 3, '2022-09-03'), (13, 33, 2, '2023-07-16'),
(20, 25, 2, '2022-06-29'), (7, 3, 1, '2022-12-25'), (4, 27, 5, '2022-06-25'), (16, 19, 2, '2023-01-21'), (12, 28, 5, '2022-12-17'),
(4, 16, 5, '2022-12-01'), (5, 10, 5, '2022-02-02'), (15, 49, 5, '2023-12-22'), (8, 32, 3, '2023-01-23'), (12, 32, 1, '2023-12-17'),
(9, 22, 1, '2022-10-27'), (22, 1, 4, '2024-01-09'), (3, 16, 5, '2023-10-21'), (10, 49, 4, '2023-02-12'), (11, 42, 5, '2023-10-18'),
(2, 32, 5, '2024-02-01'), (10, 44, 2, '2022-03-23'), (11, 39, 1, '2022-05-25'), (6, 9, 2, '2022-08-16'), (5, 47, 5, '2024-01-01'),
(14, 29, 1, '2023-06-20'), (13, 10, 2, '2022-11-11'), (18, 13, 5, '2022-02-08'), (3, 32, 4, '2023-01-05'), (9, 8, 4, '2022-09-08'),
(22, 25, 5, '2023-07-06'), (17, 13, 4, '2022-11-04'), (7, 21, 3, '2022-11-14'), (22, 30, 4, '2024-01-19'), (15, 8, 3, '2022-08-27'),
(10, 37, 3, '2022-09-05'), (5, 24, 3, '2023-06-19'), (13, 42, 1, '2024-03-15'), (3, 46, 3, '2022-12-17'), (18, 27, 5, '2022-06-16'),
(2, 28, 5, '2024-01-27'), (22, 38, 2, '2023-09-21'), (14, 2, 2, '2022-11-02'), (18, 15, 1, '2022-02-05'), (3, 39, 1, '2022-08-22'),
(10, 16, 4, '2022-11-01'), (5, 17, 5, '2023-04-22'), (5, 13, 3, '2022-03-10'), (18, 24, 1, '2022-04-30'), (21, 7, 5, '2023-11-07'),
(2, 21, 4, '2024-03-31'), (10, 4, 3, '2024-02-12'), (9, 48, 4, '2022-03-19'), (15, 23, 4, '2022-06-10'), (14, 45, 1, '2022-02-21'),
(22, 36, 5, '2023-04-24'), (22, 29, 5, '2022-07-10'), (16, 29, 5, '2024-02-23'), (22, 29, 4, '2023-07-03'), (14, 1, 3, '2022-04-19'),
(16, 7, 3, '2023-04-26'), (10, 2, 5, '2022-02-25'), (5, 4, 3, '2022-07-28'), (16, 36, 5, '2023-07-12'), (11, 10, 3, '2022-11-06'),
(11, 34, 2, '2022-09-15'), (8, 30, 5, '2022-09-23'), (10, 20, 3, '2023-06-13'), (1, 19, 4, '2024-02-15'), (1, 41, 2, '2022-10-07'),
(10, 50, 5, '2023-03-29'), (16, 23, 2, '2023-06-21'), (3, 41, 5, '2023-11-27'), (10, 14, 5, '2022-04-18'), (3, 27, 5, '2022-02-19');

INSERT INTO OrderReturn (OrderId, ProductId, ReturnDate, ReturnReasonId, Quantity) VALUES
(1, 3, '2023-08-20', 1, 1), 
(2, 4, '2023-07-05', 2, 1), 
(3, 15, '2023-11-25', 3, 1),
(5, 6, '2022-08-30', 3, 1), 
(6, 20, '2023-06-15', 5, 1), 
(7, 22, '2022-12-14', 3, 1), 
(10, 20, '2023-12-26', 1, 1), 
(12, 2, '2023-08-21', 2, 1), 
(13, 16, '2022-12-01', 3, 1), 
(15, 22, '2023-02-04', 3, 1), 
(17, 16, '2023-09-03', 2, 1), 
(18, 20, '2022-12-22', 6, 1), 
(21, 16, '2023-05-05', 1, 1), 
(23, 22, '2023-01-12', 2, 1), 
(24, 2, '2024-01-20', 3, 1), 
(26, 20, '2023-03-18', 3, 1), 
(29, 16, '2023-07-03', 5, 1), 
(31, 22, '2023-07-10', 6, 1), 
(33, 16, '2023-08-18', 1, 1), 
(35, 22, '2023-12-15', 2, 1), 
(37, 16, '2023-02-18', 3, 1), 
(40, 20, '2023-04-15', 4, 1), 
(43, 22, '2023-12-12', 5, 1), 
(45, 20, '2023-02-18', 5, 1), 
(48, 2, '2023-12-15', 1, 1), 
(50, 20, '2023-07-22', 2, 1), 
(51, 17, '2023-03-14', 3, 1), 
(54, 11, '2023-12-04', 3, 1), 
(57, 14, '2023-07-12', 2, 1), 
(60, 15, '2023-07-20', 3, 1);

-------------------------------
