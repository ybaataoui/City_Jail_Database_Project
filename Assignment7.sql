use [City_Jail_DB];

/*1. Show the average number of crimes reported by an officer.*/

SELECT COUNT(*) / COUNT(DISTINCT officer_id) AS AvgCrimePerOfficer
FROM crime_officers ;


/*2.Show the total number of crimes by status.*/
SELECT status, COUNT(*)
FROM crimes
GROUP BY status;

/*3.List the highest number of crimes committed by a person.*/
use [City_Jail_DB];

SELECT criminal_id, COUNT(*) AS NumberOfCrimes
FROM crimes
WHERE criminal_id IS NOT NULL
GROUP BY criminal_id
ORDER BY COUNT(*) DESC
OFFSET 0 ROW FETCH FIRST 1 ROW ONLY;

/*4.Display the lowest fine amount assigned to a crime charge.*/

use [City_Jail_DB];

SELECT MIN(c.fine_amount)  as LowestFine
FROM crime_charges c

/*5.	List criminals (ID and name) who have multiple sentences assigned.*/
use [City_Jail_DB];

SELECT c.last, s.criminal_id, COUNT(s.sentence_id) AS numberOfSentences
FROM criminals c, sentences s
WHERE c.criminal_id = s.criminal_id
GROUP BY c.last, s.criminal_id
HAVING COUNT(s.sentence_id) > 1
ORDER BY COUNT(s.sentence_id) DESC;

/*6.List the total number of crime charges successfully defended (guilty status assigned) by precinct. 
Include only precincts with at least seven guilty charges.*/

use [City_Jail_DB];

SELECT o.precinct, COUNT(cc.charge_status) AS totalNumberOfCharges
FROM crime_charges cc
	JOIN crime_officers co
		ON cc.crime_id = co.crime_id
	JOIN officers o 
		ON co.officer_id = o.officer_id
WHERE cc.charge_status = 'GL'
GROUP BY o.precinct
HAVING COUNT(cc.charge_status) > 7;

/*7.List the total amount of collections (fines and fees) and the total amount owed by crime classification.*/

SELECT c.classification, SUM(cc.fine_amount + cc.court_fee) as totalAmountOfCollections, 
	SUM((cc.fine_amount + cc.court_fee) - amount_paid) AS totalAmountOwed
FROM crime_charges cc 
	JOIN crimes c
		ON c.crime_id = cc.crime_id
WHERE cc.fine_amount IS NOT NULL AND cc.court_fee IS NOT NULL 
GROUP BY c.classification;

/*8.List the total number of charges by crime classification and charge status. Include a grand total in the results.*/
use [City_Jail_DB];
SELECT c.classification, cc.charge_status, COUNT(c.classification) AS totalNumberOfChageres
FROM crimes c 
	JOIN crime_charges cc
		ON c.crime_id = cc.crime_id
GROUP BY c.classification, cc.charge_status
UNION ALL
SELECT 'Grand Total' classification, ' ' charge_status, COUNT(charge_status)
FROM crime_charges;



/*9.Perform the same task as in Question #8 and add a subtotal for each charge status. */
use [City_Jail_DB];
SELECT c.classification, cc.charge_status, COUNT(c.classification) AS totalNumberOfChageres
FROM crimes c 
	JOIN crime_charges cc
		ON c.crime_id = cc.crime_id
GROUP BY c.classification, ROLLUP(cc.charge_status)
UNION ALL
SELECT 'Grand Total' classification, ' ' charge_status, COUNT(charge_status)
FROM crime_charges;


/*10.Perform the same task as in Question #8 and add a subtotal by each crime classification. */

use [City_Jail_DB];
SELECT c.classification, cc.charge_status, COUNT(c.classification) AS totalNumberOfChageres
FROM crimes c 
	JOIN crime_charges cc
		ON c.crime_id = cc.crime_id
GROUP BY ROLLUP(c.classification), cc.charge_status
UNION ALL
SELECT 'Grand Total' classification, ' ' charge_status, COUNT(charge_status)
FROM crime_charges;

/*1.List the name of each officer who has reported more than the average number of crimes officers have reported.*/

use [City_Jail_DB];

SELECT o.last, o.first, COUNT(co.officer_id) as NumberOfCrimesReportedByOfficer
FROM officers o, crime_officers co
WHERE o.officer_id = co.officer_id 
GROUP By o.last, o.first
HAVING COUNT(co.officer_id) > (
	SELECT COUNT(*) / COUNT(DISTINCT officer_id) AS AvgCrimePerOfficer
	FROM crime_officers) ;

/*2.List the names of all criminals who have committed less than average number of crimes and aren’t listed as violent offenders.
The Average crimes made by criminals is 1 crime, so if we do less and the average there not going to be any criminals*/
use [City_Jail_DB];

