-- Create terrain_polygon table
DROP TABLE IF EXISTS visdata.terrain_polygon CASCADE;

CREATE TABLE visdata.terrain_polygon (
    lod1 TEXT,
    lod2 TEXT,
    lod3 TEXT,
    name TEXT,
    z_index INTEGER,
    original_source TEXT,
    original_id TEXT,
    geom GEOMETRY(POLYGON, 28992)
);


-- BGT
INSERT INTO visdata.terrain_polygon
    SELECT
        'natural'                   AS lod1,
        CASE
        WHEN
            s."fysiekVoorkomen" = 'gemengd bos' OR
            s."fysiekVoorkomen" = 'houtwal' OR
            s."fysiekVoorkomen" = 'loofbos' OR
            s."fysiekVoorkomen" = 'naaldbos'
        THEN 'high_vegetation'
        WHEN
            s."fysiekVoorkomen" = 'grasland overig' OR
            s."fysiekVoorkomen" = 'groenvoorziening' OR
            s."fysiekVoorkomen" = 'heide' OR
            s."fysiekVoorkomen" = 'moeras' OR
            s."fysiekVoorkomen" = 'rietland' OR
            s."fysiekVoorkomen" = 'struiken' OR
            s."fysiekVoorkomen" = 'transitie'
        THEN 'low_vegetation'
        WHEN
            s."fysiekVoorkomen" = 'boomteelt' OR
            s."fysiekVoorkomen" = 'bouwland' OR
            s."fysiekVoorkomen" = 'fruitteelt' OR
            s."fysiekVoorkomen" = 'grasland agrarisch'
        THEN 'agriculture'
        ELSE
            s."fysiekVoorkomen"
        END                         AS lod2,
        s."fysiekVoorkomen"         AS lod3,
        ''                          AS name,
        s."relatieveHoogteligging"  AS z_index,
        'BGT'                       AS original_source,
        'NL.IMGeo.' || s."lokaalID" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        bgt."BegroeidTerreindeel" AS s;

INSERT INTO visdata.terrain_polygon
    SELECT
        'human-made'                AS lod1,
        CASE
        WHEN
            s."fysiekVoorkomen" = 'gesloten verharding' OR
            s."fysiekVoorkomen" = 'half verhard' OR
            s."fysiekVoorkomen" = 'open verharding' OR
            s."fysiekVoorkomen" = 'transitie'
        THEN 'closed'
        WHEN
            s."fysiekVoorkomen" = 'erf' OR
            s."fysiekVoorkomen" = 'onverhard' OR
            s."fysiekVoorkomen" = 'zand'
        THEN 'open'
        ELSE
            s."fysiekVoorkomen"
        END                         AS lod2,
        s."fysiekVoorkomen"         AS lod3,
        ''                          AS name,
        s."relatieveHoogteligging"  AS z_index,
        'BGT'                       AS original_source,
        'NL.IMGeo.' || s."lokaalID" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        bgt."OnbegroeidTerreindeel" AS s;

INSERT INTO visdata.terrain_polygon
    SELECT
        'natural'                   AS lod1,
        'low_vegetation'            AS lod2,
        type                        AS lod3,
        ''                          AS name,
        s."relatieveHoogteligging"  AS z_index,
        'BGT'                       AS original_source,
        'NL.IMGeo.' || s."lokaalID" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        bgt."OndersteunendWaterdeel" AS s;

