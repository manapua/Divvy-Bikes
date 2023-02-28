
/*
12 months of Divvy Bike Share data was cleaned using MySQL. The 12 tables had identical headings 
and all were imported into one table with the following code:
*/


LOAD DATA LOCAL INFILE "File Path"
INTO TABLE allbikedata
fields terminated by ','
ignore 1 rows;

-- ------------------------------------------------------------------------------

-- Leading and trailing spaces were removed from Ride IDs

SELECT DISTINCT LENGTH(ride_id)
FROM allbikedata;

SELECT ride_id
FROM allbikedata
WHERE LENGTH(ride_id) = 18 AND ride_id NOT LIKE '"%';

SELECT
	SUBSTRING(ride_id,2,16)
FROM allbikedata
WHERE LENGTH(ride_id) = 18;

UPDATE allbikedata
SET ride_id = SUBSTRING(ride_id,2,16)
WHERE LENGTH(ride_id) = 18;

-- ------------------------------------------------------------------------------
/*
Divvy has two types of bikes: classic bikes and electric bikes. Previously, classic bikes
were also called docked bikes. Convert docked_bike to classic_bike and remove quotes around
rideable_type names.
*/

SELECT DISTINCT rideable_type
FROM allbikedata;

SELECT
	SUBSTRING(rideable_type,2,13)
FROM allbikedata
WHERE rideable_type = '"electric_bike"';

SELECT
	SUBSTRING(rideable_type,2,12)
FROM allbikedata
WHERE rideable_type = '"classic_bike"';

SELECT
	SUBSTRING(rideable_type,2,11)
FROM allbikedata
WHERE rideable_type = '"docked_bike"';

UPDATE allbikedata
SET rideable_type = SUBSTRING(rideable_type,2,13)
WHERE rideable_type = '"electric_bike"';

UPDATE allbikedata
SET rideable_type = SUBSTRING(rideable_type,2,12)
WHERE rideable_type = '"classic_bike"';

UPDATE allbikedata
SET rideable_type = SUBSTRING(rideable_type,2,11)
WHERE rideable_type = '"docked_bike"';

SELECT rideable_type,
	CASE
		WHEN rideable_type = 'docked_bike' THEN 'classic_bike'
        ELSE rideable_type
        END AS converted
FROM allbikedata
WHERE rideable_type = 'docked_bike';

UPDATE allbikedata
SET rideable_type = CASE
	WHEN rideable_type = 'docked_bike' THEN 'classic_bike'
	ELSE rideable_type
	END
WHERE rideable_type = 'docked_bike';

-- ------------------------------------------------------------------------------
/*
Remove quotes in the member_casual field and remove line breaks
*/

SELECT DISTINCT member_casual
FROM allbikedata;

SELECT member_casual, 
	REPLACE(member_casual, '"casual"', 'casual')
FROM allbikedata;

UPDATE allbikedata
SET member_casual = REPLACE(member_casual, '"casual"', 'casual');

UPDATE allbikedata
SET member_casual = REPLACE(member_casual, '"member"', 'member');


-- Remove line breaks
UPDATE allbikedata
SET member_casual = TRIM(BOTH '\r' from member_casual)

-- ------------------------------------------------------------------------------

-- Remove quotes from started_at and ended_at fields

SELECT DISTINCT LENGTH(started_at)
FROM allbikedata;

SELECT started_at, ended_at
FROM allbikedata
WHERE started_at LIKE '%"%';

SELECT started_at
FROM allbikedata
WHERE started_at = TRIM(BOTH '"' FROM started_at);

UPDATE allbikedata
SET started_at = TRIM(BOTH '"' FROM started_at);

UPDATE allbikedata
SET ended_at = TRIM(BOTH '"' FROM ended_at);

-- ------------------------------------------------------------------------------
/*
Remove quotes, asterisks, and decimal points from Start and End Station IDs
*/

-- Remove quotes

