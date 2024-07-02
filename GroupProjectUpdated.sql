-- Database code for AirBNB group project
--Alexia, Nick, Vinita, Joonas

DROP TABLE IF EXISTS Customer CASCADE;
DROP TABLE IF EXISTS Host CASCADE ;
DROP TABLE IF EXISTS Cancellation CASCADE;
DROP TABLE IF EXISTS Listing CASCADE;
DROP TABLE IF EXISTS Review CASCADE;
DROP TABLE IF EXISTS Amenity CASCADE;
DROP TABLE IF EXISTS Booking CASCADE;
DROP TABLE IF EXISTS Host_Language cascade;
DROP TABLE IF EXISTS Listing_Amenity cascade;
DROP TABLE IF EXISTS Payment CASCADE;
DROP TABLE IF EXISTS Notification CASCADE;
DROP TABLE IF EXISTS Booking_Price_Detail CASCADE;
DROP TABLE IF EXISTS Car_Rental CASCADE;
DROP TABLE IF EXISTS Booking_Confirmation CASCADE;
DROP TABLE IF EXISTS Listing_Car_Rental CASCADE;



CREATE TABLE Customer (
    Customer_id integer PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    street VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(50),
    Customer_dob DATE NOT NULL,
    emergency_phone VARCHAR(20),
    government_id VARCHAR(50) NOT NULL,
    Customer_picture BYTEA
);

CREATE TABLE Host (
    host_id integer PRIMARY KEY,
    host_first_name VARCHAR(100) NOT NULL,
    host_last_name VARCHAR(100),
    host_email VARCHAR(100) NOT null,
    host_phone VARCHAR(20) NOT null,
    host_status BOOLEAN NOT null,
    response_time INTEGER,
    response_rate DECIMAL(5, 2),
    instant_booking BOOLEAN
);

CREATE TABLE Cancellation (
    cancellation_id SERIAL PRIMARY KEY,
    refund_amount NUMERIC(10, 2) NOT null,
    cancellation_date DATE NOT null
);

CREATE TABLE Listing (
    listing_id integer PRIMARY KEY,
    host_id integer NOT null,
    title VARCHAR(255) NOT null,
    city VARCHAR(100) NOT null,
    state VARCHAR(100) NOT null,
    country VARCHAR(100) NOT null,
    home_type VARCHAR(50),
    availability DATE NOT null,
    bedroom_count integer NOT null,
    bathroom_count integer NOT null,
    bedroom_type VARCHAR(50),
    description TEXT NOT null,
    cancellation_policy VARCHAR(100) NOT null,
    FOREIGN KEY (host_id) REFERENCES Host(host_id)
);


CREATE TABLE Review (
    review_id integer PRIMARY KEY,
    listing_id integer NOT null,
    customer_id integer NOT null,
    review_text TEXT NOT null,
    review_date date NOT null,
    star_rating decimal(10, 2),
    FOREIGN KEY (listing_id) REFERENCES Listing(listing_id),
    FOREIGN KEY (customer_id) REFERENCES Customer (customer_id)
);


CREATE TABLE Amenity (
    amenity_id integer PRIMARY KEY,
    amenity_type VARCHAR(255) NOT NULL
);

CREATE TABLE Car_Rental (
    license_plate VARCHAR(20) PRIMARY KEY,
    make VARCHAR(50) NOT null,
    model VARCHAR(50) NOT null,
    car_year integer NOT null,
    color VARCHAR(50),
    daily_price DECIMAL(10, 2) NOT null,
    host_id integer NOT null,
    listing_id integer NOT null,
    FOREIGN KEY (host_id) REFERENCES Host(host_id),
    FOREIGN KEY (listing_id) REFERENCES Listing(listing_id)
);

