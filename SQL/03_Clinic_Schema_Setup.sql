CREATE DATABASE clinic_management;
USE clinic_management;

CREATE TABLE clinics (
    cid VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE customer (
    uid VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    mobile VARCHAR(20)
);

CREATE TABLE clinic_sales (
    oid VARCHAR(50) PRIMARY KEY,
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount DECIMAL(10,2),
    datetime DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

CREATE TABLE expenses (
    eid VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50),
    description VARCHAR(200),
    amount DECIMAL(10,2),
    datetime DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

INSERT INTO clinics VALUES
('cnc-001', 'Care Plus Clinic', 'Hyderabad', 'Telangana', 'India'),
('cnc-002', 'HealthFirst Clinic', 'Hyderabad', 'Telangana', 'India'),
('cnc-003', 'Smile Care Clinic', 'Bangalore', 'Karnataka', 'India'),
('cnc-004', 'City Health Clinic', 'Chennai', 'Tamil Nadu', 'India');

INSERT INTO customer VALUES
('cust-001', 'John Doe', '9700000001'),
('cust-002', 'Priya Singh', '9700000002'),
('cust-003', 'Rahul Verma', '9700000003'),
('cust-004', 'David Miller', '9700000004');

INSERT INTO clinic_sales VALUES
-- January Sales
('ord-001', 'cust-001', 'cnc-001', 20000, '2021-01-10 10:30:00', 'sod'),
('ord-002', 'cust-002', 'cnc-002', 15000, '2021-01-12 14:20:00', 'walkin'),

-- February Sales
('ord-003', 'cust-003', 'cnc-003', 30000, '2021-02-15 11:00:00', 'sod'),
('ord-004', 'cust-001', 'cnc-001', 18000, '2021-02-18 16:45:00', 'walkin'),

-- September Sales
('ord-005', 'cust-004', 'cnc-002', 10000, '2021-09-23 12:03:22', 'sodat'),
('ord-006', 'cust-002', 'cnc-004', 22000, '2021-09-25 09:15:00', 'sod'),

-- October Sales
('ord-007', 'cust-003', 'cnc-001', 12000, '2021-10-05 18:12:50', 'walkin'),
('ord-008', 'cust-001', 'cnc-003', 25000, '2021-10-20 19:45:00', 'online');

INSERT INTO expenses VALUES
-- January Expenses
('exp-001', 'cnc-001', 'Rent', 5000, '2021-01-05 08:00:00'),
('exp-002', 'cnc-002', 'Electricity', 2000, '2021-01-15 09:30:00'),

-- February Expenses
('exp-003', 'cnc-003', 'Supplies', 3000, '2021-02-10 10:00:00'),
('exp-004', 'cnc-001', 'Equipment Repair', 4000, '2021-02-25 13:00:00'),

-- September Expenses
('exp-005', 'cnc-002', 'Maintenance', 2500, '2021-09-23 13:00:00'),
('exp-006', 'cnc-004', 'Cleaning', 1500, '2021-09-26 10:00:00'),

-- October Expenses
('exp-007', 'cnc-001', 'Medicines Stock', 5000, '2021-10-06 12:00:00'),
('exp-008', 'cnc-003', 'Water Bill', 1200, '2021-10-20 20:00:00');
