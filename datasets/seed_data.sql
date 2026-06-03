-- QA SQL Lab sample data
-- Includes valid records and intentional data quality issues for practice.

INSERT INTO users (id, first_name, last_name, email, status, country, age, created_at, deleted_at) VALUES
(1, 'Anna', 'Smith', 'anna.smith@example.com', 'ACTIVE', 'USA', 29, '2026-01-10 09:15:00', NULL),
(2, 'Brian', 'Miller', 'brian.miller@example.com', 'ACTIVE', 'Canada', 34, '2026-01-12 13:40:00', NULL),
(3, 'Carla', 'Garcia', 'carla.garcia@example.com', 'INACTIVE', 'Germany', 41, '2026-02-03 08:00:00', NULL),
(4, 'Dmitry', 'Ivanov', 'dmitry.ivanov@example.com', 'ACTIVE', 'Hungary', 27, '2026-02-14 17:30:00', NULL),
(5, 'Eva', 'Brown', 'eva.brown@example.com', 'DELETED', 'USA', 38, '2026-03-01 10:10:00', '2026-05-01 12:00:00'),
(6, 'Frank', 'Wilson', 'anna.smith@example.com', 'ACTIVE', 'USA', 45, '2026-03-05 15:25:00', NULL),
(7, 'Grace', 'Taylor', 'grace.taylor@example.com', 'ACTIVE', 'Canada', 17, '2026-04-18 11:05:00', NULL),
(8, 'Hanna', 'Kovacs', 'hanna.kovacs@example.com', 'ACTIVE', 'Hungary', NULL, '2026-06-03 09:00:00', NULL);

INSERT INTO addresses (id, user_id, city, country, postal_code, is_primary, created_at) VALUES
(1, 1, 'New York', 'USA', '10001', TRUE, '2026-01-10 09:20:00'),
(2, 2, 'Toronto', 'Canada', 'M5H', TRUE, '2026-01-12 14:00:00'),
(3, 3, 'Berlin', 'Germany', '10115', TRUE, '2026-02-03 09:30:00'),
(4, 4, 'Budapest', 'Hungary', '1051', TRUE, '2026-02-14 18:00:00'),
(5, 6, 'Boston', 'USA', '02108', TRUE, '2026-03-05 15:45:00'),
(6, 99, 'Ghost City', 'USA', '00000', TRUE, '2026-04-01 08:00:00');

INSERT INTO orders (id, user_id, order_number, status, amount, created_at) VALUES
(1, 1, 'ORD-1001', 'PAID', 120.50, '2026-01-15 10:00:00'),
(2, 1, 'ORD-1002', 'SHIPPED', 75.00, '2026-02-01 16:45:00'),
(3, 2, 'ORD-1003', 'PAID', 250.00, '2026-02-07 12:20:00'),
(4, 3, 'ORD-1004', 'CANCELLED', 60.00, '2026-02-10 09:10:00'),
(5, 4, 'ORD-1005', 'NEW', 35.99, '2026-03-20 19:00:00'),
(6, 99, 'ORD-1006', 'PAID', 15.00, '2026-04-02 07:30:00'),
(7, 6, 'ORD-1007', 'PAID', -20.00, '2026-04-10 10:10:00'),
(8, 8, 'ORD-1008', 'NEW', 49.90, '2026-06-03 09:30:00');

INSERT INTO payments (id, order_id, payment_method, status, amount, paid_at) VALUES
(1, 1, 'CARD', 'SUCCESS', 120.50, '2026-01-15 10:05:00'),
(2, 2, 'PAYPAL', 'SUCCESS', 75.00, '2026-02-01 16:50:00'),
(3, 3, 'CARD', 'SUCCESS', 250.00, '2026-02-07 12:30:00'),
(4, 4, 'CARD', 'REFUNDED', 60.00, '2026-02-10 09:15:00'),
(5, 5, 'BANK_TRANSFER', 'PENDING', 35.99, NULL),
(6, 99, 'CARD', 'SUCCESS', 15.00, '2026-04-02 07:45:00'),
(7, 7, 'CARD', 'SUCCESS', 20.00, '2026-04-10 10:20:00'),
(8, 8, 'CARD', 'FAILED', 49.90, NULL);