SELECT DISTINCT start_station_id, COUNT(*)
FROM allbikedata
WHERE start_station_id LIKE '"%"'
GROUP BY start_station_id;

SELECT 
	SUBSTRING(start_station_id, 2, LENGTH(start_station_id) - 2)
FROM allbikedata
WHERE start_station_id LIKE '"%"';

UPDATE allbikedata
SET start_station_id = SUBSTRING(start_station_id, 2, LENGTH(start_station_id) - 2)
WHERE start_station_id LIKE '"%"';

SELECT DISTINCT end_station_id, COUNT(*)
FROM allbikedata
WHERE end_station_id LIKE '"%"'
GROUP BY end_station_id;

SELECT 
	SUBSTRING(end_station_id, 2, LENGTH(end_station_id) - 2)
FROM allbikedata
WHERE end_station_id LIKE '"%"';

UPDATE allbikedata
SET end_station_id = SUBSTRING(end_station_id, 2, LENGTH(end_station_id) - 2)
WHERE end_station_id LIKE '"%"';

-- Remove *

SELECT start_station_name, LEFT(start_station_name, LOCATE('*', start_station_name)-1)
FROM allbikedata
WHERE start_station_name LIKE '%*';

UPDATE allbikedata
SET start_station_name = LEFT(start_station_name, LOCATE('*', start_station_name)-1)
WHERE start_station_name LIKE '%*';

SELECT end_station_name, LEFT(end_station_name, LOCATE('*', end_station_name)-1)
FROM allbikedata
WHERE end_station_name LIKE '%*';

UPDATE allbikedata
SET end_station_name = LEFT(end_station_name, LOCATE('*', end_station_name)-1)
WHERE end_station_name LIKE '%*';

-- Remove decimal points

SELECT start_station_id, LEFT(start_station_id, LOCATE('.', start_station_id)-1)
FROM allbikedata
WHERE start_station_id LIKE '%.%';

UPDATE allbikedata
SET start_station_id = LEFT(start_station_id, LOCATE('.', start_station_id)-1)
WHERE start_station_id LIKE '%.%';

SELECT end_station_id, LEFT(end_station_id, LOCATE('.', end_station_id)-1)
FROM allbikedata
WHERE end_station_id LIKE '%.%';

UPDATE allbikedata
SET end_station_id = LEFT(end_station_id, LOCATE('.', end_station_id)-1)
WHERE end_station_id LIKE '%.%';

/*
Start station IDs and end station IDs were not used in the data analysis process
because not all IDs had unique station names. For instance, no fewer than 30
station IDs had 2 different station names attached. When I looked more carefully into 
the locations of the different stations with the same ID, they were blocks away from each other.
Divvy bikes does not have a list of current station IDs with corresponding station 
names publicly available. The IDs were still used in the data cleaning process, however.
*/

-- ------------------------------------------------------------------------------

/*
Remove quotes, leading spaces, and trailing spaces from Start and End Station Names
*/

--Remove quotes

SELECT start_station_name
FROM allbikedata
WHERE start_station_name LIKE '"%"';

SELECT 
	SUBSTRING(start_station_name, 2, LENGTH(start_station_name) - 2)
FROM allbikedata
WHERE start_station_name LIKE '"%"';

UPDATE allbikedata
SET start_station_name = SUBSTRING(start_station_name, 2, LENGTH(start_station_name) - 2)
WHERE start_station_name LIKE '"%"';

SELECT end_station_name
FROM allbikedata
WHERE end_station_name LIKE '"%"';

SELECT 
	SUBSTRING(end_station_name, 2, LENGTH(end_station_name) - 2)
FROM allbikedata
WHERE end_station_name LIKE '"%"';

UPDATE allbikedata
SET end_station_name = SUBSTRING(end_station_name, 2, LENGTH(end_station_name) - 2)
WHERE end_station_name LIKE '"%"';

-- Remove leading and trailing spaces

SELECT DISTINCT start_station_name

