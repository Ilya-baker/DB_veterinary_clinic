USE veterinary_clinic;

-- -----------------------------------------------------------------------------------------------------------------
-- Показать какому владельцу принадлежит животное. Если у владельца нет животного - показать NULL
-- -----------------------------------------------------------------------------------------------------------------

SELECT
	lastname AS фимилия,
	firstname AS имя,
    patronymic AS отчество,
	kind AS вид,
	breed AS порода,
	name AS кличка_животного
FROM owner
LEFT JOIN animal ON owner.id  = animal.owner_id
ORDER BY фимилия;

-- -----------------------------------------------------------------------------------------------------------------
-- Показать сколько животных у каждого владельца
-- -----------------------------------------------------------------------------------------------------------------

SELECT 
	lastname AS фамилия,
    firstname AS имя,
    patronymic AS отчество,
    COUNT(animal.owner_id) AS количество_животных
FROM owner
LEFT JOIN animal ON owner.id = animal.owner_id
GROUP BY owner.id
ORDER BY количество_животных DESC;

-- -----------------------------------------------------------------------------------------------------------------
-- Показать в каком году сколько клиентов зарегистрировалось
-- -----------------------------------------------------------------------------------------------------------------

SELECT 
	SUBSTRING(created_at, 1, 4) AS год,
	COUNT(*) AS клиенты 
FROM owner
GROUP BY год 
WITH ROLLUP;

-- -----------------------------------------------------------------------------------------------------------------
-- Показать всех клиентов рождённых в определённый период
-- -----------------------------------------------------------------------------------------------------------------

SELECT * FROM owner WHERE birthday >= '2000-01-01' AND birthday < '2023-01-01';
-- или
SELECT * FROM owner WHERE birthday LIKE '20%%';
-- или
SELECT * FROM owner WHERE birthday >= '2000-01-01' AND birthday < NOW();
-- или
SELECT * FROM owner WHERE birthday BETWEEN '2000-01-01' AND NOW();

-- -----------------------------------------------------------------------------------------------------------------
-- Показать возраст клиентов и являются ли они совершеннолетними
-- -----------------------------------------------------------------------------------------------------------------

SELECT 
	IF(
		TIMESTAMPDIFF(YEAR, birthday, NOW()) >= 18,
		'совершеннолетний',
		'не совершеннолетний'
	) AS совершеннолетие,
	TIMESTAMPDIFF(YEAR, birthday, NOW()) AS возраст,
	lastname AS фимилия, 
	firstname AS имя, 
    patronymic AS отчество
FROM owner
ORDER BY возраст;

-- -----------------------------------------------------------------------------------------------------------------
-- Показать на какие отделения поступали животные
-- -----------------------------------------------------------------------------------------------------------------

SELECT 
	animal.name AS кличка,
    kind AS вид,
    breed AS порода,
    diagnos.name AS диагноз,
    procedures.name AS процедуры,
    surgery.name AS хирургия,
    therapy.name AS терапия,
    laboratory.name AS лаборатория,
    ultrasound.name AS УЗИ,
    roentgen.name AS рентген,
    zoosalon.name AS зоосалон
FROM animal
LEFT JOIN diagnos ON animal.id = diagnos.animal_id
LEFT JOIN procedures ON animal.id = procedures.animal_id
LEFT JOIN surgery ON animal.id = surgery.animal_id
LEFT JOIN therapy ON animal.id = therapy.animal_id
LEFT JOIN laboratory ON animal.id = laboratory.animal_id
LEFT JOIN ultrasound ON animal.id = ultrasound.animal_id
LEFT JOIN roentgen ON animal.id = roentgen.animal_id
LEFT JOIN zoosalon ON animal.id = zoosalon.animal_id
ORDER BY кличка

-- -----------------------------------------------------------------------------------------------------------------
-- Показать выручку по всем отделениям и общую выручку ветклиники
-- -----------------------------------------------------------------------------------------------------------------

SELECT
	sum(therapy.price) AS терапия,
	sum(surgery.price) AS хирургия,
	sum(laboratory.price) AS анализы,
	sum(procedures.price) AS процедуры,
	sum(roentgen.price) AS рентген,
	sum(ultrasound.price) AS УЗИ,
	sum(zoosalon.price) AS зоосалон,
		sum(surgery.price) + 
		sum(laboratory.price) +
		sum(procedures.price) +
		sum(roentgen.price) +
		sum(therapy.price) +
		sum(ultrasound.price) +
		sum(zoosalon.price) AS общая_выручка
FROM surgery
LEFT JOIN laboratory ON surgery.id = laboratory.id 
LEFT JOIN roentgen ON surgery.id = roentgen.id 
LEFT JOIN procedures ON surgery.id = procedures.id
LEFT JOIN therapy ON surgery.id = therapy.id
LEFT JOIN ultrasound ON surgery.id = ultrasound.id
LEFT JOIN zoosalon ON surgery.id = zoosalon.id;

-- -----------------------------------------------------------------------------------------------------------------
-- Пример работы функции SUBSTRING_INDEX в запросах:
-- Показать всех соседей по улице клиента с id = 25 
-- -----------------------------------------------------------------------------------------------------------------

SET @id_owner = 25; 

SELECT 
	*,
    SUBSTRING_INDEX(address, ' ', 2) AS location
    FROM owner
WHERE 
    SUBSTRING_INDEX(address, ' ', 2) = (
    SELECT SUBSTRING_INDEX(address, ' ', 2) FROM owner WHERE id = @id_owner)










