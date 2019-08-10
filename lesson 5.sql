USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

DROP TABLE IF EXISTS rubrics;
CREATE TABLE rubrics (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела'
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO rubrics VALUES
  (NULL, 'Видеокарты'),
  (NULL, 'Память');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';



INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');
 
USE sample; 
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели из sample';




USE shop;

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';


-- Ответы на задания

-- 1.	В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

USE sample;
START TRANSACTION;

INSERT INTO users (id, name, birthday_at, created_at,updated_at) (SELECT id, name, birthday_at, created_at,updated_at FROM shop.users WHERE id = 1);
DELETE FROM shop.users WHERE id =1;

COMMIT;

-- 2. 	Создайте представление, которое выводит название name товарной позиции из 
-- таблицы products и соответствующее название каталога name из таблицы catalogs.
USE shop;
SELECT p.name, c.name FROM products AS p JOIN catalogs AS c ON p.catalog_id =c.id;

-- 3.	по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные 
-- записи за август 2018 года '2018-08-01', '2018-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, 
-- если дата присутствует в исходном таблице и 0, если она отсутствует.

DELETE FROM users;
INSERT INTO users (name, birthday_at, created_at) VALUES
  ('Геннадий', '1990-10-05','2018-08-01' ),
  ('Наталья', '1984-11-12', '2018-08-04'),
  ('Александр', '1985-05-20', '2018-08-16'),
  ('Петр', '1986-03-14', '2018-07-17'),
  ('Сергей', '1988-02-14', '2018-08-17');


DROP TABLE IF EXISTS tmp1;
CREATE TABLE tmp1 (
  day_ INT UNSIGNED);
 

INSERT INTO tmp1 (SELECT  @curRow := @curRow + 1 AS day_
FROM    mysql.help_topic 
JOIN    (SELECT @curRow := 0) r
WHERE   @curRow<31);

SELECT ALL  users.name, users.birthday_at, users.created_at,  tmp1.day_ day_of_month, IF (MONTH(users.created_at)= 8, 1,0)  cp_num 
FROM tmp1 LEFT JOIN users  ON tmp1.day_ = DAY(users.created_at);

-- 4.	(по желанию) Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

DELETE FROM users;
INSERT INTO users (name, birthday_at, created_at) VALUES
  ('Геннадий', '1990-10-05','2018-08-01' ),
  ('Наталья', '1984-11-12', '2018-08-04'),
  ('Александр', '1985-05-20', '2018-08-16'),
  ('Петр', '1986-03-14', '2018-07-17'),
  ('Сергей', '1988-02-14', '2018-08-17'),
  ('Марина', '1990-11-05','2018-07-01' ),
  ('Елена', '1984-12-12', '2018-04-24'),
  ('Андрей', '1985-05-20', '2018-11-16'),
  ('Фома', '1987-03-14', '2018-07-19'),
  ('Володя', '1989-06-14', '2018-12-18');
 
-- SELECT *  from users ORDER BY created_at DESC;  
 
-- SELECT * FROM users ORDER BY created_at DESC LIMIT 5;

-- SELECT id FROM (SELECT id FROM users ORDER BY created_at DESC LIMIT 5) sub_q;

START TRANSACTION;
DELETE  FROM users  WHERE id NOT IN
(SELECT id FROM (SELECT id FROM users ORDER BY created_at DESC LIMIT 5) sub_q);  -- Зачем нужно оборачивать в подзапрос Я НЕ ПОНЯЛ!!!
COMMIT;

SELECT *  from users  ORDER BY created_at DESC  ;  

-- Тема “Администрирование MySQL” (эта тема изучается по вашему желанию)
-- 1.	Создайте двух пользователей которые имеют доступ к базе данных shop. 
-- Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
-- второму пользователю shop — любые операции в пределах базы данных shop.

CREATE USER 'user1'@'localhost' IDENTIFIED BY 'user1';
CREATE USER 'user2'@'localhost' IDENTIFIED BY 'user2';

GRANT ALL PRIVILEGES ON shop. * TO 'user1'@'localhost';
GRANT  SELECT ON shop. * TO 'user2'@'localhost';

FLUSH PRIVILEGES;


-- 2.	(по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, 
-- содержащие первичный ключ, имя пользователя и его пароль. Создайте представление username таблицы accounts,
-- предоставляющий доступ к столбца id и name. Создайте пользователя user_read, который бы не имел доступа к таблице accounts, 
-- однако, мог бы извлекать записи из представления username.

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  password_ VARCHAR(255)
 ) ;

INSERT INTO accounts (name, password_) VALUES
  ('Геннадий', '111'),
  ('Наталья', '123'),
  ('Александр', '321'),
  ('Сергей', '456'),
  ('Иван', '19980112'),
  ('Мария', '19920829');

SELECT * FROM accounts;

CREATE VIEW username AS SELECT accounts.id, accounts.name FROM accounts;
REVOKE  SELECT ON shop. * FROM 'user2'@'localhost';
GRANT  SELECT ON shop.username TO 'user2'@'localhost';
FLUSH PRIVILEGES;




