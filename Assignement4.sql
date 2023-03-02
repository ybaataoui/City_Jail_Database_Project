
/* Youssef Baataoui */
/* City Jail Database */

/* The following list reflects common data requests from city managers. Write the SQL statements to satisfy the requests. */
USE [City_Jail_DB];

/* List all criminal aliases beginning with the letter B */
SELECT alias 
FROM aliases 
WHERE alias LIKE 'B%';

/* List all crimes that occurred (were charged) during the month October 2008. List the crime ID, criminal ID, date charged, and classification. */
SELECT crime_id, criminal_id, date_charged, classification 
FROM crimes 
WHERE date_charged BETWEEN '01-OCT-08' AND '31-OCT-08';


/* List all crimes with a status of CA(can appeal) or IA(in appeal). List the crime ID, criminal ID, date charged, and status. */
SELECT crime_id, criminal_id, date_charged, status 
FROM crimes 
WHERE status = 'CA' OR status = 'IA';


/* List all crimes classified as a felony. List the crime ID, criminal ID, date charged, and classification. */
SELECT crime_id, criminal_id, date_charged, classification 
FROM crimes 
WHERE classification = 'F';


/* List all crimes with a hearing date more than 14 days after the date charged. List the crime ID, criminal ID, date charged, and hearing date. */
SELECT crime_id, criminal_id, date_charged, hearing_date 
FROM crimes 
WHERE DATEDIFF(day, date_charged, hearing_date) > 14;


/* List all criminals with the zip code 23510. List the criminal ID, last name, and zip code. Sort the list by criminal ID. */
SELECT criminal_id, last, zip 
FROM criminals
WHERE zip = '23510' ORDER By criminal_id;


/* List all crimes that don't have a hearing date scheduled. List the crime ID, criminal ID, date charged, and hearing date. */
SELECT crime_id, criminal_id, date_charged, hearing_date 
FROM crimes 
WHERE hearing_date IS NULL;


/* List all sentences with a probation officer assigned. List the sentence ID, criminal ID, and probation officer ID. Sort the list by probation officer ID and then criminal ID. */
SELECT sentence_id, criminal_id, prob_id 
FROM sentences 
WHERE prob_id IS NOT NULL
	ORDER BY prob_id, criminal_id;

/* List all criminals along with the crime charges filed. The report needs to include the criminal ID, name, crime code, and fine amount. */
USE [City_Jail_DB];

SELECT criminals.criminal_id, last, first, crime_code, fine_amount
FROM criminals, crime_charges, crimes
WHERE criminals.criminal_id = crimes.criminal_id AND crimes.crime_id = crime_charges.crime_id;

/* JOIN Method */
SELECT c.criminal_id, last, first, crime_code, fine_amount
FROM criminals c
JOIN crimes cr
	ON c.criminal_id = cr.criminal_id
JOIN crime_charges ch
	ON cr.crime_id = ch.crime_id;

/* List all criminals along with crime status and appeal status (if applicable). The reports need to include the criminal ID, name, 
crime classification, date charged, appeal filing date, and appeal status. Show all criminals, regardless of whether they have filed an appeal. */

/* Traditional Method */
SELECT criminals.criminal_id, last, first, classification, date_charged, filing_date, appeals.status
FROM criminals, crimes, appeals
WHERE criminals.criminal_id = crimes.criminal_id AND crimes.crime_id = appeals.crime_id;

/* JOIN Method */
SELECT c.criminal_id, last, first, classification, date_charged, filing_date, a.status
FROM criminals c
JOIN crimes cr
	ON c.criminal_id = cr.criminal_id
JOIN appeals a
	ON cr.crime_id = a.crime_id;

/*List all criminals along with crime information. The report needs to include the criminal ID, name, 
crime classification, date charged, crime code, and fine amount. Include only crimes classified as “Other.” 
Sort the list by criminal ID and date charged.*/

/* Traditiona Method */
SELECT criminals.criminal_id, last, first, classification, date_charged, crime_code, fine_amount
FROM criminals, crime_charges, crimes
WHERE criminals.criminal_id = crimes.criminal_id AND crimes.crime_id = crime_charges.crime_id 
	AND classification = 'O'
	ORDER BY criminal_id, date_charged;

/* JOIN Method*/
SELECT c.criminal_id, last, first, classification, date_charged, crime_code, fine_amount
FROM criminals c
JOIN crimes cr
	ON c.criminal_id = cr.criminal_id
JOIN crime_charges ch
	ON cr.crime_id = ch.crime_id
	AND cr.classification = 'O'
ORDER BY criminal_id, date_charged;



/* Create an alphabetical list of all criminals, including criminal ID, 
name, violent offender status, parole status, and any known aliases. */

SELECT c.criminal_id, c.first, c.last, c.v_status, c.p_status, a.alias
FROM criminals c LEFT OUTER JOIN aliases a
  ON c.criminal_id = a.criminal_id
ORDER BY first;

/*5.	A table named Prob_Contact contains the required frequency of contact with a probation officer, 
based on the length of the probation period (the number of days assigned to probation). Review the data 
in this table, which indicates ranges for the number of days and applicable contact frequencies. 
Create a list containing the name of each criminal who has been assigned a probation period, which is indicated by the sentence type.
The list should contain the criminal name, probation start date, probation end date, and required frequency of contact. 
Sort the list by criminal name and probation start date.*/

/* Traditional Method */
SELECT first, last, start_date, end_date, con_freq
From criminals c, prob_contact p, sentences s
where c.criminal_id = s.criminal_id
	AND DATEDIFF(day, s.start_date, s.end_date) >= p.low_amt  
	AND DATEDIFF(day, s.start_date, s.end_date) <= p.high_amt
	AND s.type = 'P'
	ORDER BY c.first, c.last, s.start_date;

/* Join Method */
SELECT c.last, c.first, s.start_date, s.end_date, p.con_freq
From criminals c
JOIN sentences s
	ON s.type = 'P'
JOIN prob_contact p
	ON DATEDIFF(day, s.start_date, s.end_date) >= p.low_amt
	AND DATEDIFF(day, s.start_date, s.end_date) <= p.high_amt
ORDER BY last, first, start_date;

/* A column named Mgr_ID has been added to the Prob_Officers table and contains the ID number 
of the probation supervisor for each officer. Produce a list showing each probation officer’s 
name and his or her supervisor’s name. Sort the list alphabetically by probation officer name.*/

/* Traditional Method */
SELECT pro.last, pro.first, mgr.last AS "Manager Last Name", mgr.first AS
"Manager First Name"
FROM prob_officers pro, prob_officers mgr
WHERE pro.mgr_id = mgr.prob_id
ORDER BY pro.last, pro.first;

/* Join Method */
SELECT pro.last, pro.first, mgr.last AS "Manager Last Name", mgr.first AS
"Manager First Name"
FROM prob_officers pro LEFT OUTER JOIN prob_officers mgr
	ON pro.mgr_id = mgr.prob_id
ORDER BY pro.last, pro.first;
