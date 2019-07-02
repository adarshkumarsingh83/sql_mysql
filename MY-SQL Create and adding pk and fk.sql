/*====================================== TO GET META DATA ======================================*/
/* to get the names of the constraints defined on each table */
SELECT * 
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA  = 'test' 
AND TABLE_NAME = 'EMPLOYEE';

/* to get the fields in each one of those constraints */
SELECT *
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE CONSTRAINT_SCHEMA = 'test'
AND TABLE_NAME = 'EMPLOYEE';

/* to get the foreign key constraints */
SELECT *
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'test'
AND TABLE_NAME = 'EMPLOYEE';

/* to get all the trigger on the tables */
SELECT *
FROM  INFORMATION_SCHEMA.TRIGGERS
WHERE TRIGGER_SCHEMA = 'TEST'
AND EVENT_OBJECT_TABLE ='EMPLOYEE';

/* to get all the column information about the table */
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'TEST'
AND TABLE_NAME ='EMPLOYEE';

/* to get all the procedure list on db */
SELECT *
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE="PROCEDURE"
AND ROUTINE_SCHEMA="TEST";

/* to get all the function list on db */
SELECT *
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE="FUNCTION"
AND ROUTINE_SCHEMA="TEST";

/* to get information about the permission on specific table  */
SELECT *
FROM INFORMATION_SCHEMA.COLUMN_PRIVILEGES
WHERE TABLE_SCHEMA = 'TEST'
AND TABLE_NAME ='EMPLOYEE';

/* provide the statical information about the table */
SELECT *
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'TEST'
AND TABLE_NAME ='EMPLOYEE';

/*  provides information about global privileges */
SELECT *
FROM INFORMATION_SCHEMA.USER_PRIVILEGES;

/*  provides information about views in databases */
SELECT *
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'TEST'
AND TABLE_NAME ='EMPLOYEE';

/*  provides information about tables in databases */
SELECT *
FROM INFORMATION_SCHEMA. TABLES
WHERE TABLE_SCHEMA = 'TEST';

/*  describes which key columns have constraints */
SELECT *
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'TEST'
AND TABLE_NAME ='EMPLOYEE';


/*
=============================================TABLE CREATION=======================================
=========================================COLUMN LEVEL CONSTRAINT =================================
==================================================================================================
************************************CREATING TABLE ADDRESS ************************************
---------------------------------------------------------------------------------------------------
*/

DROP TABLE IF EXISTS Address;
CREATE TABLE Address(
      Address_Id int NOT NULL PRIMARY KEY  
    , Street_Address VARCHAR(40)
    , Postal_Code    VARCHAR(12)
    , City       VARCHAR(30) NOT NULL
    , State_Province VARCHAR(25)
    , Country     VARCHAR(20)UNIQUE 
) ;

/*
---------------------------------------------------------------------------------------------------
************************************ADDING CONSTRAINT AND KEYS TO ADDRESS*************************
---------------------------------------------------------------------------------------------------
*/

/* creating index */
CREATE INDEX Index_city ON Address(City);

/* deleteing index */
ALTER TABLE Address DROP INDEX Index_city;

/*
---------------------------------------------------------------------------------------------------
*********************************DROPPING CONSTRAINT AND KEYS FROM ADDRESS*************************
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER TABLE Address 
DROP PRIMARY KEY ;

/* removing not null */
ALTER TABLE Address 
MODIFY COLUMN City VARCHAR(30);

/* dropping unique constraint */
ALTER TABLE Address DROP INDEX Country;

/* dropping table */
DROP TABLE Address;
/*
===================================================================================================
************************************CREATING TABLE DEPARTMENT************************************
---------------------------------------------------------------------------------------------------
*/
DROP TABLE IF EXISTS Department;
CREATE TABLE Department(
	Department_Id int NOT NULL PRIMARY KEY
   ,Department_Name varchar(20) NOT NULL
   ,Department_Location int DEFAULT NULL 
   ,Department_Code varchar(10)UNIQUE
   ,Manager_Id int DEFAULT NULL
   ,CONSTRAINT  Department_Fk_dept_loc_addr_id 
	FOREIGN KEY(Department_Location) REFERENCES Address(Address_Id)
       ON DELETE CASCADE
       ON UPDATE CASCADE
);

