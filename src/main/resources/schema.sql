-- ============================================================
--  Modern Employee Tracker — Database Schema
--  Database: employee_tracker
-- ============================================================

CREATE DATABASE IF NOT EXISTS employee_tracker
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE employee_tracker;

-- Drop and recreate for fresh setup
DROP TABLE IF EXISTS employee;

CREATE TABLE employee (
    id           BIGINT       NOT NULL AUTO_INCREMENT,
    name         VARCHAR(100) NOT NULL,
    email        VARCHAR(150) NOT NULL UNIQUE,
    department   VARCHAR(80)  NOT NULL,
    salary       DOUBLE       NOT NULL,
    location     VARCHAR(100),
    joining_date DATE         NOT NULL,
    status       VARCHAR(20)  NOT NULL DEFAULT 'Active',

    PRIMARY KEY (id),
    INDEX idx_employee_status     (status),
    INDEX idx_employee_department (department),
    INDEX idx_employee_email      (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Sample Data ──────────────────────────────────────────────
INSERT INTO employee (name, email, department, salary, location, joining_date, status) VALUES
('Aarav Sharma',    'aarav.sharma@example.com',    'Engineering',  75000, 'Pune',      '2023-01-15', 'Active'),
('Priya Patel',     'priya.patel@example.com',     'HR',           52000, 'Mumbai',    '2022-06-10', 'Active'),
('Rohit Verma',     'rohit.verma@example.com',     'Engineering',  80000, 'Bengaluru', '2021-09-01', 'Active'),
('Sneha Joshi',     'sneha.joshi@example.com',     'Marketing',    60000, 'Pune',      '2023-03-22', 'Active'),
('Vikram Singh',    'vikram.singh@example.com',    'Finance',      65000, 'Delhi',     '2020-11-05', 'Inactive'),
('Ananya Gupta',    'ananya.gupta@example.com',    'Engineering',  72000, 'Hyderabad', '2022-08-17', 'Active'),
('Karan Malhotra',  'karan.malhotra@example.com',  'Sales',        48000, 'Chennai',   '2023-07-01', 'Active'),
('Deepika Nair',    'deepika.nair@example.com',    'HR',           55000, 'Kochi',     '2021-04-20', 'Active'),
('Arjun Reddy',     'arjun.reddy@example.com',     'Engineering',  90000, 'Bengaluru', '2019-12-01', 'Active'),
('Meera Iyer',      'meera.iyer@example.com',      'Finance',      70000, 'Mumbai',    '2022-02-14', 'Inactive'),
('Nikhil Desai',    'nikhil.desai@example.com',    'Marketing',    58000, 'Ahmedabad', '2023-05-30', 'Active'),
('Pooja Kulkarni',  'pooja.kulkarni@example.com',  'Sales',        47000, 'Pune',      '2022-10-11', 'Active');
