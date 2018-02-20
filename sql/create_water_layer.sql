-- Create water_polygon table
DROP TABLE IF EXISTS visdata.water_polygon CASCADE;

CREATE TABLE visdata.water_polygon (
    lod1 TEXT,
    name TEXT,
    z_index INTEGER,
    original_source TEXT,
    original_id TEXT,
    geom GEOMETRY(POLYGON, 28992)
);


-- BGT
INSERT INTO visdata.water_polygon
    SELECT
        CASE
        WHEN
            s.type = 'watervlakte' OR
            s.type = 'zee'
        THEN 'water_surface'
        WHEN
            s.type = 'greppel, droge sloot' OR
            s.type = 'waterloop'
        THEN 'water_course'
        ELSE
            'undefined'
        END                         AS lod1,
        ''                          AS name,
        s."relatieveHoogteligging"  AS z_index,
        'BGT'                       AS original_source,
        'NL.IMGeo.' || s."lokaalID" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        bgt."Waterdeel" AS s;


-- TOP10NL
INSERT INTO visdata.water_polygon
    SELECT
        CASE
        WHEN
            s.typewater = 'meer, plas, ven, vijver' OR
            s.typewater = 'meer, plas' OR
            s.typewater = 'droogvallend (LAT)' OR
            s.typewater = 'zee' OR
            s.typewater = 'overig' OR
            s.typewater = 'droogvallend'
        THEN 'water_surface'
        WHEN
            s.typewater = 'waterloop' OR
            s.typewater = 'greppel, droge sloot'
        THEN 'water_course'
        ELSE
            'undefined'
        END                         AS lod1,
        s.naamofficieel             AS name,
        s.hoogteniveau::INTEGER     AS z_index,
        'TOP10NL'                   AS original_source,
        'NL.TOP10NL.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top10nl.waterdeel AS s;


-- TOP50NL
INSERT INTO visdata.water_polygon
    SELECT
        CASE
        WHEN
            s.typewater = 'meer, plas, ven, vijver' OR
            s.typewater = 'meer, plas' OR
            s.typewater = 'droogvallend (LAT)' OR
            s.typewater = 'zee' OR
            s.typewater = 'overig' OR
            s.typewater = 'droogvallend'
        THEN 'water_surface'
        WHEN
            s.typewater = 'waterloop' OR
            s.typewater = 'greppel, droge sloot'
        THEN 'water_course'
        ELSE
            'undefined'
        END                              AS lod1,
        ''                               AS name,
        s.hoogteniveau                   AS z_index,
        'TOP50NL'                        AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top50nl.waterdeel_vlak AS s;


-- TOP100NL
INSERT INTO visdata.water_polygon
    SELECT
        CASE
        WHEN
            s.typewater = 'meer, plas, ven, vijver' OR
            s.typewater = 'meer, plas' OR
            s.typewater = 'droogvallend (LAT)' OR
            s.typewater = 'zee' OR
            s.typewater = 'overig' OR
            s.typewater = 'droogvallend'
        THEN 'water_surface'
        WHEN
            s.typewater = 'waterloop' OR
            s.typewater = 'greppel, droge sloot'
        THEN 'water_course'
        ELSE
            'undefined'
        END                              AS lod1,
        ''                               AS name,
        s.hoogteniveau                   AS z_index,
        'TOP100NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top100nl.waterdeel_vlak AS s;


-- TOP250NL
INSERT INTO visdata.water_polygon
    SELECT
        CASE
        WHEN
            s.typewater = 'meer, plas, ven, vijver' OR
            s.typewater = 'meer, plas' OR
            s.typewater = 'droogvallend (LAT)' OR
            s.typewater = 'zee' OR
            s.typewater = 'overig' OR
            s.typewater = 'droogvallend'
        THEN 'water_surface'
        WHEN
            s.typewater = 'waterloop' OR
            s.typewater = 'greppel, droge sloot'
        THEN 'water_course'
        ELSE
            'undefined'
        END                              AS lod1,
        s.naamnl                         AS name,
        0                                AS z_index,
        'TOP250NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top250nl.waterdeel_vlak AS s;


-- TOP500NL
INSERT INTO visdata.water_polygon
    SELECT
        CASE
        WHEN
            s.typewater = 'meer, plas, ven, vijver' OR
            s.typewater = 'meer, plas' OR
            s.typewater = 'droogvallend (LAT)' OR
            s.typewater = 'zee' OR
            s.typewater = 'overig' OR
            s.typewater = 'droogvallend'
        THEN 'water_surface'
        WHEN
            s.typewater = 'waterloop' OR
            s.typewater = 'greppel, droge sloot'
        THEN 'water_course'
        ELSE
            'undefined'
        END                              AS lod1,
        s.naamnl                         AS name,
        0                                AS z_index,
        'TOP500NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top500nl.waterdeel_vlak AS s;


-- TOP1000NL
INSERT INTO visdata.water_polygon
    SELECT
        CASE
        WHEN
            s.typewater = 'meer, plas, ven, vijver' OR
            s.typewater = 'meer, plas' OR
            s.typewater = 'droogvallend (LAT)' OR
            s.typewater = 'zee' OR
            s.typewater = 'overig' OR
            s.typewater = 'droogvallend'
        THEN 'water_surface'
        WHEN
            s.typewater = 'waterloop' OR
            s.typewater = 'greppel, droge sloot'
        THEN 'water_course'
        ELSE
            'undefined'
        END                              AS lod1,
        s.naamnl                         AS name,
        0                                AS z_index,
        'TOP1000NL'                      AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top1000nl.waterdeel_vlak AS s;


-- Check counts
SELECT
    original_source,
    lod1,
    COUNT(*) AS aantal 
FROM
    visdata.water_polygon 
GROUP BY original_source, lod1 
ORDER BY original_source, lod1;


-- Check if there are no polygons with zero area
SELECT COUNT(*) FROM visdata.water_polygon WHERE ST_Area(geom) = 0;
