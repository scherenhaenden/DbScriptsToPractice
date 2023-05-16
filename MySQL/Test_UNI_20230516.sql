#Tests

# 1.- Create a database called Tests_UNI_20230516
# 2.- Create a table called Users with the following fields:
#     Id (int, autoincrement, primary key)
#     FirstName (nvarchar(150), not null)
#     LastName (nvarchar(150), not null)
#     Password (varchar(350), not null)
#     LastLogin (datetime)

# 3.- Create a table called Article with the following fields:
#     Id (int, autoincrement, primary key)
#     Title (varchar(400))
#     Content (text)
#     Created (datetime)
#     Updated (datetime)

# 4.- Create a table called Comments with the following fields:

#SELECT @@sql_mode;


CREATE DATABASE IF NOT EXISTS Tests_UNI_20230516;

USE Tests_UNI_20230516;

CREATE TABLE Users
(
    Id        INTEGER AUTO_INCREMENT,
    FirstName NVARCHAR(150) NOT NULL,
    LastName  NVARCHAR(150) NOT null,
    Password  VARCHAR(350) NOT NULL ,
    LastLogin DATETIME,
    Created DATETIME,
    Updated DATETIME,
    Email VARCHAR(256),
    VerifiedAccount boolean,
    PRIMARY KEY (Id)
);




CREATE TABLE Article (
    Id INTEGER AUTO_INCREMENT,
    Title VARCHAR(400),
    Content TEXT,
    Created DATETIME,
    Updated DATETIME,
    PRIMARY KEY (Id)
);


ALTER TABLE Article
ADD CreatedByUser INT,
ADD CONSTRAINT fk_created_by_user
FOREIGN KEY (CreatedByUser)
REFERENCES Users (Id);


# Insertar datos en la tabla Users
INSERT INTO Users (FirstName, LastName, Password, LastLogin, Created, Updated, Email, VerifiedAccount)
VALUES ('Carlos' , 'Perencejo', 'Somepassword', null, null, null, 'someemail@email.com', false);

# Update values in Users
UPDATE Users
SET Created = now(), Updated = now()
WHERE Id = 1
AND FirstName = 'Carlos'
AND LastName = 'Perencejo';


# Alter table so that Users (Created, Updated) are not null
ALTER TABLE Users
MODIFY COLUMN Created DATETIME NOT NULL,
MODIFY COLUMN Updated DATETIME NOT NULL;

# this should fail
INSERT INTO Users (FirstName, LastName, Password, LastLogin, Created, Updated, Email, VerifiedAccount)
VALUES ('Anita' , 'Rojas', 'Somepassword', null, null, null, 'someemailv2@email.com', false);

# this should work
INSERT INTO Users (FirstName, LastName, Password, LastLogin, Created, Updated, Email, VerifiedAccount)
VALUES ('Anita' , 'Rojas', 'Somepassword', null, now(), now(), null, false);

/*
für später (stored procedure)

BEGIN
  DECLARE error_message VARCHAR(255);

  -- First INSERT statement (expected to fail)
  INSERT INTO Users (FirstName, LastName, Password, LastLogin, Created, Updated, Email, VerifiedAccount)
  VALUES ('Anita' , 'Rojas', 'Somepassword', null, null, null, 'someemailv2@email.com', false);

  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '23000' SET MESSAGE_TEXT = 'Duplicate key error occurred.';
  END IF;

  -- Second INSERT statement (expected to work)
  INSERT INTO Users (FirstName, LastName, Password, LastLogin, Created, Updated, Email, VerifiedAccount)
  VALUES ('Anita' , 'Rojas', 'Somepassword', null, NOW(), NOW(), null, false);

  SELECT 'All statements executed successfully.' AS Result;

END;



*/

# Insertar datos en la tabla Article
# it should fail cuz of the foreign key constraint
INSERT INTO Article (Title, Content, Created, Updated, CreatedByUser)
VALUES ('Some title', 'Some content', now(), now(), 2);

INSERT INTO Article (Title, Content, Created, Updated, CreatedByUser)
# would work
#VALUES ('Some title', 'Some content', now(), now(), 1);

# but better
VALUES ('Some title', 'Some content', now(), now(),
(SELECT Id FROM Users WHERE FirstName = 'Carlos' AND LastName = 'Perencejo'));
