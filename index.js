//some of this code originates from @author joe appleton week 10 lab materials

const express = require('express');
const ejs = require('ejs');
const util = require('util');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const { isBooleanObject } = require('util/types');
const { isReadable } = require('stream');


const PORT = 8002;
const DB_HOST = '127.0.0.1';
const DB_USER = 'root';
const DB_PASSWORD = '';
const DB_NAME = 'coursework';
const DB_PORT = 3306;


var connection = mysql.createConnection({
	host: DB_HOST,
	user: DB_USER,
	password: DB_PASSWORD,
	database: DB_NAME,
	port: DB_PORT
});

// we do this to use async await with mysql (see: https://stackoverflow.com/questions/50093144/using-async-await-with-a-mysql-database)
connection.query = util.promisify(connection.query).bind(connection);

connection.connect(function (err) {
	if (err) {
		console.error('error connecting: ' + err.stack);
		return;
	}
	console.log('You are connected');
});


const app = express();

app.set('view engine', 'ejs');
app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', async (req, res) => {
	const studentCount = await connection.query('SELECT COUNT(*) as count FROM Student');
	const Team_PCount = await connection.query('SELECT COUNT(*) as count FROM Team_Peryton');
	const AeroCount = await connection.query('SELECT COUNT(*) as count FROM Aerodynamics');
	const PropulsionCount = await connection.query('SELECT COUNT(*) as count FROM Propulsion');
	res.render('index', {
		studentCount: studentCount[0].count,
		Team_PCount: Team_PCount[0].count,
		AeroCount: AeroCount[0].count,
		PropulsionCount:  PropulsionCount[0].count
	});
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
app.get('/Team_Peryton', async (req, res) => {
	const TeamP = await connection.query('SELECT * FROM Team_Peryton');
	res.render('TP', { TeamP: TeamP });

});

app.get('/Team_Peryton/edit/:id', async (req, res) => {
	const meetingAtteneded = await connection.query('SELECT meetings_attended FROM Team_Peryton WHERE URN = ?', [req.params.id]);
	const TP = await connection.query('SELECT * FROM Team_Peryton WHERE URN = ?', [req.params.id]);
	res.render('TP_edit', { TP: TP[0], meetingAtteneded: meetingAtteneded , message: '' });
});

app.get("/Team_Peryton/view/:id", async (req, res) => {
	const Team_Peryton = await connection.query(
		"SELECT * FROM Team_Peryton WHERE URN = ?",
		[req.params.id]
	);
	res.render("TP_view", { Team_Peryton: Team_Peryton[0] });
});

app.post('/Team_Peryton/edit/:id', async (req, res) => {
	const TeamMemb = req.body;

	const getTeamMemb = () => {
		return connection.query('SELECT * FROM Team_Peryton WHERE URN = ?', [req.params.id]);

	}

	const getAttendedMeetings = () => {
		return connection.query('SELECT * FROM Team_Peryton WHERE meetings_attended = ?', [TeamMemb.meetingAtteneded]);
	}

	if (isNaN(TeamMemb.meetings_attended) || TeamMemb.meetings_attended > 33) {
		const meetings = await getAttendedMeetings();
		const TP = await getTeamMemb();
		res.render('TP_edit', { TP: TP[0], meetings: meetings, message: 'error not updated, number not valid' }); return;
	}

	try {
		await connection.query('UPDATE Team_Peryton SET ? WHERE URN = ?', [TeamMemb, req.params.id]);
		const meetings = await getAttendedMeetings();
		const TP = await getTeamMemb();
		res.render('TP_edit', {TP: TP[0], meetings: meetings, message: 'Member had been Updated'});

	} catch (error) {
		console.log(error);
		const meetings = await getAttendedMeetings();
		const TP = await getTeamMemb();
		res.render('TP_edit', {TP: TP[0], meetings: meetings, message: 'error not updated, number not valid'});
	}
});
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
app.get('/aero', async (req, res) => {
	const TeamAero = await connection.query('SELECT * FROM Aerodynamics');
	res.render('aero', { TeamAero: TeamAero });

});

