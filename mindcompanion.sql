-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema mindcompanion_notes
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mindcompanion_notes
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mindcompanion_notes` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
-- -----------------------------------------------------
-- Schema mindcompanion
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mindcompanion
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mindcompanion` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `mindcompanion_notes` ;

-- -----------------------------------------------------
-- Table `mindcompanion_notes`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion_notes`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username` (`username` ASC) VISIBLE,
  UNIQUE INDEX `email` (`email` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `mindcompanion_notes`.`emotion_entries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion_notes`.`emotion_entries` (
  `id` BIGINT NOT NULL,
  `user_id` INT NULL DEFAULT '1',
  `date` VARCHAR(20) NOT NULL,
  `datetime` TIMESTAMP NOT NULL,
  `emotion` TINYINT NOT NULL,
  `energy` TINYINT NOT NULL,
  `notes` TEXT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_user_date` (`user_id` ASC, `date` ASC) VISIBLE,
  INDEX `idx_emotion` (`emotion` ASC) VISIBLE,
  INDEX `idx_energy` (`energy` ASC) VISIBLE,
  INDEX `idx_datetime` (`datetime` ASC) VISIBLE,
  CONSTRAINT `emotion_entries_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mindcompanion_notes`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `mindcompanion_notes`.`entry_search`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion_notes`.`entry_search` (
  `entry_id` BIGINT NOT NULL,
  `user_id` INT NOT NULL,
  `searchable_text` TEXT NOT NULL,
  PRIMARY KEY (`entry_id`),
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  FULLTEXT INDEX `idx_search` (`searchable_text`) VISIBLE,
  CONSTRAINT `entry_search_ibfk_1`
    FOREIGN KEY (`entry_id`)
    REFERENCES `mindcompanion_notes`.`emotion_entries` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `entry_search_ibfk_2`
    FOREIGN KEY (`user_id`)
    REFERENCES `mindcompanion_notes`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

USE `mindcompanion` ;

-- -----------------------------------------------------
-- Table `mindcompanion`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `full_name` VARCHAR(100) NULL DEFAULT NULL,
  `avatar_url` VARCHAR(255) NULL DEFAULT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  `date_of_birth` DATE NULL DEFAULT NULL,
  `gender` ENUM('male', 'female', 'other') NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` TIMESTAMP NULL DEFAULT NULL,
  `is_active` TINYINT(1) NULL DEFAULT '1',
  `email_verified` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username` (`username` ASC) VISIBLE,
  UNIQUE INDEX `email` (`email` ASC) VISIBLE,
  INDEX `idx_username` (`username` ASC) VISIBLE,
  INDEX `idx_email` (`email` ASC) VISIBLE,
  INDEX `idx_active` (`is_active` ASC) VISIBLE,
  INDEX `idx_last_login` (`last_login` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `mindcompanion`.`chat_sessions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion`.`chat_sessions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `session_title` VARCHAR(200) NULL DEFAULT NULL,
  `session_start` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `session_end` TIMESTAMP NULL DEFAULT NULL,
  `session_duration` INT NULL DEFAULT NULL,
  `overall_sentiment` ENUM('positive', 'neutral', 'negative') NULL DEFAULT NULL,
  `is_active` TINYINT(1) NULL DEFAULT '1',
  `chat_type` ENUM('support', 'advice', 'casual', 'crisis') NULL DEFAULT 'support',
  PRIMARY KEY (`id`),
  INDEX `idx_user_sessions` (`user_id` ASC, `session_start` ASC) VISIBLE,
  INDEX `idx_chat_type` (`chat_type` ASC) VISIBLE,
  INDEX `idx_sentiment` (`overall_sentiment` ASC) VISIBLE,
  INDEX `idx_chat_user_type_time` (`user_id` ASC, `chat_type` ASC, `session_start` ASC) VISIBLE,
  CONSTRAINT `chat_sessions_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mindcompanion`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `mindcompanion`.`chat_messages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion`.`chat_messages` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `session_id` INT NOT NULL,
  `message_text` TEXT NOT NULL,
  `is_user_message` TINYINT(1) NOT NULL,
  `sentiment_score` DECIMAL(3,2) NULL DEFAULT NULL,
  `emotion_detected` ENUM('joy', 'sadness', 'anger', 'fear', 'surprise', 'neutral') NULL DEFAULT NULL,
  `bot_response_type` ENUM('empathy', 'advice', 'question', 'encouragement') NULL DEFAULT NULL,
  `timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_session_time` (`session_id` ASC, `timestamp` ASC) VISIBLE,
  INDEX `idx_sentiment` (`sentiment_score` ASC) VISIBLE,
  INDEX `idx_emotion` (`emotion_detected` ASC) VISIBLE,
  CONSTRAINT `chat_messages_ibfk_1`
    FOREIGN KEY (`session_id`)
    REFERENCES `mindcompanion`.`chat_sessions` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `mindcompanion`.`emotion_entries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion`.`emotion_entries` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `entry_date` DATE NOT NULL,
  `entry_datetime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `emotion_level` TINYINT NOT NULL,
  `energy_level` TINYINT NOT NULL,
  `notes` TEXT NULL DEFAULT NULL,
  `mood_tags` JSON NULL DEFAULT NULL,
  `weather` VARCHAR(50) NULL DEFAULT NULL,
  `sleep_hours` DECIMAL(3,1) NULL DEFAULT NULL,
  `exercise_minutes` INT NULL DEFAULT NULL,
  `stress_level` TINYINT NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `unique_user_daily_entry` (`user_id` ASC, `entry_date` ASC) VISIBLE,
  INDEX `idx_user_date` (`user_id` ASC, `entry_date` ASC) VISIBLE,
  INDEX `idx_emotion` (`emotion_level` ASC) VISIBLE,
  INDEX `idx_energy` (`energy_level` ASC) VISIBLE,
  INDEX `idx_stress` (`stress_level` ASC) VISIBLE,
  INDEX `idx_datetime` (`entry_datetime` ASC) VISIBLE,
  INDEX `idx_user_emotion_date` (`user_id` ASC, `emotion_level` ASC, `entry_date` ASC) VISIBLE,
  INDEX `idx_user_energy_date` (`user_id` ASC, `energy_level` ASC, `entry_date` ASC) VISIBLE,
  CONSTRAINT `emotion_entries_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mindcompanion`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `mindcompanion`.`goals`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion`.`goals` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `goal_type` ENUM('emotion', 'energy', 'habit', 'wellness') NULL DEFAULT 'emotion',
  `target_emotion` TINYINT NULL DEFAULT NULL,
  `target_energy` TINYINT NULL DEFAULT NULL,
  `target_frequency` ENUM('daily', 'weekly', 'monthly') NULL DEFAULT 'daily',
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL DEFAULT NULL,
  `is_completed` TINYINT(1) NULL DEFAULT '0',
  `completion_date` TIMESTAMP NULL DEFAULT NULL,
  `priority` ENUM('low', 'medium', 'high') NULL DEFAULT 'medium',
  `reminder_enabled` TINYINT(1) NULL DEFAULT '1',
  `reminder_time` TIME NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_user_goals` (`user_id` ASC, `is_completed` ASC) VISIBLE,
  INDEX `idx_goal_type` (`goal_type` ASC) VISIBLE,
  INDEX `idx_priority` (`priority` ASC) VISIBLE,
  INDEX `idx_dates` (`start_date` ASC, `end_date` ASC) VISIBLE,
  INDEX `idx_goals_user_type_status` (`user_id` ASC, `goal_type` ASC, `is_completed` ASC) VISIBLE,
  CONSTRAINT `goals_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mindcompanion`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `mindcompanion`.`goal_progress`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion`.`goal_progress` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `goal_id` INT NOT NULL,
  `progress_date` DATE NOT NULL,
  `progress_note` TEXT NULL DEFAULT NULL,
  `achievement_level` TINYINT NULL DEFAULT NULL,
  `is_completed` TINYINT(1) NULL DEFAULT '0',
  `completion_percentage` DECIMAL(5,2) NULL DEFAULT '0.00',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `unique_goal_daily_progress` (`goal_id` ASC, `progress_date` ASC) VISIBLE,
  INDEX `idx_goal_date` (`goal_id` ASC, `progress_date` ASC) VISIBLE,
  CONSTRAINT `goal_progress_ibfk_1`
    FOREIGN KEY (`goal_id`)
    REFERENCES `mindcompanion`.`goals` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `mindcompanion`.`login_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion`.`login_history` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `login_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` VARCHAR(45) NULL DEFAULT NULL,
  `user_agent` TEXT NULL DEFAULT NULL,
  `device_type` ENUM('desktop', 'tablet', 'mobile', 'unknown') NULL DEFAULT NULL,
  `browser` VARCHAR(50) NULL DEFAULT NULL,
  `location` VARCHAR(100) NULL DEFAULT NULL,
  `is_successful` TINYINT(1) NULL DEFAULT '1',
  `logout_time` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_user_login` (`user_id` ASC, `login_time` ASC) VISIBLE,
  INDEX `idx_ip` (`ip_address` ASC) VISIBLE,
  INDEX `idx_device` (`device_type` ASC) VISIBLE,
  CONSTRAINT `login_history_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mindcompanion`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `mindcompanion`.`user_settings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion`.`user_settings` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `daily_reminder_enabled` TINYINT(1) NULL DEFAULT '1',
  `reminder_time` TIME NULL DEFAULT '20:00:00',
  `weekly_report_enabled` TINYINT(1) NULL DEFAULT '1',
  `theme_preference` VARCHAR(20) NULL DEFAULT 'light',
  `language` VARCHAR(10) NULL DEFAULT 'vi',
  `privacy_level` TINYINT NULL DEFAULT '1',
  `data_sharing_consent` TINYINT(1) NULL DEFAULT '0',
  `notification_preferences` JSON NULL DEFAULT NULL,
  `timezone` VARCHAR(50) NULL DEFAULT 'Asia/Ho_Chi_Minh',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `unique_user_settings` (`user_id` ASC) VISIBLE,
  CONSTRAINT `user_settings_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mindcompanion`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `mindcompanion`.`user_statistics`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion`.`user_statistics` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `stat_date` DATE NOT NULL,
  `avg_emotion` DECIMAL(3,2) NULL DEFAULT NULL,
  `avg_energy` DECIMAL(3,2) NULL DEFAULT NULL,
  `avg_stress` DECIMAL(3,2) NULL DEFAULT NULL,
  `total_entries` INT NULL DEFAULT '0',
  `streak_days` INT NULL DEFAULT '0',
  `goals_completed` INT NULL DEFAULT '0',
  `chat_sessions_count` INT NULL DEFAULT '0',
  `total_chat_messages` INT NULL DEFAULT '0',
  `mood_variance` DECIMAL(4,2) NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `unique_user_date` (`user_id` ASC, `stat_date` ASC) VISIBLE,
  INDEX `idx_user_stats` (`user_id` ASC, `stat_date` ASC) VISIBLE,
  CONSTRAINT `user_statistics_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mindcompanion`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

USE `mindcompanion_notes` ;

-- -----------------------------------------------------
-- Placeholder table for view `mindcompanion_notes`.`emotion_statistics`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion_notes`.`emotion_statistics` (`user_id` INT, `stat_date` INT, `avg_emotion` INT, `avg_energy` INT, `entries_count` INT, `min_emotion` INT, `max_emotion` INT, `min_energy` INT, `max_energy` INT);

-- -----------------------------------------------------
-- Placeholder table for view `mindcompanion_notes`.`formatted_entries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion_notes`.`formatted_entries` (`id` INT, `date` INT, `datetime` INT, `emotion` INT, `energy` INT, `notes` INT, `emotion_emoji` INT, `energy_label` INT);

-- -----------------------------------------------------
-- procedure SaveEmotionEntry
-- -----------------------------------------------------

DELIMITER $$
USE `mindcompanion_notes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveEmotionEntry`(
    IN p_user_id INT,
    IN p_emotion TINYINT,
    IN p_energy TINYINT,
    IN p_notes TEXT
)
BEGIN
    DECLARE entry_id BIGINT;
    DECLARE entry_date VARCHAR(20);
    DECLARE entry_datetime TIMESTAMP;
    
    -- Tạo ID và datetime như trong JS
    SET entry_id = UNIX_TIMESTAMP(NOW()) * 1000 + MICROSECOND(NOW(6)) DIV 1000;
    SET entry_datetime = NOW();
    SET entry_date = DATE_FORMAT(NOW(), '%d/%m/%Y');
    
    -- Insert vào bảng chính
    INSERT INTO emotion_entries (id, user_id, date, datetime, emotion, energy, notes)
    VALUES (entry_id, p_user_id, entry_date, entry_datetime, p_emotion, p_energy, p_notes);
    
    -- Insert vào bảng search
    INSERT INTO entry_search (entry_id, user_id, searchable_text)
    VALUES (entry_id, p_user_id, CONCAT(p_notes, ' ', entry_date));
    
    SELECT entry_id as new_entry_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SearchEntries
-- -----------------------------------------------------

DELIMITER $$
USE `mindcompanion_notes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchEntries`(
    IN p_user_id INT,
    IN p_search_term VARCHAR(255)
)
BEGIN
    IF p_search_term IS NULL OR p_search_term = '' THEN
        -- Trả về tất cả entries
        SELECT * FROM formatted_entries WHERE user_id = p_user_id;
    ELSE
        -- Search trong notes và date
        SELECT fe.* 
        FROM formatted_entries fe
        JOIN entry_search es ON fe.id = es.entry_id
        WHERE fe.user_id = p_user_id 
        AND (
            LOWER(fe.notes) LIKE CONCAT('%', LOWER(p_search_term), '%')
            OR fe.date LIKE CONCAT('%', p_search_term, '%')
        );
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `mindcompanion_notes`.`emotion_statistics`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mindcompanion_notes`.`emotion_statistics`;
USE `mindcompanion_notes`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `mindcompanion_notes`.`emotion_statistics` AS select `mindcompanion_notes`.`emotion_entries`.`user_id` AS `user_id`,cast(`mindcompanion_notes`.`emotion_entries`.`datetime` as date) AS `stat_date`,avg(`mindcompanion_notes`.`emotion_entries`.`emotion`) AS `avg_emotion`,avg(`mindcompanion_notes`.`emotion_entries`.`energy`) AS `avg_energy`,count(0) AS `entries_count`,min(`mindcompanion_notes`.`emotion_entries`.`emotion`) AS `min_emotion`,max(`mindcompanion_notes`.`emotion_entries`.`emotion`) AS `max_emotion`,min(`mindcompanion_notes`.`emotion_entries`.`energy`) AS `min_energy`,max(`mindcompanion_notes`.`emotion_entries`.`energy`) AS `max_energy` from `mindcompanion_notes`.`emotion_entries` group by `mindcompanion_notes`.`emotion_entries`.`user_id`,cast(`mindcompanion_notes`.`emotion_entries`.`datetime` as date) order by `stat_date` desc;

-- -----------------------------------------------------
-- View `mindcompanion_notes`.`formatted_entries`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mindcompanion_notes`.`formatted_entries`;
USE `mindcompanion_notes`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `mindcompanion_notes`.`formatted_entries` AS select `e`.`id` AS `id`,`e`.`date` AS `date`,`e`.`datetime` AS `datetime`,`e`.`emotion` AS `emotion`,`e`.`energy` AS `energy`,`e`.`notes` AS `notes`,(case `e`.`emotion` when 1 then '😔' when 2 then '😕' when 3 then '😐' when 4 then '😊' when 5 then '😄' end) AS `emotion_emoji`,(case `e`.`energy` when 1 then 'Rất thấp' when 2 then 'Thấp' when 3 then 'Trung bình' when 4 then 'Cao' when 5 then 'Rất cao' end) AS `energy_label` from `mindcompanion_notes`.`emotion_entries` `e` order by `e`.`datetime` desc;
USE `mindcompanion` ;

-- -----------------------------------------------------
-- Placeholder table for view `mindcompanion`.`database_health`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion`.`database_health` (`table_name` INT, `total_records` INT, `active_records` INT);

-- -----------------------------------------------------
-- Placeholder table for view `mindcompanion`.`emotion_trends_30d`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion`.`emotion_trends_30d` (`user_id` INT, `entry_date` INT, `daily_avg_emotion` INT, `daily_avg_energy` INT, `daily_avg_stress` INT, `entries_count` INT);

-- -----------------------------------------------------
-- Placeholder table for view `mindcompanion`.`monthly_statistics`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion`.`monthly_statistics` (`user_id` INT, `year` INT, `month` INT, `total_entries` INT, `avg_emotion` INT, `avg_energy` INT, `avg_stress` INT, `min_emotion` INT, `max_emotion` INT, `emotion_variance` INT);

-- -----------------------------------------------------
-- Placeholder table for view `mindcompanion`.`user_summary`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mindcompanion`.`user_summary` (`id` INT, `username` INT, `full_name` INT, `email` INT, `joined_date` INT, `last_login` INT, `total_entries` INT, `total_goals` INT, `total_chat_sessions` INT, `avg_emotion` INT, `avg_energy` INT, `last_entry_date` INT, `days_since_last_entry` INT);

-- -----------------------------------------------------
-- function CalculateMoodScore
-- -----------------------------------------------------

DELIMITER $$
USE `mindcompanion`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `CalculateMoodScore`(emotion INT, energy INT, stress INT) RETURNS decimal(3,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE mood_score DECIMAL(3,2);
    SET mood_score = ((emotion + energy + (6 - stress)) / 3);
    RETURN mood_score;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CalculateUserStreak
-- -----------------------------------------------------

DELIMITER $$
USE `mindcompanion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateUserStreak`(IN user_id_param INT)
BEGIN
    DECLARE streak_count INT DEFAULT 0;
    DECLARE check_date DATE DEFAULT CURDATE();
    DECLARE entry_exists INT;
    
    streak_loop: WHILE check_date >= DATE_SUB(CURDATE(), INTERVAL 365 DAY) DO
        SELECT COUNT(*) INTO entry_exists 
        FROM emotion_entries 
        WHERE user_id = user_id_param 
        AND entry_date = check_date;
        
        IF entry_exists > 0 THEN
            SET streak_count = streak_count + 1;
            SET check_date = DATE_SUB(check_date, INTERVAL 1 DAY);
        ELSE
            LEAVE streak_loop;
        END IF;
    END WHILE;
    
    SELECT streak_count as current_streak;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SaveEmotionEntry
-- -----------------------------------------------------

DELIMITER $$
USE `mindcompanion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveEmotionEntry`(
    IN p_user_id INT,
    IN p_emotion_level TINYINT,
    IN p_energy_level TINYINT,
    IN p_notes TEXT,
    IN p_stress_level TINYINT,
    IN p_sleep_hours DECIMAL(3,1),
    IN p_exercise_minutes INT
)
BEGIN
    DECLARE entry_date DATE DEFAULT CURDATE();
    DECLARE entry_id BIGINT;
    
    -- Insert hoặc update entry cho ngày hôm nay
    INSERT INTO emotion_entries (
        user_id, entry_date, emotion_level, energy_level, 
        notes, stress_level, sleep_hours, exercise_minutes
    )
    VALUES (
        p_user_id, entry_date, p_emotion_level, p_energy_level,
        p_notes, p_stress_level, p_sleep_hours, p_exercise_minutes
    )
    ON DUPLICATE KEY UPDATE
        emotion_level = p_emotion_level,
        energy_level = p_energy_level,
        notes = p_notes,
        stress_level = p_stress_level,
        sleep_hours = p_sleep_hours,
        exercise_minutes = p_exercise_minutes,
        updated_at = CURRENT_TIMESTAMP;
    
    SET entry_id = LAST_INSERT_ID();
    
    SELECT entry_id as saved_entry_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SearchEntries
-- -----------------------------------------------------

DELIMITER $$
USE `mindcompanion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchEntries`(
    IN p_user_id INT,
    IN p_search_term VARCHAR(255),
    IN p_limit INT 
)
BEGIN
	IF p_limit IS NULL OR p_limit < 1 THEN
        SET p_limit = 50;
    END IF;
    
    IF p_search_term IS NULL OR p_search_term = '' THEN
        SELECT * FROM emotion_entries 
        WHERE user_id = p_user_id 
        ORDER BY entry_date DESC 
        LIMIT p_limit;
    ELSE
        SELECT * FROM emotion_entries 
        WHERE user_id = p_user_id 
        AND (
            LOWER(notes) LIKE CONCAT('%', LOWER(p_search_term), '%')
            OR DATE_FORMAT(entry_date, '%d/%m/%Y') LIKE CONCAT('%', p_search_term, '%')
        )
        ORDER BY entry_date DESC 
        LIMIT p_limit;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `mindcompanion`.`database_health`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mindcompanion`.`database_health`;
USE `mindcompanion`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `mindcompanion`.`database_health` AS select 'users' AS `table_name`,count(0) AS `total_records`,count((case when (`mindcompanion`.`users`.`is_active` = true) then 1 end)) AS `active_records` from `mindcompanion`.`users` union all select 'emotion_entries' AS `emotion_entries`,count(0) AS `COUNT(*)`,count((case when (`mindcompanion`.`emotion_entries`.`entry_date` >= (curdate() - interval 30 day)) then 1 end)) AS `Name_exp_6` from `mindcompanion`.`emotion_entries` union all select 'goals' AS `goals`,count(0) AS `COUNT(*)`,count((case when (`mindcompanion`.`goals`.`is_completed` = false) then 1 end)) AS `COUNT(CASE WHEN is_completed = FALSE THEN 1 END)` from `mindcompanion`.`goals` union all select 'chat_sessions' AS `chat_sessions`,count(0) AS `COUNT(*)`,count((case when (`mindcompanion`.`chat_sessions`.`is_active` = true) then 1 end)) AS `COUNT(CASE WHEN is_active = TRUE THEN 1 END)` from `mindcompanion`.`chat_sessions`;

-- -----------------------------------------------------
-- View `mindcompanion`.`emotion_trends_30d`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mindcompanion`.`emotion_trends_30d`;
USE `mindcompanion`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `mindcompanion`.`emotion_trends_30d` AS select `mindcompanion`.`emotion_entries`.`user_id` AS `user_id`,`mindcompanion`.`emotion_entries`.`entry_date` AS `entry_date`,avg(`mindcompanion`.`emotion_entries`.`emotion_level`) AS `daily_avg_emotion`,avg(`mindcompanion`.`emotion_entries`.`energy_level`) AS `daily_avg_energy`,avg(`mindcompanion`.`emotion_entries`.`stress_level`) AS `daily_avg_stress`,count(0) AS `entries_count` from `mindcompanion`.`emotion_entries` where (`mindcompanion`.`emotion_entries`.`entry_date` >= (curdate() - interval 30 day)) group by `mindcompanion`.`emotion_entries`.`user_id`,`mindcompanion`.`emotion_entries`.`entry_date` order by `mindcompanion`.`emotion_entries`.`user_id`,`mindcompanion`.`emotion_entries`.`entry_date`;

-- -----------------------------------------------------
-- View `mindcompanion`.`monthly_statistics`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mindcompanion`.`monthly_statistics`;
USE `mindcompanion`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `mindcompanion`.`monthly_statistics` AS select `mindcompanion`.`emotion_entries`.`user_id` AS `user_id`,year(`mindcompanion`.`emotion_entries`.`entry_date`) AS `year`,month(`mindcompanion`.`emotion_entries`.`entry_date`) AS `month`,count(0) AS `total_entries`,avg(`mindcompanion`.`emotion_entries`.`emotion_level`) AS `avg_emotion`,avg(`mindcompanion`.`emotion_entries`.`energy_level`) AS `avg_energy`,avg(`mindcompanion`.`emotion_entries`.`stress_level`) AS `avg_stress`,min(`mindcompanion`.`emotion_entries`.`emotion_level`) AS `min_emotion`,max(`mindcompanion`.`emotion_entries`.`emotion_level`) AS `max_emotion`,std(`mindcompanion`.`emotion_entries`.`emotion_level`) AS `emotion_variance` from `mindcompanion`.`emotion_entries` where (`mindcompanion`.`emotion_entries`.`entry_date` >= (curdate() - interval 1 month)) group by `mindcompanion`.`emotion_entries`.`user_id`,year(`mindcompanion`.`emotion_entries`.`entry_date`),month(`mindcompanion`.`emotion_entries`.`entry_date`);

-- -----------------------------------------------------
-- View `mindcompanion`.`user_summary`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mindcompanion`.`user_summary`;
USE `mindcompanion`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `mindcompanion`.`user_summary` AS select `u`.`id` AS `id`,`u`.`username` AS `username`,`u`.`full_name` AS `full_name`,`u`.`email` AS `email`,`u`.`created_at` AS `joined_date`,`u`.`last_login` AS `last_login`,count(distinct `ee`.`id`) AS `total_entries`,count(distinct `g`.`id`) AS `total_goals`,count(distinct `cs`.`id`) AS `total_chat_sessions`,avg(`ee`.`emotion_level`) AS `avg_emotion`,avg(`ee`.`energy_level`) AS `avg_energy`,max(`ee`.`entry_date`) AS `last_entry_date`,(to_days(curdate()) - to_days(max(`ee`.`entry_date`))) AS `days_since_last_entry` from (((`mindcompanion`.`users` `u` left join `mindcompanion`.`emotion_entries` `ee` on((`u`.`id` = `ee`.`user_id`))) left join `mindcompanion`.`goals` `g` on((`u`.`id` = `g`.`user_id`))) left join `mindcompanion`.`chat_sessions` `cs` on((`u`.`id` = `cs`.`user_id`))) where (`u`.`is_active` = true) group by `u`.`id`,`u`.`username`,`u`.`full_name`,`u`.`email`,`u`.`created_at`,`u`.`last_login`;
USE `mindcompanion_notes`;

DELIMITER $$
USE `mindcompanion_notes`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `mindcompanion_notes`.`update_search_on_entry_change`
AFTER UPDATE ON `mindcompanion_notes`.`emotion_entries`
FOR EACH ROW
BEGIN
    UPDATE entry_search 
    SET searchable_text = CONCAT(NEW.notes, ' ', NEW.date)
    WHERE entry_id = NEW.id;
END$$


DELIMITER ;
USE `mindcompanion`;

DELIMITER $$
USE `mindcompanion`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `mindcompanion`.`update_stats_after_entry`
AFTER INSERT ON `mindcompanion`.`emotion_entries`
FOR EACH ROW
BEGIN
    INSERT INTO user_statistics (
        user_id, stat_date, avg_emotion, avg_energy, 
        avg_stress, total_entries
    )
    VALUES (
        NEW.user_id, NEW.entry_date, NEW.emotion_level, 
        NEW.energy_level, NEW.stress_level, 1
    )
    ON DUPLICATE KEY UPDATE
        avg_emotion = (avg_emotion * total_entries + NEW.emotion_level) / (total_entries + 1),
        avg_energy = (avg_energy * total_entries + NEW.energy_level) / (total_entries + 1),
        avg_stress = (avg_stress * total_entries + NEW.stress_level) / (total_entries + 1),
        total_entries = total_entries + 1,
        updated_at = CURRENT_TIMESTAMP;
END$$

USE `mindcompanion`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `mindcompanion`.`update_last_login`
AFTER INSERT ON `mindcompanion`.`login_history`
FOR EACH ROW
BEGIN
    IF NEW.is_successful = TRUE THEN
        UPDATE users 
        SET last_login = NEW.login_time 
        WHERE id = NEW.user_id;
    END IF;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
