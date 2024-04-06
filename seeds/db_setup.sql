DROP DATABASE IF EXISTS coursework; 

  

CREATE DATABASE coursework; 

  

USE coursework; 

  

-- Course table 

DROP TABLE IF EXISTS Course; 

  

CREATE TABLE Course ( 

    Crs_Code INT UNSIGNED NOT NULL, 

    Crs_Title VARCHAR(255) NOT NULL, 

    Crs_Enrollment INT UNSIGNED, 

    PRIMARY KEY (Crs_code) 

); 

  

INSERT INTO Course VALUES  

    (100, 'BSc Computer Science', 150), 

    (101, 'BSc Computer Information Technology', 20), 

    (200, 'MSc Data Science', 100), 

    (201, 'MSc Security', 30), 

    (210, 'MSc Electrical Engineering', 70), 

    (211, 'BSc Physics', 100); 

  

-- Student table 

DROP TABLE IF EXISTS Student; 

  

CREATE TABLE Student ( 

    URN INT UNSIGNED NOT NULL, 

    Stu_FName VARCHAR(255) NOT NULL, 

    Stu_LName VARCHAR(255) NOT NULL, 

    Stu_DOB DATE, 

    Stu_Phone VARCHAR(12), 

    Stu_Course INT UNSIGNED NOT NULL, 

    Stu_Type ENUM('UG', 'PG'), 

    PRIMARY KEY (URN), 

    FOREIGN KEY (Stu_Course) REFERENCES Course (Crs_Code) ON DELETE RESTRICT 

); 

  

INSERT INTO Student VALUES 

    (612345, 'Sara', 'Khan', '2002-06-20', '01483112233', 100, 'UG'), 

    (612346, 'Pierre', 'Gervais', '2002-03-12', '01483223344', 100, 'UG'), 

    (612347, 'Patrick', 'O-Hara', '2001-05-03', '01483334455', 100, 'UG'), 

    (612348, 'Iyabo', 'Ogunsola', '2002-04-21', '01483445566', 100, 'UG'), 

    (612349, 'Omar', 'Sharif', '2001-12-29', '01483778899', 100, 'UG'), 

    (612350, 'Yunli', 'Guo', '2002-06-07', '01483123456', 100, 'UG'), 

    (612351, 'Costas', 'Spiliotis', '2002-07-02', '01483234567', 100, 'UG'), 

    (612352, 'Tom', 'Jones', '2001-10-24', '01483456789', 101, 'UG'), 

    (612353, 'Simon', 'Larson', '2002-08-23', '01483998877', 101, 'UG'), 

    (612354, 'Sue', 'Smith', '2002-05-16', '01483776655', 101, 'UG'); 

  

-- Undergraduate table 

DROP TABLE IF EXISTS Undergraduate; 

  

CREATE TABLE Undergraduate ( 

    UG_URN INT UNSIGNED NOT NULL, 

    UG_Credits INT NOT NULL, 

    CHECK (60 <= UG_Credits AND UG_Credits <= 150), 

    PRIMARY KEY (UG_URN), 

    FOREIGN KEY (UG_URN) REFERENCES Student(URN) ON DELETE CASCADE 

); 

  

INSERT INTO Undergraduate VALUES 

    (612345, 120), 

    (612346, 90), 

    (612347, 150), 

    (612348, 120), 

    (612349, 120), 

    (612350, 60), 

    (612351, 60), 

    (612352, 90), 

    (612353, 120), 

    (612354, 90); 

  

-- Postgraduate table 

DROP TABLE IF EXISTS Postgraduate; 

  

CREATE TABLE Postgraduate ( 

    PG_URN INT UNSIGNED NOT NULL, 

    Thesis VARCHAR(512) NOT NULL, 

    PRIMARY KEY (PG_URN), 

    FOREIGN KEY (PG_URN) REFERENCES Student(URN) ON DELETE CASCADE 

); 

  

-- Team_Peryton table 

