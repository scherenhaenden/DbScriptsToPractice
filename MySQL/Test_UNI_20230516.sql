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


# Insert data into Users
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

# Insert data into Article
# it should fail cuz of the foreign key constraint
INSERT INTO Article (Title, Content, Created, Updated, CreatedByUser)
VALUES ('Some title', 'Some content', now(), now(), 2);

INSERT INTO Article (Title, Content, Created, Updated, CreatedByUser)
# would work
#VALUES ('Some title', 'Some content', now(), now(), 1);

# but better
VALUES ('Some title', 'Some content', now(), now(),
(SELECT Id FROM Users WHERE FirstName = 'Carlos' AND LastName = 'Perencejo'));

# Select data from Article
SELECT * FROM Article;

# Select data from Article and Users
SELECT * FROM Article
INNER JOIN Users
ON Article.CreatedByUser = Users.Id;

# Select data from Article and Users with aliases but only some columns
SELECT
    Article.Id AS ArticleId, Article.Title, Article.Content, Article.Created, Article.Updated,
Users.Id AS UserId, Users.FirstName, Users.LastName, Users.Email
FROM Article
INNER JOIN Users
ON Article.CreatedByUser = Users.Id;


# I need more users
INSERT INTO Users (FirstName, LastName, Password, LastLogin, Created, Updated, Email, VerifiedAccount)
VALUES
    ('John', 'Doe', 'Password123', null, NOW(), NOW(), null, true),
    ('Emma', 'Smith', 'SecretPass', null, NOW(), NOW(), null, false),
    ('Michael', 'Johnson', 'Secure123', null, NOW(), NOW(), null, true),
    ('Sophia', 'Brown', 'MyPassword', null, NOW(), NOW(), null, false),
    ('Daniel', 'Garcia', 'TopSecret', null, NOW(), NOW(), null, true),
    ('Olivia', 'Miller', 'Confidential', null, NOW(), NOW(), null, false),
    ('William', 'Anderson', 'Password1234', null, NOW(), NOW(), null, true),
    ('Isabella', 'Wilson', 'SecurePassword', null, NOW(), NOW(), null, false),
    ('James', 'Taylor', 'ProtectedPass', null, NOW(), NOW(), null, true),
    ('Mia', 'Martinez', 'Secret123', null, NOW(), NOW(), null, false),
    ('Benjamin', 'Clark', 'MySecretPass', null, NOW(), NOW(), null, true),
    ('Ava', 'Lopez', 'SuperSecret', null, NOW(), NOW(), null, false),
    ('Henry', 'Harris', 'ConfidentialPass', null, NOW(), NOW(), null, true),
    ('Emily', 'Young', 'HiddenPass', null, NOW(), NOW(), null, false),
    ('Alexander', 'Lee', 'Protected123', null, NOW(), NOW(), null, true),
    ('Sofia', 'Walker', 'MyConfidentialPass', null, NOW(), NOW(), null, false),
    ('Jacob', 'Hall', 'TopSecret123', null, NOW(), NOW(), null, true),
    ('Madison', 'Turner', 'MySecurePass', null, NOW(), NOW(), null, false),
    ('Ethan', 'Hernandez', 'SecretPassword123', null, NOW(), NOW(), null, true);

SELECT * FROM Users;


# I need more articles
INSERT INTO Article (Title, Content, Created, Updated, CreatedByUser)
VALUES ((SELECT SUBSTRING(MD5(RAND()), 1, 10)), (SELECT SUBSTRING(MD5(RAND()), 1, 10)), now(), now(),
(SELECT Id FROM Users ORDER BY RAND() LIMIT 1));



SELECT
    Article.Id AS ArticleId, Article.Title, Article.Content, Article.Created, Article.Updated,
Users.Id AS UserId, Users.FirstName, Users.LastName, Users.Email
FROM Article
INNER JOIN Users
ON Article.CreatedByUser = Users.Id;

# how many articles were written by each user?
SELECT Users.ID AS USERID, COUNT(*) AS COUNT FROM Users
INNER JOIN Article
ON Users.Id = Article.CreatedByUser
GROUP BY Users.Id;

# find users that did not write any articles
SELECT Users.ID AS USERID, COUNT(Article.CreatedByUser) AS COUNT FROM Users
LEFT JOIN Article
ON Users.Id = Article.CreatedByUser
WHERE 1=1
#AND Article.Id IS NULL
GROUP BY Users.Id;

SELECT * FROM Users
WHERE Id NOT IN (SELECT CreatedByUser FROM Article);

SELECT * FROM Article
WHERE 1=1
ORDER BY CreatedByUser ASC;

