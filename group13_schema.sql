-- Group13 Schema for goats database
-- Worked on by Brielle, Liz, and Noverah
-- Installation:
--      createdb goats
--      psql goats
--      \i schema.sql 
--      \i group13_schema.sql

-- this view works off the Session Animal Traits table, we use for weights like Birth Weight and Weaning Weigh
-- Created by Noverah

DROP VIEW MergedData;
CREATE VIEW MergedData AS
SELECT 
    SAT.session_id AS session_id,
    SAT.animal_id AS animal_id,
    SAT.trait_code AS trait_code,
    SAT.alpha_value AS trait_alpha_value,
    SAT.alpha_units AS trait_alpha_units,
    SAT.when_measured AS trait_when_measured,
    SAT.latestForSessionAnimal AS trait_latestForSessionAnimal,
    SAT.latestForAnimal AS trait_latestForAnimal,
    SAT.is_history AS trait_is_history,
    SAT.is_exported AS trait_is_exported,
    SAT.is_deleted AS trait_is_deleted,
    SAA.activity_code AS activity_code,
    SAA.when_measured AS activity_when_measured,
    SAA.latestForSessionAnimal AS activity_latestForSessionAnimal,
    SAA.latestForAnimal AS activity_latestForAnimal,
    SAA.is_history AS activity_is_history,
    SAA.is_exported AS activity_is_exported,
    SAA.is_deleted AS activity_is_deleted
FROM 
    SessionAnimalTrait SAT
INNER JOIN 
    SessionAnimalActivity SAA ON SAT.session_id = SAA.session_id AND SAT.animal_id = SAA.animal_id;


-- initialize goats table, all goats
-- Brielle and Liz
DROP TABLE GOATS;
CREATE TABLE goats(
    eid_tag integer PRIMARY KEY,  --animal id from schema.sql
    dob timestamp,
    dam_tag varchar(16) NOT NULL default '',  --dam from schema.sql
    goat_tag varchar(16) NOT NULL default '', --tag from schema.sql
    sex varchar(20) NOT NULL default ''
);

-- Insert into goats, straight from given schema.sql / Animal.csv
INSERT INTO goats(eid_tag, DOB, dam_tag, goat_tag, sex)
SELECT animal_id, dob_date, dam, tag, sex
FROM Animal;

-- view of all goats with DOA or DWOT in their tag indicating stillborn <- Specified by stake holder
-- Created by Brielle
DROP VIEW stillborn_kids;
CREATE VIEW stillborn_kids AS
select 
    *
from 
    goats as g
where 
    g.goat_tag LIKE '%DOA%' OR g.goat_tag LIKE '%DWOT%'; -- DOA or DWOT in tag

-- A View of Number of stillborns per dam
-- Created by Brielle Edited by Liz
DROP VIEW dam_num_stillborns;
CREATE VIEW dam_num_stillborns AS
select 
    g.goat_tag, COUNT(d.eid_tag) as num_stillborns --counting eid_tags from stillborns view
from 
    goats as g
join 
    stillborn_kids as d on g.goat_tag = d.dam_tag --joining goats and stillborns on dam tag from still born
group by 
    g.goat_tag; -- grouping by goat_tag

-- finding who is a dam
-- Created by Brielle and Liz
DROP VIEW who_dams;
CREATE VIEW who_dams AS
SELECT
   d1.*
FROM
   goats AS g
LEFT JOIN
   goats AS d1 ON g.goat_tag = d1.dam_tag -- getting all goats who have a goat tag that is also another goats dam_tag
WHERE
   d1.sex = 'Female' AND d1.eid_tag IS NOT NULL; -- Error handling, should only be female, and have eid_tag

--How many times a dam has given birth
-- written by Liz
DROP VIEW mult_kids;
CREATE VIEW mult_kids AS
select
   g.goat_tag, COUNT(DISTINCT DATE(d.dob)) as mult_births 
from
   goats as g
join
   goats as d on g.goat_tag = d.dam_tag
group by
   g.goat_tag;


-- finding the corresponding kids to dams
-- Written by Brielle and Liz
DROP VIEW dam_kids;
CREATE VIEW dam_kids AS
select 
    g.goat_tag, COUNT(d.eid_tag) as num_kids --counting eid_tags
from 
    goats as g
join 
    goats as d on g.goat_tag = d.dam_tag -- to a dam tag
group by 
    g.goat_tag;

-- dams table, only goats that are dams
-- written and edited by Brielle and Liz
DROP TABLE dams;
CREATE TABLE dams( --eid_tag, dam_tag, num_of_kids, multiple_births, stillborns
    eid_tag integer PRIMARY KEY,
    goat_tag varchar(16) NOT NULL default '',
    num_of_kids float,
    -- avg_weight_of_child varchar(255),
    multiple_births float,
    num_of_stillborns float NOT NULL default 0,
    FOREIGN KEY (eid_tag) REFERENCES goats
);