INSERT INTO visdata.terrain_polygon
    SELECT
        CASE
        WHEN
            s."fysiekVoorkomen" = 'groenvoorziening'
        THEN 'natural'
        ELSE
            'human-made'
        END                         AS lod1,
        CASE
        WHEN
            s."fysiekVoorkomen" = 'gesloten verharding' OR
            s."fysiekVoorkomen" = 'half verhard' OR
            s."fysiekVoorkomen" = 'open verharding' OR
            s."fysiekVoorkomen" = 'transitie'
        THEN 'closed'
        WHEN
            s."fysiekVoorkomen" = 'onverhard' OR
            s."fysiekVoorkomen" = 'zand'
        THEN 'open'
        WHEN
            s."fysiekVoorkomen" = 'groenvoorziening'
        THEN 'low_vegetation'
        ELSE
            s."fysiekVoorkomen"
        END                         AS lod2,
        s."fysiekVoorkomen"         AS lod3,
        ''                          AS name,
        s."relatieveHoogteligging"  AS z_index,
        'BGT'                       AS original_source,
        'NL.IMGeo.' || s."lokaalID" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        bgt."OndersteunendWegdeel" AS s;

INSERT INTO visdata.terrain_polygon
    SELECT
        'human-made'                AS lod1,
        'closed'                    AS lod2,
        "typeOverbruggingsdeel"     AS lod3,
        ''                          AS name,
        s."relatieveHoogteligging"  AS z_index,
        'BGT'                       AS original_source,
        'NL.IMGeo.' || s."lokaalID" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        bgt."Overbruggingsdeel" AS s;

INSERT INTO visdata.terrain_polygon
    SELECT
        'human-made'                AS lod1,
        CASE
        WHEN
            s."fysiekVoorkomen" = 'gesloten verharding' OR
            s."fysiekVoorkomen" = 'half verhard' OR
            s."fysiekVoorkomen" = 'open verharding' OR
            s."fysiekVoorkomen" = 'transitie'
        THEN 'closed'
        WHEN
            s."fysiekVoorkomen" = 'onverhard' OR
            s."fysiekVoorkomen" = 'zand'
        THEN 'open'
        ELSE
            s."fysiekVoorkomen"
        END                         AS lod2,
        s."fysiekVoorkomen"         AS lod3,
        ''                          AS name,
        s."relatieveHoogteligging"  AS z_index,
        'BGT'                       AS original_source,
        'NL.IMGeo.' || s."lokaalID" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        bgt."Wegdeel" AS s;


-- TOP10NL
INSERT INTO visdata.terrain_polygon
    SELECT
        CASE
        WHEN
            s.typelandgebruik = 'aanlegsteiger' OR
            s.typelandgebruik = 'braakliggend' OR
            s.typelandgebruik = 'dodenakker' OR
            s.typelandgebruik = 'dodenakker met bos' OR
            s.typelandgebruik = 'kassengebied' OR
            s.typelandgebruik = 'overig' OR
            s.typelandgebruik = 'spoorbaanlichaam'
        THEN 'human-made'
        WHEN
            s.typelandgebruik = 'akkerland' OR
            s.typelandgebruik = 'basaltblokken, steenglooiing' OR
            s.typelandgebruik = 'boomgaard' OR
            s.typelandgebruik = 'boomkwekerij' OR
            s.typelandgebruik = 'bos: gemengd bos' OR
            s.typelandgebruik = 'bos: griend' OR
            s.typelandgebruik = 'bos: loofbos' OR
            s.typelandgebruik = 'bos: naaldbos' OR
            s.typelandgebruik = 'duin' OR
            s.typelandgebruik = 'fruitkwekerij' OR
            s.typelandgebruik = 'grasland' OR
            s.typelandgebruik = 'heide' OR
            s.typelandgebruik = 'populieren' OR
            s.typelandgebruik = 'zand'
        THEN 'natural'
        ELSE
            s.typelandgebruik
        END                        AS lod1,
        CASE
        WHEN
            s.typelandgebruik = 'aanlegsteiger' OR
            s.typelandgebruik = 'overig' OR
            s.typelandgebruik = 'spoorbaanlichaam'
        THEN 'closed'
        WHEN
            s.typelandgebruik = 'basaltblokken, steenglooiing' OR
            s.typelandgebruik = 'braakliggend' OR
            s.typelandgebruik = 'dodenakker' OR
            s.typelandgebruik = 'dodenakker met bos' OR
            s.typelandgebruik = 'duin' OR
            s.typelandgebruik = 'zand'
        THEN 'open'
        WHEN
            s.typelandgebruik = 'bos: gemengd bos' OR
            s.typelandgebruik = 'bos: griend' OR
            s.typelandgebruik = 'bos: loofbos' OR
            s.typelandgebruik = 'bos: naaldbos' OR
            s.typelandgebruik = 'populieren'
        THEN 'high_vegetation'
        WHEN
            s.typelandgebruik = 'grasland' OR
            s.typelandgebruik = 'heide'
        THEN 'low_vegetation'
        WHEN
            s.typelandgebruik = 'akkerland' OR
            s.typelandgebruik = 'boomgaard' OR
            s.typelandgebruik = 'boomkwekerij' OR
            s.typelandgebruik = 'fruitkwekerij' OR
            s.typelandgebruik = 'kassengebied'
        THEN 'agriculture'
        ELSE
            s.typelandgebruik
        END                        AS lod2,
        s.typelandgebruik          AS lod3,
        s.naam                     AS name,
        s.hoogteniveau::INTEGER    AS z_index,
        'TOP10NL'                  AS original_source,
        'NL.TOP10NL.'|| s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top10nl.terrein AS s
    WHERE
        s.typelandgebruik != 'bebouwd gebied';