/*
---------------------------------------------------------------------------------------------------
*********************************ADDING CONSTRAINT AND KEYS TO DEPARTMENT**************************
---------------------------------------------------------------------------------------------------
*/

/* creating index */
CREATE INDEX Index_Department_Name 
ON Department(Department_Name);

/* dropping unique constraint */
ALTER TABLE Department 
DROP INDEX Index_Department_Name;

/*
---------------------------------------------------------------------------------------------------
***************************DROPPING CONSTRAINT AND KEYS FROM DEPARTMENT****************************
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER Table Department 
DROP PRIMARY KEY ;

/* removing not null */
ALTER TABLE Department 
MODIFY  COLUMN Department_Name VARCHAR(20);

/* removing forigen key */
ALTER TABLE Department
DROP FOREIGN KEY Department_Fk_dept_loc_addr_id;

/* removing unidque key */
ALTER TABLE Department
DROP INDEX Department_Code;

/* dropping table */
DROP TABLE Department;

/*
==================================================================================================
***************************************CREATING TABLE EMPLOYEE************************************
---------------------------------------------------------------------------------------------------
*/
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee(
	Employee_Id int  PRIMARY KEY NOT NULL
	,First_Name varchar(20)  NOT NULL
	,Middle_Name varchar(20) DEFAULT NULL
	,Last_Name varchar(20)  NOT NULL
	,Emp_Gender varchar(6) NOT NULL CHECK(Emp_Gender IN('Male', 'Female'))
	,Hire_Date date  NOT NULL
	,Emp_Phone varchar(10)DEFAULT NULL 
	,Emp_Email varchar(30) NOT NULL UNIQUE
	,Emp_Salary float DEFAULT NULL
	,Emp_Comm float DEFAULT NULL	
	,Emp_Mgr int DEFAULT NULL
	,Emp_Dept int DEFAULT NULL
	,Emp_Address int
  ,CONSTRAINT Employee_Fk_emp_mgr_emp_id 
	FOREIGN KEY(Emp_Mgr) REFERENCES Employee(Employee_Id)
  ,CONSTRAINT Employee_Fk_emp_dept_dept_id 
	FOREIGN KEY(Emp_Dept) REFERENCES Department(Department_Id)
	 ON DELETE SET NULL
	 ON UPDATE CASCADE
  ,CONSTRAINT Employee_Fk_emp_addr_addr_id 
	FOREIGN KEY(Emp_Address) REFERENCES Address(Address_Id)
 ); 
 
/*
---------------------------------------------------------------------------------------------------
******************************ADDING CONSTRAINT AND KEYS TO EMPLOYOEE******************************
---------------------------------------------------------------------------------------------------
*/

 /* creating index */
CREATE INDEX Index_First_Name 
ON Employee(First_Name);

/* dropping unique constraint */
ALTER TABLE Employee 
DROP INDEX Index_First_Name;

/* creating trigger because check constriant doesn't work */
DELIMITER $$
CREATE TRIGGER `Employee_Emp_Gender` BEFORE INSERT ON `Employee`
FOR EACH ROW
BEGIN
    IF Emp_Gender NOT IN('Male', 'Female') THEN
    SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'check constraint on Employee.Emp_Gender failed';
    END IF;
END$$   
DELIMITER ;

/*
---------------------------------------------------------------------------------------------------
****************************DROPPING CONSTRAINT AND KEYS FROM EMPLOYOEE****************************
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER Table Employee 
DROP PRIMARY KEY ;

/* removing not null */
ALTER TABLE Employee 
MODIFY  COLUMN Last_Name VARCHAR(20);

/* removiing trigger*/
DROP TRIGGER 
IF EXISTS Employee_Emp_Gender;

/* removing forigen key */
ALTER TABLE Employee
DROP FOREIGN KEY Employee_Fk_emp_mgr_emp_id;

ALTER TABLE Employee
DROP FOREIGN KEY Employee_Fk_emp_dept_dept_id;

