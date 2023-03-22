use [City_Jail_DB];

/*1. Show the average number of crimes reported by an officer.*/

SELECT COUNT(*) / COUNT(DISTINCT officer_id) AS AvgCrimePerOfficer
FROM crime_officers ;


/*2.	Show the total number of crimes by status.*/
SELECT status, COUNT(*)
FROM crimes
GROUP BY status;

/*3.	List the highest number of crimes committed by a person.*/
use [City_Jail_DB];

SELECT criminal_id, COUNT(*) AS NumberOfCrimes
FROM crimes
WHERE criminal_id IS NOT NULL
GROUP BY criminal_id
ORDER BY COUNT(*) DESC
OFFSET 0 ROW FETCH FIRST 1 ROW ONLY;

/*4.	Display the lowest fine amount assigned to a crime charge.*/

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