app.get('/aero/edit/:id', async (req, res) => {
	const motorSi = await connection.query('SELECT MotorSizes FROM MotorSizeOptions');
	const motorTy = await connection.query('SELECT MotorTypes FROM MotorTypeOptions');
	const battType = await connection.query('SELECT BatteryTypes FROM BatteryTypeOptions');
	const AeroTeam = await connection.query('SELECT * FROM Aerodynamics WHERE URN = ?', [req.params.id]);
	res.render('aero_edit', { AeroTeam: AeroTeam[0], motorSi: motorSi , motorTy:motorTy , battType:battType  , message: '' });
});

app.get("/aero/view/:id", async (req, res) => {
	const TeamAero = await connection.query(
		"SELECT * FROM Aerodynamics WHERE URN = ?",
		[req.params.id]
	);
	res.render("aero_view", { TeamAero: TeamAero[0] });
});

app.post('/aero/edit/:id', async (req, res) => {
	const AeroMemb = req.body;
	

	const sanitizeInput = (input) => {
		// Implement input sanitization logic here, if needed
		return input.trim(); // For example, trim leading and trailing spaces
	};
	const validateResearchTopics = (topics) => {
		const validTopics = ['Wing', 'Body', 'Propeller', 'Tail', 'Body Frame', 'Wing Frame'];
		return topics.every((topic) => validTopics.includes(topic));
	};

	const sanitizedResearchOnParts = sanitizeInput(AeroMemb.ResearchOnParts);
	// Validate the input format and research topics
	const regex = /^Research on \(([^)]+( and [^)]+)*)\)$/; // Regex for the specified format
	const match = sanitizedResearchOnParts.match(regex);


	const getAeroMemb = () => {
		return connection.query('SELECT * FROM Aerodynamics WHERE URN = ?', [req.params.id]);
	}
	const getbattType =  () => {
		return connection.query('SELECT * FROM BatteryTypeOptions');
	}
	const getmotorTy =  () => {
		return connection.query('SELECT * FROM MotorTypeOptions');
	}
	const getmotorSi =  () => {
		return connection.query('SELECT * FROM MotorSizeOptions');
	}

	if (sanitizedResearchOnParts !== '' && (!match || !validateResearchTopics(match[1].split(' and ')))) {
		// Invalid input
		const battType = await getbattType();
		const motorSi = await getmotorSi();
		const AeroTeam = await getAeroMemb();
		const motorTy = await getmotorTy();
		return res.render('aero_edit', {
		  AeroTeam: AeroTeam[0],
		  motorTy: motorTy,
		  motorSi: motorSi,
		  battType: battType,
		  message: 'Error: Invalid input format or research topics change form similar to this: <br>Research on (Wing and Tail and Wing Frame), <br>or Research on (Wing and Tail), <br>Research on (Wing), <br>no extra spaces between letters, <br>acceptable research topics: Wing, Body, Propeller, Tail, Body Frame, Wing Frame',
		});
	}
	
	try {
		await connection.query('UPDATE Aerodynamics SET `MotorSize` = ?, `MotorType` = ?, `ResearchOnParts` = ?, `BatteryType` = ? WHERE URN = ?', [AeroMemb.MotorSize, AeroMemb.MotorType, AeroMemb.ResearchOnParts, AeroMemb.BatteryType, req.params.id]);
		const battType = await getbattType();
		const motorSi = await getmotorSi();
		const motorTy = await getmotorTy();
		const AeroTeam = await getAeroMemb();
		res.render('aero_edit', {AeroTeam: AeroTeam[0],motorTy:motorTy,motorSi:motorSi, battType:battType ,message: 'Member had been Updated'});

	} catch (error) {
		console.log(error);
		const battType = await getbattType();
		const motorSi = await getmotorSi();
		const AeroTeam = await getAeroMemb();
		const motorTy = await getmotorTy();
		res.render('aero_edit', {AeroTeam: AeroTeam[0], motorTy:motorTy,motorSi:motorSi,battType:battType , message: 'error not updated, invalid entry'});
	}
});

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
app.get('/students', async (req, res) => {
	const students = await connection.query('SELECT * FROM Student INNER JOIN Course  ON student.Stu_Course = course.Crs_Code');
	res.render('students', { students: students });

});