ALTER TABLE Employee
DROP FOREIGN KEY Employee_Fk_emp_addr_addr_id;

/* removing unique key */
ALTER TABLE Employee
DROP INDEX Emp_Email;

/* dropping table */
DROP TABLE Employee;

/*
===================================================================================================
************************************CREATING TABLE EDUCATION **************************************
---------------------------------------------------------------------------------------------------
*/
DROP TABLE IF EXISTS Education;
CREATE TABLE Education(
	Education_Id int PRIMARY KEY NOT NULL
	,High_School varchar(50) DEFAULT NOT NULL
	,Intermediate varchar(50)DEFAULT NOT NULL
	,Graducation varchar(50) DEFAULT NULL
	,Post_Graduation varchar(50)DEFAULT NULL
	,Emp_Id int
  ,CONSTRAINT Education_Fk_emp_id_emp_id 
	FOREIGN KEY(Emp_Id) REFERENCES Employee(Employee_Id)
	ON DELETE CASCADE
 );
 
/*
---------------------------------------------------------------------------------------------------
****************************ADDING CONSTRAINT AND KEYS TO EDUCATION********************************
---------------------------------------------------------------------------------------------------
*/
 
/* creating index */
CREATE INDEX Index_Graducation 
ON Education(First_Name);

/* dropping unique constraint */
ALTER TABLE Education 
DROP INDEX Index_Graducation;

/*
---------------------------------------------------------------------------------------------------
****************************DROPPING CONSTRAINT AND KEYS FROM EDUCATION****************************
---------------------------------------------------------------------------------------------------
*/
 
 /* removing primary key */
ALTER Table Education 
DROP PRIMARY KEY ;

/* removing not null */
ALTER TABLE Education 
MODIFY COLUMN Intermediate VARCHAR(50);

/* removing default value */
ALTER TABLE Education
ALTER COLUMN Post_Graduation DROP DEFAULT;

/* removing forigen key */
ALTER TABLE Education
DROP FOREIGN KEY Education_Fk_emp_id_emp_id;

/* dropping table */
DROP TABLE Education;
 
/*
===================================================================================================
**********************************CREATING TABLE EMPOLYMENT_HISTROY********************************
---------------------------------------------------------------------------------------------------
*/

DROP TABLE IF EXISTS Employment_History;
CREATE TABLE Employment_History(
	 Employment_id int PRIMARY KEY NOT NULL
	,Company_Name varchar(50) DEFAULT NULL
	,Company_Location int  NOT NULL
	,Company_Phone varchar(12)UNIQUE NOT NULL
	,Emp_Id int
  ,CONSTRAINT Employment_History_Fk_coy_loc_addr_id 
	FOREIGN KEY(Company_Location) REFERENCES Address(Address_Id)
	ON DELETE CASCADE
  ,CONSTRAINT Employment_History_Fk_emp_id_emp_id 
	FOREIGN KEY(Emp_Id) REFERENCES Employee(Employee_Id)
	ON DELETE CASCADE
 );
 
/*
---------------------------------------------------------------------------------------------------
************************ADDING CONSTRAINT AND KEYS TO EMPOLYMENT_HISTROY***************************
---------------------------------------------------------------------------------------------------
*/ 
 /* creating index */
CREATE INDEX Index_Company_Name 
ON Employment_History(Company_Name);

/* dropping unique constraint */
ALTER TABLE Employment_History 
DROP INDEX Index_Company_Name;

/*
---------------------------------------------------------------------------------------------------
*********************DROPPING CONSTRAINT AND KEYS FROM EMPOLYMENT_HISTROY**************************
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER Table Employment_History 
DROP PRIMARY KEY ;

/* removing not null */
ALTER TABLE Employment_History 
MODIFY COLUMN Company_Location int;

/* dropping unique constraint */
ALTER TABLE Employment_History 
DROP INDEX Company_Phone;

/* removing forigen key */
ALTER TABLE Employment_History
DROP FOREIGN KEY Employment_History_Fk_coy_loc_addr_id;

ALTER TABLE Employment_History
DROP FOREIGN KEY Employment_History_Fk_emp_id_emp_id;

