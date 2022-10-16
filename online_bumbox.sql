DROP DATABASE IF EXISTS online_bumbox;
CREATE DATABASE online_bumbox;

use online_bumbox;
-- Создание таблиц
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, 
    firstname VARCHAR(100),
    lastname VARCHAR(100), 
    email VARCHAR(100) UNIQUE,
    password_hash varchar(100),
    phone BIGINT unsigned,
    INDEX users_firstname_lastname_idx(firstname, lastname),
    UNIQUE INDEX email_unique (email),
    UNIQUE INDEX phone_unique (phone)
);

   
DROP TABLE IF EXISTS musics;
CREATE TABLE musics (
	id serial primary key,
	name varchar(100) DEFAULT NULL,
	length_track TIME DEFAULT null,
	album_title VARCHAR(100), 
	rating TINYINT UNSIGNED DEFAULT NULL,
	logo VARCHAR(31) DEFAULT NULL
);	
	
DROP TABLE IF exists singer;	
CREATE TABLE singer (
	id SERIAL PRIMARY KEY,
	singer_firstname_lastname VARCHAR(100) NOT NULL
);

DROP TABLE IF exists singer_musics;	
CREATE TABLE singer_musics (
	music_id BIGINT UNSIGNED NOT NULL,
    singer_id BIGINT UNSIGNED NOT NULL,
	release_at YEAR DEFAULT NULL,
    INDEX fk_singer_music_music_idx (music_id),
    INDEX fk_singer_music_category_idx (singer_id),
    CONSTRAINT fk_singer_musics_music FOREIGN KEY (music_id) REFERENCES musics (id),
    CONSTRAINT fk_singer_musics_singer FOREIGN KEY (singer_id) REFERENCES singer (id),
    PRIMARY KEY (music_id, singer_id)
); 


DROP TABLE IF exists categories;
CREATE TABLE categories (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL unique
);


DROP TABLE IF exists categories_musics;
CREATE TABLE categories_musics (
	music_id BIGINT UNSIGNED NOT NULL,
    category_id BIGINT UNSIGNED NOT NULL,
    INDEX fk_categories_musics_music_idx (music_id),
    INDEX fk_categories_musics_category_idx (category_id),
    CONSTRAINT fk_categories_musics_music FOREIGN KEY (music_id) REFERENCES musics (id),
    CONSTRAINT fk_categories_musics_category FOREIGN KEY (category_id) REFERENCES categories (id),
    PRIMARY KEY (music_id, category_id)
);
    

DROP TABLE IF exists reviews;
CREATE TABLE reviews (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    music_id BIGINT UNSIGNED NOT NULL,
    txt TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX fk_reviews_user_idx (user_id),
    INDEX fk_reviews_music_idx (music_id),
    CONSTRAINT fk_reviews_users_user FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_reviews_musics_book FOREIGN KEY (music_id) REFERENCES musics (id)
);


DROP TABLE IF exists review_likes;
CREATE TABLE review_likes (
	user_id BIGINT UNSIGNED NOT NULL,
    review_id BIGINT UNSIGNED NOT NULL,
    like_type BOOLEAN,
    INDEX fk_likes_users_idx (user_id),
    INDEX fk_likes_reviews_idx (review_id),
    CONSTRAINT fk_likes_users_user FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_likes_reviews_review FOREIGN KEY (review_id) REFERENCES reviews (id),
    PRIMARY KEY (user_id, review_id)
);

DROP TABLE IF exists rating_votes;
CREATE TABLE rating_votes (
	user_id BIGINT UNSIGNED NOT NULL,
	music_id BIGINT UNSIGNED NOT NULL,
	vote TINYINT UNSIGNED NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- возможно пригодится, чтобы давать свежим голосам больший вес
	INDEX fk_votes_singer_idx (user_id),
    INDEX fk_votes_music_idx (music_id),
    CONSTRAINT fk_votes_users_user FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_votes_musics_music FOREIGN KEY (music_id) REFERENCES musics (id),
    PRIMARY KEY (user_id, music_id)
);

