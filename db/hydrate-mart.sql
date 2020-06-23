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

-- pg 547
insert into mart.person_type_lookup values
    (1, 'Driver of a Motor Vehicle In-Transport', 'Driver', true),
    (2, 'Passenger of a Motor Vehicle In-Transport', 'Passenger', true),
    (3, 'Occupant of a Motor Vehicle Not In-Transport', 'Other non-occupant', false),
    (4, 'Occupant of a Non-Motor Vehicle Transport Device', 'Other non-occupant', false),
    (5, 'Pedestrian', 'Pedestrian', false),
    (6, 'Bicyclist', 'Pedalcyclist', false),
    (7, 'Other Cyclist', 'Pedalcyclist', false),
    (8, 'Person on Personal Conveyances', 'Other non-occupant', false),
    (9, 'Unknown Occupant Type in a Motor Vehicle In-Transport', 'Passenger', true),
    (10, 'Persons In/On Buildings', 'Other non-occupant', false),
    (19, 'Not Reported/Unknown Type of Non-Motorist', 'Unknown non-occupant type', false),
    (88, 'Not Reported/Unknown Type of Non-Motorist', 'Unknown person type', null);

-- pg 448
insert into mart.crash_group_pedestrian_lookup values
    (100, 'Unusual Circumstances'),
    (200, 'Backing Vehicle'),
    (310, 'Working or Playing in Roadway'),
    (340, 'Bus/Bus Stop-Related'),
    (350, 'Unique Midbock'),
    (400, 'Walking/Running Along Roadway'),
    (460, 'Diveway Access/Driveway Access Related'),
    (500, 'Waiting to Cross'),
    (600, 'Pedestrian in Roadway - Circumstances Unknown'),
    (720, 'Multiple Threat/Trapped'),
    (740, 'Dash/Dart-Out'),
    (750, 'Crossing Roadway - Vehicle Not Turning'),
    (790, 'Crossing Roadway - Vehicle Turning'),
    (800, 'Non-Trafficway'),
    (910, 'Crossing Expressway'),
    (990, 'Other/Unknown - Insufficient Details');

-- pg 449
insert into mart.crash_group_bicyclist_lookup values
    (110, 'Loss of Control/Turning Error'),
    (140, 'Motorist Failed to Yield - Sign-Controlled Intersection'),
    (145, 'Bicyclist Failed to Yield - Sign-Controlled Intersection'),
    (150, 'Motorist Failed to Yield - Signalized Intersection'),
    (158, 'Bicyclist Failed to Yield - Signalized Intersection'),
    (190, 'Crossing Paths - Other Circumstances'),
    (210, 'Motorist Left Turn/Merge'),
    (215, 'Motorist Right Turn/Merge'),
    (219, 'Parking/Bus-Related'),
    (220, 'Bicyclist Left Turn/Merge'),
    (225, 'Bicyclist Right Turn/Merge'),
    (230, 'Motorist Overtaking Bicyclist'),
    (240, 'Bicyclist Overtaking Motorist'),
    (258, 'Wrong-Way/Wrong-Side'),
    (290, 'Parallel Paths - Other Circumstances'),
    (310, 'Bicyclist Failed to Yield - Midblock'),
    (320, 'Motorist Failed to Yield - Midblock'),
    (600, 'Backing Vehicle'),
    (850, 'Other/Unusual Circumstances'),
    (910, 'Non-Trafficway'),
    (990, 'Other/Unknown - Insufficient Details');

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

-- pg 478
insert into mart.veh_factors_lookup values
    (0, 'None'),
    (1, 'Tires'),
    (2, 'Brake System'),
    (3, 'Steering'),
    (4, 'Suspension'),
    (5, 'Power Train'),
    (6, 'Exhaust System'),
    (7, 'Head Lights'),
    (8, 'Signal Lights'),
    (9, 'Other Lights'),
    (10, 'Wipers'),
    (11, 'Wheels'),
    (12, 'Mirrors'),
    (13, 'Windows/Windshield'),
    (14, 'Body, Doors'),
    (15, 'Truck Coupling / Trailer Hitch / Safety Chains'),
    (16, 'Safety Systems'),
    (17, 'Vehicle Contributing Factors - No Details'),
    (97, 'Other'),
    (98, 'Not Reported'),
    (99, 'Unknown / Reported as Unknown');

insert into mart.visual_obstructions_lookup values
    (0, 'No Obstruction Noted'),
    (1, 'Rain, Snow, Fog, Smoke, Sand, Dust'),
    (2, 'Reflected Glare, Bright Sunlight, Headlights'),
    (3, 'Curve, Hill, or Other Roadway Design Features'),
    (4, 'Building, Billboard, or Other Structure'),
    (5, 'Trees, Crops, Vegetation'),
    (6, 'In-Transport Motor Vehicle (including Load)'),
    (7, 'Not-In-Transport Motor Vehicle (Parked, Working)'),
    (8, 'Splash or Spray of Passing Vehicle'),
    (9, 'Inadequate Defrost or Defog System'),
    (10, 'Inadequate Vehicle Lighting System'),
    (11, 'Obstructing Interior to the Vehicle'),
    (12, 'External Mirrors'),
    (13, 'Broken or Improperly Cleaned Windshield'),
    (14, 'Obstructing Angles on Vehicle'),
    (95, 'No Driver Present/Unknown if Driver Present'),
    (97, 'Vision Obscured - No Details'),
    (98, 'Other Visual Obstruction'),
    (99, 'Unknown / Reported as Unknown');

insert into mart.nm_impairments_lookup values
    (0, 'None/Apparently Normal'),
    (1, 'Ill, Blackout'),
    (2, 'Asleep or Fatigued'),
    (3, 'Walking with a Cane or Crutches'),
    (4, 'Paraplegic or in a Wheelchair'),
    (5, 'Impaired Due to Previous Injury'),
    (6, 'Deaf'),
    (7, 'Blind'),
    (8, 'Emotional'),
    (9, 'Under the Influence of Alcohol, Drugs or Medication'),
    (10, 'Physical Impairment - No Details'),
    (96, 'Other Physical Impairment'),
    (98, 'Not Reported'),
    (99, 'Unknown / Reported as Unknown');


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