DROP TABLE IF EXISTS Team_Peryton; 

  

CREATE TABLE Team_Peryton ( 

    URN INT UNSIGNED NOT NULL PRIMARY KEY, 

    meetings_attended INT, 

    Glider_workshop_attend BOOLEAN, 

    Drone_license BOOLEAN NOT NULL, 

    Room_num INT, 

    Drone_experience BOOLEAN NOT NULL, 

    TeamLeader_URN INT UNSIGNED, 

    FOREIGN KEY (URN) REFERENCES Student(URN) ON DELETE CASCADE, 

    FOREIGN KEY (TeamLeader_URN) REFERENCES Team_Peryton(URN) ON DELETE SET NULL 

); 

  

INSERT INTO Team_Peryton (URN, meetings_attended, Glider_workshop_attend, Drone_license, Room_num, Drone_experience, TeamLeader_URN) 

VALUES 

    (612345, 5, TRUE, TRUE, 102, FALSE, NULL), 

    (612346, 3, FALSE, FALSE, 105, TRUE, 612345), 

    (612347, 7, TRUE, TRUE, 103, TRUE, 612345), 

    (612348, 2, TRUE, FALSE, 101, FALSE, 612345), 

    (612349, 4, TRUE, TRUE, 104, TRUE, 612346), 

    (612350, 6, FALSE, TRUE, 106, FALSE, 612346), 

    (612351, 1, FALSE, FALSE, 107, FALSE, 612346), 

    (612352, 8, TRUE, TRUE, 108, TRUE, 612346), 

    (612353, 5, TRUE, FALSE, 109, FALSE, 612347), 

    (612354, 9, FALSE, TRUE, 110, TRUE, 612347); 

  

-- Hobbies table 

DROP TABLE IF EXISTS Hobbies; 

  

CREATE TABLE Hobbies ( 

    HobbyName VARCHAR(255) PRIMARY KEY 

); 

  

INSERT INTO Hobbies (HobbyName) VALUES 

    ('Reading'), 

    ('Hiking'), 

    ('Chess'), 

    ('Taichi'), 

    ('Ballroom Dancing'), 

    ('Football'), 

    ('Tennis'), 

    ('Rugby'), 

    ('Climbing'), 

    ('Rowing'); 

  

-- Student_Hobby Junction Table 

DROP TABLE IF EXISTS Student_Hobby; 

  

CREATE TABLE Student_Hobby ( 

    URN INT UNSIGNED NOT NULL, 

    HobbyName VARCHAR(255), 

    PRIMARY KEY (URN, HobbyName), 

    FOREIGN KEY (URN) REFERENCES Student(URN) ON DELETE CASCADE, 

    FOREIGN KEY (HobbyName) REFERENCES Hobbies(HobbyName) 

); 

  

INSERT INTO Student_Hobby (URN, HobbyName) VALUES 

    (612345, 'Reading'), (612345, 'Hiking'),  

    (612346, 'Chess'), (612346, 'Football'), 

    (612347, 'Taichi'), (612348, 'Ballroom Dancing'),  

    (612349, 'Football'), (612350, 'Tennis'), 

    (612351, 'Rugby'), (612352, 'Climbing'), (612353, 'Rowing'); 

  

-- Groups_Joined table 

DROP TABLE IF EXISTS Groups_Joined; 

  

CREATE TABLE Groups_Joined ( 

    StuGroups_Joined VARCHAR(255) PRIMARY KEY 

); 

  

INSERT INTO Groups_Joined (StuGroups_Joined) VALUES 

    ('Catapult&Image Recognition'), 

    ('Propulsion'), 

    ('Aerodynamics'); 

  

-- StudentGroups table 

DROP TABLE IF EXISTS StudentGroups; 

  