DROP TABLE IF exists users_bumbox;
CREATE TABLE users_bumbox (
	user_id BIGINT UNSIGNED NOT NULL,
    music_id BIGINT UNSIGNED NOT NULL,
    INDEX fk_users_bumbox_user_idx (user_id),
    INDEX fk_users_bumbox_music_idx (music_id),
    CONSTRAINT fk_users_bumbox_user FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_users_bumbox_music FOREIGN KEY (music_id) REFERENCES musics (id),
    PRIMARY KEY (user_id, music_id)
);

DROP TABLE IF exists medias;
CREATE TABLE medias (
	music_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	media_type ENUM('MP3', 'CD', 'AAC') NOT NULL,
	INDEX fk_images_musics_music_idx (music_id),
    CONSTRAINT fk_images_musics_music FOREIGN KEY (music_id) REFERENCES musics (id)
);
-- Наполнение таблиц
INSERT INTO singer VALUES
	(1, 'Руки Вверх'),
    (2, 'БИ-2'),
    (3, 'Баста'),
    (4, 'Жан-Мишель Жарр'),
    (5, 'Михаил Круг'),
    (6, 'Ария'),
    (7, 'Дмитрий Цыганов'),
    (8, 'MATRANG'),
    (9, 'Excuse Me'),
    (10, 'Группа DADO'),
    (11, 'Треустье'),
    (12, 'Sanitana'),
    (13, 'Григорий Лепс'),
    (14, 'Макс Корж'),
    (15, 'B.B. King'),
    (16, 'Король и Шут'),
    (17,'Bob Marley'),
    (18, 'Александр Малинин');

INSERT INTO categories VALUES
	(1, 'поп'),
    (2, 'рок'),
    (3, 'рэп'),
    (4, 'электронная'),
    (5, 'шансон'),
    (6, 'металл'),
    (7, 'классика'),
    (8, 'r&b'),
    (9, 'джаз'),
    (10, 'кантри'),
    (11, 'фолк'),
    (12, 'инструментальная'),
    (13, 'эстрадная'),
    (14, 'хип-хоп'),
    (15, 'блюз'),
    (16, 'панк'),
    (17, 'регги'),
    (18, 'романс');
      
INSERT INTO musics(id, name, length_track, album_title, rating)	VALUES
	(1, 'Студент', '00:03:29', 'Дышите равномерно', 9 ),
	(2, 'Полковнику никто не пишет', '00:04:54', 'БИ-2', 3),
	(3, 'Так плачет весна', '00:03:51', 'Баста 1', 11),
	(4, 'Stardust', '00:04:36', 'Planet Jarre', 8),
	(5, 'Владимирский централ', '00:04:28', 'Владимирский централ', 17),
	(6, 'Беспечный ангед', '00:03:58', 'Легенды русского рока: Ария', 6),
	(7, 'Соната ми минор: II. Adagio cantabile', '00:06:15', 'Алябьев: Фортепианное трио ля минор и Соната ми минор', 18),
	(8, 'Медуза', '00:02:43', 'Медуза', 7),
	(9, 'Дышу', '00:03:58', 'Sad Salad', 19),
	(10, 'Pervona', '00:02:56', 'Pervona', 20),
	(11, 'Все мне снились твои глаза', '00:03:03', 'Дымок кадильный', 16),
	(12, 'Now or Never', '00:05:20', 'Greates_thits', 15),
	(13, 'Самый лучший день', '00:04:29', 'Пенсне', 4),
	(14, 'Эндорфин', '00:04:28', 'Жить в кайф', 1),
	(15, 'Messy But Good', '00:02:36', 'The Life Of Riley', 10),
	(16, 'Проклятый старый дом', '00:04:17', 'Как в старой сказке', 2),
	(17, 'No Woman, No Cry', '00:03:36', 'Ya Man!', 14),
	(18, 'Берега', '00:05:06', '50 лучших песен', 13);

INSERT INTO categories_musics VALUES
	(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), 
    (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18);
 