SELECT c.last, c.first, COUNT(cs.crime_id) as NbrOfCrimes
FROM criminals c
	JOIN crimes cs
	ON c.criminal_id = cs.criminal_id AND c.v_status = 'N'
GROUP BY c.last, c.first
HAVING COUNT(cs.criminal_id) < (
	SELECT COUNT(*) / COUNT(DISTINCT criminal_id) AS AvgCrimePerCriminal
	FROM criminals ) ;

/*3.List appeal information for each appeal that has a less than average number of 
days between the filing and hearing dates.*/
use [City_Jail_DB];

SELECT appeal_id, crime_id, filing_date, hearing_date, status, 
	DATEDIFF(day, filing_date, hearing_date) AS DaysBetween
From appeals
WHERE DATEDIFF(day, filing_date, hearing_date) < (
	SELECT AVG(DATEDIFF(day, filing_date, hearing_date)) 
	FROM appeals);

/*4.List the names of probation officers who have had a less than average number of criminals assigned.*/
use [City_Jail_DB];

SELECT po.first, po.last
FROM prob_officers po
JOIN sentences s
ON po.prob_id = s.prob_id
GROUP BY po.first, po.last
HAVING COUNT(s.criminal_id) < (
	SELECT COUNT(criminal_id) / COUNT(DISTINCT prob_id)
	from sentences);


/*5. List each crime that has had the highest number of appeals recorded.*/

use [City_Jail_DB];

SELECT crime_id, COUNT(*) AS NumberOfAppeals
FROM appeals
WHERE crime_id IS NOT NULL
GROUP BY crime_id
ORDER BY COUNT(*) DESC
OFFSET 0 ROW FETCH FIRST 1 ROW ONLY;

/*6.List the information on crime charges for each charge that has had a fine above average and a sum paid below average.*/

use [City_Jail_DB];

SELECT *
FROM crime_charges cc
WHERE cc.fine_amount > (
	SELECT AVG(fine_amount) as averageFine FROM crime_charges) 
	AND cc.amount_paid < (
	SELECT AVG(amount_paid) as averagePaid FROM crime_charges);


SELECT AVG(fine_amount) as averageFine FROM crime_charges;

SELECT AVG(amount_paid) as averagePaid FROM crime_charges;

/*7.List the names of all criminals who have had any of the crime code charges involved in crime ID 10089.*/

SELECT c.first, c.last
FROM criminals c
JOIN crimes cs
	ON cs.criminal_id = c.criminal_id
JOIN crime_charges cc
	ON cc.crime_id = cs.crime_id
WHERE cc.crime_id in (SELECT crime_id FROM crime_charges WHERE crime_id = 10089);

/*8.Use a correlated subquery to determine which criminals have had at least one probation period assigned.*/

SELECT c.last, c.first 
FROM criminals c JOIN sentences cs
ON cs.criminal_id = c.criminal_id
WHERE DATEDIFF(day, start_date, end_date) in 
	(SELECT DATEDIFF(day, start_date, end_date)
	 FROM sentences 
	 WHERE DATEDIFF(day, start_date, end_date) > 0);

/*9.List the names of officers who have booked the highest number of crimes. 
Note that more than one officer might be listed.*/

SELECT o.last, o.first, co.officer_id, COUNT(*) AS NumberOfCrimePerOfficer
FROM officers o JOIN crime_officers co
ON o.officer_id = co.officer_id AND co.officer_id IS NOT NULL
GROUP BY co.officer_id, o.last, o.first
ORDER BY COUNT(*) DESC
OFFSET 0 ROW FETCH FIRST 2 ROW ONLY
;

/*10.The criminal data warehouse contains a copy of the CRIMINALS table that needs to be updated periodically from the production CRIMINALS table. 
The data warehouse table is named CRIMINALS_DW. Use a single SQL statement to update the data warehouse table to reflect any data changes for 
existing criminals and to add new criminals.*/

use [City_Jail_DB];

MERGE criminals_dw cd
USING criminals c 
	ON cd.criminal_id = C.criminal_id
WHEN MATCHED 
	THEN UPDATE set cd.last = c.last, cd.first = c.first, cd.street = c.street, cd.city = c.city, 
	 cd.state = c.state, cd.zip = c.zip, cd.phone = c.phone, cd.v_status = c.v_status, cd.p_status = c.p_status
WHEN NOT MATCHED BY TARGET
	THEN insert (last, first, street, city, state, zip, phone, v_status, p_status)
	values(c.last, c.first, c.street, c.city, c.state, c.zip, c.phone, c.v_status, c.p_status);