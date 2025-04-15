create database hospitaldbm;
use hospitaldbm;

CREATE TABLE Patients (
    patient_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    dob DATE,
    contact_number VARCHAR(15),
    address VARCHAR(255),
    medical_history TEXT
);

INSERT INTO Patients (name, gender, dob, contact_number, address, medical_history) 
VALUES 
('John Doe', 'Male', '1985-07-12', '1234567890', '123 Elm St', 'Diabetes, Hypertension'),
('Jane Smith', 'Female', '1990-09-25', '0987654321', '456 Oak St', 'Asthma'),
 ('Michael Scott', 'Male', '1964-03-15', '2223334444', '789 Birch St', 'Hypertension'),
('Pam Beesly', 'Female', '1980-09-25', '9876543210', '456 Cedar St', 'None'),
('Dwight Schrute', 'Male', '1978-01-20', '5556667777', '123 Farm Ln', 'None'),
('Jim Halpert', 'Male', '1979-10-01', '1112223333', '321 Maple St', 'Back Pain');


-- Create the Doctors table
CREATE TABLE Doctors (
    doctor_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    specialization VARCHAR(100),
    contact_number VARCHAR(15),
    email VARCHAR(100)
);

INSERT INTO Doctors (name, specialization, contact_number, email) 
VALUES 
('Dr. Alice Johnson', 'Cardiologist', '5551234567', 'alice.j@hospital.com'),
('Dr. Robert Brown', 'Dermatologist', '5559876543', 'robert.b@hospital.com'),
('Dr. Meredith Palmer', 'Psychiatrist', '5553334444', 'meredith.p@hospital.com'),
('Dr. Stanley Hudson', 'Endocrinologist', '5557778888', 'stanley.h@hospital.com');

-- Create the Appointments table
CREATE TABLE Appointments (
    appointment_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    appointment_time TIME,
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

INSERT INTO Appointments (patient_id, doctor_id, appointment_date, appointment_time, status) 
VALUES 
(1, 1, '2024-10-20', '10:00:00', 'Scheduled'),
(2, 2, '2024-10-21', '11:30:00', 'Scheduled'),
(3, 1, '2024-10-22', '09:00:00', 'Completed'),
(4, 3, '2024-10-23', '12:00:00', 'Scheduled'),
(5, 4, '2024-10-24', '14:00:00', 'Cancelled');

-- Create the Billing table
CREATE TABLE Billing (
    bill_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    bill_date DATE,
    amount DECIMAL(10, 2),
    status ENUM('Paid', 'Pending', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

INSERT INTO Billing (patient_id, doctor_id, bill_date, amount, status) 
VALUES 
(1, 1, '2024-10-20', 200.00, 'Paid'),
(2, 2, '2024-10-21', 150.00, 'Pending'),
(3, 1, '2024-10-22', 300.00, 'Paid'),
(4, 3, '2024-10-23', 250.00, 'Pending'),
(5, 4, '2024-10-24', 400.00, 'Cancelled');
 
select * from Patients;
select * from doctors;
select * from appointments;
select * from billing
where status = 'pending';

drop table billing;

select medical_history from patients
where patient_id =1;
select * from appointments
where doctor_id  = 1;

update appointments
set status = 'completed'
where appointment_id = 1;

INSERT INTO Billing (patient_id, doctor_id, bill_date, amount, status)
VALUES (1, 1, '2024-10-18', 250.00, 'Pending');
-- Inserts a new billing record for a patient, specifying the patient ID, doctor ID, date, amount, and billing status
insert into billing (patient_id, doctor_id, bill_date, amount, status)
values (1,1, '2024-10-18', 250.00, 'pending');

select sum(amount) from billing
where patient_id = 1;

update billing 
set status = 'paid'
where bill_id =1;
select count(*) from patients;
select * from patients;

select patients.name
from patients
inner join appointments on patients.patient_id = appointments.patient_id
where appointments.doctor_id =1;

SELECT *                                    -- Selects all columns from the Billing table
FROM Billing                               -- From the Billing table
WHERE MONTH(bill_date) = 10               -- Filters results to include only records from October
AND YEAR(bill_date) = 2024;                -- Filters results to include only records from the year 2024

 select * 
 from billing
 where month(bill_date) = 10
 and year(bill_date)= 2024;
 
SELECT p.name, COUNT(DISTINCT a.doctor_id) AS doctor_count  
FROM Patients p                                            
JOIN Appointments a ON p.patient_id = a.patient_id         
GROUP BY p.patient_id                                     
HAVING doctor_count > 1;                               
    
SELECT d.name AS doctor_name, COUNT(a.appointment_id) AS total_appointments  
FROM Doctors d                                                         
JOIN Appointments a ON d.doctor_id = a.doctor_id                       
WHERE MONTH(a.appointment_date) = 10 AND YEAR(a.appointment_date) = 2024  
GROUP BY d.doctor_id;         

select d.name as doctor_name, sum(b.amount) as total_income 
from doctors d
join billing b on d.doctor_id = b.doctor_id
where b.status = 'paid'
group by d.doctor_id;       

SELECT p.name, b.amount, b.bill_date                                   -- Selects the patient's name, bill amount, and bill date
FROM Patients p                                                        -- From the Patients table (alias 'p')
JOIN Billing b ON p.patient_id = b.patient_id                           -- Joins the Billing table on patient_id to match patients with their billing records
WHERE b.status = 'Pending';                                             -- Filters the billing records to only include those with a 'Pending' status

select p.name, b.amount, b.bill_date
from patients p
join billing b on p.patient_id = b.patient_id
where b.status = 'pending';

select p.name, a.appointment_date
from patients p
join appointments a on p.patient_id = a.appointment_id
where a.status = 'cancelled';

select avg(amount) as avg_bill_amount
from billing;

select p.name, count(a.appointment_id) as total_appointments
from patients p
join appointments a on p.patient_id = a.patient_id
group by p.patient_id
order by total_appointments desc
limit 3;

SELECT p.name, COUNT(a.appointment_id) AS total_appointments  
FROM Patients p                                              
JOIN Appointments a ON p.patient_id = a.patient_id            
GROUP BY p.patient_id                                         
ORDER BY total_appointments DESC                              
LIMIT 3;                                                      

select p.name 
from patients p
join appointments a on p.patient_id = a.patient_id
where a.doctor_id =1;

select appointment_date, count(appointment_id) as total_appointments
from appointments 
group by appointment_date;