INSERT INTO singer_musics VALUES
	(1, 1, 1997), (2, 2, 2001), (3, 3, 2003), (4, 4, 1997), (5, 5, 1999), (6, 6, 2008), (7, 7, 2011), (8, 8, 2012), (9, 9, 2018), (10, 10, 2004), 
    (11, 11, 2009), (12, 12, 1991), (13, 13, 2015), (14, 14, 2007), (15, 15, 1967), (16, 16, 2004), (17, 17, 1994), (18, 18, 1998);

INSERT INTO medias VALUES
	(1, 'CD'), (2, 'MP3'), (3, 'MP3'), (4, 'CD'), (5, 'CD'), (6, 'AAC'), (7, 'AAC'), (8, 'AAC'), (9, 'AAC'), (10, 'MP3'), 
    (11, 'MP3'), (12, 'CD'), (13, 'AAC'), (14, 'MP3'), (15, 'CD'), (16, 'MP3'), (17, 'CD'), (18, 'CD');
    
INSERT INTO users (id,lastname,firstname,email,phone) VALUES
	(1, 'Максим','Демченко','max_dem@yandex.ru','89131456784'),
	(2, 'Евгения','Морозова','kate_sid@mail.ru','81234567854'),
	(3, 'Дима','Медведев','dimonich@yandex.ru','89057896432'),
	(4, 'Павел','Дуров','vk_ceo@yandex.ru','89056078543'),
	(5, 'Пользователь','Пользователь','bot_5@yandex.ru','89609011075'),
	(6, 'Вареник','Варенников','pelmenchiki@ygmail.ru','89511668456'),
	(7, 'Филип','Киркоров','im_cari@yandex.ru','89077775787'),
    (8, 'Маргарита', 'Симонян', 'shou_tnt@tnt.ru', '88003455698'),
    (9, 'Валерий', 'Мелалзе', 'gde_Vera@yandex.ru', '89995556644'),
    (10, 'Christiano', 'Ronaldo', 'better_messi@gmail.ru', '88553458787'),
    (11, 'Павел', 'Воля', 'shuchu_nepereshuchu@yandex.ru', '89175655445'),
    (12, 'Артем', 'Дзюба', 'yes_Salamich@mail.ru', '89875861245');
    
INSERT INTO rating_votes (user_id, music_id, vote) VALUES
	(1,3,10), (1,2,7), (1,8,2), (1,9,6), (1,4,4),
	(2,1,7), (2,4,6), (2,8,8), (2,11,8), (2,15,3),
	(3,2,8), (3,3,6), (3,7,10), (3,9,6), (3,6,3),
	(4,7,8), (4,10,6), (4,12,8), (4,17,9), (4,18,7),
	(5,4,6), (5,5,9), (5,9,4), (5,13,7), (5,17,7),
	(6,5,8), (6,8,6), (6,14,7), (6,15,8), (6,18,4),
	(7,1,8), (7,6,8), (7,7,6), (7,10,7), (7,15,10),
    (8,4,8), (8,6,8), (8,12,6), (8,13,7), (8,16,10),
    (9,5,8), (9,7,8), (9,8,6), (9,14,7), (9,16,10),
	(10,6,8), (10,8,4), (10,12,6), (10,16,7), (10,18,9),
	(11,7,9), (11,9,8), (11,12,6), (11,13,5), (11,16,10),
	(12,8,8), (12,10,8), (12,11,6), (12,15,7), (12,16,10);
    
INSERT INTO users_bumbox values
	(1,3), (1,7), (1,9), (1,16), (2,18),
	(2,1), (2,5), (2,8), (2,11), (2,17),
	(3,2), (3,6), (3,7), (3,9), (3,10),
	(4,4), (4,5), (4,8), (4,12), (4,13),
	(5,2), (5,6), (5,11), (5,17), (5,18),
	(6,5), (6,7), (6,10), (6,13), (6,14),
	(7,1), (7,7), (7,14), (7,15), (7,17),
    (8,3), (8,5), (8,9), (8,12), (8,18),
    (9,2), (9,4), (9,8), (9,15), (9,17),
    (10,6), (10,9), (10,11), (10,15), (10,17),
    (11,1), (11,8), (11,9), (11,16), (11,18),
    (12,2), (12,5), (12,7), (12,10), (12,16);
    
