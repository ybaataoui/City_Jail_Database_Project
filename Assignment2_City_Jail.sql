USE [CITY_JAIL]
/*Add foreign keys and checks constraint.*/

ALTER TABLE Aliases ALTER COLUMN Criminal_ID INTEGER NOT NULL;
ALTER TABLE Aliases ADD CONSTRAINT criminals_fk FOREIGN KEY(Criminal_ID) REFERENCES Criminals(Criminal_ID);


ALTER TABLE Criminals ADD CONSTRAINT criminals_v_status CHECK (V_status IN ('N', 'Y')), 
		          CONSTRAINT criminals_p_status CHECK (P_status IN ('N', 'Y'));

ALTER TABLE Crimes ALTER COLUMN Criminal_ID INTEGER NOT NULL;
ALTER TABLE Crimes ADD CONSTRAINT crimes_criminals_fk FOREIGN KEY(Criminal_ID) REFERENCES Criminals(Criminal_ID),
	               CONSTRAINT classification_crime CHECK (Classification_Crime IN ('F', 'M', 'O', 'U')),
		   CONSTRAINT v_status CHECK (Crime_status IN ('CL', 'CA', 'IA'));

ALTER TABLE Sentences ALTER COLUMN Criminal_ID INTEGER NOT NULL;
ALTER TABLE Sentences ADD CONSTRAINT Sentences_criminals_fk FOREIGN KEY (Criminal_ID) REFERENCES Criminals(Criminal_ID),
CONSTRAINT prob_Officers_fk FOREIGN KEY (Prob_ID) 
REFERENCES Prob_officers(Prob_ID),
			  CONSTRAINT s_type CHECK (S_Type IN ('J', 'H', 'P'));

ALTER TABLE Prob_officers ADD CONSTRAINT prob_officer_status CHECK (Status IN ('A', 'I'));

ALTER TABLE Officers ADD CONSTRAINT o_status CHECK (O_Status IN ('A', 'I'));

/*Third, use the CREATE TABLE command to build the three tables dropped in the first step.*/

CREATE TABLE Appeals
(Appeal_ID INT,
Crime_ID INT,
Filing_date Date,
Hearing_Date Date,
A_Status CHAR(1) DEFAULT 'P',
	CONSTRAINT appeals_pk PRIMARY KEY (Appeal_ID),
	CONSTRAINT appeals_crimes_fk FOREIGN KEY (Crime_ID) REFERENCES Crimes(Crime_ID),
	CONSTRAINT appeal_status CHECK (A_Status IN ('P', 'A', 'D')));

ALTER TABLE Appeals ALTER COLUMN Crime_ID INTEGER NOT NULL; // make Crime_ID not null in the appeals table

CREATE TABLE Crime_officers
(Crime_ID INT,
Officer_ID INT,
	CONSTRAINT crime_officers_fk FOREIGN KEY (Officer_ID) REFERENCES Officers(Officer_ID),
	CONSTRAINT crimes_fk FOREIGN KEY (Crime_ID) REFERENCES Crimes(Crime_ID));

CREATE TABLE Crime_charges
(Charge_ID INT,
Crime_ID INT,
Crime_code INT,
Charge_status CHAR(2),
Fine_amount DECIMAL(7,2),
Court_fee DECIMAL(7,2),
Amount_paid DECIMAL(7,2),
Pay_due_date Date,
	CONSTRAINT crime_charges_pk PRIMARY KEY (Charge_ID),
	CONSTRAINT Crime_charges_crimes_fk FOREIGN KEY (Crime_ID) REFERENCES Crimes(Crime_ID),
	CONSTRAINT charge_status CHECK (Charge_status IN ('PD', 'GL', 'NG')));
