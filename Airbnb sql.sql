--Centralizing calendar data (data from files excel_calendarp0-3 to dbo.calendar table)
select count(*) from dbo.calendar

insert into dbo.calendar(listing_id,date,available,price,adjusted_price, minimum_nights, maximum_nights)
select listing_id,date,available,price,adjusted_price, minimum_nights, maximum_nights 
from dbo.calendar3;

--Drop temp calendar tables 
DROP TABLE dbo.calendar3,dbo.calendar2,dbo.calendar1;

--Data Cleaning--------------------------------------------------------------------------- 
select distinct price 
from dbo.calendar 

--Drop unnessary columns
alter table dbo.reviews
drop column F1

-- unable to cast,string price as int, removing '$' from price
UPDATE dbo.calendar
SET price = REPLACE(price, '$', '')

-- removing cents from price
select distinct price, substring(price, 1, (len(price) - 3))
from dbo.calendar

UPDATE dbo.calendar
SET price = substring(price, 1, (len(price) - 3))

-- Remove "," from thousands place 
UPDATE dbo.calendar
SET price = REPLACE(price, ',', '')

Select distinct price, REPLACE(price, ',', '')
from dbo.calendar

--Data Convert to display full price(non scientific notation) 
alter table dbo.calendar 
alter column price BIGINT

--Converting Listing price to Big int 
UPDATE dbo.listings
SET price = REPLACE(price, '$', '')

select distinct price, substring(price, 1, (len(price) - 3))
from dbo.listings

UPDATE dbo.listings
SET price = substring(price, 1, (len(price) - 3))
 

UPDATE dbo.listings
SET price = REPLACE(price, ',', '')

alter table dbo.listings
alter column price BIGINT


--converting id to bigint to remove scientific notation  
select distinct id
from dbo.listings

alter table dbo.listings
alter column id bigint


--converting id to bigint to remove scientific notation 
select distinct listing_id
from dbo.calendar

alter table dbo.calendar
alter column listing_id bigint


--Replacing null with dallas as neighborhood

select distinct neighbourhood, count(*) 
from listings 
group by neighbourhood 

select neighbourhood 
from listings 
where is null 

update dbo.listings
set neighbourhood = 'Dallas, Texas, United States'
where neighbourhood is null

select distinct id, neighbourhood, neighbourhood_cleansed
from listings 
where neighbourhood is not null and neighbourhood not like '%Dallas%'

--Merging multiple dallas formats into 1 
select distinct neighbourhood, count(*) 
from listings 
where neighbourhood like '%Dallas%'
group by neighbourhood 

select distinct neighbourhood, count(*) 
from listings 
where neighbourhood = 'Dallas, United States'
group by neighbourhood 

UPDATE dbo.listings
SET neighbourhood = 'Dallas, Texas, United States'
where neighbourhood = 'Dallas, United States'


--Shared rooms have no beds, typically a couch, every other type has at least 1 bed. 
select listing_url, property_type,room_type, bedrooms, beds
from listings
where beds is null and room_type ='Shared room'

update listings 
set beds = '0'
where beds is null and room_type ='Shared room'

-- replace null for bathrooms_text with 0 baths
update listings 
set bathrooms_text = '0 baths' 
where bathrooms_text is null


--Extract and replace null and blanks from bathroom with float value from bathroom_text
select bathrooms,bathrooms_text, LEFT(bathrooms_text, charindex(' ', bathrooms_text)) as baths
from listings

select * 
from listings 
where bathrooms_text = 'Half-bath' and bathrooms is null or bathrooms =  ' '

update listings 
set bathrooms = LEFT(bathrooms_text, charindex(' ', bathrooms_text))
where bathrooms = ' '

update listings 
set bathrooms = 0.5
where id in ('50620623','4110844')



--Insights---------------------------------------------------------------------

--sum price in each neighbourhood
select l.neighbourhood, format(avg(c.price),'c') as total_price 
from dbo.calendar c
join dbo.listings l on c.listing_id = l.id 
where c.available = 'f' and c.price < '9999' 
group by l.neighbourhood
order by total_price asc

--Avg price in each district 
select l.neighbourhood_cleansed, format(avg(c.price),'c') as total_price 
from dbo.calendar c
join dbo.listings l on c.listing_id = l.id 
where c.available = 'f' and c.price < '9999' 
group by l.neighbourhood_cleansed
order by total_price asc

--Highest and lowest listing in each district 
select l.neighbourhood_cleansed, format(max(c.price),'c') as Highest_price, format(min(c.price),'c') as Lowest_price
from dbo.calendar c
join dbo.listings l on c.listing_id = l.id 
where c.available = 'f'  and c.price < '9999' 
group by l.neighbourhood_cleansed
order by l.neighbourhood_cleansed asc

--avg price per district 
select l.neighbourhood_cleansed, format(avg(c.price),'c') as avg_price
from dbo.calendar c
join dbo.listings l on c.listing_id = l.id 
where c.available = 'f' and c.price < '9999' 
group by l.neighbourhood_cleansed
order by l.neighbourhood_cleansed asc



--Property type listed
select distinct property_type, count(*) as Properties_listed 
from listings  
group by property_type 

-- Price by property type listed
select distinct l.property_type, format(max(c.price),'c') as Highest_price, format(min(c.price),'c') as Lowest_price
from dbo.calendar c
join dbo.listings l on c.listing_id = l.id 
where c.available = 'f' and c.price < '9999' 
group by l.property_type
order by 1 asc

--avg price per bed room
select l.beds, format(avg(c.price),'c') as avg_price 
from dbo.calendar c
join dbo.listings l on c.listing_id = l.id 
where c.available = 'f' and c.price < '9999' 
group by l.beds
order by avg_price asc

---highest and lowestest listings by accomdation 
select distinct l.accommodates, format(max(c.price),'c') as Highest_price, format(min(c.price),'c') as Lowest_price
from [Airbnb Project].dbo.calendar c
join [Airbnb Project].dbo.listings l on c.listing_id = l.id 
where c.available = 'f' and c.price < '9999' 
group by l.accommodates
order by 1 asc

--Prepare data for tablau (only included listings that were confirmed booked, since others listing prices are subject to change) 

--calendar csv
select listing_id, date, price 
from calendar
where available = 'f'

--Listing csv 
select id,property_type,room_type, bedrooms, beds,bathrooms, bathrooms_text,neighbourhood_cleansed,latitude,longitude,accommodates
from listings









