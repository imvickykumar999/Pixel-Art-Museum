-- 1. Drop the Database if it exists to start fresh
DROP DATABASE IF EXISTS Pixel_Art_Museum;

-- 2. Create and Select the Database
CREATE DATABASE Pixel_Art_Museum;
USE Pixel_Art_Museum;

-- 3. Create the Tables
CREATE TABLE employees (
    badge_id INT PRIMARY KEY,
    name VARCHAR(100),
    role VARCHAR(100),
    salary INT,
    join_date DATE
);

CREATE TABLE gallery_access (
    area_id VARCHAR(10) PRIMARY KEY,
    area_name VARCHAR(100),
    security_level INT
);

CREATE TABLE security_logs (
    event_id INT PRIMARY KEY,
    timestamp DATETIME,
    area_id VARCHAR(10),
    badge_id INT,
    action VARCHAR(10)
);

CREATE TABLE incidents (
    incident_id VARCHAR(20) PRIMARY KEY,
    description TEXT,
    time_of_event DATETIME
);

-- 4. Insert the Data
INSERT INTO employees VALUES (101, 'Sarah Jenkins', 'Curator', 75000, '2022-03-15');
INSERT INTO employees VALUES (102, 'Vicky Kumar', 'Database Admin', 82000, '2024-01-10');
INSERT INTO employees VALUES (103, 'Marcus Thorne', 'Security Lead', 68000, '2023-11-20');
INSERT INTO employees VALUES (104, 'Elena Rodriguez', 'IT Specialist', 71000, '2025-05-02');
INSERT INTO employees VALUES (105, 'James Bond (Intern)', 'Intern', 30000, '2026-02-01');

INSERT INTO gallery_access VALUES ('A1', 'Main Lobby', 1);
INSERT INTO gallery_access VALUES ('A2', 'Digital Vault', 5);
INSERT INTO gallery_access VALUES ('A3', 'Server Room', 4);
INSERT INTO gallery_access VALUES ('A4', 'Employee Lounge', 2);
INSERT INTO gallery_access VALUES ('A5', 'Curator\'s Office', 3);

INSERT INTO security_logs VALUES (5001, '2026-02-12 21:00:00', 'A1', 101, 'entry');
INSERT INTO security_logs VALUES (5002, '2026-02-12 22:05:00', 'A3', 104, 'entry');
INSERT INTO security_logs VALUES (5003, '2026-02-12 22:10:00', 'A3', 102, 'entry');
INSERT INTO security_logs VALUES (5004, '2026-02-12 22:12:00', 'A3', 102, 'exit');
INSERT INTO security_logs VALUES (5005, '2026-02-12 22:20:00', 'A3', 104, 'exit');
INSERT INTO security_logs VALUES (5006, '2026-02-12 22:30:00', 'A5', 103, 'entry');

INSERT INTO incidents VALUES ('INC-99', 'Digital Masterpiece "Pixel Mona Lisa" deleted from server.', '2026-02-12 22:15:00');

-- 5. Join command for solution
SELECT 
    employees.name, 
    employees.role, 
    security_logs.timestamp, 
    security_logs.area_id, 
    security_logs.action
FROM employees
INNER JOIN security_logs ON employees.badge_id = security_logs.badge_id
WHERE security_logs.area_id = 'A3';

SELECT 
	name, role
    FROM employees 
    WHERE badge_id = (
		SELECT badge_id 
        FROM security_logs 
        WHERE area_id = 'A3' 
        AND action = 'entry' 
        AND timestamp <= (
			SELECT time_of_event 
            FROM incidents 
            WHERE incident_id = 'INC-99'
		) AND badge_id 
        NOT IN ( 
			SELECT badge_id 
            FROM security_logs 
            WHERE area_id = 'A3' 
            AND action = 'exit' 
            AND timestamp <= (
				SELECT time_of_event 
                FROM incidents 
                WHERE incident_id = 'INC-99'
			) 
		) 
	);
