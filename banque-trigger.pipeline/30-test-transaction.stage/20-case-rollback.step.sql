-- Clients Transaction
BEGIN;
UPDATE Client SET solde = solde - 50 WHERE Id_Client = 40;
UPDATE Client SET solde = solde + 50 WHERE Id_Client = 30;
ROLLBACK;

-- expected, actual, table, filter
ASSERT_FLOAT_EQUALS( 400.4 + 100 - 0, solde, Client, Id_Client = 40 )
ASSERT_FLOAT_EQUALS( 300.3 + 0.01, solde, Client, Id_Client = 30 )
-- expected, actual, table
ASSERT_FLOAT_EQUALS( 100.1 + 200.2 + 300.3 + 400.4, SUM(solde), Client)