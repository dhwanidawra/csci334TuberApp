
/*
REF
REF 1 = GREATEST()+1 
REF 2 = must contain capitals or whatever [NOT NECCESSARY]
REF 3 = a bit after current datetime  
REF 4 = current datetime 
REF 5 = restrict input

All issues resolved, for now

ISS
ISS 1 = e.g. SESSION(FK_TOUR_ID) GUIDEMESSAGE(FK_TOUR_ID1) - Is it possible to fix this without renaming the FK using TABLE_NAME?
ISS 2 = not sure if this is the correct type
ISS 3 = unsure what column means - STATE and STATUS are the most puzzling
ISS 4 = is it possible to constrain this in SQL?
*/

CREATE TABLE USERS
(
	/* PK */
	USERS_ID        VARCHAR(30)    	NOT NULL, /* USERNAME */
    
	/* CK */
	GUIDE_ID		INT     		NOT NULL, /* REF 1 */ 
	TOURIST_ID		INT				NOT NULL, /* REF 1 */

	PASSWORD        VARCHAR(30)     NOT NULL, /* REF 2 */
	FIRSTNAME 		VARCHAR(30)     NOT NULL,
	LASTNAME 		VARCHAR(30)     NOT NULL,

	CONSTRAINT PK_USERS_ID PRIMARY KEY (USERS_ID),
	CONSTRAINT CK_GUIDE_ID UNIQUE (GUIDE_ID),
    CONSTRAINT CK_TOURIST_ID UNIQUE (TOURIST_ID)
);  

GO

CREATE TABLE ADMINS
(
	/* PK */
	ADMINS_ID       VARCHAR(30)     NOT NULL, /* ADMIN USERNAME */

    PASSWORD        VARCHAR(30)     NOT NULL, /* REF 2 */
	
	CONSTRAINT PK_ADMINS_ID PRIMARY KEY (ADMINS_ID)
);

GO

CREATE TABLE TOUR
(
	/* PK */
	TOUR_ID				INT     		NOT NULL, /* REF 1 */
	
	/* FK */
	GUIDE_ID			INT		     	NOT NULL, 

	TOUR_TITLE	 		VARCHAR(30)     NOT NULL, 
	TOUR_DESCRIPTION	VARCHAR(280)    NOT NULL, 
	LATITUDE			DECIMAL(8,6)  	NOT NULL, 
	LONGITUDE			DECIMAL(9,6)	NOT NULL, 
	AGGREGATE_SCORE		DECIMAL(4,2)	NOT NULL,
	
	/*
	LATITUDE [-90.000000 to 90.000000]
	LONGITUDE [-180.000000 to 180.000000]
	*/

	CONSTRAINT PK_TOUR_ID PRIMARY KEY (TOUR_ID),
	CONSTRAINT FK_TOUR_GUIDE_ID FOREIGN KEY (GUIDE_ID) REFERENCES USERS(GUIDE_ID)
);

GO

CREATE TABLE SESSION
(
	/* PK */
	SESSION_ID			INT     		NOT NULL, /* REF 1 */

	/* CK */
	SESSION_DATETIME 	SMALLDATETIME   NOT NULL, /* REF 3 */
	/* CK FK */
	TOUR_ID				INT				NOT NULL,

	CONSTRAINT PK_SESSION_ID PRIMARY KEY (SESSION_ID),
	CONSTRAINT CK_SESSION UNIQUE (TOUR_ID, SESSION_DATETIME),
	CONSTRAINT FK_SESSION_TOUR_ID FOREIGN KEY (TOUR_ID) REFERENCES TOUR(TOUR_ID)
);

GO

CREATE TABLE BOOKING
(
	/* PK FK */
	SESSION_ID		INT     		NOT NULL,
	TOURIST_ID		INT     		NOT NULL,

	PRICE 			DECIMAL(5,2)    NOT NULL,
	BOOKING_STATE	VARCHAR(30)     NOT NULL, /* ISS 3 */

	CONSTRAINT PK_BOOKING_ID PRIMARY KEY (SESSION_ID, TOURIST_ID),
	CONSTRAINT FK_BOOKING_SESSION_ID FOREIGN KEY (SESSION_ID) REFERENCES SESSION(SESSION_ID),
	CONSTRAINT FK_BOOKING_TOURIST_ID FOREIGN KEY (TOURIST_ID) REFERENCES USERS(TOURIST_ID)
);

GO

CREATE TABLE ISSUE
(
	/* PK FK */
	SESSION_ID			INT     		NOT NULL,
	TOURIST_ID			INT		    	NOT NULL,
	
	/* FK */
	ADMINS_ID			VARCHAR(30)     NOT NULL,
	
	ISSUE_DATETIME 		SMALLDATETIME   NOT NULL, /* REF 4 */
	ISSUE_DESCRIPTION	VARCHAR(280)    NOT NULL, 
	ISSUE_STATUS		VARCHAR(30)     NOT NULL, /* ISS 3 */
	ISSUE_SUBJECT		VARCHAR(30)     NOT NULL

	CONSTRAINT PK_ISSUE PRIMARY KEY (SESSION_ID, TOURIST_ID),
	CONSTRAINT FK_ISSUE_TOURIST_ID FOREIGN KEY (TOURIST_ID) REFERENCES USERS(TOURIST_ID),
	CONSTRAINT FK_ISSUE_SESSION_ID FOREIGN KEY (SESSION_ID) REFERENCES SESSION(SESSION_ID),
	CONSTRAINT FK_ISSUE_ADMINS_ID FOREIGN KEY (ADMINS_ID) REFERENCES ADMINS(ADMINS_ID)
);

