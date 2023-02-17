
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