INSERT INTO visdata.terrain_polygon
    SELECT
        CASE
        WHEN
            s.typeweg = 'parkeerplaats' OR
            s.typeweg = 'parkeerplaats: carpool' OR
            s.typeweg = 'parkeerplaats: P+R' OR
            s.typeweg = 'rolbaan, platform' OR
            s.typeweg = 'startbaan, landingsbaan'
        THEN 'human-made'
        END                        AS lod1,
        'closed'                   AS lod2,
        s.typeweg                  AS lod3,
        ''                         AS name,
        0                          AS z_index,
        'TOP10NL'                  AS original_source,
        'NL.TOP10NL.'|| s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top10nl.wegdeel AS s
    WHERE
        s.typeweg = 'parkeerplaats' OR
        s.typeweg = 'parkeerplaats: carpool' OR
        s.typeweg = 'parkeerplaats: P+R' OR
        s.typeweg = 'rolbaan, platform' OR
        s.typeweg = 'startbaan, landingsbaan';


-- TOP50NL
INSERT INTO visdata.terrain_polygon
    SELECT
        CASE
        WHEN
            s.typelandgebruik = 'aanlegsteiger' OR
            s.typelandgebruik = 'braakliggend' OR
            s.typelandgebruik = 'dodenakker' OR
            s.typelandgebruik = 'kassengebied' OR
            s.typelandgebruik = 'ongedefinieerd' OR
            s.typelandgebruik = 'overig' OR
            s.typelandgebruik = 'spoorbaanlichaam'
        THEN 'human-made'
        WHEN
            s.typelandgebruik = 'akkerland' OR
            s.typelandgebruik = 'basaltblokken, steenglooiing' OR
            s.typelandgebruik = 'boomgaard' OR
            s.typelandgebruik = 'boomkwekerij' OR
            s.typelandgebruik = 'bos: gemengd bos' OR
            s.typelandgebruik = 'bos: griend' OR
            s.typelandgebruik = 'bos: loofbos' OR
            s.typelandgebruik = 'bos: naaldbos' OR
            s.typelandgebruik = 'duin' OR
            s.typelandgebruik = 'fruitkwekerij' OR
            s.typelandgebruik = 'grasland' OR
            s.typelandgebruik = 'heide' OR
            s.typelandgebruik = 'populieren' OR
            s.typelandgebruik = 'zand'
        THEN 'natural'
        ELSE
            s.typelandgebruik
        END                              AS lod1,
        CASE
        WHEN
            s.typelandgebruik = 'aanlegsteiger' OR
            s.typelandgebruik = 'ongedefinieerd' OR
            s.typelandgebruik = 'overig' OR
            s.typelandgebruik = 'spoorbaanlichaam'
        THEN 'closed'
        WHEN
            s.typelandgebruik = 'basaltblokken, steenglooiing' OR
            s.typelandgebruik = 'braakliggend' OR
            s.typelandgebruik = 'dodenakker' OR
            s.typelandgebruik = 'duin' OR
            s.typelandgebruik = 'zand'
        THEN 'open'
        WHEN
            s.typelandgebruik = 'bos: gemengd bos' OR
            s.typelandgebruik = 'bos: griend' OR
            s.typelandgebruik = 'bos: loofbos' OR
            s.typelandgebruik = 'bos: naaldbos' OR
            s.typelandgebruik = 'populieren'
        THEN 'high_vegetation'
        WHEN
            s.typelandgebruik = 'grasland' OR
            s.typelandgebruik = 'heide'
        THEN 'low_vegetation'
        WHEN
            s.typelandgebruik = 'akkerland' OR
            s.typelandgebruik = 'boomgaard' OR
            s.typelandgebruik = 'boomkwekerij' OR
            s.typelandgebruik = 'fruitkwekerij' OR
            s.typelandgebruik = 'kassengebied'
        THEN 'agriculture'
        ELSE
            s.typelandgebruik
        END                              AS lod2,
        s.typelandgebruik                AS lod3,
        ''                               AS name,
        0                                AS z_index,
        'TOP50NL'                        AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top50nl.terrein_vlak AS s
    WHERE
        s.typelandgebruik != 'bebouwd gebied';

