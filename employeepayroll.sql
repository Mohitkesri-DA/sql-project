-- Create the database for the Payroll Management System
CREATE DATABASE EmpPayrollDB;
USE EmpPayrollDB;
CREATE TABLE Employees (
    employee_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(255) NOT NULL,
    department VARCHAR(100),
    position VARCHAR(100),
    hire_date DATE,
    base_salary DECIMAL(10, 2) NOT NULL
);
INSERT INTO Employees (employee_name, department, position, hire_date, base_salary) VALUES 
('Alan Vince', 'Finance', 'Manager', '2020-01-15', 50000.00),
('Alex Kent', 'HR', 'HR Specialist', '2019-03-10', 40000.00);

-- Create the Attendance table
CREATE TABLE Attendance (
    attendance_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    attendance_date DATE,
    status ENUM('Present', 'Absent', 'Leave'),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);
INSERT INTO Attendance (employee_id, attendance_date, status) VALUES 
(1, '2023-09-01', 'Present'),
(2, '2023-09-01', 'Leave');

CREATE TABLE Salaries (
    salary_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    base_salary DECIMAL(10, 2) NOT NULL,
    bonus DECIMAL(10, 2),
    deductions DECIMAL(10, 2),
    month VARCHAR(20),
    year INT,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
); 
INSERT INTO Salaries (employee_id, base_salary, bonus, deductions, month, year) VALUES 
(1, 50000.00, 5000.00, 2000.00, 'September', 2023),
(2, 40000.00, 3000.00, 1000.00, 'September', 2023);

CREATE TABLE Payroll (
    payroll_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    total_salary DECIMAL(10, 2),
    payment_date DATE,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);
insert into employees(employee_name, department, position, hire_date, base_salary)
values
 ('jennith kery', 'sales', 'sales executive', '2023-10-01', 300000.00);
 
select * from employees;

update employees
set  base_salary = 59000.00
 where employee_id in(1,4);
delete from employees
where employee_id =3;

insert into attendance (employee_id, attendance_date, status)
values (1, '2023-09-02','present');
select *  from attendance;


SELECT employee_id, (base_salary + bonus - deductions) AS total_salary
FROM Salaries
WHERE employee_id = 1 AND month = 'September' AND year = 2023;

select employee_id, (base_salary + bonus- deductions) as total_salary
from salaries
where employee_id =1 and month = 'september' and year = 2023;

insert into payroll (employee_id, total_salary, payment_date)
values
(1, 54000.00, '2023-09-30');
select * from payroll;

-- Select employee_name from the Employees table
-- Select base_salary, bonus, and deductions from the Salaries table
-- Select total_salary and payment_date from the Payroll table

SELECT e.employee_name, s.base_salary, s.bonus, s.deductions, p.total_salary, p.payment_date as filter_salary
FROM Employees e
JOIN Salaries s ON e.employee_id = s.employee_id
JOIN Payroll p ON e.employee_id = p.employee_id
WHERE e.employee_id = 1 AND s.month = 'September' AND s.year = 2023;

-- Select employee_id and calculate the number of 'Present' days
SELECT employee_id, 
       SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) AS present_days,
       SUM(CASE WHEN status = 'Absent' THEN 1 ELSE 0 END) AS absent_days,
       SUM(CASE WHEN status = 'Leave' THEN 1 ELSE 0 END) AS leave_days
FROM Attendance
WHERE attendance_date BETWEEN '2023-09-01' AND '2023-09-30'
AND employee_id = 1
GROUP BY employee_id;

