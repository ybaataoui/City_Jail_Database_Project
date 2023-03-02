USE [City_Jail_DB]

/*1.  List the following information for all crimes that have a period greater than 14 days between the date charged and the hearing date: 
crime ID, classification, date charged, hearing date, and number of days between the date charged and the hearing date.*/

SELECT crime_id, classification, date_charged, hearing_date, 
	DATEDIFF(day, date_charged, hearing_date) as number_days
FROM crimes  
WHERE DATEDIFF(day, date_charged, hearing_date) > 14;

/*2. Produce a list showing each active police officer and his or her community assignment, 
indicated by the second letter of the precinct code. Display the community description listed 
in the following chart, based on the second letter of the precinct code.*/

SELECT last, first, 
	(CASE  
		 WHEN precinct LIKE '_A%' THEN 'Shady Grove'
		 WHEN precinct LIKE '_B%' THEN 'Center City'
	     WHEN precinct LIKE '_C%' THEN 'Bay Landing' 
		 ELSE NULL
		 END) as community_description
FROM Officers 
WHERE status = 'A';

/*3.Produce a list of sentencing information to include criminal ID, name (displayed in all uppercase letters), 
sentence ID, sentence start date, and length in months of the sentence. 
The number of months should be shown as a whole number. The start date should be displayed in the format “December 17, 2009.”*/

SELECT c.criminal_id, UPPER(c.first) as First_Name, UPPER(c.last) as Last_Name, 
	s.sentence_id, FORMAT (s.start_date, 'MMMM dd, yyyy') as StartDate, 
	DATEDIFF(month, s.start_date, s.end_date) as Months_Number
FROM criminals c, sentences s
WHERE s.criminal_id = c.criminal_id;

/*4.A list of all amounts owed is needed. Create a list showing each criminal name, charge ID, total amount owed (fine amount plus court fee), 
amount paid, amount owed, and payment due date. If nothing has been paid to date, the amount paid is NULL. Include only criminals who owe some 
amount of money. Display the dollar amounts with a dollar sign and two decimals.*/

SELECT c.first, c.last, ch.charge_id, FORMAT((ch.fine_amount + ch.court_fee), 'C') as Total_Amount, 
FORMAT(ch.amount_paid,'C') as Amount_Paid, FORMAT(((ch.fine_amount + ch.court_fee) - amount_paid), 'C') as Amount_Owed, ch.pay_due_date
FROM criminals c, crime_charges ch, crimes cr
WHERE ch.crime_id = cr.crime_id 
	AND cr.criminal_id = c.criminal_id 
	AND ((ch.fine_amount + ch.court_fee) - amount_paid) > 0;

SELECT c.first, c.last, ch.charge_id, FORMAT((ch.fine_amount + ch.court_fee), 'C') as Total_Amount, 
FORMAT(ch.amount_paid,'C') as Amount_Paid, FORMAT(((ch.fine_amount + ch.court_fee) - amount_paid), 'C') as Amount_Owed, ch.pay_due_date
FROM crime_charges ch 
JOIN crimes cr
	ON ch.crime_id = cr.crime_id 
JOIN criminals c
	ON cr.criminal_id = c.criminal_id
WHERE ((ch.fine_amount + ch.court_fee) - amount_paid) > 0;

/*5.Display the criminal name and probation start date for all criminals who have a probation period greater than two months. 
Also, display the date that’s two months from the beginning of the probation period, which will serve as a review date.*/

SELECT c.first, c.last, s.start_date, DATEDIFF(month, s.start_date, s.end_date) as Nbr_Of_Months, 
DATEADD(month, 2, s.start_date) as review_date
FROM criminals c, sentences s
WHERE c.criminal_id = s.criminal_id 
		AND DATEDIFF(month, s.start_date, s.end_date) > 2;