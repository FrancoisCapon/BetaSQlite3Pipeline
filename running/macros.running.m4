# RUNNING

define(_ASSERT_RESULT,
[IIF((SELECT result FROM assert) = 1 ,'ASSERT_PASS','ASSERT_FAIL') AS RESULT])

define(_ASSERT_WHERE,
[ifelse([$1], [],,WHERE $1)])

define(_ASSERT_PRINT,
[SELECT _ASSERT_RESULT, $1 AS EXPECTED, (SELECT result FROM query) AS ACTUAL, "$3" AS [$2]])

dnl $1 expedted, $2 actual (SQL expression), $3 table, $4 condition
define(ASSERT_EXACT_EQUALS,
[-- [$0]($*)
WITH
query AS ( SELECT $2 AS result FROM $3 _ASSERT_WHERE($4) ),
assert AS ( SELECT query.result = ( $1 ) AS result FROM query )
_ASSERT_PRINT($1,[$0], [$*])];)

define(_ASSERT_FLOAT_COMPARE_DEFAULT_DELTA,[0.0001])

define(_ASSERT_FLOAT_COMPARE,
[ifelse([$1], [], _ASSERT_FLOAT_COMPARE_DEFAULT_DELTA, $1)])

dnl expedted, $2 actual (expression), $3 table, $4 condition, $5 comparaison tolerance
define(ASSERT_FLOAT_EQUALS,
[-- [$0]($*)
WITH
query AS ( SELECT $2 AS result FROM $3 _ASSERT_WHERE($4) ),
assert AS ( SELECT abs(query.result - ( $1 )) < _ASSERT_FLOAT_COMPARE($5) AS result FROM query )
_ASSERT_PRINT($1,[$0], [$*])];)


