-- Create sites table 
CREATE TABLE Sites (
  ID int PRIMARY KEY,
  ville varchar(100)
);

-- Insert into sites table 
INSERT INTO Sites (ID, ville)
VALUES
(1, 'Paris'),
(2, 'Lyon'),
(3, 'Marseille'),
(4, 'Bordeaux'),
(5, 'Lille');

-- Create Agence table 
CREATE TABLE Agence (
  ID int PRIMARY KEY,
  Designation varchar(100),
  IDVille int FOREIGN KEY REFERENCES Sites(ID)
);

-- Insert into Agence table 
INSERT INTO Agence (ID, Designation, IDVille)
VALUES
(1, 'Agence A', 1),
(2, 'Agence B', 2),
(3, 'Agence C', 3),
(4, 'Agence D', 4),
(5, 'Agence E', 5);

-- Fetch Agence table 
SELECT Agence.Designation AS Agence, Sites.ville AS Ville
FROM Agence
INNER JOIN Sites ON Agence.IDVille = Sites.ID;

-- Create Agent table 
CREATE TABLE Agent (
  matricule varchar(25) PRIMARY KEY,
  nom varchar(25),
  IDAgence int FOREIGN KEY REFERENCES Agence(ID)
);

-- Insert into Agent table 
INSERT INTO Agent (matricule, nom, IDAgence)
VALUES
('A001', 'Ise Mirembe', 1),
('A002', 'Baraka Kambale', 2),
('A003', 'Aggestor Geek', 1),
('A004', 'Alfred Syatsukwa', 3),
('A005', 'Esaie Muhasa', 2);

-- Select Agent table 
SELECT a.ID AS IDAgence, a.Designation AS NomAgence, 
       ag.matricule, ag.nom
FROM Agence a
INNER JOIN Agent ag ON a.ID = ag.IDAgence;
GO

-- Create Client table
CREATE TABLE Client (
  numero INT PRIMARY KEY,
  nom varchar(25),
  sexe varchar(1),
  IDVille int FOREIGN KEY REFERENCES Sites(ID)
)

-- Insert into Client table
INSERT INTO Client (numero, nom, sexe, IDVille)
VALUES
(1, 'Mathina Neema', 'F', 1),
(2, 'Kiviti Immaculee', 'F', 2),
(3, 'Henry ', 'M', 3),
(4, 'Seraphine Kahindo', 'F', 1),
(5, 'Jospin Kombi', 'M', 2);

--select  Client table
SELECT Client.numero, Client.nom, Client.sexe, Sites.ville
FROM Client
INNER JOIN Sites ON Client.IDVille = Sites.ID;
GO

--Create TypeCompte table
CREATE TABLE TypeCompte (
  ID INT PRIMARY KEY,
  categorie varchar(25)
)

--Insert into TypeCompte table
INSERT INTO TypeCompte (ID, categorie)
VALUES
(1, 'Compte courant'),
(2, 'Compte épargne'),
(3, 'Compte à terme');

--Select TypeCompte table
SELECT * FROM TypeCompte

-- Create Compte table
CREATE TABLE Compte (
  ID INT PRIMARY KEY,
  solde float,
  numeroClient int FOREIGN KEY REFERENCES Client(numero),
  TypeCompte int FOREIGN KEY REFERENCES TypeCompte(ID)
)

-- Insert into Compte table
INSERT INTO Compte (ID, solde, numeroClient, TypeCompte)
VALUES
(1, 1500.00, 1, 1),
(2, 2500.00, 2, 2),
(3, 3000.00, 3, 1),
(4, 2000.00, 4, 2),
(5, 1800.00, 5, 1);

--select  Compte table
SELECT Compte.ID, Compte.solde, Client.nom AS ClientNom, TypeCompte.categorie AS TypeCompteCategorie
FROM Compte
INNER JOIN Client ON Compte.numeroClient = Client.numero
INNER JOIN TypeCompte ON Compte.TypeCompte = TypeCompte.ID;
GO

-- Create Transactions table
CREATE TABLE Transactions (
  ID INT PRIMARY KEY,
  montant float,
  motif varchar(25),
  dateT date,
  Compte int FOREIGN KEY REFERENCES Compte(ID)
)

-- Insert into Transactions table
INSERT INTO Transactions (ID, montant, motif, dateT, Compte)
VALUES
(1, 100.00, 'Achat alimentaire', '2024-03-01', 1),
(2, 50.00, 'Frais de transport', '2024-03-02', 2),
(3, 200.00, 'Facture électricité', '2024-03-03', 3),
(4, 75.00, 'Restaurant', '2024-03-04', 4),
(5, 120.00, 'Achat vêtements', '2024-03-05', 5);

-- Select Transactions table
SELECT Transactions.ID, Transactions.montant, Transactions.motif, Transactions.dateT, Compte.ID AS CompteID, Compte.solde, Client.nom AS ClientNom, TypeCompte.categorie AS TypeCompteCategorie
FROM Transactions
INNER JOIN Compte ON Transactions.Compte = Compte.ID
INNER JOIN Client ON Compte.numeroClient = Client.numero
INNER JOIN TypeCompte ON Compte.TypeCompte = TypeCompte.ID;
GO

-- Procédure pour insertion dans la table Client
CREATE PROCEDURE InsertClientProc
    @numero INT,
    @nom varchar(25),
    @sexe varchar(1),
    @IDVille int
AS
BEGIN
    INSERT INTO Client (numero, nom, sexe, IDVille)
    VALUES (@numero, @nom, @sexe, @IDVille)
END
GO

-- Procédure pour insertion dans la table Agence
CREATE PROCEDURE InsertAgenceProc
    @ID int,
    @Designation varchar(100),
    @IDVille int
AS
BEGIN
    INSERT INTO Agence (ID, Designation, IDVille)
    VALUES (@ID, @Designation, @IDVille)
END
GO

-- Procédure pour insertion dans la table TypeCompte
CREATE PROCEDURE InsertTypeCompteProc
    @ID INT,
    @categorie varchar(25)
AS
BEGIN
    INSERT INTO TypeCompte (ID, categorie)
    VALUES (@ID, @categorie)
END
GO

-- Procédure pour modification d'un compte
CREATE PROCEDURE UpdateCompteProc
    @ID INT,
    @solde float,
    @numeroClient int,
    @TypeCompte int
AS
BEGIN
    UPDATE Compte
    SET solde = @solde,
        numeroClient = @numeroClient,
        TypeCompte = @TypeCompte
    WHERE ID = @ID
END
GO

-- Procédure pour modification d'un agent
CREATE PROCEDURE UpdateAgentProc
    @matricule varchar(25),
    @nom varchar(25),
    @IDAgence int
AS
BEGIN
    UPDATE Agent
    SET nom = @nom,
        IDAgence = @IDAgence
    WHERE matricule = @matricule
END
GO

-- Procédure pour afficher les transactions
CREATE PROCEDURE ShowTransactionsProc
AS
BEGIN
    SELECT Transactions.ID, Transactions.montant, Transactions.motif, Transactions.dateT, Compte.ID AS CompteID, Compte.solde, Client.nom AS ClientNom, TypeCompte.categorie AS TypeCompteCategorie
    FROM Transactions
    INNER JOIN Compte ON Transactions.Compte = Compte.ID
    INNER JOIN Client ON Compte.numeroClient = Client.numero
    INNER JOIN TypeCompte ON Compte.TypeCompte = TypeCompte.ID
END
GO