CREATE TABLE Booking (
    booking_id integer PRIMARY KEY,
    listing_id integer NOT null,
    customer_id integer NOT null,
    cancellation_id integer NOT null,
    license_plate VARCHAR(20),
    check_in DATE NOT null,
    check_out DATE NOT null,
    booking_date DATE NOT null,
    booking_time TIME NOT null,
    total_price_paid DECIMAL(10, 2) NOT null,
    FOREIGN KEY (listing_id) REFERENCES listing(listing_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (cancellation_id) REFERENCES cancellation(cancellation_id),
    FOREIGN KEY (license_plate) REFERENCES Car_Rental(license_plate)
);

CREATE TABLE Host_Language (
    host_id INTEGER,
    host_language VARCHAR(255),
    PRIMARY KEY (host_id, host_language),
    FOREIGN KEY (host_id) REFERENCES host(host_id)
);

CREATE TABLE Listing_Amenity (
    listing_id integer,
    amenity_id integer,
    PRIMARY KEY (listing_id, amenity_id),
    FOREIGN KEY (listing_id) REFERENCES listing(listing_id),
    FOREIGN KEY (amenity_id) REFERENCES amenity(amenity_id)
);

CREATE TABLE Payment (
    payment_id integer PRIMARY KEY,
    payment_card_type VARCHAR(50) NOT null,
    payment_card_number VARCHAR (50) NOT null,
    billing_zip VARCHAR(20) NOT null,
    billing_country VARCHAR(100),
    booking_id integer NOT null,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

CREATE TABLE Notification (
    notification_id INTEGER PRIMARY KEY,
    sent_date DATE NOT null,
    notification_status VARCHAR(50),
    notification_body TEXT NOT null,
    booking_id integer NOT null,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);


CREATE TABLE Booking_Price_Detail (
    price_detail_number VARCHAR(255) PRIMARY KEY,
    booking_id integer NOT null,
    total_price DECIMAL(10, 2) NOT null,
    price_by_day DECIMAL(10, 2) NOT null,
    early_bird_discount DECIMAL(10, 2),
    cleaning_fee DECIMAL(10, 2),
    service_fee DECIMAL(10, 2),
    car_fee DECIMAL(10, 2),
    additional_fee decimal (10, 2),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);


CREATE TABLE Booking_Confirmation (
    confirmation_code VARCHAR(50) PRIMARY KEY,
    booking_id integer NOT null,
    verification_email VARCHAR(255) NOT null,
    verification_text VARCHAR(255),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

CREATE TABLE Listing_Car_Rental (
    license_plate VARCHAR(20),
    listing_id integer,
    status BOOLEAN,
    PRIMARY KEY (license_plate, listing_id),
    FOREIGN KEY (license_plate) REFERENCES Car_Rental(license_plate),
    FOREIGN KEY (listing_id) REFERENCES Listing(listing_id)
);


ALTER TABLE Car_Rental DROP COLUMN listing_id;



--- Populating the database with sample data:

-- Populate Customer table
INSERT INTO Customer (Customer_id, first_name, last_name, email, phone, street, city, state, Customer_dob, emergency_phone, government_id)
VALUES 
(1, 'John', 'Doe', 'john@example.com', '123-456-7890', '123 Main St', 'New York', 'NY', '1990-01-01', '987-654-3210', 'US123456789'),
(2, 'Alice', 'Smith', 'alice@example.com', '987-654-3210', '456 Elm St', 'Los Angeles', 'CA', '1985-05-15', '555-555-5555', 'US987654321'),
(3, 'Michael', 'Johnson', 'michael@example.com', '111-222-3333', '789 Oak St', 'Chicago', 'IL', '1988-08-20', '333-333-3333', 'US333333333'),
(4, 'Emily', 'Brown', 'emily@example.com', '444-555-6666', '567 Pine St', 'Houston', 'TX', '1975-03-10', '999-999-9999', 'US999999999'),
(5, 'Sophia', 'Wilson', 'sophia@example.com', '777-888-9999', '890 Maple St', 'Miami', 'FL', '1982-11-25', '777-777-7777', 'US777777777'),
(6, 'James', 'Anderson', 'james@example.com', '222-333-4444', '678 Cedar St', 'Seattle', 'WA', '1995-06-30', '222-222-2222', 'US222222222'),
(7, 'Olivia', 'Martinez', 'olivia@example.com', '666-777-8888', '456 Elm St', 'San Francisco', 'CA', '1998-09-15', '666-666-6666', 'US666666666'),
(8, 'William', 'Garcia', 'william@example.com', '333-444-5555', '345 Birch St', 'Boston', 'MA', '1991-04-05', '888-888-8888', 'US888888888'),
(9, 'Emma', 'Lopez', 'emma@example.com', '888-999-0000', '234 Walnut St', 'Austin', 'TX', '1987-02-14', '111-111-1111', 'US111111111'),
(10, 'Alexander', 'Hernandez', 'alexander@example.com', '555-666-7777', '789 Oak St', 'Philadelphia', 'PA', '1980-10-12', '444-444-4444', 'US444444444'),
(11, 'Isabella', 'Perez', 'isabella@example.com', '999-000-1111', '890 Maple St', 'Denver', 'CO', '1979-07-08', '000-000-0000', 'US000000000'),
(12, 'Michael', 'Flores', 'michael2@example.com', '222-333-4444', '678 Cedar St', 'Portland', 'OR', '1993-12-20', '222-222-2222', 'US222222222'),
(13, 'Charlotte', 'Gonzalez', 'charlotte@example.com', '444-555-6666', '567 Pine St', 'Phoenix', 'AZ', '1996-05-18', '999-999-9999', 'US999999999'),
(14, 'Mason', 'Ramirez', 'mason@example.com', '777-888-9999', '890 Maple St', 'Detroit', 'MI', '1976-08-22', '777-777-7777', 'US777777777'),
(15, 'Ava', 'Torres', 'ava@example.com', '111-222-3333', '123 Main St', 'San Antonio', 'TX', '1983-01-28', '111-111-1111', 'US111111111');

-- Populate Host table
INSERT INTO Host (host_id, host_first_name, host_last_name, host_email, host_phone, host_status, response_time, response_rate, instant_booking)
VALUES 
(1, 'Emily', 'Johnson', 'emily@example.com', '111-222-3333', TRUE, 30, 95.5, TRUE),
(2, 'Michael', 'Brown', 'michael@example.com', '444-555-6666', TRUE, 45, 90.0, FALSE),
(3, 'Sophia', 'Wilson', 'sophia@example.com', '777-888-9999', TRUE, 60, 98.3, TRUE),
(4, 'Olivia', 'Martinez', 'olivia@example.com', '666-777-8888', FALSE, 55, 87.9, TRUE),
(5, 'William', 'Garcia', 'william@example.com', '333-444-5555', TRUE, 40, 92.6, FALSE),
(6, 'Emma', 'Lopez', 'emma@example.com', '888-999-0000', TRUE, 35, 96.2, TRUE),
(7, 'Alexander', 'Hernandez', 'alexander@example.com', '555-666-7777', TRUE, 50, 88.9, FALSE),
(8, 'Isabella', 'Perez', 'isabella@example.com', '999-000-1111', FALSE, 65, 93.7, TRUE),
(9, 'Charlotte', 'Gonzalez', 'charlotte@example.com', '444-555-6666', TRUE, 25, 97.4, FALSE),
(10, 'Mason', 'Ramirez', 'mason@example.com', '777-888-9999', TRUE, 70, 85.2, TRUE),
(11, 'Ava', 'Torres', 'ava@example.com', '111-222-3333', TRUE, 20, 94.8, TRUE),
(12, 'Liam', 'Hernandez', 'liam@example.com', '222-333-4444', FALSE, 15, 91.1, FALSE),
(13, 'Emma', 'Garcia', 'emma2@example.com', '333-444-5555', TRUE, 75, 89.5, TRUE),
(14, 'Michael', 'Martinez', 'michael2@example.com', '444-555-6666', FALSE, 55, 86.7, FALSE),
(15, 'Sophia', 'Ramirez', 'sophia2@example.com', '555-666-7777', TRUE, 45, 97.8, TRUE);

-- Populate Cancellation table
INSERT INTO Cancellation (refund_amount, cancellation_date)
VALUES 
(50.00, '2024-02-01'),
(25.00, '2024-02-10'),
(35.00, '2024-02-15'),
(20.00, '2024-02-20'),
(40.00, '2024-02-25'),
(30.00, '2024-02-28'),
(45.00, '2024-03-05'),
(60.00, '2024-03-10'),
(55.00, '2024-03-15'),
(70.00, '2024-03-20'),
(65.00, '2024-03-25'),
(75.00, '2024-03-30'),
(80.00, '2024-04-05'),
(85.00, '2024-04-10'),
(90.00, '2024-04-15');

-- Populate Listing table
INSERT INTO Listing (listing_id, host_id, title, city, state, country, home_type, availability, bedroom_count, bathroom_count, bedroom_type, description, cancellation_policy)
VALUES 
(1, 1, 'Cozy Apartment in Downtown', 'New York', 'NY', 'USA', 'Apartment', '2024-03-01', 1, 1, 'Private', 'A cozy apartment located in the heart of downtown.', 'Flexible'),
(2, 2, 'Luxury Villa with Pool', 'Los Angeles', 'CA', 'USA', 'Villa', '2024-03-15', 3, 2, 'Shared', 'Luxurious villa with a private pool and stunning views.', 'Moderate'),
(3, 3, 'Charming Cottage in the Countryside', 'Seattle', 'WA', 'USA', 'Cottage', '2024-04-01', 2, 1, 'Entire', 'A charming cottage nestled in the picturesque countryside.', 'Strict'),
(4, 4, 'Modern Loft in Downtown', 'Chicago', 'IL', 'USA', 'Loft', '2024-04-15', 1, 1, 'Entire', 'A modern loft with stunning city views.', 'Moderate'),
(5, 5, 'Beachfront Bungalow', 'Miami', 'FL', 'USA', 'Bungalow', '2024-05-01', 2, 2, 'Private', 'A cozy bungalow right on the beach.', 'Flexible'),
(6, 6, 'Spacious Mountain Retreat', 'Denver', 'CO', 'USA', 'House', '2024-05-15', 4, 3, 'Entire', 'A spacious retreat nestled in the mountains.', 'Strict'),
(7, 7, 'Rustic Cabin by the Lake', 'Portland', 'OR', 'USA', 'Cabin', '2024-06-01', 1, 1, 'Private', 'A rustic cabin with serene lake views.', 'Flexible'),
(8, 8, 'Historic Townhouse in Boston', 'Boston', 'MA', 'USA', 'Townhouse', '2024-06-15', 3, 2, 'Entire', 'A historic townhouse in the heart of the city.', 'Moderate'),
(9, 9, 'Sunny Condo with City Views', 'San Francisco', 'CA', 'USA', 'Condo', '2024-07-01', 2, 1, 'Private', 'A sunny condo with panoramic city views.', 'Flexible'),
(10, 10, 'Secluded Retreat in the Woods', 'Austin', 'TX', 'USA', 'House', '2024-07-15', 3, 2, 'Entire', 'A secluded retreat surrounded by nature.', 'Strict'),
(11, 11, 'Lakefront Cabin with Hot Tub', 'Philadelphia', 'PA', 'USA', 'Cabin', '2024-08-01', 2, 1, 'Private', 'A cozy cabin with a relaxing hot tub overlooking the lake.', 'Flexible'),
(12, 12, 'Downtown Loft with Skyline Views', 'Phoenix', 'AZ', 'USA', 'Loft', '2024-08-15', 1, 1, 'Entire', 'A stylish loft with breathtaking skyline views.', 'Moderate'),
(13, 13, 'Cozy Cottage near National Park', 'Detroit', 'MI', 'USA', 'Cottage', '2024-09-01', 2, 1, 'Private', 'A cozy cottage perfect for exploring the nearby national park.', 'Flexible'),
(14, 14, 'Beach House with Private Pool', 'San Antonio', 'TX', 'USA', 'House', '2024-09-15', 4, 3, 'Entire', 'A luxurious beach house with a private pool.', 'Strict'),
(15, 15, 'Mountain Chalet with Scenic Views', 'Seattle', 'WA', 'USA', 'Chalet', '2024-10-01', 3, 2, 'Entire', 'A charming chalet with stunning mountain views.', 'Moderate');

-- Populate Review table
INSERT INTO Review (review_id, listing_id, customer_id, review_text, review_date, star_rating)
VALUES 
(1, 1, 2, 'Great location and comfortable stay.', '2024-02-20', 4.50),
(2, 2, 1, 'Amazing villa with excellent amenities.', '2024-02-25', 5.00),
(3, 3, 3, 'Charming cottage with beautiful surroundings.', '2024-03-05', 4.00),
(4, 4, 4, 'Modern loft with great views of the city.', '2024-03-10', 4.20),
(5, 5, 5, 'Perfect beachfront getaway.', '2024-03-15', 4.80),
(6, 6, 6, 'Spacious retreat with breathtaking views.', '2024-03-20', 4.70),
(7, 7, 7, 'Rustic cabin with a cozy atmosphere.', '2024-03-25', 4.30),
(8, 8, 8, 'Historic townhouse with character.', '2024-03-30', 4.60),
(9, 9, 9, 'Sunny condo with stunning city views.', '2024-04-05', 4.90),
(10, 10, 10, 'Secluded retreat surrounded by nature.', '2024-04-10', 4.40),
(11, 11, 11, 'Relaxing lakefront cabin with hot tub.', '2024-04-15', 4.50),
(12, 12, 12, 'Stylish loft with breathtaking skyline views.', '2024-04-20', 4.30),
(13, 13, 13, 'Cozy cottage perfect for a getaway.', '2024-04-25', 4.80),
(14, 14, 14, 'Luxurious beach house with private pool.', '2024-04-30', 4.60),
(15, 15, 15, 'Charming chalet with stunning mountain views.', '2024-05-05', 4.70);



-- Populate Amenity table
INSERT INTO Amenity (amenity_id, amenity_type)
VALUES 
(1, 'WiFi'),
(2, 'Swimming Pool'),
(3, 'Hot Tub'),
(4, 'Gym'),
(5, 'Parking'),
(6, 'Kitchen'),
(7, 'Air Conditioning'),
(8, 'Pet Friendly'),
(9, 'Fireplace'),
(10, 'Beach Access'),
(11, 'Hiking Trails'),
(12, 'BBQ Grill'),
(13, 'Balcony'),
(14, 'Game Room'),
(15, 'Laundry Facilities');

-- Populate Car_Rental table
INSERT INTO Car_Rental (license_plate, make, model, car_year, color, daily_price, host_id)
VALUES 
('ABC123', 'Toyota', 'Camry', 2019, 'Silver', 50.00, 1),
('XYZ456', 'Honda', 'Civic', 2020, 'Blue', 60.00, 2),
('DEF789', 'Ford', 'Escape', 2018, 'Black', 70.00, 3),
('GHI012', 'Chevrolet', 'Malibu', 2017, 'White', 55.00, 4),
('JKL345', 'Nissan', 'Altima', 2019, 'Red', 65.00, 5),
('MNO678', 'Hyundai', 'Elantra', 2021, 'Gray', 75.00, 6),
('PQR901', 'Kia', 'Forte', 2018, 'Green', 45.00, 7),
('STU234', 'Subaru', 'Outback', 2020, 'Brown', 80.00, 8),
('VWX567', 'Mazda', 'CX-5', 2017, 'Yellow', 70.00, 9),
('YZA890', 'Jeep', 'Cherokee', 2016, 'Orange', 90.00, 10),
('BCD123', 'Volkswagen', 'Jetta', 2021, 'Purple', 55.00, 11),
('EFG456', 'Audi', 'A4', 2022, 'Silver', 100.00, 12),
('HIJ789', 'BMW', '3 Series', 2021, 'Black', 120.00, 13),
('KLM012', 'Mercedes-Benz', 'C-Class', 2020, 'Blue', 110.00, 14),
('NOP345', 'Tesla', 'Model 3', 2022, 'White', 150.00, 15);

-- Populate Listing_Car_Rental table
INSERT INTO Listing_Car_Rental (license_plate, listing_id, status)
VALUES 
('ABC123', 1, true),
('XYZ456', 2, true),
('DEF789', 3, true),
('GHI012', 4, true),
('JKL345', 5, true),
('MNO678', 6, true),
('PQR901', 7, true),
('STU234', 8, true),
('VWX567', 9, true),
('YZA890', 10, true),
('BCD123', 11, true),
('EFG456', 12, true),
('HIJ789', 13, true),
('KLM012', 14, true),
('NOP345', 15, true);

-- Populate Booking table
INSERT INTO Booking (booking_id, listing_id, customer_id, cancellation_id, license_plate, check_in, check_out, booking_date, booking_time, total_price_paid)
VALUES 
(1, 1, 2, 1, 'ABC123', '2024-02-20', '2024-02-25', '2024-01-15', '12:00:00', 250.00),
(2, 2, 1, 2, NULL, '2024-02-25', '2024-03-05', '2024-01-20', '13:00:00', 350.00),
(3, 3, 3, 3, 'XYZ456', '2024-03-05', '2024-03-10', '2024-01-25', '14:00:00', 300.00),
(4, 4, 4, 4, NULL, '2024-03-10', '2024-03-15', '2024-01-30', '15:00:00', 400.00),
(5, 5, 5, 5, 'DEF789', '2024-03-15', '2024-03-20', '2024-02-05', '16:00:00', 450.00),
(6, 6, 6, 6, NULL, '2024-03-20', '2024-03-25', '2024-02-10', '17:00:00', 500.00),
(7, 7, 7, 7, 'GHI012', '2024-03-25', '2024-03-30', '2024-02-15', '18:00:00', 550.00),
(8, 8, 8, 8, NULL, '2024-03-30', '2024-04-05', '2024-02-20', '19:00:00', 600.00),
(9, 9, 9, 9, 'JKL345', '2024-04-05', '2024-04-10', '2024-02-25', '20:00:00', 650.00),
(10, 10, 10, 10, NULL, '2024-04-10', '2024-04-15', '2024-03-01', '21:00:00', 700.00),
(11, 11, 11, 11, 'MNO678', '2024-04-15', '2024-04-20', '2024-03-05', '22:00:00', 750.00),
(12, 12, 12, 12, NULL, '2024-04-20', '2024-04-25', '2024-03-10', '23:00:00', 800.00),
(13, 13, 13, 13, 'PQR901', '2024-04-25', '2024-04-30', '2024-03-15', '00:00:00', 850.00),
(14, 14, 14, 14, NULL, '2024-04-30', '2024-05-05', '2024-03-20', '01:00:00', 900.00),
(15, 15, 15, 15, 'STU234', '2024-05-05', '2024-05-10', '2024-03-25', '02:00:00', 950.00);


-- Populate Host_Language table
INSERT INTO Host_Language (host_id, host_language)
VALUES 
(1, 'English'),
(2, 'Spanish'),
(3, 'French'),
(4, 'German'),
(5, 'Italian'),
(6, 'Mandarin'),
(7, 'Japanese'),
(8, 'Korean'),
(9, 'Russian'),
(10, 'Arabic'),
(11, 'Portuguese'),
(12, 'Dutch'),
(13, 'Swedish'),
(14, 'Norwegian'),
(15, 'Danish');

-- Populate Listing_Amenity table
INSERT INTO Listing_Amenity (listing_id, amenity_id)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15);

-- Populate Payment table

INSERT INTO Payment (payment_id, payment_card_type, payment_card_number, billing_zip, billing_country, booking_id)
VALUES 
(1, 'Visa', '4111111111111111', '10001', 'USA', 1),
(2, 'MasterCard', '5500000000000004', '90001', 'USA', 2),
(3, 'American Express', '340000000000009', '20001', 'USA', 3),
(4, 'Discover', '6011000000000004', '30001', 'USA', 4),
(5, 'Visa', '4007000000027', '40001', 'USA', 5),
(6, 'MasterCard', '5555555555554444', '50001', 'USA', 6),
(7, 'American Express', '370000000000002', '60001', 'USA', 7),
(8, 'Discover', '6011111111111117', '70001', 'USA', 8),
(9, 'Visa', '4000111111111115', '80001', 'USA', 9),
(10, 'MasterCard', '2221000000000009', '90001', 'USA', 10),
(11, 'American Express', '371449635398431', '10001', 'USA', 11),
(12, 'Discover', '6011000990139424', '20001', 'USA', 12),
(13, 'Visa', '4000056655665556', '30001', 'USA', 13),
(14, 'MasterCard', '5555555555554444', '40001', 'USA', 14),
(15, 'American Express', '378282246310005', '50001', 'USA', 15);


-- Populate Notification table
INSERT INTO Notification (notification_id, sent_date, notification_status, notification_body, booking_id)
VALUES 
(1, '2024-02-25', 'Sent', 'Your booking has been confirmed.', 1),
(2, '2024-03-05', 'Sent', 'Reminder: Your check-in is approaching.', 2),
(3, '2024-03-10', 'Sent', 'Cancellation: Booking ID 3 has been cancelled.', 3),
(4, '2024-03-15', 'Sent', 'Your booking has been confirmed.', 4),
(5, '2024-03-20', 'Sent', 'Reminder: Your check-in is approaching.', 5),
(6, '2024-03-25', 'Sent', 'Cancellation: Booking ID 6 has been cancelled.', 6),
(7, '2024-03-30', 'Sent', 'Your booking has been confirmed.', 7),
(8, '2024-04-05', 'Sent', 'Reminder: Your check-in is approaching.', 8),
(9, '2024-04-10', 'Sent', 'Cancellation: Booking ID 9 has been cancelled.', 9),
(10, '2024-04-15', 'Sent', 'Your booking has been confirmed.', 10),
(11, '2024-04-20', 'Sent', 'Reminder: Your check-in is approaching.', 11),
(12, '2024-04-25', 'Sent', 'Cancellation: Booking ID 12 has been cancelled.', 12),
(13, '2024-04-30', 'Sent', 'Your booking has been confirmed.', 13),
(14, '2024-05-05', 'Sent', 'Reminder: Your check-in is approaching.', 14),
(15, '2024-05-10', 'Sent', 'Cancellation: Booking ID 15 has been cancelled.', 15);

-- Populate Booking_Price_Detail table
INSERT INTO Booking_Price_Detail (price_detail_number, booking_id, total_price, price_by_day, early_bird_discount, cleaning_fee, service_fee, car_fee, additional_fee)
VALUES 
('PD001', 1, 400.00, 100.00, NULL, 50.00, 20.00, NULL, NULL),
('PD002', 2, 800.00, 160.00, NULL, 75.00, 30.00, NULL, NULL),
('PD003', 3, 600.00, 120.00, NULL, 60.00, 25.00, NULL, NULL),
('PD004', 4, 450.00, 90.00, NULL, 45.00, 15.00, NULL, NULL),
('PD005', 5, 700.00, 140.00, NULL, 70.00, 30.00, NULL, NULL),
('PD006', 6, 1000.00, 200.00, NULL, 100.00, 40.00, NULL, NULL),
('PD007', 7, 300.00, 60.00, NULL, 30.00, 10.00, NULL, NULL),
('PD008', 8, 650.00, 130.00, NULL, 65.00, 25.00, NULL, NULL),
('PD009', 9, 550.00, 110.00, NULL, 55.00, 20.00, NULL, NULL),
('PD010', 10, 750.00, 150.00, NULL, 75.00, 30.00, NULL, NULL),
('PD011', 11, 400.00, 80.00, NULL, 40.00, 15.00, NULL, NULL),
('PD012', 12, 850.00, 170.00, NULL, 85.00, 35.00, NULL, NULL),
('PD013', 13, 600.00, 120.00, NULL, 60.00, 25.00, NULL, NULL),
('PD014', 14, 950.00, 190.00, NULL, 95.00, 40.00, NULL, NULL),
('PD015', 15, 800.00, 160.00, NULL, 80.00, 35.00, NULL, NULL);




-- Populate Booking_Confirmation table
INSERT INTO Booking_Confirmation (confirmation_code, booking_id, verification_email, verification_text)
VALUES 
('CONF001', 1, 'customer1@example.com', 'Your booking has been confirmed. Thank you!'),
('CONF002', 2, 'customer2@example.com', 'Your reservation is confirmed. Enjoy your stay!'),
('CONF003', 3, 'customer3@example.com', 'Booking confirmed. Have a great trip!'),
('CONF004', 4, 'customer4@example.com', 'Reservation confirmed. Have a wonderful stay!'),
('CONF005', 5, 'customer5@example.com', 'Your booking is confirmed. Enjoy your vacation!'),
('CONF006', 6, 'customer6@example.com', 'Reservation confirmed. Have a pleasant stay!'),
('CONF007', 7, 'customer7@example.com', 'Your booking has been confirmed. Thank you for choosing us!'),
('CONF008', 8, 'customer8@example.com', 'Reservation confirmed. Enjoy your time with us!'),
('CONF009', 9, 'customer9@example.com', 'Your booking is confirmed. We look forward to hosting you!'),
('CONF010', 10, 'customer10@example.com', 'Reservation confirmed. Have a fantastic stay!'),
('CONF011', 11, 'customer11@example.com', 'Your booking has been confirmed. Enjoy your trip!'),
('CONF012', 12, 'customer12@example.com', 'Reservation confirmed. Have a memorable stay!'),
('CONF013', 13, 'customer13@example.com', 'Your booking is confirmed. Have a wonderful experience!'),
('CONF014', 14, 'customer14@example.com', 'Reservation confirmed. Enjoy your staycation!'),
('CONF015', 15, 'customer15@example.com', 'Your booking has been confirmed. Have a great time!');



SELECT *
FROM amenity;

SELECT *
FROM booking;

SELECT *
FROM booking_confirmation;

SELECT *
FROM booking_price_detail;

SELECT *
FROM cancellation;

SELECT *
FROM car_rental;

SELECT *
FROM customer;

SELECT *
FROM host;

SELECT *
FROM host_language;

SELECT *
FROM listing;

SELECT *
FROM listing_amenity;

SELECT *
FROM listing_car_rental;

SELECT *
FROM notification;

SELECT *
FROM payment;

SELECT *
FROM review;