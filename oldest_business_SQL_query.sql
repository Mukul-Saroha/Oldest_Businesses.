# Q1.The founding years of the oldest companies in which country
SELECT  c.country, b.year_founded
FROM countries c
JOIN businesses b ON c.country_code = b.country_code
ORDER BY year_founded ASC 
LIMIT 1;
# Ans. oldest companies in "Japan" and Year 578 AD




# Q2.The oldest company in the world and the industry it belongs to?
SELECT c.category, b.business
FROM categories c
JOIN businesses b ON c.category_code = b.category_code
ORDER BY year_founded
LIMIT 1;
# Ans. industry it belongs "Construction" and company "Kong Gumi"




# Q3.How many companies—and which ones—were founded before 1000 AD
 SELECT count(year_founded)
 FROM businesses
 WHERE year_founded <= 1000;
# Ans. Count of Companies is 6
 SELECT businesses.year_founded, businesses.business
 FROM businesses
 WHERE year_founded <= 1000;
# Ans. the  companies is  "Kong Gumi", 'St Peter Stifts Kulinarium','The Royal Mint'...
 
 
 
 
# Q4.The most common industries to which the oldest companies belong to
 SELECT  count(businesses.business) ,categories.category  
 FROM businesses  
 JOIN categories ON categories.category_code = businesses.category_code  
 GROUP BY categories.category  
 ORDER BY count(businesses.business) DESC  
 LIMIT 1;
# Ans. The most common industries - 'Banking & Finance'
SELECT businesses.year_founded, businesses.business, categories.category
FROM businesses
JOIN categories ON categories.category_code = businesses.category_code
WHERE categories.category = 'Banking & Finance'
ORDER BY businesses.year_founded ASC
LIMIT 1;
# Ans. The 'Banking & Finance' industries oldest company 'Casa Nacional de Moneda'

# another method of question 4
WITH oldest_businesses AS (
    SELECT b.business, b.year_founded, ca.category
	FROM businesses b
    JOIN categories ca ON ca.category_code = b.category_code
),
common_industries AS (
    SELECT category, COUNT(category) AS frequency
    FROM oldest_businesses
    GROUP BY category
) 
SELECT b.year_founded, ci.category, ci.frequency, b.business
FROM common_industries ci
JOIN oldest_businesses b ON b.category = ci.category
ORDER BY ci.frequency DESC, year_founded ASC
LIMIT 1;




# Q5.The oldest companies by continent
WITH oldest_companies AS( 
          SELECT b.business, b.year_founded, c.continent,
		  ROW_NUMBER() OVER(PARTITION BY c.continent ORDER BY b.year_founded ASC) AS row_no
		  FROM businesses b
		  JOIN countries c ON b.country_code = c.country_code
          ORDER BY b.year_founded ASC
)
SELECT business, year_founded, continent 
FROM oldest_companies
WHERE row_no = 1;




# Q6.The most common category for the oldest companies on each continent
WITH business_continent AS (
    SELECT b.business, b.year_founded, c.continent,
        ROW_NUMBER() OVER (PARTITION BY c.continent ORDER BY b.year_founded ASC) AS row_no
    FROM businesses b
    JOIN countries c ON b.country_code = c.country_code
),
business_categories AS (
    SELECT bco.continent, bco.business, bco.year_founded, c.category,
        COUNT(*) AS frequency
    FROM business_continent bco
    JOIN businesses b ON bco.business = b.business
    JOIN categories c ON b.category_code = c.category_code
    WHERE bco.row_no = 1
    GROUP BY bco.continent, bco.business, bco.year_founded, c.category
),
frequency1 AS (
    SELECT continent, MAX(frequency) AS max_frequency
    FROM business_categories bca
    GROUP BY continent
)
SELECT bca.continent, bca.business, bca.year_founded, bca.category
FROM business_categories bca
JOIN frequency1 f ON bca.continent = f.continent
WHERE bca.frequency = f.max_frequency
ORDER BY bca.year_founded;





