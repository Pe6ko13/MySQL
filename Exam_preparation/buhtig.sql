CREATE TABLE `users` (
    `id` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(30) NOT NULL UNIQUE, 
    `password` VARCHAR(30) NOT NULL,
    `email` VARCHAR(50) NOT NULL
);

CREATE TABLE `repositories` (
  `id` INT(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `repositories_contributors` (
    `repository_id` INT(11) NOT NULL,
    `contributor_id` INT(11) NOT NULL,
    CONSTRAINT `pk_repoContributors`
    PRIMARY KEY (repository_id, contributor_id),
    CONSTRAINT `fk_repoContributors_repo`
    FOREIGN KEY (repository_id) REFERENCES repositories(id),
    CONSTRAINT `fk_repoContributors_contributors`
    FOREIGN KEY (contributor_id) REFERENCES users(id)
);

CREATE TABLE `issues` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `issue_status` varchar(6) NOT NULL,
  `repository_id` int NOT NULL,
  `assignee_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_issues_repo_idx` (`repository_id`),
  KEY `fk_issues_users_idx` (`assignee_id`),
  CONSTRAINT `fk_issues_repo` FOREIGN KEY (`repository_id`) REFERENCES `repositories` (`id`),
  CONSTRAINT `fk_issues_users` FOREIGN KEY (`assignee_id`) REFERENCES `users` (`id`)
);

CREATE TABLE `commits` (
    `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `message` VARCHAR(225) NOT NULL,
    `issue_id` INT(11),
    `repository_id` INT(11) NOT NULL,
    `contributor_id` INT(11) NOT NULL,
     CONSTRAINT `fk_commits_issues` FOREIGN KEY (issue_id) REFERENCES `issues`(id),
     CONSTRAINT `fk_commits_repositories` 
     FOREIGN KEY (repository_id) REFERENCES repositories(id),
     CONSTRAINT `fk_commits_users`
     FOREIGN KEY (contributor_id) REFERENCES users(id)
);

CREATE TABLE `files` (
    `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `size` DECIMAL(10, 2) NOT NULL,
    `parent_id` INT(11),
    `commit_id` INT(11) NOT NULL,
    CONSTRAINT `fk_files_files`
    FOREIGN KEY (parent_id) REFERENCES files(id),
    CONSTRAINT `commit_id`
    FOREIGN KEY (commit_id) REFERENCES commits(id)
);

INSERT INTO issues (`title`, `issue_status`, `repository_id`, `assignee_id`)
SELECT 
        CONCAT('Critical Problem With ', f.name, '!') as `title`,
        'open' AS `issue_status`,
        CEIL((f.id * 2) / 3) AS `repository_id`,
        (SELECT contributor_id FROM commits
            WHERE commits.id = f.commit_id) AS `assignee_id`
FROM files AS f
WHERE f.id BETWEEN 46 AND 50;



UPDATE repositories_contributors AS rc
SET rc.repository_id = 
(SELECT rep.id FROM repositories AS rep
WHERE rep.id NOT IN (SELECT repository_id FROM 
                    (SELECT repository_id FROM repositories_contributors) AS a)
                    ORDER BY rep.id LIMIT 1)
WHERE rc.repository_id = rc.contributor_id;


DELETE FROM repositories r
WHERE ( 
    SELECT COUNT(*) FROM issues i
    WHERE i.repository_id = r.id) = 0;


DELIMITER $$
CREATE PROCEDURE udp_commit(
    username VARCHAR(30),
    password VARCHAR(10),
    message VARCHAR(255),
    issue_id INT
)
BEGIN
    START TRANSACTION;
    IF ((SELECT COUNT(*) FROM users u WHERE u.username = username) = 0)
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No such user!';
        ROLLBACK;
    ELSEIF ((SELECT COUNT(*) FROM users u WHERE u.username = username AND u.password = password) = 0)
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password is incorrect!';
        ROLLBACK;
    ELSEIF ((SELECT COUNT(*) FROM issues i WHERE i.id = issue_id) = 0)
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The issue does not exist!';
        ROLLBACK;
    ELSE
        INSERT INTO commits (`message`, `issue_id`, `repository_id`, `contributor_id`) 
        VALUES(
                message, 
                issue_id, 
                (SELECT repository_id FROM issues i WHERE i.id = issue_id),
                (SELECT id FROM users u WHERE u.username = username)
        );

        UPDATE issues i SET i.issue_status = 'closed'
        WHERE i.id = issue_id;
        COMMIT;
    END IF;
END $$

CALL udp_commit('WhoDenoteBel', 'ajmISQi*', 'Fixed issue: Invalid', 2);


DELIMITER $$

CREATE PROCEDURE udp_findbyextension(extension VARCHAR(50))
BEGIN
    SELECT f.id, f.name AS `caption`, CONCAT(f.size, 'KB') AS `user` FROM files f
    WHERE f.name LIKE CONCAT('%', extension);
END $$

CALL udp_findbyextension('html');