/* dropping table */
DROP TABLE Employment_History;

/*
===================================================================================================
========================================TABLE LEVEL CONSTRAINT=====================================
*****************************************CREATING TABLE *******************************************
---------------------------------------------------------------------------------------------------
*/
DROP TABLE IF EXISTS Address;
CREATE TABLE Address(
      Address_Id int NOT NULL
    , Street_Address VARCHAR(40)
    , Postal_Code    VARCHAR(12)
    , City       VARCHAR(30) NOT NULL
    , State_Province VARCHAR(25)
    , Country     VARCHAR(20)
    ,PRIMARY KEY(Address_Id)
	,CONSTRAINT Address_Unq_country UNIQUE(Country) 	
) ;

/* creating index */
CREATE INDEX Index_city ON Address(City);

/* deleteing index */
ALTER TABLE Address DROP INDEX Index_city;
/*
---------------------------------------------------------------------------------------------------
************************************DROPPING CONSTRAINT AND KEYS **********************************
---------------------------------------------------------------------------------------------------
*/
/* removing primary key */
ALTER TABLE Address 
DROP PRIMARY KEY ;

/* removing not null */
ALTER TABLE Address 
MODIFY COLUMN City VARCHAR(30);

/* dropping unique constraint */
ALTER TABLE Address DROP INDEX Country;

/* dropping table */
DROP TABLE Address;

/*
===================================================================================================
************************************CREATING TABLE ************************************
---------------------------------------------------------------------------------------------------
*/
DROP TABLE IF EXISTS Department;
CREATE TABLE Department(
	Department_Id int NOT NULL
	,Department_Name varchar(20) NOT NULL
	,Department_Code varchar(10)
	,Department_location int DEFAULT NULL
	,Manager_id int DEFAULT NULL
  ,CONSTRAINT Department_Pk_dept_id 
	PRIMARY KEY(Department_Id)
  ,CONSTRAINT Department_Unq_dept_code 
    UNIQUE(Department_Code)
  ,CONSTRAINT Department_Fk_dept_loc_addr_id 
	FOREIGN KEY(Department_location) REFERENCES Address(Address_Id)
	ON DELETE CASCADE
    ON UPDATE CASCADE
);
/* creating index */
CREATE INDEX Index_Department_Name 
ON Department(Department_Name);

/* dropping unique constraint */
ALTER TABLE Department 
DROP INDEX Index_Department_Name;

/*
---------------------------------------------------------------------------------------------------
DROPPING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER Table Department 
DROP PRIMARY KEY ;

/* removing not null */
ALTER TABLE Department 
MODIFY  COLUMN Department_Code VARCHAR(10);

/* removing forigen key */
ALTER TABLE Department
DROP FOREIGN KEY Department_Fk_dept_loc_addr_id;

/* removing the unique constraint */
ALTER TABLE Department
DROP INDEX Department_Unq_dept_code;

/* dropping table */
DROP TABLE Department;

/*
===================================================================================================
CREATING TABLE 
---------------------------------------------------------------------------------------------------
*/

DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee(
	Employee_Id int   NOT NULL
	,First_Name varchar(20)  NOT NULL
	,Middle_Name varchar(20) DEFAULT NULL
	,Last_Name varchar(20)  NOT NULL
	,Emp_Gender varchar(6) NOT NULL
	,Hire_Date date  NOT NULL
	,Emp_Phone varchar(10)DEFAULT NULL 
	,Emp_Email varchar(30) NOT NULL 
	,Emp_Salary float DEFAULT NULL
	,Emp_Comm float DEFAULT NULL
	,Emp_Mgr int DEFAULT NULL
	,Emp_Dept int DEFAULT NULL
	,Emp_Address int
  ,CONSTRAINT Employee_Pk_emp_id 
	PRIMARY KEY(Employee_Id)
  ,CONSTRAINT Employee_Chk_emp_gender
    CHECK(Emp_Gender IN('Male', 'Female'))
  ,CONSTRAINT Employee_Unq_emp_email
    UNIQUE(Emp_Email)
  ,CONSTRAINT Employee_Fk_emp_mgr_emp_id 
	FOREIGN KEY(Emp_Mgr) REFERENCES Employee(Employee_Id)
  ,CONSTRAINT Employee_Fk_emp_dept_dept_id 
	FOREIGN KEY(Emp_Dept) REFERENCES Department(Department_Id)
	 ON DELETE SET NULL
	 ON UPDATE CASCADE
  ,CONSTRAINT Employee_Fk_emp_addr_addr_id 
	FOREIGN KEY(Emp_Address) REFERENCES Address(Address_Id)
 );
 /* creating index */
