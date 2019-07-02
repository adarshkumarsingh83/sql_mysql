
--------------------------------------------------------------------------------------------------------------------------------------------------
SET @selecAlltEmpFunction = selectAllEmpFunction();
select @selecAlltEmpFunction;
--------------------------------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
DROP FUNCTION IF EXISTS selectAllEmpFunction$$
CREATE DEFINER=`root`@`localhost`FUNCTION selectAllEmpFunction()RETURNS VARCHAR(1024)
LANGUAGE SQL
READS SQL DATA
DETERMINISTIC
BEGIN
   DECLARE EMP_DATA VARCHAR(1024) DEFAULT "";
   DECLARE EXIT_LOOP INTEGER DEFAULT 0;
   DECLARE EMP_ID INTEGER DEFAULT 0;
   DECLARE EMP_NAME VARCHAR(45) DEFAULT "";
   DECLARE EMP_EMAIL VARCHAR(30) DEFAULT "";

   DECLARE EMP_CURSOR CURSOR FOR SELECT EMPNO,EMPNAME,EMPEMAIL FROM EMPLOYEE;
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET EXIT_LOOP = 1;

     OPEN EMP_CURSOR;

         READ_EMP_DATA_LOOP:LOOP

               FETCH EMP_CURSOR INTO EMP_ID,EMP_NAME,EMP_EMAIL;

               IF EXIT_LOOP = 1 THEN
                  LEAVE READ_EMP_DATA_LOOP;
               END IF;

                  SET EMP_DATA=CONCAT(EMP_ID,',',EMP_NAME,',',EMP_EMAIL,';',EMP_DATA);

        END LOOP READ_EMP_DATA_LOOP;

   CLOSE EMP_CURSOR;

   IF CHAR_LENGTH(EMP_DATA)!= 0 THEN
     RETURN COALESCE(EMP_DATA);
   ELSE
     RETURN CONCAT('NO DATA NOT FOUND IN EMPLOYEE TABLE ' );
   END IF;

END $$
DELIMITER ;
--------------------------------------------------------------------------------------------------------------------------------------------------
SET @selectEmpData = selectEmpFunction(6);
select @selectEmpData;
--------------------------------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
DROP FUNCTION IF EXISTS selectEmpFunction$$
CREATE DEFINER=`root`@`%`FUNCTION selectEmpFunction(EMP_NO INT)RETURNS VARCHAR(85)
LANGUAGE SQL
READS SQL DATA
DETERMINISTIC
BEGIN
   DECLARE EMP_DATA VARCHAR(85) DEFAULT NULL;
   DECLARE EMP_ID INT(10) DEFAULT NULL;
   DECLARE EMP_NAME VARCHAR(45) DEFAULT NULL;
   DECLARE EMP_EMAIL VARCHAR(30) DEFAULT NULL;

   SELECT EMPNO INTO EMP_ID FROM EMPLOYEE WHERE EMPNO =EMP_NO;
   SELECT EMPNAME INTO EMP_NAME FROM EMPLOYEE WHERE EMPNO =EMP_NO;
   SELECT EMPEMAIL INTO EMP_EMAIL FROM EMPLOYEE WHERE EMPNO =EMP_NO;


   SET EMP_DATA=(CONCAT(EMP_ID,', ',EMP_NAME,', ',EMP_EMAIL));

   IF CHAR_LENGTH(EMP_DATA)!= 0 THEN
     RETURN COALESCE(EMP_DATA);
   ELSE
       RETURN CONCAT('DATA NOT FOUND FOR EMPLOYEE WITH ID  => ',EMP_NO);
   END IF;

END $$
DELIMITER ;
--------------------------------------------------------------------------------------------------------------------------------------------------
SET @insertEmpCount = insertEmpFunction(6,'sonu Singh','sonu@singh.com');
select @insertEmpCount;
--------------------------------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
DROP FUNCTION IF EXISTS insertEmpFunction$$
CREATE DEFINER=`root`@`%` FUNCTION insertEmpFunction(EMP_NO INT(10),EMP_NAME VARCHAR(45),EMP_EMAIL VARCHAR(30))RETURNS VARCHAR(100)
LANGUAGE SQL
DETERMINISTIC
BEGIN
   DECLARE RESULT_INSERT VARCHAR(100) DEFAULT NULL;
   INSERT INTO EMPLOYEE(EMPNO,EMPNAME,EMPEMAIL)VALUES(EMP_NO,EMP_NAME,EMP_EMAIL);

   IF (SELECT ROW_COUNT()) != 0 THEN
    SET RESULT_INSERT= (CONCAT('NEW RECORD CREATED SUCCESSFULLY ',(SELECT ROW_COUNT())));
   ELSE
    SET RESULT_INSERT= (CONCAT('NEW RECORD NOT CREATED SUCCESSFULLY ',(SELECT ROW_COUNT())));
   END IF;

   RETURN (RESULT_INSERT);
END $$
DELIMITER ;
--------------------------------------------------------------------------------------------------------------------------------------------------
SET @updateEmpCount = updateEmpFunction(2,'Amit Kumar Singh','amitkumar@singh.com');
select @updateEmpCount;
--------------------------------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
DROP FUNCTION IF EXISTS updateEmpFunction$$
CREATE DEFINER=`root`@`%` FUNCTION updateEmpFunction(EMP_NO INT(10),EMP_NAME VARCHAR(45),EMP_EMAIL VARCHAR(30))RETURNS VARCHAR(100)
LANGUAGE SQL
DETERMINISTIC
BEGIN

   DECLARE RESULT_UPDATE VARCHAR(100) DEFAULT NULL;
   UPDATE EMPLOYEE SET EMPNAME=EMP_NAME, EMPEMAIL=EMP_EMAIL WHERE EMPNO=EMP_NO;

   IF (SELECT ROW_COUNT()) != 0 THEN
    SET RESULT_UPDATE= (CONCAT('RECORD UPDATED SUCCESSFULLY ',(SELECT ROW_COUNT())));
   ELSE
    SET RESULT_UPDATE= (CONCAT('RECORD NOT UPDATED SUCCESSFULLY ',(SELECT ROW_COUNT())));
   END IF;

   RETURN (RESULT_UPDATE);
END $$
DELIMITER ;
--------------------------------------------------------------------------------------------------------------------------------------------------
SET @deletedEmpCount = deleteEmpFunction(7);
select @deletedEmpCount;
--------------------------------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
DROP FUNCTION IF EXISTS deleteEmpFunction$$
CREATE DEFINER=`root`@`%` FUNCTION deleteEmpFunction(EMP_NO INT)RETURNS VARCHAR(100)
LANGUAGE SQL
DETERMINISTIC
BEGIN
   DECLARE RESULT_DELETE VARCHAR(100) DEFAULT NULL;
   DELETE FROM EMPLOYEE WHERE EMPNO = EMP_NO;

   IF (SELECT ROW_COUNT()) != 0 THEN
    SET RESULT_DELETE= (CONCAT('RECORD DELETED SUCCESSFULLY ',(SELECT ROW_COUNT())));
   ELSE
    SET RESULT_DELETE= (CONCAT('RECORD NOT DELETED SUCCESSFULLY ',(SELECT ROW_COUNT())));
   END IF;

   RETURN (RESULT_DELETE);

END $$
DELIMITER ;
--------------------------------------------------------------------------------------------------------------------------------------------------