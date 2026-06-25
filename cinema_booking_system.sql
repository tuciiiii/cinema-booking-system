CREATE DATABASE cinema_booking_system;
USE cinema_booking_system;

CREATE TABLE Movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    duration_minutes INT NOT NULL,
    release_year INT,
    rating DECIMAL(3,1),

    CHECK (duration_minutes > 0),
    CHECK (rating IS NULL OR (rating >= 0 AND rating <= 10))
);

CREATE TABLE Genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE MovieGenres (
    movie_id INT NOT NULL,
    genre_id INT NOT NULL,

    PRIMARY KEY (movie_id, genre_id),

    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
        ON DELETE CASCADE,

    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
        ON DELETE CASCADE
);

CREATE TABLE Seats (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    row_num INT NOT NULL,
    seat_number INT NOT NULL,

    UNIQUE (row_num, seat_number),

    CHECK (row_num > 0),
    CHECK (seat_number > 0)
);

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(30),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Screenings (
    screening_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),

    UNIQUE (start_time),

    CHECK (ticket_price >= 0)
);

CREATE TABLE Reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    reserved_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED')
        NOT NULL DEFAULT 'PENDING',

    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL,
    screening_id INT NOT NULL,
    seat_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id)
        ON DELETE CASCADE,

    FOREIGN KEY (screening_id) REFERENCES Screenings(screening_id),

    FOREIGN KEY (seat_id) REFERENCES Seats(seat_id),

    UNIQUE (screening_id, seat_id),

    CHECK (price >= 0)
);

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('CARD', 'CASH', 'BANK_TRANSFER') NOT NULL,
    payment_status ENUM('PENDING', 'PAID', 'FAILED', 'REFUNDED')
        NOT NULL DEFAULT 'PENDING',
    paid_at DATETIME,

    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id)
        ON DELETE CASCADE,

    CHECK (amount >= 0)
);


INSERT INTO Movies (title, duration_minutes, release_year, rating) VALUES
('Dune: Part Two', 166, 2024, 8.6),
('The Wild Robot', 102, 2024, 8.4),
('Oppenheimer', 180, 2023, 8.7),
('Inside Out 2', 96, 2024, 7.8),
('The Batman', 176, 2022, 7.9),
('Interstellar', 169, 2014, 8.8),
('Parasite', 132, 2019, 8.5),
('Mission: Impossible - Dead Reckoning', 163, 2023, 7.7),
('Spirited Away', 125, 2001, 8.6);

INSERT INTO Genres (name) VALUES
('Action'),
('Adventure'),
('Drama'),
('Sci-Fi'),
('Animation'),
('Thriller'),
('Comedy');

INSERT INTO MovieGenres (movie_id, genre_id) VALUES
(1, 2), (1, 3), (1, 4),
(2, 2), (2, 5),
(3, 3),
(4, 5), (4, 7),
(5, 1), (5, 6),
(6, 2), (6, 3), (6, 4),
(7, 3), (7, 6),
(8, 1), (8, 2), (8, 6),
(9, 2), (9, 5);

INSERT INTO Seats (row_num, seat_number) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5),
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5),
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5);

INSERT INTO Customers (first_name, last_name, email, phone) VALUES
('Ivan', 'Petrov', 'ivan.petrov@example.com', '0888123456'),
('Maria', 'Ivanova', 'maria.ivanova@example.com', '0888234567'),
('Georgi', 'Dimitrov', 'georgi.dimitrov@example.com', '0888345678'),
('Elena', 'Stoyanova', 'elena.stoyanova@example.com', '0888456789'),
('Nikolay', 'Kolev', 'nikolay.kolev@example.com', '0888567890'),
('Anna', 'Georgieva', 'anna.georgieva@example.com', '0888678901'),
('Martin', 'Todorov', 'martin.todorov@example.com', '0888789012'),
('Sofia', 'Marinova', 'sofia.marinova@example.com', '0888890123'),
('Dimitar', 'Vasilev', 'dimitar.vasilev@example.com', '0888901234'),
('Katerina', 'Popova', 'katerina.popova@example.com', '0888012345');

INSERT INTO Screenings (movie_id, start_time, ticket_price) VALUES
(1, '2026-07-21 18:00:00', 16.50),
(2, '2026-07-21 21:00:00', 12.00),
(3, '2026-07-22 18:00:00', 14.00),
(4, '2026-07-22 21:00:00', 10.00),
(5, '2026-07-23 18:00:00', 16.50),
(6, '2026-07-23 21:00:00', 16.50),
(7, '2026-07-24 18:00:00', 14.00),
(8, '2026-07-24 21:00:00', 14.00);