CREATE INDEX Index_First_Name 
ON Employee(First_Name);

/* dropping unique constraint */
ALTER TABLE Employee 
DROP INDEX Index_First_Name;
/*
---------------------------------------------------------------------------------------------------
DROPPING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER Table Employee 
DROP PRIMARY KEY ;

/* removing not null */
ALTER TABLE Employee 
MODIFY  COLUMN Last_Name VARCHAR(20);

/* removing check constraint */
ALTER TABLE Employee
DROP CHECK Employee_Chk_emp_gender;

/* removing forigen key */
ALTER TABLE Employee
DROP FOREIGN KEY Employee_Fk_emp_mgr_emp_id;

ALTER TABLE Employee
DROP FOREIGN KEY Employee_Fk_emp_dept_dept_id;

ALTER TABLE Employee
DROP FOREIGN KEY Employee_Fk_emp_addr_addr_id;

/* removing unique key */
ALTER TABLE Employee
DROP INDEX Employee_Unq_emp_email;

/* dropping table */
DROP TABLE Employee;

/*
===================================================================================================
CREATING TABLE 
---------------------------------------------------------------------------------------------------
*/

DROP TABLE IF EXISTS Education;
CREATE TABLE Education(
	Education_Id int  NOT NULL
	,High_School varchar(50) DEFAULT NULL
	,Intermediate varchar(50)DEFAULT NULL
	,Graducation varchar(50) DEFAULT NULL
	,Post_Graduation varchar(50) NULL
	,Emp_Id int
  ,CONSTRAINT Education_Pk_educa_id 
	PRIMARY KEY(Education_Id)
  ,CONSTRAINT Education_Fk_emp_id_emp_id 
	FOREIGN KEY(Emp_Id) REFERENCES Employee(Employee_Id)
	ON DELETE CASCADE
 );
/*
===================================================================================================
CREATING TABLE 
---------------------------------------------------------------------------------------------------
*/
DROP TABLE IF EXISTS Employment_History;
CREATE TABLE Employment_History(
	Employment_id int  NOT NULL
	,Company_Name varchar(50) DEFAULT NULL
	,Company_Location int  NOT NULL
	,Company_Phone varchar(12)NOT NULL
	,Emp_Id int
  ,CONSTRAINT Employment_History_Pk_employment_id
	PRIMARY KEY(Employment_Id)
  ,CONSTRAINT Employment_History_Fk_coy_loc_addr_id
	FOREIGN KEY(Company_Location) REFERENCES Address(Address_Id)
	ON DELETE CASCADE
  ,CONSTRAINT Employment_History_Fk_emp_id_emp_id
	FOREIGN KEY(Emp_Id) REFERENCES Employee(Employee_id)
	ON DELETE CASCADE
 );
/*
==================================================================================================
==================================SEPERATLY APPLYING CONSTRAINT===================================
==================================================================================================
CREATING TABLE 
---------------------------------------------------------------------------------------------------
*/
DROP TABLE IF EXISTS Address;
CREATE TABLE Address(
      Address_Id   int  NOT NULL
    , Street_Address VARCHAR(40)
    , Postal_Code    VARCHAR(12)
    , City       VARCHAR(30) NOT NULL
    , State_Province VARCHAR(25)
    , Country     VARCHAR(20)
) ;
/* creating index */
CREATE INDEX Index_city ON Address(City);

/* deleteing index */
ALTER TABLE Address DROP INDEX Index_city;

/*
---------------------------------------------------------------------------------------------------
ADDING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/
/* adding primary key */
ALTER TABLE Address
ADD CONSTRAINT Address_Pk_addr_id 
PRIMARY KEY (Address_Id);

