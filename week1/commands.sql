CREATE TABLE accounts (
  id INTEGER PRIMARY KEY,
  name TEXT,
  credit INTEGER
);

INSERT INTO accounts VALUES (1, 'Account1', 1000);
INSERT INTO accounts VALUES (2, 'Account2', 1000);
INSERT INTO accounts VALUES (3, 'Account3', 1000);

BEGIN;
UPDATE accounts SET credit = credit - 500 WHERE id = 1;
UPDATE accounts SET credit = credit + 500 WHERE id = 3;

UPDATE accounts SET credit = credit - 700 WHERE id = 2;
UPDATE accounts SET credit = credit + 700 WHERE id = 1;

UPDATE accounts SET credit = credit - 100 WHERE id = 2;
UPDATE accounts SET credit = credit + 100 WHERE id = 3;
COMMIT;

SELECT id, credit FROM accounts;

ALTER TABLE accounts ADD COLUMN bankName TEXT;

UPDATE accounts SET bankName = 'SpearBank' WHERE id = 1;
UPDATE accounts SET bankName = 'Tinkoff' WHERE id = 2;
UPDATE accounts SET bankName = 'SpearBank' WHERE id = 3;

INSERT INTO accounts VALUES (4, 'Account4', 0, 'Account4');

BEGIN;
UPDATE accounts SET credit = credit - 500 WHERE id = 1;
UPDATE accounts SET credit = credit + 500 WHERE id = 3;

UPDATE accounts SET credit = credit - 700 WHERE id = 2;
UPDATE accounts SET credit = credit - 30 WHERE id = 2;
UPDATE accounts SET credit = credit + 700 WHERE id = 1;
UPDATE accounts SET credit = credit + 30 WHERE id = 4;

UPDATE accounts SET credit = credit - 100 WHERE id = 2;
UPDATE accounts SET credit = credit - 30 WHERE id = 2;
UPDATE accounts SET credit = credit + 100 WHERE id = 3;
UPDATE accounts SET credit = credit + 30 WHERE id = 4;
COMMIT;

SELECT id, credit FROM accounts;

CREATE TABLE Ledger (
  id INTEGER PRIMARY KEY,
  fromId INTEGER,
  toId INTEGER,
  fee INTEGER,
  amount INTEGER,
  transactionDateTime TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

BEGIN;
UPDATE accounts SET credit = credit - 500 WHERE id = 1;
UPDATE accounts SET credit = credit + 500 WHERE id = 3;

INSERT INTO Ledger VALUES (1, 1, 3, 0, 500);

UPDATE accounts SET credit = credit - 700 WHERE id = 2;
UPDATE accounts SET credit = credit + 700 WHERE id = 1;
UPDATE accounts SET credit = credit - 30 WHERE id = 2;
UPDATE accounts SET credit = credit + 30 WHERE id = 4;

INSERT INTO Ledger VALUES (2, 2, 1, 30, 700);

UPDATE accounts SET credit = credit - 100 WHERE id = 2;
UPDATE accounts SET credit = credit + 100 WHERE id = 3;
UPDATE accounts SET credit = credit - 30 WHERE id = 2;
UPDATE accounts SET credit = credit + 30 WHERE id = 4;

INSERT INTO Ledger VALUES (3, 2, 3, 30, 500);
COMMIT;

SELECT * FROM Ledger;
