FROM allbikedata
WHERE start_station_name NOT LIKE LTRIM(RTRIM(start_station_name));

UPDATE allbikedata
SET start_station_name = LTRIM(RTRIM(start_station_name));

SELECT DISTINCT end_station_name
FROM allbikedata
WHERE end_station_name NOT LIKE LTRIM(RTRIM(end_station_name));

UPDATE allbikedata
SET end_station_name = LTRIM(RTRIM(end_station_name));

/*
A "Public Rack" is a docking station that is for electric bikes. These docking stations had
already been for electric bikes only, and midway through 2022, Divvy updated those stations
by adding the term "Public Rack" before the station name. To keep the names of the stations
consistent with this change, "Public Rack" was added to the station names that had not yet 
been updated.
*/


SELECT *
FROM allbikedata AS a1
JOIN allbikedata AS a2
ON a1.start_station_name = CONCAT('Public Rack - ', a2.start_station_name)
WHERE a1.start_station_name LIKE 'Public Rack - %'

UPDATE allbikedata AS a1
JOIN allbikedata AS a2
ON a1.start_station_name = CONCAT('Public Rack - ', a2.start_station_name)
SET a2.start_station_name = a1.start_station_name
WHERE a2.start_station_name NOT LIKE 'Public Rack - %'

SELECT *
FROM allbikedata AS a1
JOIN allbikedata AS a2
ON a1.end_station_name = CONCAT('Public Rack - ', a2.end_station_name)
WHERE a1.end_station_name LIKE 'Public Rack - %'

UPDATE allbikedata AS a1
JOIN allbikedata AS a2
ON a1.end_station_name = CONCAT('Public Rack - ', a2.end_station_name)
SET a2.end_station_name = a1.end_station_name
WHERE a2.end_station_name NOT LIKE 'Public Rack - %'

-- Clean typos

UPDATE allbikedata
SET end_station_name = CASE
    WHEN end_station_name = 'Public Rack - Laflin St &51st ST' THEN 'Public Rack - Laflin St & 51st St'
        ELSE end_station_name
        END
WHERE end_station_id = 1042

-- Remove stations that are administration and maintenance stations

DELETE
FROM allbikedata
WHERE start_station_id = 'Pawel Bialowas - Test- PBSC charging station'
	OR start_station_id = 'DIVVY CASSETTE REPAIR MOBILE STATION'
    OR end_station_id = 'DIVVY CASSETTE REPAIR MOBILE STATION'
    OR start_station_id = 'DIVVY 001 - Warehouse test station'
    OR start_station_id = '2059 Hastings Warehouse Station'
    OR end_station_id = '2059 Hastings Warehouse Station'
    OR start_station_id = 'Hastings WH 2'
    OR start_station_id = 'Hubbard Bike-checking (LBS-WH-TEST)'
    OR end_station_id = 'Hubbard Bike-checking (LBS-WH-TEST)'
    OR start_station_id = 'DIVVY 001';

-- ------------------------------------------------------------------------------

/*
Some of the longtitudes and latitudes have a value of 0, but they have a station name
and ID listed. These queries replaced 0 with NULL, then joined the table to itself to retrieve
the missing dated based on matching station IDs. The query selected the missing latitude 
or longitude to replace the NULL values.
*/

UPDATE allbikedata
SET end_lat = NULL
WHERE end_lat = 0;

SELECT a1.ride_id, a1.end_station_name, a1.end_station_id, a1.end_lat, a2.end_lat,
	IFNULL(a1.end_lat, a2.end_lat)
FROM allbikedata a1
JOIN allbikedata a2
	ON a1.end_station_id = a2.end_station_id
WHERE 
	a1.end_lat IS NULL;
    
UPDATE allbikedata AS a1
INNER JOIN allbikedata a2 ON a1.end_station_id = a2.end_station_id
SET a1.end_lat = IFNULL(a1.end_lat, a2.end_lat)
WHERE 
	a1.end_lat IS NULL;

