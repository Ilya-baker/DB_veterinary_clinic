DROP DATABASE IF EXISTS `veterinary_clinic`;
CREATE DATABASE IF NOT EXISTS `veterinary_clinic` DEFAULT CHARACTER SET utf8 ;
USE `veterinary_clinic`;

DROP TABLE IF EXISTS `owner`;
CREATE TABLE IF NOT EXISTS `owner` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  -- INT(10) - числовой тип данных, миксимальной длинны в 10 символов.
  -- UNSIGNED - поле не может быть отрицательным числом.
  -- NOT NULL - поле обязательное для заполнения, оно не может быть пустым.
  -- NULL - поле не обязательное для заполнения. 
  -- AUTO_INCREMENT - автоматически подставлять значение в поле. Т.е берёт предыдущее значение и добавляет 1. 
  `lastname` VARCHAR(255) NOT NULL COMMENT 'фамилия',
  `firstname` VARCHAR(255) NOT NULL COMMENT 'имя',
  `patronymic` VARCHAR(255) NOT NULL COMMENT 'отчество', 
  `gender` VARCHAR(10) NOT NULL COMMENT 'пол: муж, жен',
  `birthday` DATE NOT NULL COMMENT 'день рождения', 
  -- DATE - формат YYYY-MM-DD.
  `address` VARCHAR(255) NULL DEFAULT NULL COMMENT 'адрес',
  `phone` BIGINT(11) UNSIGNED NULL DEFAULT NULL COMMENT 'телефон',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время регистрации клиента',
  -- DATETIME - формат YYYY-MM-DD HH:MI:SS.
  -- DEFAULT NOW() - автоматически подставится значение NOW() (текущее время и дата создания). 
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  -- PRIMARY KEY - поле "id" становится первичным ключом.
  INDEX `lastname_firstname_patronymic_idx` (`lastname` ASC, `firstname` ASC, `patronymic` ASC) INVISIBLE)
  -- INDEX - Индекс ускоряет извлечение данных из таблиц. Ведь если нет индекса, то БД будет перебирать все имена в таблице и сравнивать их с запросом. Индекс создаётся для одного или нескольких столбцов. 
  -- INVISIBLE - невидимый индекс.
ENGINE = InnoDB
-- ENGINE - при создании таблицы будет использован движок InnoDB.
DEFAULT CHARACTER SET = utf8
-- CHARACTER SET - при создании таблицы будет использован использована кодировка utf8.
	-- Кодировка utf8nb4 utf8nb4_general_ci позволяет вставлять смайлики в текст (просто utf8 не позволяет. Ибо в ней 3 бита, а не 4).
COMMENT = 'Владелец животного ';

