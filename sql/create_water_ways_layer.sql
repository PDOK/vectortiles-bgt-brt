-- Create water_line table
DROP TABLE IF EXISTS visdata.water_line CASCADE;

CREATE TABLE visdata.water_line (
    lod1 TEXT,
    name TEXT,
    z_index INTEGER,
    original_source TEXT,
    original_id TEXT,
    geom GEOMETRY(LINESTRING, 28992)
);


-- BGT: doesn't contain suitable data for water lines


-- TOP10NL
INSERT INTO visdata.water_line
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
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top10nl.waterdeel AS s;


-- TOP50NL
INSERT INTO visdata.water_line
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
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top50nl.waterdeel_lijn AS s;


-- TOP100NL
INSERT INTO visdata.water_line
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
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top100nl.waterdeel_lijn AS s;


-- TOP250NL
INSERT INTO visdata.water_line
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
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top250nl.waterdeel_lijn AS s;


-- TOP500NL
INSERT INTO visdata.water_line
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
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top500nl.waterdeel_lijn AS s;


-- TOP1000NL
INSERT INTO visdata.water_line
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
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top1000nl.waterdeel_lijn AS s;


-- Check counts
SELECT
    original_source,
    lod1,
    COUNT(*) AS aantal 
FROM
    visdata.water_line 
GROUP BY original_source, lod1 
ORDER BY original_source, lod1;


-- Check if there are no lines with zero length
SELECT COUNT(*) FROM visdata.water_line WHERE ST_Length(geom) = 0;