/* removing unique constraint */
ALTER TABLE Address 
ADD CONSTRAINT Address_Unq_city UNIQUE(City);
/*
/*
---------------------------------------------------------------------------------------------------
DROPPING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/
/* removing primary key */
ALTER TABLE Address 
DROP PRIMARY KEY ;

/* removing not null */
ALTER TABLE Address 
MODIFY COLUMN City VARCHAR(30);

/* dropping unique constraint */
ALTER TABLE Address DROP INDEX Address_Unq_city;

/* dropping table */
DROP TABLE Address;
/*
===================================================================================================
CREATING TABLE =
---------------------------------------------------------------------------------------------------
*/
DROP TABLE IF EXISTS Department;
CREATE TABLE Department(
	Department_id int NOT NULL
	,Department_Name varchar(20) NOT NULL
	,Department_Code varchar(10)
	,Department_location int DEFAULT NULL
	,Manager_id int DEFAULT NULL
);
/* creating index */
CREATE INDEX Index_Department_Name 
ON Department(Department_Name);

/* dropping unique constraint */
ALTER TABLE Department 
DROP INDEX Index_Department_Name;

/*
---------------------------------------------------------------------------------------------------
ADDING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/
ALTER TABLE Department
ADD CONSTRAINT Department_pk_dept_id  
PRIMARY KEY (Department_id);

ALTER TABLE Department
ADD CONSTRAINT Department_Unq_dept_name 
UNIQUE (Department_Name);

ALTER TABLE Department
MODIFY Department_name varchar(20) DEFAULT 'ORG';

ALTER TABLE Department
ADD CONSTRAINT Department_Fk_dept_loc
FOREIGN KEY(Department_location)
REFERENCES Address(Address_Id)
ON DELETE CASCADE
ON UPDATE CASCADE;

/* adding unique constraint */
ALTER TABLE Department
ADD CONSTRAINT Department_Unq_dept_code 
UNIQUE(Department_Code)
/*
---------------------------------------------------------------------------------------------------
DROPPING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/
/* removing primary key */
ALTER TABLE Department
DROP PRIMARY KEY ;

/* removing the unique constraint */
ALTER TABLE Department
DROP INDEX Department_Unq_dept_code;

dropping unique constraint 
ALTER TABLE Department DROP INDEX Index_dept_name;
/*
===================================================================================================
CREATING TABLE 
---------------------------------------------------------------------------------------------------
*/
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee(
	 Employee_id int  NOT NULL
	,First_Name varchar(20)
	,Middle_Name varchar(20)
	,Last_Name varchar(20) 
	,Emp_Gender varchar(6)
	,Hire_Date date
	,Emp_Phone varchar(10)
	,Emp_Email varchar(30) NOT NULL 
	,Emp_Salary float
	,Emp_Comm float
	,Emp_Address int DEFAULT NULL
	,Emp_Dept int DEFAULT NULL
	,Employee_Mgr int DEFAULT NULL
 );
 /*
---------------------------------------------------------------------------------------------------
ADDING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/
ALTER TABLE Employee
ADD CONSTRAINT Employee_pk_emp_id 
PRIMARY KEY (Employee_id);

ALTER TABLE Employee
MODIFY COLUMN First_Name varchar(20) NOT NULL;

ALTER TABLE Employee
MODIFY COLUMN Last_Name varchar(20) NOT NULL;

ALTER TABLE Employee 
MODIFY COLUMN Hire_Date date NOT NULL;

/* adding check constraint */
ALTER TABLE Employee
ADD CONSTRAINT Employee_Chk_emp_gender 
CHECK(Emp_Gender IN('Male', 'Female'));

/* adding unique constraint */
ALTER TABLE Employee
ADD CONSTRAINT Employee_Unq_emp_email 
UNIQUE(Emp_Email)

/* adding the forigen keys */
ALTER TABLE Employee
ADD CONSTRAINT Employee_Fk_emp_dept_dept_id 
FOREIGN KEY(Emp_Dept) 
REFERENCES Department(Department_id)
ON DELETE SET NULL 
ON UPDATE CASCADE;

