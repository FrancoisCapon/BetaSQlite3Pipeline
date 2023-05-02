CREATE TABLE Agence(
   Id_Agence INTEGER,
   nom TEXT NOT NULL,
   PRIMARY KEY(Id_Agence),
   UNIQUE(nom)
);

CREATE TABLE Employe(
   Id_Employe INTEGER,
   nom TEXT NOT NULL,
   Id_Agence INTEGER NOT NULL,
   PRIMARY KEY(Id_Employe),
   UNIQUE(nom),
   FOREIGN KEY(Id_Agence) REFERENCES Agence(Id_Agence)
);

CREATE TABLE Client(
   Id_Client INTEGER,
   nom TEXT NOT NULL,
   solde REAL NOT NULL,
   Id_Agence INTEGER, -- null client web
   PRIMARY KEY(Id_Client),
   UNIQUE(nom),
   FOREIGN KEY(Id_Agence) REFERENCES Agence(Id_Agence)
);