INSERT INTO visdata.terrain_polygon
    SELECT
        CASE
        WHEN
            s.typeweg = 'parkeerplaats' OR
            s.typeweg = 'parkeerplaats: carpool' OR
            s.typeweg = 'parkeerplaats: P+R' OR
            s.typeweg = 'rolbaan, platform' OR
            s.typeweg = 'startbaan, landingsbaan'
        THEN 'human-made'
        END                              AS lod1,
        'closed'                         AS lod2,
        s.typeweg                        AS lod3,
        ''                               AS name,
        0                                AS z_index,
        'TOP50NL'                        AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top50nl.wegdeel_vlak AS s
    WHERE
        s.typeweg = 'parkeerplaats' OR
        s.typeweg = 'parkeerplaats: carpool' OR
        s.typeweg = 'parkeerplaats: P+R' OR
        s.typeweg = 'rolbaan, platform' OR
        s.typeweg = 'startbaan, landingsbaan';


-- TOP100NL
INSERT INTO visdata.terrain_polygon
    SELECT
        CASE
        WHEN
            s.typelandgebruik = 'aanlegsteiger' OR
            s.typelandgebruik = 'bebouwd gebied' OR
            s.typelandgebruik = 'dodenakker' OR
            s.typelandgebruik = 'kassengebied' OR
            s.typelandgebruik = 'overig' OR
            s.typelandgebruik = 'spoorbaanlichaam'
        THEN 'human-made'
        WHEN
            s.typelandgebruik = 'akkerland' OR
            s.typelandgebruik = 'basaltblokken, steenglooiing' OR
            s.typelandgebruik = 'boomgaard' OR
            s.typelandgebruik = 'bos: gemengd bos' OR
            s.typelandgebruik = 'grasland' OR
            s.typelandgebruik = 'heide' OR
            s.typelandgebruik = 'zand'
        THEN 'natural'
        ELSE
            s.typelandgebruik
        END                              AS lod1,
        CASE
        WHEN
            s.typelandgebruik = 'aanlegsteiger' OR
            s.typelandgebruik = 'bebouwd gebied' OR
            s.typelandgebruik = 'overig' OR
            s.typelandgebruik = 'spoorbaanlichaam'
        THEN 'closed'
        WHEN
            s.typelandgebruik = 'basaltblokken, steenglooiing' OR
            s.typelandgebruik = 'dodenakker' OR
            s.typelandgebruik = 'zand'
        THEN 'open'
        WHEN
            s.typelandgebruik = 'bos: gemengd bos'
        THEN 'high_vegetation'
        WHEN
            s.typelandgebruik = 'grasland' OR
            s.typelandgebruik = 'heide'
        THEN 'low_vegetation'
        WHEN
            s.typelandgebruik = 'akkerland' OR
            s.typelandgebruik = 'boomgaard' OR
            s.typelandgebruik = 'kassengebied'
        THEN 'agriculture'
        ELSE s.typelandgebruik
        END                              AS lod2,
        s.typelandgebruik                AS lod3,
        ''                               AS name,
        0                                AS z_index,
        'TOP100NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top100nl.terrein_vlak AS s;


