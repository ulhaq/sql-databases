SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

DELIMITER $$
DROP PROCEDURE IF EXISTS `addInstructorToTeam`$$
CREATE PROCEDURE `addInstructorToTeam` (IN `instructorId` INT, IN `teamId` INT)  BEGIN
	DECLARE val int;
	SELECT COUNT(*) INTO val FROM instructor_team WHERE instructor_id=instructorId;
    IF val < 2 THEN
		INSERT INTO instructor_team VALUES (instructorId, teamId);
    ELSE
    	SELECT "The instructor is already assigned to two teams.";
	END IF;
END$$

DROP PROCEDURE IF EXISTS `addSessionToCourse`$$
CREATE PROCEDURE `addSessionToCourse` (IN `courseId` INT, IN `startsAt` TIMESTAMP, IN `endsAt` TIMESTAMP)  BEGIN
	DECLARE val VARCHAR(255);
	SELECT starts_at INTO val FROM sessions WHERE course_id=courseId ORDER BY starts_at ASC LIMIT 1;
    IF (WEEK(startsAt) - WEEK(val)) < 12 THEN
		INSERT INTO sessions (course_id, starts_at, ends_at) VALUES (courseId, startsAt, endsAt);
    ELSE
    	SELECT "Courses may not extend over more than 12 weeks";
	END IF;
END$$

DROP PROCEDURE IF EXISTS `addTraineeToCourse`$$
CREATE PROCEDURE `addTraineeToCourse` (IN `courseId` INT, IN `traineeId` INT)  BEGIN
	DECLARE val int;
	SELECT COUNT(*) INTO val FROM course_trainee WHERE course_id=courseId;
    IF val < 100 THEN
    	IF EXISTS (SELECT course_trainee.trainee_id FROM `course_trainee` INNER JOIN courses ON course_trainee.course_id=courses.id WHERE course_trainee.trainee_id=traineeId AND courses.remote=0) THEN
        	SELECT "This trainee is already enrolled in one onsite course.";
        ELSEIF (SELECT COUNT(*) FROM `course_trainee` INNER JOIN courses ON course_trainee.course_id=courses.id WHERE course_trainee.trainee_id=traineeId AND courses.remote=1) > 2 THEN
			SELECT "This trainee is already enrolled in three online courses.";
        ELSE
            INSERT INTO course_trainee VALUES (courseId, traineeId);
        END IF;
    ELSE
        SELECT "Can not add more than 100 trainees per course.";
	END IF;
END$$

DROP PROCEDURE IF EXISTS `whenBusy`$$
CREATE PROCEDURE `whenBusy` (IN `instructorId` INT)  BEGIN
	SELECT instructors.name, starts_at AS occupied FROM instructors INNER JOIN instructor_team ON instructors.id = instructor_team.instructor_id INNER JOIN teams ON teams.id = instructor_team.team_id INNER JOIN courses ON teams.id = courses.team_id INNER JOIN sessions on sessions.course_id=courses.id WHERE instructors.id=instructorId;
END$$

DROP PROCEDURE IF EXISTS `whoCompleted`$$
CREATE PROCEDURE `whoCompleted` (IN `courseId` INT)  BEGIN
	SELECT trainees.name FROM trainees INNER JOIN course_trainee ON course_trainee.trainee_id=trainees.id WHERE course_trainee.course_id=courseId AND completed=1;
END$$

DELIMITER ;

DROP TABLE IF EXISTS `courses`;
CREATE TABLE IF NOT EXISTS `courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `team_id` int(11) NOT NULL,
  `remote` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_courses_team_id` (`team_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4;

INSERT INTO `courses` (`id`, `name`, `team_id`, `remote`) VALUES
(1, 'PHP Course', 1, 1),
(2, 'SQL Course', 2, 1),
(3, 'JAVA Course', 1, 0);

DROP TABLE IF EXISTS `course_trainee`;
CREATE TABLE IF NOT EXISTS `course_trainee` (
  `course_id` int(11) NOT NULL,
  `trainee_id` int(11) NOT NULL,
  `completed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`course_id`,`trainee_id`),
  KEY `fk_courses_trainee_trainee_id` (`trainee_id`)
) ENGINE=InnoDB;