ALTER TABLE Employee 
ADD CONSTRAINT Employee_Fk_emp_mgr_emp_id
FOREIGN KEY(Employee_Mgr)
REFERENCES Employee(Employee_id);

ALTER TABLE Employee
ADD CONSTRAINT Employee_Fk_emp_addr_addr_id
FOREIGN KEY(Emp_Address)
REFERENCES Address(Address_Id);

ALTER TABLE Employee
MODIFY  Middle_Name varchar(20) DEFAULT NULL;

ALTER TABLE Employee
MODIFY Emp_Phone varchar(10)DEFAULT NULL;

ALTER TABLE Employee
MODIFY Emp_Salary float DEFAULT NULL;

ALTER TABLE Employee
MODIFY Emp_Comm float DEFAULT NULL ;

/*
---------------------------------------------------------------------------------------------------
DROPPING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/
/* removing primary key */
ALTER TABLE Employee
DROP PRIMARY KEY ;

/* removing not null */
ALTER TABLE Employee 
MODIFY  COLUMN Last_Name VARCHAR(20);

/* removing check constraint */
ALTER TABLE Employee
DROP CHECK Employee_Chk_emp_gender;

/* removing unique constraint */
ALTER TABLE Employee
DROP INDEX Employee_Unq_emp_email;

/* remoiving forigen key*/
ALTER TABLE Employee
DROP FOREIGN KEY Employee_Fk_emp_dept_dept_id;

ALTER TABLE Employee
ALTER COLUMN Emp_Comm DROP DEFAULT;
/*
===================================================================================================
CREATING TABLE 
---------------------------------------------------------------------------------------------------
*/
DROP TABLE IF EXISTS Education;
CREATE TABLE Education(
	Education_Id int  NOT NULL
	,High_School varchar(50)
	,Intermediate varchar(50)
	,Graducation varchar(50) 
	,Post_Graduation varchar(50) 
	,Emp_Id int NOT NULL		
 );
 /*
---------------------------------------------------------------------------------------------------
ADDING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/
ALTER TABLE Education 
ADD CONSTRAINT Education_Pk_education_id 
PRIMARY KEY (Education_Id);

ALTER TABLE Education 
MODIFY COLUMN Emp_Id int NOT NULL;

ALTER TABLE Education
ADD CONSTRAINT Education_Fk_emp_id_emp_id
FOREIGN KEY(Emp_Id) REFERENCES Employee(Employee_id)
ON DELETE CASCADE;

ALTER TABLE Education
MODIFY High_School varchar(50) DEFAULT NULL;

ALTER TABLE Education
MODIFY Intermediate varchar(50)DEFAULT NULL;

ALTER TABLE Education
MODIFY Graducation varchar(50)DEFAULT NULL;

ALTER TABLE Education
MODIFY Post_Graduation varchar(50)DEFAULT NULL;
/*
---------------------------------------------------------------------------------------------------
DROPPING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER TABLE Education
DROP  PRIMARY KEY Education_Pk_education_id;

/* removing forigen key */
ALTER TABLE Education
DROP FOREIGN KEY Education_Fk_emp_id_emp_id;

