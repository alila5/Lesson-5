USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '�������� �������',
  UNIQUE unique_name(name(10))
) COMMENT = '������� ��������-��������';

INSERT INTO catalogs VALUES
  (NULL, '����������'),
  (NULL, '����������� �����'),
  (NULL, '����������'),
  (NULL, '������� �����'),
  (NULL, '����������� ������');

DROP TABLE IF EXISTS rubrics;
CREATE TABLE rubrics (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '�������� �������'
) COMMENT = '������� ��������-��������';

INSERT INTO rubrics VALUES
  (NULL, '����������'),
  (NULL, '������');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��� ����������',
  birthday_at DATE COMMENT '���� ��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '����������';



INSERT INTO users (name, birthday_at) VALUES
  ('��������', '1990-10-05'),
  ('�������', '1984-11-12'),
  ('���������', '1985-05-20'),
  ('������', '1988-02-14'),
  ('����', '1998-01-12'),
  ('�����', '1992-08-29');
 
USE sample; 
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��� ����������',
  birthday_at DATE COMMENT '���� ��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '���������� �� sample';




USE shop;

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��������',
  description TEXT COMMENT '��������',
  price DECIMAL (11,2) COMMENT '����',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = '�������� �������';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 7890.00, 1),
  ('Intel Core i5-7400', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 12700.00, 1),
  ('AMD FX-8320E', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.', 4780.00, 1),
  ('AMD FX-8320', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', '����������� ����� ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', '����������� ����� Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', '����������� ����� MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = '������';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT '���������� ���������� �������� �������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������ ������';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT '�������� ������ �� 0.0 �� 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = '������';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT '����� �������� ������� �� ������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������ �� ������';


-- ������ �� �������

-- 1.	� ���� ������ shop � sample ������������ ���� � �� �� �������, ������� ���� ������. 
-- ����������� ������ id = 1 �� ������� shop.users � ������� sample.users. ����������� ����������.

USE sample;
START TRANSACTION;

INSERT INTO users (id, name, birthday_at, created_at,updated_at) (SELECT id, name, birthday_at, created_at,updated_at FROM shop.users WHERE id = 1);
DELETE FROM shop.users WHERE id =1;

COMMIT;

-- 2. 	�������� �������������, ������� ������� �������� name �������� ������� �� 
-- ������� products � ��������������� �������� �������� name �� ������� catalogs.
USE shop;
SELECT p.name, c.name FROM products AS p JOIN catalogs AS c ON p.catalog_id =c.id;

-- 3.	�� �������) ����� ������� ������� � ����������� ����� created_at. � ��� ��������� ���������� ����������� 
-- ������ �� ������ 2018 ���� '2018-08-01', '2018-08-04', '2018-08-16' � 2018-08-17. 
-- ��������� ������, ������� ������� ������ ������ ��� �� ������, ��������� � �������� ���� �������� 1, 
-- ���� ���� ������������ � �������� ������� � 0, ���� ��� �����������.

DELETE FROM users;
INSERT INTO users (name, birthday_at, created_at) VALUES
  ('��������', '1990-10-05','2018-08-01' ),
  ('�������', '1984-11-12', '2018-08-04'),
  ('���������', '1985-05-20', '2018-08-16'),
  ('����', '1986-03-14', '2018-07-17'),
  ('������', '1988-02-14', '2018-08-17');


DROP TABLE IF EXISTS tmp1;
CREATE TABLE tmp1 (
  day_ INT UNSIGNED);
 

INSERT INTO tmp1 (SELECT  @curRow := @curRow + 1 AS day_
FROM    mysql.help_topic 
JOIN    (SELECT @curRow := 0) r
WHERE   @curRow<31);

SELECT ALL  users.name, users.birthday_at, users.created_at,  tmp1.day_ day_of_month, IF (MONTH(users.created_at)= 8, 1,0)  cp_num 
FROM tmp1 LEFT JOIN users  ON tmp1.day_ = DAY(users.created_at);

-- 4.	(�� �������) ����� ������� ����� ������� � ����������� ����� created_at. 
-- �������� ������, ������� ������� ���������� ������ �� �������, �������� ������ 5 ����� ������ �������.

DELETE FROM users;
INSERT INTO users (name, birthday_at, created_at) VALUES
  ('��������', '1990-10-05','2018-08-01' ),
  ('�������', '1984-11-12', '2018-08-04'),
  ('���������', '1985-05-20', '2018-08-16'),
  ('����', '1986-03-14', '2018-07-17'),
  ('������', '1988-02-14', '2018-08-17'),
  ('������', '1990-11-05','2018-07-01' ),
  ('�����', '1984-12-12', '2018-04-24'),
  ('������', '1985-05-20', '2018-11-16'),
  ('����', '1987-03-14', '2018-07-19'),
  ('������', '1989-06-14', '2018-12-18');
 
-- SELECT *  from users ORDER BY created_at DESC;  
 
-- SELECT * FROM users ORDER BY created_at DESC LIMIT 5;

-- SELECT id FROM (SELECT id FROM users ORDER BY created_at DESC LIMIT 5) sub_q;

START TRANSACTION;
DELETE  FROM users  WHERE id NOT IN
(SELECT id FROM (SELECT id FROM users ORDER BY created_at DESC LIMIT 5) sub_q);  -- ����� ����� ����������� � ��������� � �� �����!!!
COMMIT;

SELECT *  from users  ORDER BY created_at DESC  ;  

-- ���� ������������������ MySQL� (��� ���� ��������� �� ������ �������)
-- 1.	�������� ���� ������������� ������� ����� ������ � ���� ������ shop. 
-- ������� ������������ shop_read ������ ���� �������� ������ ������� �� ������ ������, 
-- ������� ������������ shop � ����� �������� � �������� ���� ������ shop.

CREATE USER 'user1'@'localhost' IDENTIFIED BY 'user1';
CREATE USER 'user2'@'localhost' IDENTIFIED BY 'user2';

GRANT ALL PRIVILEGES ON shop. * TO 'user1'@'localhost';
GRANT  SELECT ON shop. * TO 'user2'@'localhost';

FLUSH PRIVILEGES;


-- 2.	(�� �������) ����� ������� ������� accounts ���������� ��� ������� id, name, password, 
-- ���������� ��������� ����, ��� ������������ � ��� ������. �������� ������������� username ������� accounts,
-- ��������������� ������ � ������� id � name. �������� ������������ user_read, ������� �� �� ���� ������� � ������� accounts, 
-- ������, ��� �� ��������� ������ �� ������������� username.

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  password_ VARCHAR(255)
 ) ;

INSERT INTO accounts (name, password_) VALUES
  ('��������', '111'),
  ('�������', '123'),
  ('���������', '321'),
  ('������', '456'),
  ('����', '19980112'),
  ('�����', '19920829');

SELECT * FROM accounts;

CREATE VIEW username AS SELECT accounts.id, accounts.name FROM accounts;
REVOKE  SELECT ON shop. * FROM 'user2'@'localhost';
GRANT  SELECT ON shop.username TO 'user2'@'localhost';
FLUSH PRIVILEGES;