GO

CREATE TABLE GUIDEMESSAGE
(
	/* PK */
	GUIDE_MESSAGE_ID 	INT     		NOT NULL, /* REF 1 */
	
	/* FK */
	TOUR_ID				INT     		NOT NULL, 
	GUIDE_ID			INT     		NOT NULL,
	TOURIST_ID			INT			    NOT NULL, 

	GUIDE_DATETIME 		SMALLDATETIME   NOT NULL, /* REF 4 */
	GUIDE_SUBJECT		VARCHAR(30)     NOT NULL,
	GUIDE_CONTENT		VARCHAR(30)     NOT NULL,

	CONSTRAINT PK_GUIDE_MESSAGE_ID PRIMARY KEY (GUIDE_MESSAGE_ID),
	CONSTRAINT FK_GUIDEMESSAGE_GUIDE_ID FOREIGN KEY (GUIDE_ID) REFERENCES USERS(GUIDE_ID),
	CONSTRAINT FK_GUIDEMESSAGE_TOURIST_ID FOREIGN KEY (TOURIST_ID) REFERENCES USERS(TOURIST_ID), 
	CONSTRAINT FK_GUIDEMESSAGE_TOUR_ID FOREIGN KEY (TOUR_ID) REFERENCES TOUR(TOUR_ID)
);

GO

CREATE TABLE ADMINSMESSAGE
(
	/* PK */
	ADMINS_MESSAGE_ID 	INT     		NOT NULL, /* REF 1 */
	
	/* FK */
	TOUR_ID				INT			    NOT NULL,
	TOURIST_ID			INT			    NOT NULL,
	GUIDE_ID			INT			    NOT NULL,
	ADMINS_ID			VARCHAR(30) 	NOT NULL, 

	ADMINS_DATETIME 	SMALLDATETIME   NOT NULL, /* REF 4 */
	ADMINS_SUBJECT		VARCHAR(30)     NOT NULL,
	ADMINS_CONTENT		VARCHAR(280)    NOT NULL,

	CONSTRAINT PK_ADMINSMESSAGE_ADMINS_MESSAGE_ID PRIMARY KEY (ADMINS_MESSAGE_ID),
	CONSTRAINT FK_ADMINSMESSAGE_TOURIST_ID FOREIGN KEY (TOURIST_ID) REFERENCES USERS(TOURIST_ID), 
	CONSTRAINT FK_ADMINSMESSAGE_ADMINS_ID FOREIGN KEY (ADMINS_ID) REFERENCES ADMINS(ADMINS_ID), 
	CONSTRAINT FK_ADMINSMESSAGE_GUIDE_ID FOREIGN KEY (GUIDE_ID) REFERENCES USERS(GUIDE_ID), 
	CONSTRAINT FK_ADMINSMESSAGE_TOUR_ID FOREIGN KEY (TOUR_ID) REFERENCES TOUR(TOUR_ID) 
);

GO

CREATE TABLE TOURISTMESSAGE
(
	/* PK */
	TOURIST_MESSAGE_ID 	INT			    NOT NULL, /* REF 1 */
	
	/* FK */
	TOUR_ID				INT				NOT NULL,
	TOURIST_ID			INT			    NOT NULL,
	GUIDE_ID			INT			    NOT NULL,
	
	TOURIST_DATETIME 	SMALLDATETIME   NOT NULL, /* REF 4 */
	TOURIST_SUBJECT		VARCHAR(30)     NOT NULL,
	TOURIST_CONTENT		VARCHAR(280)    NOT NULL,

	CONSTRAINT PK_TOURIST_MESSAGE_ID PRIMARY KEY (TOURIST_MESSAGE_ID),
	CONSTRAINT FK_TOURISTMESSAGE_TOURIST_ID FOREIGN KEY (TOURIST_ID) REFERENCES USERS(TOURIST_ID), 
	CONSTRAINT FK_TOURISTMESSAGE_GUIDE_ID FOREIGN KEY (GUIDE_ID) REFERENCES USERS(GUIDE_ID), 
	CONSTRAINT FK_TOURISTMESSAGE_TOUR_ID FOREIGN KEY (TOUR_ID) REFERENCES TOUR(TOUR_ID)
);

GO

/* CURRENT */

CREATE TABLE REVIEW
(
	/* PK FK */
	TOURIST_ID			INT		     	NOT NULL,
	TOUR_ID				INT     		NOT NULL,
	
	SCORE				DECIMAL(4,2)	NOT NULL, /* REF 5 */
	REVIEW_DESCRIPTION 	VARCHAR(280)    NOT NULL, 
	REVIEW_SUBJECT		VARCHAR(280)    NOT NULL, 

	CONSTRAINT PK_REVIEW PRIMARY KEY (TOURIST_ID, TOUR_ID),
	CONSTRAINT FK_REVIEW_TOURIST_ID FOREIGN KEY (TOURIST_ID) REFERENCES USERS(TOURIST_ID), 
	CONSTRAINT FK_REVIEW_TOUR_ID FOREIGN KEY (TOUR_ID) REFERENCES TOUR(TOUR_ID)
);																			  

GO