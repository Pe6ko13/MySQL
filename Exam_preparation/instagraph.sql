CREATE TABLE `instagraph`.`pictures` (
`id` INT NOT NULL AUTO_INCREMENT,
`path` VARCHAR(255) NOT NULL,
`size` DECIMAL(10,2) NOT NULL,
PRIMARY KEY (`id`));


CREATE TABLE `instagraph`.`users` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(30) NOT NULL,
    `password` VARCHAR(30) NOT NULL,
    `profile_picture_id` INT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
    INDEX `fk_users_pictures_idx` (`picture_id` ASC) VISIBLE,
    CONSTRAINT `fk_users_pictures`
    FOREIGN KEY (`profile_picture_id`)
    REFERENCES `instagraph`.`pictures` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `instagraph`.`posts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `caption` VARCHAR(255) NOT NULL,
  `user_id` INT NOT NULL,
  `picture_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_posts_users_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_posts_pictures_idx` (`picture_id` ASC) VISIBLE,
  CONSTRAINT `fk_posts_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `instagraph`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_posts_pictures`
    FOREIGN KEY (`picture_id`)
    REFERENCES `instagraph`.`pictures` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE `instagraph`.`comments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `content` VARCHAR(255) NOT NULL,
  `user_id` INT NOT NULL,
  `post_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_comments_users_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_comments_posts_idx` (`post_id` ASC) VISIBLE,
  CONSTRAINT `fk_comments_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `instagraph`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comments_posts`
    FOREIGN KEY (`post_id`)
    REFERENCES `instagraph`.`posts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE `instagraph`.`users_followers` (
  `user_id` INT NOT NULL,
  `follewer_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `follewer_id`),
  INDEX `fk_uf__idx` (`follewer_id` ASC) VISIBLE,
  CONSTRAINT `fk_uf_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `instagraph`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_uf_`
    FOREIGN KEY (`follewer_id`)
    REFERENCES `instagraph`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


INSERT INTO comments (`content`, `user_id`, `post_id`) 
SELECT concat('OMG!' , (SELECT u.username FROM users u WHERE u.id = p.user_id), '!This is so cool!'),
    CEILING((p.id * 3)/2),
    p.id FROM posts p
    WHERE p.id BETWEEN 1 AND 10;


UPDATE users u
SET u.profile_picture_id = (
    CASE 
        WHEN (SELECT COUNT(*)
            FROM users_followers uf
            WHERE uf.user_id = u.id) = 0 
            THEN u.id
        ELSE (SELECT COUNT(*)
            FROM users_followers uf
            WHERE uf.user_id = u.id )
    END
)
WHERE profile_picture_id IS NULL;


DELETE FROM users u
WHERE u.id NOT IN( SELECT `user_id` from users_followers)
AND ( SELECT COUNT(*) from users_followers uf
        WHERE uf.follower_id = u.id) = 0;
