USE [City Jail Database]
GO
CREATE TABLE Aliases
(Alias_ID INT,
Criminal_ID INT,
Alias VARCHAR(10),
	CONSTRAINT aliases_aliasid_pk PRIMARY KEY(Alias_ID),
	CONSTRAINT aliases_criminal_Id_fk FOREIGN KEY(Criminal_ID)
		REFERENCES Criminals(Criminal_ID));

CREATE TABLE Criminals
(Criminal_ID INT,
Last_Name VARCHAR(15),
First_Name VARCHAR(10),
Street VARCHAR(30),
City VARCHAR(20),
Zip CHAR(5),
Phone CHAR(10),
V_status CHAR(1) DEFAULT 'N',
P_status CHAR(1) DEFAULT 'N',
	CONSTRAINT criminals_criminal_id_pk PRIMARY KEY(Criminal_ID),
	CONSTRAINT criminals_v_status
			CHECK (V_status IN ('N', 'Y')),
	CONSTRAINT criminals_p_status
			CHECK (P_status IN ('N', 'Y')));


CREATE TABLE Crimes
(Crime_ID INT,
Criminal_ID INT,
Classification_Crime CHAR(1),
Crime_status CHAR(2),
Hearing_Date Date,
Appeal_cut_date Date,
	CONSTRAINT crimes_crimeid_pk PRIMARY KEY(Crime_ID),
	CONSTRAINT crimes_criminal_Id_fk FOREIGN KEY(Criminal_ID)
		REFERENCES Criminals(Criminal_ID),
	CONSTRAINT classification_crime
			CHECK (Classification_Crime IN ('F', 'M', 'O', 'U')),
	CONSTRAINT v_status
			CHECK (Crime_status IN ('CL', 'CA', 'IA')));

CREATE TABLE Sentences
(Sentence_ID INT,
Criminal_ID INT,
Prob_ID INT,
Violations INT,
S_Type CHAR(1),
StartDate Date,
End_date Date,
	CONSTRAINT sentences_sentence_id_pk PRIMARY KEY (Sentence_ID),
	CONSTRAINT sentences_criminal_id_fk FOREIGN KEY (Criminal_ID)
		REFERENCES Criminals(Criminal_ID),
	CONSTRAINT sentences_prob_id_fk FOREIGN KEY (Prob_ID)
		REFERENCES Prob_officers(Prob_ID),
	CONSTRAINT s_type
			CHECK (S_Type IN ('J', 'H', 'P')));


CREATE TABLE Prob_officers
(Prob_ID INT,
Last_Name VARCHAR(15),
First_Name VARCHAR(10),
Street VARCHAR(30),
City VARCHAR(20),
State VARCHAR(2),
Zip CHAR(5),
Phone CHAR(10),
Email CHAR(30),
Status CHAR(1) DEFAULT 'A',
	CONSTRAINT prob_officers_prob_id_pk PRIMARY KEY (Prob_ID),
	CONSTRAINT prob_officer_status
			CHECK (Status IN ('A', 'I')));

CREATE TABLE Crime_charges
(Charge_ID INT,
Crime_ID INT,
Crime_code INT,
Charge_status CHAR(2),
Fine_amount DECIMAL(7,2),
Court_fee DECIMAL(7,2),
Amount_paid DECIMAL(7,2),
Pay_due_date Date,
	CONSTRAINT crime_charges_charge_id_pk PRIMARY KEY (Charge_ID),
	CONSTRAINT crime_charges_crime_id_fk FOREIGN KEY (Crime_ID)
		REFERENCES Crimes(Crime_ID),
	CONSTRAINT charge_status
			CHECK (Charge_status IN ('PD', 'GL', 'NG')));

CREATE TABLE Officers
(Officer_ID INT,
Last_Name VARCHAR(15),
First_Name VARCHAR(10),
Badge VARCHAR(14),
Precinct CHAR(4),
Phone CHAR(10),
O_Status CHAR(1) DEFAULT 'A',
	CONSTRAINT officers_officer_id_pk PRIMARY KEY (Officer_ID),
	CONSTRAINT o_status
			CHECK (O_Status IN ('A', 'I')));

CREATE TABLE Crime_officers
(Crime_ID INT,
Officer_ID INT,
	CONSTRAINT crime_officers_officer_id_fk FOREIGN KEY (Officer_ID)
		REFERENCES Officers(Officer_ID),
	CONSTRAINT crime_officers_crime_id_fk FOREIGN KEY (Crime_ID)
		REFERENCES Crimes(Crime_ID));

CREATE TABLE Appeals
(Appeal_ID INT,
Crime_ID INT,
Filing_date Date,
Hearing_Date Date,
A_Status CHAR(1) DEFAULT 'P',
	CONSTRAINT appeals_appeal_id_pk PRIMARY KEY (Appeal_ID),
	CONSTRAINT appeals_crime_id_fk FOREIGN KEY (Crime_ID)
		REFERENCES Crimes(Crime_ID),
	CONSTRAINT a_status
			CHECK (A_Status IN ('P', 'A', 'D')));

CREATE TABLE Crime_codes 
(Crime_code INT,
Code_description VARCHAR(30),
	CONSTRAINT crime_codes_crime_id_pk PRIMARY KEY (Crime_code));






/* Section B */
Add a default value of U for the Classification column of the Crimes table.

ALTER TABLE dbo.Crimes 
ADD DEFAULT ('U') FOR Classification_Crime;

Add a column named Date_Recorded to the Crimes table. This column needs to hold date values and should be set to the current date by default.

ALTER TABLE crimes
ADD date_recorded DATE DEFAULT GETDATE();

Add a column to the Prob_officers table to contain the pager number for each officer. The column needs to accommodate a phone number, including area code. Name the column Pager#.

ALTER TABLE Prob_officers
ADD Pager# CHAR(10);

Change the Alias column in the Aliases table to accommodate up to 20 characters

ALTER TABLE Aliases
ALTER COLUMN Alias VARCHAR(20);
