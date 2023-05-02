-- Clients Transaction
BEGIN TRANSACTION;
UPDATE Client SET solde = solde + 100 WHERE Id_Client = 40;
UPDATE Client SET solde = solde - 100 WHERE Id_Client = 20;
COMMIT;
-- expected, actual, table, filter
ASSERT_FLOAT_EQUALS( (400.4 + 100), solde, Client, Id_Client = 40 )
ASSERT_FLOAT_EQUALS( (200.2 - 100), solde, Client, Id_Client = 20 )
-- expected, actual, table
ASSERT_FLOAT_EQUALS( (100.1 + 200.2 + 300.3 + 400.4), SUM(solde), Client)