-- TOP250NL
INSERT INTO visdata.terrain_polygon
    SELECT
        CASE
        WHEN
            s.typelandgebruik = 'overig'
        THEN 'human-made'
        WHEN
            s.typelandgebruik = 'bos' OR
            s.typelandgebruik = 'zand'
        THEN 'natural'
        ELSE
            s.typelandgebruik
        END                              AS lod1,
        CASE
        WHEN
            s.typelandgebruik = 'overig'
        THEN 'closed'
        WHEN
            s.typelandgebruik = 'zand'
        THEN 'open'
        WHEN
            s.typelandgebruik = 'bos'
        THEN 'high_vegetation'
        ELSE
            s.typelandgebruik
        END                              AS lod2,
        s.typelandgebruik                AS lod3,
        ''                               AS name,
        0                                AS z_index,
        'TOP250NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top250nl.terrein_vlak AS s;


-- TOP500NL
INSERT INTO visdata.terrain_polygon
    SELECT
        CASE
        WHEN
            s.typelandgebruik = 'overig'
        THEN 'human-made'
        WHEN
            s.typelandgebruik = 'bos' OR
            s.typelandgebruik = 'zand'
        THEN 'natural'
        ELSE
            s.typelandgebruik
        END                              AS lod1,
        CASE
        WHEN
            s.typelandgebruik = 'overig'
        THEN 'closed'
        WHEN
            s.typelandgebruik = 'zand'
        THEN 'open'
        WHEN
            s.typelandgebruik = 'bos'
        THEN 'high_vegetation'
        ELSE
            s.typelandgebruik
        END                              AS lod2,
        s.typelandgebruik                AS lod3,
        ''                               AS name,
        0                                AS z_index,
        'TOP500NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top500nl.terrein_vlak AS s;


-- TOP1000NL
INSERT INTO visdata.terrain_polygon
    SELECT
        CASE
        WHEN
            s.typelandgebruik = 'bos' OR
            s.typelandgebruik = 'zand'
        THEN 'natural'
        ELSE
            s.typelandgebruik
        END                              AS lod1,
        CASE
        WHEN
            s.typelandgebruik = 'zand'
        THEN 'open'
        WHEN
            s.typelandgebruik = 'bos'
        THEN 'high_vegetation'
        ELSE
            s.typelandgebruik
        END                              AS lod2,
        s.typelandgebruik                AS lod3,
        ''                               AS name,
        0                                AS z_index,
        'TOP1000NL'                      AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top1000nl.terrein_vlak AS s;


-- Check counts
SELECT
    original_source,
    lod1,
    lod2,
    COUNT(*) AS aantal 
FROM
    visdata.terrain_polygon 
GROUP BY original_source, lod1, lod2 
ORDER BY original_source, lod1, lod2;

SELECT
    original_source,
    lod1,
    lod2,
    lod3,
    COUNT(*) AS aantal 
FROM
    visdata.terrain_polygon 
GROUP BY original_source, lod1, lod2, lod3 
ORDER BY original_source, lod1, lod2, lod3;


-- Check if there are no polygons with zero area
SELECT COUNT(*) FROM visdata.terrain_polygon WHERE ST_Area(geom) = 0;