app.get('/students/edit/:id', async (req, res) => {
	const courses = await connection.query('SELECT Crs_Code, Crs_Title  FROM Course');
	const student = await connection.query('SELECT * FROM Student WHERE URN = ?', [req.params.id]);
	res.render('student_edit', { student: student[0], courses: courses, message: '' });
});

app.get("/students/view/:id", async (req, res) => {
	const student = await connection.query(
		"SELECT * FROM Student INNER JOIN Course  ON student.Stu_Course = course.Crs_Code WHERE URN = ?",
		[req.params.id]
	);
	res.render("student_view", { student: student[0] });
});

app.post('/students/edit/:id', async (req, res) => {
	const updatedStudent = req.body;

	const getStudent = () => {
		return connection.query('SELECT * FROM Student WHERE URN = ?', [req.params.id]);

	}

	const getCourse = () => {
		return connection.query('SELECT * FROM Course WHERE Crs_Code = ?', [updatedStudent.Stu_Course]);
	}


	if (isNaN(updatedStudent.Stu_Phone) || updatedStudent.Stu_Phone.length != 11) {
		const courses = await getCourse();
		const student = await getStudent();
		res.render('student_edit', { student: student[0], courses: courses, message: 'error not updated, number not valid' }); return;

	}

	try {
		await connection.query('UPDATE Student SET ? WHERE URN = ?', [updatedStudent, req.params.id]);
		const courses = await getCourse();
		const student = await getStudent();
		res.render('student_edit', { student: student[0], courses: courses, message: 'student updated' });

	} catch (error) {
		console.log(error);
		const courses = await getCourse();
		const student = await getStudent();
		res.render('student_edit', { student: student[0], courses: courses, message: 'error not updated' });
	}
});


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
app.get('/prop', async (req, res) => {
	const props = await connection.query('SELECT * FROM Propulsion');
	res.render('prop', { props: props });

});
//
app.get('/prop/edit/:id', async (req, res) => {
	const boolValues = await connection.query('SELECT possibleBool FROM newBool');
	const prop = await connection.query('SELECT * FROM Propulsion  WHERE URN = ?', [req.params.id]);
	const AeroTeam = await connection.query('SELECT * FROM Aerodynamics WHERE URN = ?', [req.params.id]);
	res.render('prop_edit', {prop: prop[0],AeroTeam:AeroTeam[0] ,boolValues:boolValues, message: '' });
});

app.get("/prop/view/:id", async (req, res) => {
	const prop = await connection.query(
		"SELECT * FROM Propulsion  WHERE URN = ?",
		[req.params.id]
	);
	res.render("prop_view", {prop: prop[0]});
});

app.post('/prop/edit/:id', async (req, res) => {
	const updatedStuProp = req.body;

	// Validate that the new PartName doesn't already exist for the given Propulsionpart_URN
	const boolChoice = () => { 
		return connection.query('SELECT possibleBool FROM newBool');
		
	}
	const choosingProp = () => { 
		return connection.query('SELECT * FROM Propulsion  WHERE URN = ?', [req.params.id]);
	}
	const getAeroMemb = () => {
		return connection.query('SELECT * FROM Aerodynamics WHERE URN = ?', [req.params.id]);
	}

	try {
		const AeroTeam = await getAeroMemb();
		const boolValues = await boolChoice();
		const prop = await choosingProp();

		await connection.query('UPDATE Propulsion SET `done_prot_wiring` = ?, `concept_plane_designed` = ?  WHERE URN = ?', [updatedStuProp.done_prot_wiring, updatedStuProp.concept_plane_designed, req.params.id]);
		res.render('prop_edit', {boolValues:boolValues, prop:prop[0],AeroTeam:AeroTeam[0] ,message: 'Part updated' });

	} catch (error) {
		console.log(error);
		const AeroTeam = await getAeroMemb();
		const boolValues = await boolChoice();
		const prop = await choosingProp();
		res.render('prop_edit',  {prop:prop[0] , boolValues:boolValues,AeroTeam:AeroTeam[0] , message: 'error not updated' });
	}
});


app.listen(PORT, () => {
	console.log(`Example app listening at http://localhost:${PORT}`);
});