# BetaSQlite3Pipeline

## Requirements
* `bash`
* `sqlite3`
* `m4`

## Running Examples

### All Stages in Pipeline
```
running$ ./running_bootstrap.sh banque-trigger
WARNING: DEV => rm log and tmp

PIPELINE BEGIN: banque-trigger

 + STAGE BEGIN: 10-test-setup
 | STEP STATUS: Successful      10-create-tables.step.sql
 | STEP STATUS: Successful      20-banque.step.populate
 | STEP STATUS: Successful      30-assert-examples.step.sql
 + STAGE END:   Successful      10-test-setup.stage

 + STAGE BEGIN: 30-test-transaction
 | STEP STATUS: Successful      10-case-commit.step.sql
 | STEP STATUS: Failed  20-case-rollback.step.sql

┌─────────────┬────────────┬────────────┬──────────────────────────────────────────────┐
│   RESULT    │  EXPECTED  │   ACTUAL   │             ASSERT_FLOAT_EQUALS              │
├─────────────┼────────────┼────────────┼──────────────────────────────────────────────┤
│ ASSERT_PASS │ 500.4      │ 500.4      │ 400.4 + 100 - 0,solde,Client,Id_Client = 40  │
└─────────────┴────────────┴────────────┴──────────────────────────────────────────────┘
┌─────────────┬────────────┬────────────┬───────────────────────────────────────────┐
│   RESULT    │  EXPECTED  │   ACTUAL   │            ASSERT_FLOAT_EQUALS            │
├─────────────┼────────────┼────────────┼───────────────────────────────────────────┤
│ ASSERT_FAIL │ 300.31     │ 300.3      │ 300.3 + 0.01,solde,Client,Id_Client = 30  │
└─────────────┴────────────┴────────────┴───────────────────────────────────────────┘
┌─────────────┬────────────┬────────────┬─────────────────────────────────────────────────┐
│   RESULT    │  EXPECTED  │   ACTUAL   │               ASSERT_FLOAT_EQUALS               │
├─────────────┼────────────┼────────────┼─────────────────────────────────────────────────┤
│ ASSERT_PASS │ 1001.0     │ 1001.0     │ 100.1 + 200.2 + 300.3 + 400.4,SUM(solde),Client │
└─────────────┴────────────┴────────────┴─────────────────────────────────────────────────┘

 + STAGE END:   Failed  30-test-transaction.stage

PIPELINE END:   Failed  banque-trigger.pipeline
```
### Stop Pipeline After Stage
```
running$ ./running_bootstrap.sh banque-trigger 10-test-setup
WARNING: DEV => rm log and tmp

PIPELINE BEGIN: banque-trigger

 + STAGE BEGIN: 10-test-setup
 | STEP STATUS: Successful      10-create-tables.step.sql
 | STEP STATUS: Successful      20-banque.step.populate
 | STEP STATUS: Successful      30-assert-examples.step.sql
 + STAGE END:   Successful      10-test-setup.stage

PIPELINE END:   Successful      banque-trigger.pipeline
```