CREATE TABLE  StudentGroups( 

    URN INT UNSIGNED NOT NULL, 

    StuGroups_Joined VARCHAR(255), 

    FOREIGN KEY (StuGroups_Joined) REFERENCES Groups_Joined(StuGroups_Joined) ON DELETE RESTRICT, 

    FOREIGN KEY (URN) REFERENCES Team_Peryton(URN) ON DELETE CASCADE 

); 

  

INSERT INTO StudentGroups (URN, StuGroups_Joined) VALUES 

    (612345, 'Catapult&Image Recognition'), 

    (612345, 'Aerodynamics'), 

    (612346, 'Propulsion'), 

    (612347, 'Catapult&Image Recognition'), 

    (612348, 'Aerodynamics'), 

    (612349, 'Propulsion'), 

    (612350, 'Catapult&Image Recognition'), 

    (612351, 'Aerodynamics'), 

    (612352, 'Propulsion'), 

    (612353, 'Catapult&Image Recognition'), 

    (612354, 'Aerodynamics'); 

  

-- Parts_Printed table 

DROP TABLE IF EXISTS Parts_Printed; 

  

CREATE TABLE Parts_Printed ( 

    PartName VARCHAR(255) PRIMARY KEY 

); 

INSERT INTO Parts_Printed (PartName) VALUES 

    ('Wing'), ('Body'), ('Propeller'), ('Tail'), ('Body Frame'),('Wing Frame'); 

-- Propulsion table 

DROP TABLE IF EXISTS Propulsion; 

CREATE TABLE Propulsion ( 

    URN INT UNSIGNED NOT NULL, 

    done_prot_wiring BOOLEAN, 

    concept_plane_designed BOOLEAN, 

    FOREIGN KEY (URN) REFERENCES Team_Peryton(URN) ON DELETE CASCADE 

); 

  

INSERT INTO Propulsion (URN, done_prot_wiring, concept_plane_designed) VALUES 

    (612345, TRUE, FALSE), 

    (612346, TRUE, TRUE), 

    (612347, FALSE, TRUE), 

    (612348, TRUE, FALSE), 

    (612349, FALSE, FALSE), 

    (612350, TRUE, TRUE), 

    (612351, FALSE, TRUE), 

    (612352, TRUE, FALSE), 

    (612353, TRUE, TRUE), 

    (612354, FALSE, FALSE); 


DROP TABLE IF EXISTS newBool;

CREATE TABLE newBool ( 

    possibleBool BOOLEAN

); 

INSERT INTO newBool (possibleBool) VALUES 

    (FALSE), 

    (TRUE); 

-- Propulsion_Parts table 

DROP TABLE IF EXISTS Propulsion_Parts; 

CREATE TABLE Propulsion_Parts ( 

   Propulsionpart_URN INT UNSIGNED NOT NULL, 
	
	PartNames VARCHAR(255), 

   FOREIGN KEY (PartNames) REFERENCES Parts_Printed(PartName), 

   FOREIGN KEY (Propulsionpart_URN) REFERENCES Propulsion(URN) ON DELETE CASCADE 
   PRIMARY KEY (Propulsionpart_URN, PartNames), 

); 

INSERT INTO Propulsion_Parts (Propulsionpart_URN, PartNames) VALUES 

    (612345, 'Wing'), (612345, 'Propeller'), (612346, 'Wing'),  

    (612346, 'Tail'), (612347, 'Wing'), 

    (612347, 'Body'), (612348, 'Wing Frame'), (612348, 'Body Frame'), 

    (612349, 'Body Frame'), (612354, 'Propeller'); 

  

  

-- Aerodynamics table 

DROP TABLE IF EXISTS Aerodynamics; 

  

