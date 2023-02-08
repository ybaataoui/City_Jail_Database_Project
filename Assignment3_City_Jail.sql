/*1.	The head DBA has requested the creation of a sequence for the primary key columns of the Criminals and Crimes tables. After creating the sequences, 
add a new criminal named Manie Capella to the Criminals table by using the correct sequence. 
(Use any values for the remainder of columns.)*/

USE [CITY_JAIL]

CREATE SEQUENCE criminal_id_seq
START WITH 1
INCREMENT BY 1
NO CACHE
NO CYCLE;

INSERT INTO criminals (criminal_id, Last_Name, First_Name, street, city, zip, phone, v_status, p_status) 
	VALUES (NEXT VALUE FOR criminal_id_seq, 'Manie','Capella','1105 Tree Lane', 'Virginia Beach', '23510', 7576778484, 'Y', 'N');

CREATE SEQUENCE crime_id_seq
START WITH 1
INCREMENT BY 1
NO CACHE
NO CYCLE;


/*2.	A crime needs to be added for the criminal, too. Add a row to the Crimes table, referencing the sequence value 
already generated for the Criminal_ID and using the correct sequence to generate the Crime_ID value. 
(Use any values for the remainder of columns.)*/

INSERT INTO crimes (crime_id, criminal_id, Classification_Crime, Crime_status, Hearing_Date, appeal_cut_date)
  VALUES (NEXT VALUE FOR crime_id_seq, 5, 'M', 'CA', '25-NOV-08', '15-FEB-09');

/*3.The last name, street, and phone number columns of the Criminals table are used quite often in the WHERE clause condition of queries. 
Create objects that might improve data retrieval for these queries.*/

CREATE SYNONYM
Last_Name
FOR Last_Name.criminals;

CREATE SYNONYM
Street
FOR Street.criminals;

CREATE SYNONYM
Phone
FOR Phone.criminals;

/*4.Would a bitmap index be appropriate for any columns in the City Jail database (assuming the columns are used in search and/or sort operations)? If so, identify the columns and explain why a bitmap index is appropriate for them.*/

/*A bitmap index would be appropriate for the crimes table, specifically the classification column. Because we have multiple crime types, 
the index will speed up the search of criminals who performed a specific type of crime.*/

/*5.Would using the City Jail database be any easier with the creation of synonyms? Explain why or why not.

I think using the City Jail database will be easy with the creation of synonyms if we are going to reference the database from different servers, 
or if multiple users are going to use it from different locations. For example, to reference a table in the database from another server we need 
to use the whole parts name, Server1.Youssef. City_Jail.Crimes, but with the synonyms, we can create one name that refers to the Crimes tables 
and use it in every server we want. Also, if the database location changes, we can just drop the synonym and create a new one with the same name that points to the new location.*/