INSERT INTO Reservations (customer_id, reserved_at, status) VALUES
(1, '2026-07-19 10:15:00', 'CONFIRMED'),
(2, '2026-07-19 11:20:00', 'CONFIRMED'),
(3, '2026-07-20 09:30:00', 'PENDING'),
(4, '2026-07-20 12:45:00', 'CONFIRMED'),
(5, '2026-07-20 14:10:00', 'CONFIRMED'),
(6, '2026-07-21 08:40:00', 'CONFIRMED'),
(1, '2026-07-21 10:00:00', 'CONFIRMED'),
(8, '2026-07-21 11:30:00', 'CANCELLED');

INSERT INTO Tickets (reservation_id, screening_id, seat_id, price) VALUES
(1, 1, 1, 16.50),
(1, 1, 2, 16.50),
(2, 2, 3, 12.00),
(3, 3, 4, 14.00),
(3, 3, 5, 14.00),
(4, 5, 6, 16.50),
(4, 5, 7, 16.50),
(5, 6, 8, 16.50),
(6, 7, 10, 14.00),
(7, 6, 9, 16.50);

INSERT INTO Payments
(reservation_id, amount, payment_method, payment_status, paid_at)
VALUES
(1, 33.00, 'CARD', 'PAID', '2026-07-19 10:16:00'),
(2, 12.00, 'CASH', 'PAID', '2026-07-19 11:25:00'),
(3, 28.00, 'CARD', 'PENDING', NULL),
(4, 33.00, 'BANK_TRANSFER', 'PAID', '2026-07-20 12:50:00'),
(5, 16.50, 'CARD', 'PAID', '2026-07-20 14:15:00'),
(6, 14.00, 'CASH', 'PAID', '2026-07-21 08:45:00'),
(7, 16.50, 'CARD', 'PAID', '2026-07-21 10:05:00');

-- Всички прожекции с филм

SELECT
    s.screening_id,
    m.title,
    s.start_time,
    s.ticket_price
FROM Screenings s
JOIN Movies m ON s.movie_id = m.movie_id
ORDER BY s.start_time;


-- Филми и техните жанрове

SELECT
    m.movie_id,
    m.title,
    GROUP_CONCAT(g.name ORDER BY g.name SEPARATOR ', ') AS genres
FROM Movies m
LEFT JOIN MovieGenres mg ON m.movie_id = mg.movie_id
LEFT JOIN Genres g ON mg.genre_id = g.genre_id
GROUP BY m.movie_id, m.title
ORDER BY m.title;

-- Брой резервирани билети и приходи за всяка прожекция

SELECT
    s.screening_id,
    m.title,
    s.start_time,
    COUNT(t.ticket_id) AS reserved_tickets,
    COALESCE(SUM(t.price), 0) AS total_revenue
FROM Screenings s
JOIN Movies m ON s.movie_id = m.movie_id
LEFT JOIN Tickets t ON s.screening_id = t.screening_id
GROUP BY
    s.screening_id,
    m.title,
    s.start_time
ORDER BY total_revenue DESC;


-- Прожекции без резервирани билети

SELECT
    s.screening_id,
    m.title,
    s.start_time
FROM Screenings s
JOIN Movies m ON s.movie_id = m.movie_id
LEFT JOIN Tickets t ON s.screening_id = t.screening_id
GROUP BY s.screening_id, m.title, s.start_time
HAVING COUNT(t.ticket_id) = 0;

-- Всички клиенти и брой резервации

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.reservation_id) AS total_reservations
FROM Customers c
LEFT JOIN Reservations r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_reservations DESC;


-- Прожекции с повече билети от средното

WITH tickets_per_screening AS (
    SELECT
        s.screening_id,
        m.title,
        COUNT(t.ticket_id) AS total_tickets
    FROM Screenings s
    JOIN Movies m ON s.movie_id = m.movie_id
    LEFT JOIN Tickets t ON s.screening_id = t.screening_id
    GROUP BY s.screening_id, m.title
),
avg_tickets AS (
    SELECT AVG(total_tickets) AS avg_total_tickets
    FROM tickets_per_screening
)
SELECT
    tps.screening_id,
    tps.title,
    tps.total_tickets
FROM tickets_per_screening tps
CROSS JOIN avg_tickets avg_t
WHERE tps.total_tickets > avg_t.avg_total_tickets;