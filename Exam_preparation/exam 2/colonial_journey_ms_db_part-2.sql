Section 3.

SELECT id, journey_start, journey_end FROM journeys
WHERE purpose = 'Military'
ORDER BY journey_start;

SELECT sh.name AS `spaceship_name`, sp.name AS `spaceport_name` FROM spaceships sh
JOIN journeys j ON sh.id = j.spaceship_id
JOIN spaceports sp ON j.destination_spaceport_id = sp.id
WHERE sh.light_speed_rate = (SELECT MAX(light_speed_rate) FROM spaceships);


SELECT sh.name, sh.manufacturer FROM spaceships sh
JOIN journeys j ON sh.id = j.spaceship_id
JOIN travel_cards tc ON tc.journey_id = j.id
JOIN  colonists c ON c.id = tc.colonist_id
WHERE tc.job_during_journey = 'Pilot' AND
YEAR(C.birth_date) > YEAR('1989-01-01')
ORDER BY sh.name;

SELECT p.name `planet_name`, sp.name `spaceport_name` FROM planets p
JOIN spaceports sp ON sp.planet_id = p.id
JOIN journeys j ON j.destination_spaceport_id = sp.id
WHERE j.purpose = 'Educational'
ORDER BY spaceport_name DESC;


SELECT p.name `planet_name`, COUNT(j.id) `journeys_count` FROM planets p
JOIN spaceports sp ON sp.planet_id = p.id
JOIN journeys j ON j.destination_spaceport_id = sp.id
GROUP BY planet_name
ORDER BY journeys_count DESC;


SELECT tc.job_during_journey `job_name` FROM travel_cards tc
WHERE tc.journey_id = (
    SELECT j.id FROM journeys j
    ORDER BY DATEDIFF(j.journey_end, j.journey_start) DESC LIMIT 1
)
GROUP BY job_name
ORDER BY COUNT(tc.job_during_journey);


Section 4;


CREATE Function udf_count_colonists_by_destination_planet (planet_name VARCHAR(30))
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE c_count INT;
    SET c_count := (
        SELECT COUNT(c.id) FROM colonists c
        JOIN travel_cards tc ON tc.colonist_id = c.id
        JOIN journeys j ON j.id = tc.journey_id
        JOIN spaceports sp ON sp.id = j.destination_spaceport_id
        JOIN planets p ON p.id = sp.planet_id 
        WHERE p.name = planet_name
    );
    RETURN c_count;
END;

SELECT udf_count_colonists_by_destination_planet ('Otroyphus');

DELIMITER $$
CREATE PROCEDURE udp_modify_spaceship_light_speed_rate(spaceship_name VARCHAR(50), light_speed_rate_increse INT(11))
BEGIN
    START TRANSACTION;
    IF spaceship_name NOT IN (SELECT sh.name FROM spaceships sh)
        THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Spaceship you are trying to modify does not exists.';
        ROLLBACK;
    ELSE
        UPDATE spaceships sh
        SET light_speed_rate = light_speed_rate + light_speed_rate_increse
        WHERE sh.name = spaceship_name;
    END IF;
END $$

DELIMITER ;

CALL udp_modify_spaceship_light_speed_rate ('USS Templar', 5);
SELECT name, light_speed_rate FROM spaceships WHERE name = 'USS Templar';

CALL udp_modify_spaceship_light_speed_rate ('Na Pesho koraba', 1914);
SELECT name, light_speed_rate FROM spacheships WHERE name = 'Na Pesho koraba';