--insert into dams table 
-- Written by Brielle and Liz
INSERT INTO dams(eid_tag, goat_tag, num_of_kids, multiple_births, num_of_stillborns)
SELECT
    a.eid_tag, -- Eid Tag -> from Animal Table in schema.sql
    a.goat_tag, -- Visual Tga -> from Animal Table in schema.sql
    k.num_kids, -- Number of Kids -> from still borns view & dam's kids view
    COALESCE (m.mult_births, 0), -- how many times a dam gave birth -> from mult_births view
    COALESCE (s.num_stillborns, 0) -- number of still borns -> from still borns view
FROM
    who_dams AS a 
NATURAL JOIN
    dam_kids AS k
LEFT JOIN
    mult_kids AS m ON a.goat_tag = m.goat_tag
LEFT JOIN 
    dam_num_stillborns AS s ON a.goat_tag = s.goat_tag;

-- Birth weights from table, many "BWTs" marked, repeates of tags not all on DOB
-- Worked on by Brielle, Liz, and Noverah
DROP VIEW birth_weights_original;
CREATE VIEW birth_weights_original AS
select 
    animal_id AS eid_tag, -- animal id
    trait_alpha_value AS BWT, -- weight value
    trait_when_measured AS date_measured -- date
from 
    MergedData as md -- View created by Noverah
where 
    md.trait_code=357; -- Birth Weight trait code 

--Finds birth weight for each goat by eid_tag
-- Created by Brielle and Liz
DROP VIEW birth_weights;
CREATE VIEW birth_weights AS 
SELECT
   DISTINCT eid_tag, -- Only want 1 birth weight
   CASE 
      WHEN bwt = '' THEN 0.0 -- some blank
      ELSE CAST(bwt AS FLOAT) -- make float
   END AS bwt
FROM
   birth_weights_original NATURAL JOIN goats -- join on birth weights orginal view, containg all weights under trait code 357
WHERE
   DATE(dob) = DATE(date_measured); -- just want ones recorded on date of birth for true birth weight

-- View for Sires
-- Created by Liz and Noverah
DROP VIEW sires;
CREATE VIEW sires AS 
SELECT
    animal_id as eid_tag, 
    tag as goat_tag,
    sire
FROM
    Animal;
    
-- View for Breeds
-- Created by Liz and Noverah
DROP VIEW breeds;
CREATE VIEW breeds AS
SELECT
    animal_id as eid_tag, 
    tag as goat_tag,
    breed
FROM
    Animal
WHERE
    breed != '';

--View for sale weights, found using status and last_weight
-- Created by Liz Edited by Brielle
DROP VIEW sale_weights;
CREATE VIEW sale_weights AS
SELECT
    animal_id as eid_tag,
    tag as goat_tag, 
    CASE
        WHEN last_weight = '' THEN 0.0 -- get last weight if status sold
        ELSE CAST (last_weight AS FLOAT)
    END as sale_weight
FROM
    Animal -- from Animal in Schema.sql
WHERE
    status = 'Sold'; -- status is sold


-- DROP VIEW wean_weights_original; 
-- created by Noverah
DROP VIEW wean_weights_original;
CREATE VIEW wean_weights_original AS
select
   animal_id AS eid_tag,
   trait_alpha_value AS wean_wt,
   trait_when_measured AS date_measured
from
   MergedData as md
where
   md.trait_code in (53, 383); -- test : 53

-- def wean weights by stake holder: weights in august / september the year the kid was born
-- Creayed by Noverah
DROP VIEW wean_weights;
CREATE VIEW wean_weights AS
select
   distinct eid_tag,
   CASE 
      WHEN wean_wt = '' THEN 0.0
      ELSE CAST(wean_wt AS FLOAT) 
   END as wean_wt
from
   wean_weights_original NATURAL JOIN goats
where
   extract(year from dob) = extract(year from date_measured) -- Year goat was born
   AND extract(day from date_measured) in (8, 9);  -- weaning weights in August / September

-- Weights table, containing weaning, birth, and sale
-- Created by Brielle
DROP TABLE weights;
create table weights(
   eid_tag integer PRIMARY KEY,  --animal id from schema.sql
   goat_tag varchar(16) NOT NULL default '',
   bwt float, 
   wean_wt float, 
   sale_wt float 
);
-- Created by Brielle
insert into weights(eid_tag, goat_tag, bwt, wean_wt, sale_wt)
select 
   g.eid_tag,
   g.goat_tag,
   b.bwt,
   w.wean_wt,
   s.sale_weight
from goats as g
left outer join birth_weights as b ON g.eid_tag = b.eid_tag
left outer join wean_weights as w ON g.eid_tag = w.eid_tag
left outer join sale_weights as s ON g.eid_tag = s.eid_tag;

DROP VIEW dam_avg_weights;
CREATE VIEW dam_avg_weights as
    select 
            dam_tag, 
            AVG(bwt) as avg_bwt, 
            AVG(wean_wt) as avg_wean_wt, 
            AVG(sale_wt) as avg_sale_wt 
    from goats natural join weights  
    group by dam_tag;