CREATE TABLE Aerodynamics ( 

    URN INT UNSIGNED NOT NULL, 

    ResearchOnParts TEXT, 

    SimulatorySoftwareRan BOOLEAN, 

    TailSize DECIMAL(5,2) CHECK (TailSize BETWEEN 4.5 AND 7.5), 

    WingSize DECIMAL(5,2) CHECK (WingSize BETWEEN 4.5 AND 7.5), 

    DistanceBetween DECIMAL(5,2) CHECK (DistanceBetween BETWEEN 4.5 AND 7.5), 

    BatteryType VARCHAR(255), 

    FirstSeg BOOLEAN, 

    SecondSeg BOOLEAN, 

    ThirdSeg BOOLEAN, 

    PathTestResult VARCHAR(255),

    MotorSize VARCHAR(255), 

    MotorType VARCHAR(255), 

    FOREIGN KEY (URN) REFERENCES Team_Peryton(URN) ON DELETE CASCADE 

); 

DROP TABLE IF EXISTS MotorSizeOptions; 

CREATE TABLE MotorSizeOptions ( 
    MotorSizes VARCHAR(255), 
);

INSERT INTO MotorSizeOptions ()
VALUES 
('Large'),
('Medium'),
('Small');

DROP TABLE IF EXISTS MotorTypeOptions; 

CREATE TABLE MotorTypeOptions ( 
    MotorTypes VARCHAR(255), 
);

INSERT INTO MotorTypeOptions (MotorTypes)
VALUES 
('Electric'),
('Gasoline');

DROP TABLE IF EXISTS BatteryTypeOptions; 

CREATE TABLE BatteryTypeOptions ( 
    BatteryTypes VARCHAR(255), 
);

INSERT INTO BatteryTypeOptions (BatteryTypes)
VALUES 
('Whole'),
('Segmented');
  
INSERT INTO Aerodynamics (URN, ResearchOnParts, SimulatorySoftwareRan, TailSize, WingSize, DistanceBetween, PlaneCourseFollowed, BatteryType, FirstSeg, SecondSeg, ThirdSeg, PathTestResult, MotorSize, MotorType)
VALUES 
    (612345, 'Research on wings and propellers', TRUE, 5.6, 6.7, 5.0, 'Whole', TRUE, TRUE, TRUE, 'PathTest was followed', 'Large', 'Electric'), 
    (612346, 'Research on tail and body_frame', FALSE, 6.2, 5.8, 6.5, 'Segmented', TRUE, FALSE, TRUE, 'PathTest was unsuccessful', 'Medium', 'Gasoline'), 
    (612347, 'Research on motor and battery', TRUE, 5.5, 6.0, 5.2, 'Whole', FALSE, TRUE, FALSE, 'PathTest was unsuccessful', 'Small', 'Electric'), 
    (612348, 'Research on body_frame and wing_frame', FALSE, 6.8, 4.9, 6.0, 'Segmented', TRUE, TRUE, TRUE, 'PathTest was followed', 'Medium', 'Gasoline'), 
    (612349, 'No specific research', TRUE, 5.7, 6.5, 5.5, 'Whole', FALSE, FALSE, FALSE, 'PathTest was unsuccessful', 'Large', 'Electric'), 
    (612350, 'Research on wings and propellers', FALSE, 6.0, 6.2, 4.8, 'Segmented', TRUE, FALSE, TRUE, 'PathTest was unsuccessful', 'Small', 'Electric'), 
    (612351, 'Research on motor and battery', TRUE, 5.8, 6.5, 5.2, 'Whole', FALSE, TRUE, FALSE, 'PathTest was unsuccessful', 'Medium', 'Gasoline'), 
    (612352, 'Research on tail and body_frame', FALSE, 6.5, 5.7, 6.3, 'Segmented', TRUE, TRUE, TRUE, 'PathTest was followed', 'Small', 'Electric'), 
    (612353, 'Research on wings and propellers', TRUE, 5.9, 6.0, 5.1, 'Whole', TRUE, TRUE, FALSE, 'PathTest was unsuccessful', 'Large', 'Electric'), 
    (612354, 'Research on body_frame and wing_frame', FALSE, 6.3, 5.5, 6.2, 'Segmented', TRUE, TRUE, TRUE, 'PathTest was followed', 'Medium', 'Gasoline');