DROP TABLE IF EXISTS `animal`;
CREATE TABLE IF NOT EXISTS `animal` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `owner_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'кличка животного',
  `kind` VARCHAR(255) NOT NULL COMMENT 'вид',
  `breed` VARCHAR(50) NOT NULL COMMENT 'порода',
  `gender` VARCHAR(10) NOT NULL COMMENT 'пол: самец, самка',
  -- TINYINT(1) - числовой тип данный который занимает очень мало памяти, длинной в 1 символ.
  -- DEFAULT 0 - поле по умолчанию будет заполнено 0, но его можно изменить.
  `birthday` DATE NOT NULL COMMENT 'дата рождения',
  `castration` VARCHAR(10) NOT NULL COMMENT 'кастрация: стер, не стер',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время регистрации питомца',
  `end` DATE NULL DEFAULT NULL COMMENT 'дата смерти',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `owner_idx` (`owner_id` ASC) VISIBLE,
  -- VISIBLE - невидимый индекс.
  CONSTRAINT `fk_animal_owner`
  -- CONSTRAINT - с помощью этого оператора можно задать имя для ограничения внешнего ключа.
    FOREIGN KEY (`owner_id`)
    -- FOREIGN KEY - внешний ключ.
    REFERENCES `veterinary_clinic`.`owner` (`id`)
    -- REFERENCES (отсылка) - связывает таб 'amimal' c таб 'owner' по внешнему ключу. 
    ON DELETE NO ACTION
    -- ON DELETE - с помощью этого выражения можно установить действия, которые выполняться при УДАЛЕНИИ связанной строки в главной таблице 'owner'.
		-- RESTRICT - при попытке удаления из 'owner', при наличии связанных записей в 'animal' будет выдана ошибка. Т.е нельзя удалить владельца животного, пока не удалишь всех животных принадлежащих ему. 
		-- CASCADE - автоматически удаляет или изменяет строки из `animal` при удалении или изменении связанных строк в 'owner'. Т.е при удалении владельца удаляются и все животные принадлежащие ему.
		-- SET NULL - при удалении связанной строки из 'owner' устанавливает для столбца внешнего ключа значение NULL. Т.е при удалении владельца, у животного в id владельца установится значение NULL.
		-- NO ACTION - предотвращает какие-либо действия в зависимой таблице `animal` при удалении связанных строк в главной таблице 'owner'. Т.е  в id владельца остаётся то значение которое было изначально.
		-- SET DEFAULT - при удалении связанной строки из 'owner' устанавливает для столбца внешнего ключа значение по умолчанию, которое задается с помощью DEFAULT. Если для столбца не задано значение по умолчанию, то в качестве него поставится NULL.
    ON UPDATE NO ACTION)
    -- ON UPDATE - с помощью этого выражения можно установить действия, которые выполняться при ИЗМЕНЕНИИ связанной строки в главной таблице 'owner'.
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'животное';

DROP TABLE IF EXISTS `diagnos`;
CREATE TABLE IF NOT EXISTS `diagnos` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'название диагноза',
  `anamnesis` TEXT NULL DEFAULT NULL COMMENT 'данные о самочувствии  животного за последнее время',
  `inspection` TEXT NULL DEFAULT NULL COMMENT 'результат осмотра',
  `created_at` DATETIME DEFAULT NOW() COMMENT 'дата и время обращения',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_diagnos_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `veterinary_clinic`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'терапевтический приём';

DROP TABLE IF EXISTS `therapy`;
CREATE TABLE IF NOT EXISTS `therapy` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'название услуги',
  `price` INT(10) UNSIGNED NOT NULL COMMENT 'цена услуги',
  `anamnesis` TEXT DEFAULT NULL COMMENT 'данные о самочувсивии животного за последнее время',
  `exam` TEXT DEFAULT NULL COMMENT 'описание осморта',
  `treatment` TEXT DEFAULT NULL COMMENT 'назначение лечения',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время проведения осмотра',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_therapy_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `veterinary_clinic`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'терапия';

DROP TABLE IF EXISTS `surgery`;
CREATE TABLE IF NOT EXISTS `surgery` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'название услуги',
  `price` INT(10) UNSIGNED NOT NULL COMMENT 'цена услуги',
  `anamnesis` TEXT DEFAULT NULL COMMENT 'данные о самочувсивии животного за последнее время',
  `work` TEXT DEFAULT NULL COMMENT 'описание проведённой операции',
  `treatment` TEXT DEFAULT NULL COMMENT 'назначение послеоперационного лечения',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время проведения операции',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_surgery_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `veterinary_clinic`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'хирургия';

DROP TABLE IF EXISTS `procedures`;
CREATE TABLE IF NOT EXISTS `procedures` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL COMMENT 'название процедуры',
  `price` INT(10) UNSIGNED NOT NULL COMMENT 'цена услуги',
  `description` TEXT NULL DEFAULT NULL COMMENT 'описание манипуляции, препаратов и их дозировки',
  `status` TEXT NULL DEFAULT NULL COMMENT 'описание состояния пациента',
  `created_at` DATETIME DEFAULT NOW() COMMENT 'дата и время обращения',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_procedures_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `veterinary_clinic`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'выполнение процедур по назначению из текущей клиники или из сторонней клиники ';

DROP TABLE IF EXISTS `ultrasound`;
CREATE TABLE IF NOT EXISTS `ultrasound` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'название исследования',
  `price` INT(10) UNSIGNED NOT NULL COMMENT 'цена услуги',
  `description` TEXT NULL DEFAULT NULL COMMENT 'описание УЗИ',
  `result` TEXT NULL DEFAULT NULL COMMENT 'заключение по УЗИ',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время проведения уз-исследования',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_ultrasound_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `veterinary_clinic`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'УЗИ';

DROP TABLE IF EXISTS `roentgen`;
CREATE TABLE IF NOT EXISTS `roentgen` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'название исследования',
  `price` INT(10) UNSIGNED NOT NULL COMMENT 'цена услуги',
  `description` TEXT NULL DEFAULT NULL COMMENT 'описание рентгеновского снимка',
  `result` TEXT NULL DEFAULT NULL COMMENT 'заключение по рентгеновскому снимку',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время рентгеновского снимка',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_roentgen_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `veterinary_clinic`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'рентген';

DROP TABLE IF EXISTS `laboratory`;
CREATE TABLE IF NOT EXISTS `laboratory` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'название исследования',
  `price` INT(10) UNSIGNED NOT NULL COMMENT 'цена услуги',
  `result` TEXT NULL DEFAULT NULL COMMENT 'результаты исследования',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время проведения исследования',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_laboratory_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `veterinary_clinic`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'лабораторные исследования';

DROP TABLE IF EXISTS `zoosalon`;
CREATE TABLE IF NOT EXISTS `zoosalon` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'название услуги',
  `price` INT(10) UNSIGNED NOT NULL COMMENT 'цена услуги',
  `description` VARCHAR(255) NULL DEFAULT NULL COMMENT 'описание выполненой услуги',
  `created_at` DATETIME DEFAULT NOW() COMMENT 'дата и время обращения',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_zoosalon_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `veterinary_clinic`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'зоосалон';

DROP TABLE IF EXISTS `media_types`;
CREATE TABLE IF NOT EXISTS `media_types` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL COMMENT 'название',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время создания',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'типы медиа файла ';

DROP TABLE IF EXISTS `media`;
CREATE TABLE IF NOT EXISTS `media` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `media_types_id` INT(10) UNSIGNED NOT NULL,
  `diagnos_id` INT(10) UNSIGNED NOT NULL,
  `therapy_id` INT(10) UNSIGNED NOT NULL,
  `surgery_id` INT(10) UNSIGNED NOT NULL,
  `procedures_id` INT(10) UNSIGNED NOT NULL,
  `ultrasound_id` INT(10) UNSIGNED NOT NULL,
  `roentgen_id` INT(10) UNSIGNED NOT NULL,
  `laboratory_id` INT(10) UNSIGNED NOT NULL,
  `zoosalon_id` INT(10) UNSIGNED NOT NULL,
  `blob` BLOB NOT NULL,
  `size` INT(10) UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `metadata` JSON NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `media_types_idx` (`media_types_id` ASC) VISIBLE,
  INDEX `diagnos_idx` (`diagnos_id` ASC) VISIBLE,
  INDEX `therapy_idx` (`diagnos_id` ASC) VISIBLE,
  INDEX `surgery_idx` (`diagnos_id` ASC) VISIBLE,
  INDEX `procedures_idx` (`diagnos_id` ASC) VISIBLE,
  INDEX `ultrasound_idx` (`diagnos_id` ASC) VISIBLE,
  INDEX `roentgen_idx` (`diagnos_id` ASC) VISIBLE,
  INDEX `laboratory_idx` (`diagnos_id` ASC) VISIBLE,
  INDEX `zoosalon_idx` (`diagnos_id` ASC) VISIBLE,
  CONSTRAINT `fk_media_media_types`
    FOREIGN KEY (`media_types_id`)
    REFERENCES `veterinary_clinic`.`media_types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_diagnos`
    FOREIGN KEY (`diagnos_id`)
    REFERENCES `veterinary_clinic`.`diagnos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_therapy`
    FOREIGN KEY (`therapy_id`)
    REFERENCES `veterinary_clinic`.`therapy` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_surgery`
    FOREIGN KEY (`surgery_id`)
    REFERENCES `veterinary_clinic`.`surgery` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_procedures`
    FOREIGN KEY (`procedures_id`)
    REFERENCES `veterinary_clinic`.`procedures` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_ultrasound`
    FOREIGN KEY (`ultrasound_id`)
    REFERENCES `veterinary_clinic`.`ultrasound` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_roentgen`
    FOREIGN KEY (`roentgen_id`)
    REFERENCES `veterinary_clinic`.`roentgen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_laboratory`
    FOREIGN KEY (`laboratory_id`)
    REFERENCES `veterinary_clinic`.`laboratory` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_zoosalon`
    FOREIGN KEY (`zoosalon_id`)
    REFERENCES `veterinary_clinic`.`zoosalon` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'медиа файлы';

 


