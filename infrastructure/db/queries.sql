''' Login '''
SELECT * FROM Users WHERE U_Username = '${Username}' AND U_Password = '${Password}'

''' Search Film By Name '''
SELECT F_Name FROM Films WHERE F_Name LIKE '${String}%'

''' Search By Category '''
SELECT F_Name FROM Films WHERE F_Category LIKE '%${Category}%'

''' Choosing A Film '''
SELECT * FROM Films WHERE F_Name = '${Film_Name}'

''' Add a Rating '''
UPDATE `Film_Library`.`films` SET `F_Rating` = '${(F_Rating * F_Count_Ratings + F_Added_Rating) / (F_Count_Ratings + 1)}' WHERE (`F_ID` = '${F_ID}');
UPDATE `Film_Library`.`films` SET `F_Count_Ratings` = `F_Count_Ratings` + 1;

''' Pull The Entire Film List '''
SELECT F_Name FROM Films

''' Pull Actor List '''
SELECT * FROM actors

''' Search Actor By Name '''
SELECT * FROM actors WHERE A_Name LIKE '${String}%'