INSERT INTO `course_trainee` (`course_id`, `trainee_id`, `completed`) VALUES
(1, 1, 1),
(1, 3, 1),
(1, 4, 1),
(1, 5, 1),
(1, 7, 0),
(1, 8, 0),
(1, 9, 0),
(1, 10, 0),
(1, 11, 0),
(1, 12, 0),
(1, 13, 0),
(1, 14, 0),
(1, 15, 0),
(1, 16, 1),
(1, 17, 0),
(1, 18, 0),
(1, 19, 0),
(1, 20, 0),
(1, 21, 0),
(1, 22, 0),
(1, 23, 0),
(1, 24, 0),
(1, 25, 0),
(1, 26, 0),
(1, 27, 0),
(1, 28, 0),
(1, 29, 0),
(1, 30, 0),
(1, 31, 0),
(1, 32, 0),
(1, 33, 0),
(1, 34, 0),
(1, 35, 0),
(1, 36, 0),
(1, 37, 0),
(1, 38, 0),
(1, 39, 0),
(1, 40, 0),
(1, 41, 0),
(1, 42, 0),
(1, 43, 0),
(1, 44, 0),
(1, 45, 0),
(1, 46, 0),
(1, 47, 0),
(1, 48, 0),
(1, 49, 0),
(1, 50, 0),
(1, 51, 0),
(1, 52, 0),
(1, 53, 0),
(1, 54, 0),
(1, 55, 0),
(1, 56, 0),
(1, 57, 0),
(1, 58, 0),
(1, 59, 0),
(1, 60, 0),
(1, 61, 0),
(1, 62, 0),
(1, 63, 0),
(1, 64, 0),
(1, 65, 0),
(1, 66, 0),
(1, 67, 0),
(1, 68, 0),
(1, 69, 0),
(1, 70, 0),
(1, 71, 0),
(1, 72, 0),
(1, 73, 0),
(1, 74, 0),
(1, 75, 0),
(1, 76, 0),
(1, 77, 0),
(1, 78, 0),
(1, 79, 0),
(1, 80, 0),
(1, 81, 0),
(1, 82, 0),
(1, 83, 0),
(1, 84, 0),
(1, 85, 0),
(1, 86, 0),
(1, 87, 0),
(1, 88, 0),
(1, 89, 0),
(1, 90, 0),
(1, 91, 0),
(1, 92, 0),
(1, 93, 0),
(1, 94, 0),
(1, 95, 0),
(1, 96, 0),
(1, 97, 0),
(1, 98, 0),
(1, 99, 0),
(2, 1, 0),
(3, 1, 0),
(3, 2, 0),
(3, 6, 0);