/* removing default value */
ALTER TABLE Education
ALTER COLUMN Post_Graduation DROP DEFAULT;
/*
===================================================================================================
CREATING TABLE 
---------------------------------------------------------------------------------------------------
*/
DROP TABLE IF EXISTS Employment_History;
CREATE TABLE Employment_History(
	Employement_Id int NOT NULL
	,Company_Name varchar(50) DEFAULT NULL
	,Company_Location int NOT NULL
	,Company_Phone varchar(12)
	,Emp_Id int  NOT NULL
 );
 /*
---------------------------------------------------------------------------------------------------
ADDING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/
ALTER TABLE Employment_History 
ADD CONSTRAINT Employment_History_pk_employement_id 
PRIMARY KEY (Employement_id);

ALTER TABLE Employment_History 
ADD CONSTRAINT Employment_History_Fk_coy_addr_addr_id
	 FOREIGN KEY(Company_Location) REFERENCES Address(Address_Id)
	 ON DELETE CASCADE;
	 
ALTER TABLE Employment_History 
ADD CONSTRAINT Employment_History_Fk_emp_id_emp_id
	 FOREIGN KEY(Emp_Id) REFERENCES Employee(Employee_id)
	 ON DELETE CASCADE;

ALTER TABLE Employment_History 
MODIFY COLUMN Company_Phone varchar(12) NOT NULL;
/*
---------------------------------------------------------------------------------------------------
DROPPING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/

ALTER Table Employment_History 
DROP PRIMARY KEY ;

ALTER TABLE Employment_History 
DROP FOREIGN KEY Employment_History_Fk_coy_addr_addr_id;

removing not null
ALTER TABLE employment_history 
MODIFY  COLUMN Company_Phone VARCHAR(12);
/*
---------------------------------------------------------------------------------------------------
ADDING AND REMOVING COLUMN FROM TABLE
---------------------------------------------------------------------------------------------------
*/
ALTER TABLE DEPARTMENT ADD COLUMN country VARCHAR(20);

ALTER TABLE DEPARTMENT DROP COLUMN country ; 

/*=================================================================================================*/

===================================================================================================
VIEWS 
==============================================================
Creating View
---------------------------------------------------------------------------------------------------------------
 CREATE 
  [ALGORITHM = {MERGE  | TEMPTABLE | UNDEFINED}]
VIEW [database_name].  [view_name 
AS
[SELECT  statement]

The algorithm attribute allows you to control which mechanism is used when creating a view.
MERGE means the input query will combine with the SELECT statement in the view definition and MySQL will execute the combined query to return the result set. This mechanism is more efficient than using TEMPTABLE (temporary table) but MERGE only allowed when the rows in the view represent a one-to-one relationship with the rows in the underlying table. In case the MERGE is not allowed, MySQL will switch the algorithm to UNDEFINED. The combination of input query and query in view definition into one query sometimes refers as view resolution.
TEMPTABLE means MySQL first create a temporary table based on SELECT statements in the view definition, and then it executes the input query against this temporary table. Because MySQL has to create temporary table to store the result set so it has to move the data from the real database table to the temporary table therefore TEMPTABLE mechanism is less efficient than MERGE. In addition, views which use TEMPTABLE algorithm is not updateable.
UNDEFINED is the default algorithm when you create a view without declaring explicit algorithm. UNDEFINED algorithm enables MySQL make a decision whether to use MERGE or TEMPTABLE. It prefers MERGE to TEMPTABLE.
---------------------------------------------------------------------------------------------------------------
Updating a VIEW
---------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW view_name AS
SELECT columns
FROM table
WHERE predicates;
---------------------------------------------------------------------------------------------------------------
Dropping a VIEW
---------------------------------------------------------------------------------------------------------------
DROP VIEW [IF EXISTS]
    view_name [, view_name] ...
    [RESTRICT | CASCADE]
---------------------------------------------------------------------------------------------------------------
Alter a VIEW
---------------------------------------------------------------------------------------------------------------

    ALTER [<algorithm attributes>] VIEW [<database>.]< name> [(<columns>)] AS
<SELECT statement> [<check options>]
==============================================================
==============================================================
INDEX 
==============================================================
CRATING 
---------------------------------------------------------------------------------------------------------------
CREATE INDEX <index_name>
on <TABLE_NAME>(<columns_names>);
---------------------------------------------------------------------------------------------------------------
DROPPING INDEX 
---------------------------------------------------------------------------------------------------------------
DROP INDEX <table_name>.<index_name>;
==============================================================
==============================================================
CREATING TRIGGER

CREATE  
    TRIGGER `event_name` BEFORE/AFTER INSERT/UPDATE/DELETE  
    ON `database`.`table`  
    FOR EACH ROW BEGIN  
        -- trigger body  
        -- this code is applied to every  
        -- inserted/updated/deleted row  
    END;  

DELETING TRIGGER
    DROP TRIGGER [IF EXISTS] [schema_name.]trigger_name
DROPPING TRIGGER 
    DROP TRIGGER TABLENAME.TRIGGERNAME 
==============================================================

==============================================================