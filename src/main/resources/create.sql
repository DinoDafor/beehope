DROP TABLE IF EXISTS requests;
create table requests
(   id int primary key AUTO_INCREMENT,
    name        char(50) NOT NULL,
    description char(50),
    coordinates char(50) NOT NULL,
    status char(50) NOT NULL,
    image char(50)
);
-- user table
INSERT INTO requests (name, description, coordinates, status, image) VALUES
('Cat', 'Poor cat...','40.52 52.44', 'in progress', 'fox.png');