DROP TABLE IF EXISTS `instructors`;
CREATE TABLE IF NOT EXISTS `instructors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31;

INSERT INTO `instructors` (`id`, `name`) VALUES
(1, 'Abby'),
(2, 'Lacey'),
(3, 'Lucia'),
(4, 'Felix'),
(5, 'Anisa'),
(6, 'Jessie'),
(7, 'Frankie'),
(8, 'Amber'),
(9, 'Lisa'),
(10, 'Sylvia'),
(11, 'Isabella'),
(12, 'Sophie'),
(13, 'Felicity'),
(14, 'Aliyah'),
(15, 'Jamie'),
(16, 'Demi'),
(17, 'Serena'),
(18, 'Amira'),
(19, 'Ayla'),
(20, 'Catherine'),
(21, 'Brianna'),
(22, 'Gertrude'),
(23, 'Gabriella'),
(24, 'Aiden'),
(25, 'Khadija'),
(26, 'Natalia'),
(27, 'Madeleine'),
(28, 'Jodie'),
(29, 'Maya'),
(30, 'Amina');

DROP TABLE IF EXISTS `instructor_team`;
CREATE TABLE IF NOT EXISTS `instructor_team` (
  `instructor_id` int(11) NOT NULL,
  `team_id` int(11) NOT NULL,
  PRIMARY KEY (`instructor_id`,`team_id`),
  KEY `fk_instructor_team_team_id` (`team_id`)
) ENGINE=InnoDB;

INSERT INTO `instructor_team` (`instructor_id`, `team_id`) VALUES
(1, 1),
(2, 1),
(1, 2);
DROP VIEW IF EXISTS `popular_courses`;
CREATE TABLE IF NOT EXISTS `popular_courses` (
`name` varchar(255)
,`highest` bigint(21)
,`availability` bigint(22)
);

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL,
  `starts_at` timestamp NOT NULL,
  `ends_at` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_sessions_course_id` (`course_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11;

INSERT INTO `sessions` (`id`, `course_id`, `starts_at`, `ends_at`) VALUES
(1, 1, '2020-02-13 23:00:00', '2020-02-14 03:00:00'),
(2, 1, '2020-02-20 23:00:00', '2020-02-21 03:00:00'),
(3, 1, '2020-04-30 22:00:00', '2020-05-01 06:00:00'),
(4, 1, '2020-04-30 23:00:00', '2020-05-01 06:00:00'),
(5, 1, '2020-05-01 23:00:00', '2020-05-01 06:00:00'),
(6, 1, '2020-05-02 22:00:00', '2020-05-01 06:00:00'),
(7, 1, '2020-05-02 23:00:00', '2020-05-01 06:00:00'),
(8, 1, '2020-05-03 23:00:00', '2020-05-01 06:00:00'),
(9, 1, '2020-05-07 23:00:00', '2020-05-01 06:00:00'),
(10, 1, '2020-05-08 23:00:00', '2020-05-01 06:00:00');

DROP TABLE IF EXISTS `teams`;
CREATE TABLE IF NOT EXISTS `teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3;

INSERT INTO `teams` (`id`, `name`) VALUES
(1, 'PHPER'),
(2, 'SQLER');

DROP TABLE IF EXISTS `trainees`;
CREATE TABLE IF NOT EXISTS `trainees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=201;

INSERT INTO `trainees` (`id`, `name`) VALUES
(1, 'Sara Richardson'),
(2, 'John Martin'),
(3, 'Henry Alexander'),
(4, 'Mary Kelly'),
(5, 'Howard Wright'),
(6, 'Jesse Perry'),
(7, 'Tammy Hall'),
(8, 'Alan Gonzales'),
(9, 'Heather Flores'),
(10, 'Daniel Collins'),
(11, 'Margaret Rogers'),
(12, 'Doris Hernandez'),
(13, 'Johnny Carter'),
(14, 'Pamela Bailey'),
(15, 'Bonnie Miller'),
(16, 'Carl Lewis'),
(17, 'Willie Howard'),
(18, 'Eric Scott'),
(19, 'Emily Adams'),
(20, 'Earl Williams'),
(21, 'Lillian Reed'),
(22, 'Fred Taylor'),
(23, 'Anne Anderson'),
(24, 'Rose Long'),
(25, 'David Coleman'),
(26, 'Michelle Evans'),
(27, 'Laura Bryant'),
(28, 'Steven Bell'),
(29, 'Annie King'),
(30, 'Jason Baker'),
(31, 'Stephanie Moore'),
(32, 'Timothy Watson'),
(33, 'Karen Davis'),
(34, 'Anthony Lopez'),
(35, 'Bobby Russell'),
(36, 'Katherine Diaz'),
(37, 'Lawrence Hughes'),
(38, 'Jennifer Allen'),
(39, 'Russell Nelson'),
(40, 'Rebecca Thompson'),
(41, 'Judith Torres'),
(42, 'James Ward'),
(43, 'Tina Sanders'),
(44, 'Lois Edwards'),
(45, 'Paul Gray'),
(46, 'Debra Stewart'),
(47, 'Barbara Murphy'),
(48, 'Dorothy Phillips'),
(49, 'Virginia Ross'),
(50, 'Craig Martinez'),
(51, 'Samuel Lee'),
(52, 'Ryan Hill'),
(53, 'Carlos Young'),
(54, 'Sarah Cox'),
(55, 'Kathy Griffin'),
(56, 'Jerry Rivera'),
(57, 'Ruby Powell'),
(58, 'Jimmy Thomas'),
(59, 'Julie Butler'),
(60, 'Roger Clark'),
(61, 'Christina Green'),
(62, 'Victor Jenkins'),
(63, 'Arthur Washington'),
(64, 'Patricia Harris'),
(65, 'Norma Brooks'),
(66, 'Benjamin Bennett'),
(67, 'Lori Sanchez'),
(68, 'Angela White'),
(69, 'Louise Mitchell'),
(70, 'Ruth Parker'),
(71, 'Jean Morgan'),
(72, 'Douglas Cook'),
(73, 'Beverly Walker'),
(74, 'Rachel Johnson'),
(75, 'Gregory Peterson'),
(76, 'Keith Wood'),
(77, 'Paula Garcia'),
(78, 'Christopher Barnes'),
(79, 'Susan Smith'),
(80, 'Adam Wilson'),
(81, 'Phyllis Foster'),
(82, 'Brandon Price'),
(83, 'Jane Rodriguez'),
(84, 'Stephen Perez'),
(85, 'Denise Morris'),
(86, 'Amy Brown'),
(87, 'Billy Patterson'),
(88, 'Nicole Ramirez'),
(89, 'Theresa Gonzalez'),
(90, 'Linda Jackson'),
(91, 'Deborah Roberts'),
(92, 'Jacqueline Simmons'),
(93, 'Michael Jones'),
(94, 'Teresa Cooper'),
(95, 'Edward Henderson'),
(96, 'Steve Robinson'),
(97, 'Mildred James'),
(98, 'Betty Campbell'),
(99, 'Donald Turner'),
(100, 'Joshua'),
(101, 'Eric Bell'),
(102, 'Joan Stewart'),
(103, 'Julia Henderson'),
(104, 'Martha Phillips'),
(105, 'Howard Sanders'),
(106, 'Paul Rogers'),
(107, 'Dennis Martin'),
(108, 'Ronald James'),
(109, 'Doris Bailey'),
(110, 'Harry Howard'),
(111, 'Diane Jackson'),
(112, 'Evelyn Edwards'),
(113, 'Charles Johnson'),
(114, 'Amanda Scott'),
(115, 'Patricia Moore'),
(116, 'Judy Kelly'),
(117, 'Jeremy Clark'),
(118, 'Anna Davis'),
(119, 'Barbara Diaz'),
(120, 'Wayne Harris'),
(121, 'Larry Russell'),
(122, 'Donald Wright'),
(123, 'Phyllis Thomas'),
(124, 'Carl Brooks'),
(125, 'Ann Butler'),
(126, 'Louise Bryant'),
(127, 'James Patterson'),
(128, 'Robert Hall'),
(129, 'Rose Long'),
(130, 'Kathy Young'),
(131, 'Marie Hughes'),
(132, 'Kimberly Gonzalez'),
(133, 'Louis Watson'),
(134, 'Bonnie Foster'),
(135, 'Catherine Wood'),
(136, 'Richard Torres'),
(137, 'Sandra Green'),
(138, 'Amy Robinson'),
(139, 'Annie Adams'),
(140, 'Cheryl Simmons'),
(141, 'Helen Williams'),
(142, 'Melissa Hill'),
(143, 'Debra Gonzales'),
(144, 'Brian Morgan'),
(145, 'Kathleen Garcia'),
(146, 'Clarence Gray'),
(147, 'Denise Richardson'),
(148, 'Gary Lewis'),
(149, 'Roger Cox'),
(150, 'Jose Sanchez'),
(151, 'Justin Morris'),
(152, 'Steve Griffin'),
(153, 'Paula Evans'),
(154, 'Tammy Walker'),
(155, 'Matthew Coleman'),
(156, 'David Hernandez'),
(157, 'Keith Martinez'),
(158, 'Albert Rivera'),
(159, 'Eugene Rodriguez'),
(160, 'Beverly Wilson'),
(161, 'Joshua Campbell'),
(162, 'Laura Allen'),
(163, 'Jimmy Miller'),
(164, 'Lawrence Murphy'),
(165, 'John Perez'),
(166, 'Earl Cooper'),
(167, 'Carol Jenkins'),
(168, 'Norma Smith'),
(169, 'Janet Brown'),
(170, 'Lori Ramirez'),
(171, 'Roy Powell'),
(172, 'Shirley Nelson'),
(173, 'Lois Flores'),
(174, 'Phillip Perry'),
(175, 'Angela Roberts'),
(176, 'Donna Alexander'),
(177, 'Susan Barnes'),
(178, 'Anthony Cook'),
(179, 'Craig Jones'),
(180, 'Timothy Carter'),
(181, 'Jason Reed'),
(182, 'Diana Mitchell'),
(183, 'Kenneth Price'),
(184, 'Andrew Lee'),
(185, 'Virginia Turner'),
(186, 'Mildred Collins'),
(187, 'Sarah Parker'),
(188, 'Jesse Taylor'),
(189, 'Raymond Ross'),
(190, 'Sharon White'),
(191, 'Judith Baker'),
(192, 'Katherine Washington'),
(193, 'Tina Peterson'),
(194, 'Douglas Ward'),
(195, 'Sara Thompson'),
(196, 'Janice Bennett'),
(197, 'Terry Anderson'),
(198, 'Carlos King'),
(199, 'Emily Lopez'),
(200, 'Ruby');

DROP TABLE IF EXISTS `popular_courses`;
CREATE VIEW `popular_courses`  AS  SELECT `courses`.`name` AS `name`,count(0) AS `highest`,(100 - count(0)) AS `availability` FROM (`courses` JOIN `course_trainee` ON((`courses`.`id` = `course_trainee`.`course_id`))) GROUP BY `course_trainee`.`course_id` ORDER BY `highest` DESC;


ALTER TABLE `courses`
  ADD CONSTRAINT `fk_courses_team_id` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`);

ALTER TABLE `course_trainee`
  ADD CONSTRAINT `fk_courses_trainee_course_id` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
  ADD CONSTRAINT `fk_courses_trainee_trainee_id` FOREIGN KEY (`trainee_id`) REFERENCES `trainees` (`id`);

ALTER TABLE `instructor_team`
  ADD CONSTRAINT `fk_instructor_team_instructor_id` FOREIGN KEY (`instructor_id`) REFERENCES `instructors` (`id`),
  ADD CONSTRAINT `fk_instructor_team_team_id` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`);

ALTER TABLE `sessions`
  ADD CONSTRAINT `fk_sessions_course_id` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`);
COMMIT;