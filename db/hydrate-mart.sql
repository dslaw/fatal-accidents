-- Categorical data mappings.

-- pg 63
insert into mart.light_condition_lookup (id, description) values
    (1, 'Daylight'),
    (2, 'Dark - Not Lighted'),
    (3, 'Dark - Lighted'),
    (4, 'Dawn'),
    (5, 'Dusk'),
    (6, 'Dark - Unknown Lighting'),
    (7, 'Other'),
    (8, 'Not Reported'),
    (9, 'Unknown');

-- pg 64
insert into mart.weather_lookup (id, description) values
    (0, 'No Additional Atmospheric Conditions'),
    (1, 'Clear'),
    (2, 'Rain'),
    (3, 'Sleet, Hail'),
    (4, 'Snow'),
    (5, 'Fog, Smog, Smoke'),
    (6, 'Sever Crosswinds'),
    (7, 'Blowing Sand, Soil, Dirt'),
    (8, 'Other'),
    (10, 'Cloudy'),
    (11, 'Blowing Snow'),
    (12, 'Freezing Rain or Drizzle'),
    (98, 'Not Reported'),
    (99, 'Unknown');

-- pg 457
insert into mart.impairment_lookup (id, description) values
    (0, 'None/Apparently Normal'),
    (1, 'Ill, Blackout'),
    (2, 'Asleep or Fatigued'),
    (3, 'Walking with a Cane or Crutches, etc'),
    (4, 'Paraplegic or Restricted to Wheelchair'),
    (5, 'Impaired Due to Previous Injury'),
    (6, 'Deaf'),
    (7, 'Blind'),
    (8, 'Emotional (Depressed, Angry, Disturbed, etc)'),
    (9, 'Under the influence of Alcohol, Drugs or Medication'),
    (10, 'Physical Impairment - No Details'),
    (95, 'No Driver Present/Unknown if Driver Present'),
    (96, 'Other Physical Impairment'),
    (98, 'Not Reported'),
    (99, 'Unknown if Impaired');

-- pg 455
insert into mart.distractions_lookup (id, description) values
    (0, 'Not Distracted'),
    (1, 'Looked But Did Not See'),
    (3, 'By Other Occupant(s)'),
    (4, 'By a Moving Object in Vehicle'),
    (5, 'While Talking or Listening to Cellular Phone'),
    (6, 'While Manipulating Cellular Phone'),
    (7, 'While Adjusting Audio or Climate Controls'),
    (9, 'While Using Other Component/Controls Integral to Vehicle'),
    (10, 'While Using or Reaching For Device/Object Brought Into Vehicle'),
    (12, 'Distracted by Outside Person, Object or Event'),
    (13, 'Eating or Drinking'),
    (14, 'Smoking Related'),
    (15, 'Other Cellular Phone Related'),
    (16, 'No Driver Present/Unknown if Driver Present'),
    (17, 'Distraction/Inattention'),
    (18, 'Distraction/Careless'),
    (19, 'Careless/Inattentive'),
    /* Count distraction and inattention as the same for
       consistency across different time periods. */
    (92, 'Distraction/Inattention, Details Unknown'),
    (93, 'Distraction/Inattention, Details Unknown'),
    (96, 'Not Reported'),
    (97, 'Lost In Thought/Day Dreaming'),
    (98, 'Other Distraction'),
    (99, 'Unknown if Distracted');

-- pg 92
insert into mart.hitrun_lookup (id, description) values
    (0, 'No'),
    (1, 'Yes'),
    (8, 'Not Reported'),
    (9, 'Unknown');

-- pg 157
insert into mart.license_status_lookup (id, description) values
    (0, 'Not Licensed'),
    (1, 'Suspended'),
    (2, 'Revoked'),
    (3, 'Expired'),
    (4, 'Cancelled or Denied'),
    (6, 'Valid License'),
    (7, 'No Driver Present/Unknown if Driver Present'),
    (9, 'Unknown License Status');


-- Static date/time values.
-- Re: casting to timstamp w/o time zone, see https://dba.stackexchange.com/a/175964

insert into mart.dim_time (value)
select v::time without time zone
from generate_series(
    '2000-01-01 00:00'::timestamp without time zone,
    '2000-01-01 23:59'::timestamp without time zone,
    '1 minute'::interval
) as t(v);

insert into mart.dim_date (value)
select v
from generate_series(
    '2010-01-01'::timestamp without time zone,
    '2018-12-31'::timestamp without time zone,
    '1 day'::interval
) as t(v);