INSERT INTO reviews (user_id, music_id, txt) VALUES
	(1,5,'Ничего лучше не слушал'),
	(2,8,'Оч понравилось произведение'),
	(3,5,'Мурашки по коже, Wow'),
	(3,10,'Что это было?, вообще не зашло'),
	(4,2,'Мне одному не понравилась'),
	(4,4,'Автору следовало бы лучше над текстом поработать'),
	(5,1,'Восхитительный'),
	(5,2,'Замысел хороший, реализация подкачала'),
	(6,7,'Этот парень умеет петь?'),
	(7,2,'супер, слушаю целый день'),
	(7,5,'Пока - мой топ 1'),
	(7,7,'вообще не понравилось'),
    (7,2,'супер, слушаю целый день'),
	(8,9,'давайте его на новогодний огонек'),
    (8,15,'это мой любимый певец!'),
	(9,16,'круто, круто, круто'),
    (10,11,'супер, слушаю целый день'),
	(10,12,'Эта песня точно порвет чарты'),
    (11,3,'хочу спеть эту песню в караоке'),
	(11,18,'талантище'),
    (12,10,'ла-ла-ла, песня поднимает настроение'),
	(12,13,'топ, лучше не бывает');    
    
INSERT INTO review_likes VALUES
	(1,4,true), (2,6,false),(2,1,true), (2,3,true), (2,10,true), (3,3,true), (3,5,true), (4,2,false), (4,8,true), 
    (5,2,false), (5,7,true), (5,9,false), (5,10,true), (6,10,true), (7,6,true), (7,9,true), (8,10,false), (8,11,true), 
    (8,15,false), (9,12,true), (9,13,true), (9,15,true), (9,17,true), (10,10,false), (10,14,true), (10,15,false), (10,17,true), 
    (11,8,true), (11,11,true), (11,15,true), (11,16,false), (12,7,true), (12,12,false), (12,14,true), (12,16,true), (12,18,true);

-- Запросы
CREATE OR REPLACE VIEW music_table AS
SELECT
	musics.name,
	(SELECT singer_firstname_lastname FROM singer WHERE id = pg.singer_id) AS singer,
	release_at,
	length_track,
	musics.album_title,
	rating / 10 AS rating
FROM musics JOIN singer_musics AS pg ON musics.id = pg.music_id;

CREATE OR REPLACE VIEW rating_table AS
SELECT
	musics.name,
	rating / 10 AS rating,
	vote,
	(select firstname FROM users WHERE user_id = id) AS user
FROM rating_votes JOIN musics ON music_id = id ORDER BY name,vote;  
   
SELECT * FROM music_table;
SELECT * FROM rating_table;

-- Функции и тригеры
DROP TRIGGER IF EXISTS rating_votes_check;
DROP FUNCTION IF EXISTS get_rating;
DROP TRIGGER IF EXISTS do_vote;

DELIMITER //

/*ограничение голосования (допустимые значения 1..10)*/
CREATE TRIGGER rating_vote_check BEFORE INSERT ON rating_votes
FOR EACH ROW
BEGIN
	IF NEW.vote NOT IN (1,2,3,4,5,6,7,8,9,10) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'Insert Canceled. Vote может принимать значения от 1 до 10';
	END IF;
END //

/*подсчет рейтинга*/
CREATE FUNCTION get_rating (id BIGINT)
RETURNS INT READS SQL DATA
BEGIN
	RETURN (SELECT ROUND(AVG(vote) * 10) FROM rating_votes WHERE book_id = id);
END //

/*проголосовать*/
CREATE TRIGGER do_vote AFTER INSERT ON rating_votes
FOR EACH ROW 
BEGIN
	UPDATE books SET rating = get_rating(NEW.book_id) WHERE id = NEW.book_id;
END

DELIMITER ;
