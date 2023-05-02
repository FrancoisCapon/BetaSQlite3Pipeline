-- Clients
-- expected, actual, table, filter
ASSERT_EXACT_EQUALS( 'Client 01', nom, Client, Id_Client = 10 )
ASSERT_FLOAT_EQUALS( 400.4, solde, Client, Id_Client = 40 )
ASSERT_EXACT_EQUALS( 2, Id_Agence, Client, Id_Client = 20 )
-- expected, actual, table
ASSERT_FLOAT_EQUALS( 100.1 + 200.2 + 300.3 + 400.4, SUM(solde), Client)