UPDATE allbikedata
SET end_lng = NULL
WHERE end_lng = 0;

SELECT a1.ride_id, a1.end_station_name, a1.end_station_id, a1.end_lng, a2.end_lng,
	IFNULL(a1.end_lng, a2.end_lng)
FROM allbikedata a1
JOIN allbikedata a2
	ON a1.end_station_id = a2.end_station_id
WHERE 
	a1.end_lng IS NULL
    AND a2.end_lng IS NOT NULL;
    
UPDATE allbikedata AS a1
INNER JOIN allbikedata a2 ON a1.end_station_id = a2.end_station_id
SET a1.end_lng = IFNULL(a1.end_lng, a2.end_lng)
WHERE 
	a1.end_lng IS NULL;

-- ------------------------------------------------------------------------------

/*
Remove all stations that have neither a Start Station Name and a Start Station ID
or an End Station Name and an End Station ID.

Every entry has starting and ending coordinates, so I first tried to use the latitudes
and longitudes to find the missing station names. However, all of the latitudes and
longitudes listed for the missing station names did not have enough decimal places to 
accurately pin down the station locations.

A fifth decimal place (1.00000) has an accuracy up to 1.1 meters, a fourth decimal place
(1.0000) has an accuracy up to 11 meters, a third (1.000) is up to 110 kilometers, a
second (1.00) is up to 1.1 kilometer, and a first (1.0) is up to 11.1 kilometers. The 
latitudes and longitudes without station names had, at most, two decimal places. Therefore,
it wasn't possible to accurately locate their corresponding stations.
*/

SELECT *
FROM allbikedata
WHERE start_station_name = ''
	OR end_station_name = '';

DELETE
FROM allbikedata
WHERE start_station_name = ''
	OR end_station_name = '';

-- ------------------------------------------------------------------------------

/* Create a column to show the length of each bike ride. One column is in seconds
and a second column shows hours, minutes, and seconds */

ALTER TABLE allbikedata
ADD ride_length_seconds INT AFTER ended_at;

SELECT started_at, ended_at, unix_timestamp(ended_at) - unix_timestamp(started_at)
FROM allbikedata;

UPDATE allbikedata
SET ride_length_seconds = unix_timestamp(ended_at) - unix_timestamp(started_at);

ALTER TABLE allbikedata
ADD ride_length_minutes TIME AFTER ride_length_seconds;

SELECT ride_length_seconds, sec_to_time(ride_length_seconds) AS score_time
FROM allbikedata;

UPDATE allbikedata
SET ride_length_minutes = sec_to_time(ride_length_seconds);


/*
Some of the ride durations have a negative value. Delete all rows that have a
negative ride length
*/

SELECT *
FROM allbikedata
WHERE ride_length_seconds < 0;

DELETE
FROM allbikedata
WHERE ride_length_seconds < 0;


/*
Remove the rides that were less than 1 minute that had the same Start Station and
End Station. These were likely mistakes or false starts where the customer returned
the bikes before beginning a ride. Also remove rides that were more than 24 hours.
These long rides indicate possible stolen bikes or extenuating circumstances where
a customer was unable to return a bike. Both high and low ride lengths do not reflect
rider behavior and are anomalies.
*/


DELETE
FROM allbikedata
WHERE ride_length_seconds <= 40;

DELETE
FROM allbikedata
WHERE ride_length_seconds >= 86400

-- ------------------------------------------------------------------------------

-- Create day of the week and month of the year columns

ALTER TABLE allbikedata
ADD day_of_week NVARCHAR(255) AFTER ended_at;

SELECT started_at, dayname(started_at)
FROM allbikedata;

UPDATE allbikedata
SET day_of_week = dayname(started_at);

ALTER TABLE allbikedata
ADD month NVARCHAR(255) AFTER ended_at;

SELECT monthname(started_at), started_at
FROM allbikedata;

UPDATE allbikedata
SET month = monthname(started_at);