-- Create infrastructure_line table
DROP TABLE IF EXISTS visdata.infrastructure_line CASCADE;

CREATE TABLE visdata.infrastructure_line (
    lod1 TEXT,
    lod2 TEXT,
    name TEXT,
    z_index INTEGER,
    original_source TEXT,
    original_id TEXT,
    geom GEOMETRY(LINESTRING, 28992)
);


-- BGT railways
INSERT INTO visdata.infrastructure_line
    SELECT
        'railway'                   AS lod1,
        CASE
        WHEN
            s.functie = 'trein'
        THEN 'train'
        WHEN
            s.functie = 'metro' OR
            s.functie = 'sneltram'
        THEN 'metro'
        WHEN
            s.functie = 'tram'
        THEN 'tram'
        ELSE
            s.functie
        END                         AS lod2,
        ''                          AS name,
        s."relatieveHoogteligging"  AS z_index,
        'BGT'                       AS original_source,
        'NL.IMGeo.' || s."lokaalID" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        bgt."Spoor" AS s;


-- TOP10NL roads
INSERT INTO visdata.infrastructure_line
    SELECT
        CASE
        WHEN
            s.typeweg = 'autosnelweg' OR
            s.typeweg = 'lokale weg' OR
            s.typeweg = 'overig' OR
            s.typeweg = 'straat' OR
            s.typeweg = 'hoofdweg' OR
            s.typeweg = 'regionale weg'
        THEN 'roads'
        WHEN
            s.typeweg = 'veerverbinding'
        THEN 'ferry'
        WHEN
            s.typeweg = 'startbaan, landingsbaan' OR
            s.typeweg = 'rolbaan, platform'
        THEN 'flight'
        ELSE
            s.typeweg
        END                         AS lod1,
        CASE
        WHEN
            s.typeweg = 'autosnelweg'
        THEN 'highway'
        WHEN
            s.typeweg = 'hoofdweg' OR
            s.typeweg = 'regionale weg'
        THEN 'arterial'
        WHEN
            s.typeweg = 'lokale weg' OR
            s.typeweg = 'overig' OR
            s.typeweg = 'straat'
        THEN 'local'
        WHEN
            s.typeweg = 'veerverbinding'
        THEN 'ferry'
        WHEN
            s.typeweg = 'startbaan, landingsbaan' OR
            s.typeweg = 'rolbaan, platform'
        THEN 'flight'
        ELSE
            s.typeweg
        END                         AS lod2,
        COALESCE(
            NULLIF(s.naam, ''),
            NULLIF(s.brugnaam, ''),
            NULLIF(s.tunnelnaam, ''),
            NULLIF(s.knooppuntnaam, ''),
            NULLIF(s.awegnummer, ''),
            NULLIF(s.nwegnummer, ''),
            NULLIF(s.swegnummer, ''),
            NULLIF(s.afritnaam, ''),
            NULLIF(s.afritnummer, ''),
            '')                     AS name,
        s.hoogteniveau::INTEGER     AS z_index,
        'TOP10NL'                   AS original_source,
        'NL.TOP10NL.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.hartgeometrie, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top10nl.wegdeel AS s;


-- TOP10NL railways
INSERT INTO visdata.infrastructure_line
    SELECT
        'railway'                   AS lod1,
        CASE
        WHEN
            s.typespoorbaan = 'trein'
        THEN 'train'
        WHEN
            s.typespoorbaan = 'metro' OR
            s.typespoorbaan = 'sneltram'
        THEN 'metro'
        WHEN
            s.typespoorbaan = 'tram'
        THEN 'tram'
        ELSE
            s.typespoorbaan
        END                         AS lod2,
        s.baanvaknaam               AS name,
        s.hoogteniveau::INTEGER     AS z_index,
        'TOP10NL'                   AS original_source,
        'NL.TOP10NL.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top10nl.spoorbaandeel AS s;


-- TOP50NL roads
INSERT INTO visdata.infrastructure_line
    SELECT
        CASE
        WHEN
            s.typeweg = 'hoofdweg' OR
            s.typeweg = 'regionale weg' OR
            s.typeweg = 'autosnelweg' OR
            s.typeweg = 'lokale weg' OR
            s.typeweg = 'overig' OR
            s.typeweg = 'straat'
        THEN 'roads'
        WHEN
            s.typeweg = 'veerverbinding'
        THEN 'ferry'
        WHEN
            s.typeweg = 'startbaan, landingsbaan' OR
            s.typeweg = 'rolbaan, platform'
        THEN 'flight'
        ELSE
            s.typeweg
        END                              AS lod1,
        CASE
        WHEN
            s.typeweg = 'autosnelweg'
        THEN 'highway'
        WHEN
            s.typeweg = 'hoofdweg' OR
            s.typeweg = 'regionale weg'
        THEN 'arterial'
        WHEN
            s.typeweg = 'lokale weg' OR
            s.typeweg = 'overig' OR
            s.typeweg = 'straat'
        THEN 'local'
        WHEN
            s.typeweg = 'veerverbinding'
        THEN 'ferry'
        WHEN
            s.typeweg = 'startbaan, landingsbaan'
        THEN 'flight'
        ELSE
            s.typeweg
        END                              AS lod2,
        COALESCE(
            NULLIF(s.straatnaamfries, ''),
            NULLIF(s.straatnaamnl, ''),
            NULLIF(s.brugnaam, ''),
            NULLIF(s.tunnelnaam, ''),
            NULLIF(s.knooppuntnaam, ''),
            NULLIF(s.awegnummer, ''),
            NULLIF(s.nwegnummer, ''),
            NULLIF(s.swegnummer, ''),
            NULLIF(s.afritnaam, ''),
            NULLIF(s.afritnummer, ''),
            '')                          AS name,
        0                                AS z_index,
        'TOP50NL'                        AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top50nl.wegdeel_lijn AS s
    WHERE
        s.typeweg != 'parkeerplaats' OR
        s.typeweg != 'parkeerplaats: carpool' OR
        s.typeweg != 'parkeerplaats: P+R';


-- TOP50NL railways
INSERT INTO visdata.infrastructure_line
    SELECT
        'railway'                        AS lod1,
        CASE
        WHEN
            s.typespoorbaan = 'trein'
        THEN 'train'
        WHEN
            s.typespoorbaan = 'metro' OR
            s.typespoorbaan = 'sneltram'
        THEN 'metro'
        WHEN
            s.typespoorbaan = 'tram'
        THEN 'tram'
        ELSE
            s.typespoorbaan
        END                              AS lod2,
        ''                               AS name,
        s.hoogteniveau                   AS z_index,
        'TOP50NL'                        AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top50nl.spoorbaandeel_lijn AS s;


-- TOP100NL roads
INSERT INTO visdata.infrastructure_line
    SELECT
        CASE
        WHEN
            s.typeweg = 'hoofdweg' OR
            s.typeweg = 'regionale weg' OR
            s.typeweg = 'autosnelweg' OR
            s.typeweg = 'lokale weg' OR
            s.typeweg = 'overig' OR
            s.typeweg = 'straat'
        THEN 'roads'
        WHEN
            s.typeweg = 'veerverbinding'
        THEN 'ferry'
        WHEN
            s.typeweg = 'startbaan, landingsbaan' OR
            s.typeweg = 'rolbaan, platform'
        THEN 'flight'
        ELSE
            s.typeweg
        END                              AS lod1,
        CASE
        WHEN
            s.typeweg = 'autosnelweg'
        THEN 'highway'
        WHEN
            s.typeweg = 'hoofdweg' OR
            s.typeweg = 'regionale weg'
        THEN 'arterial'
        WHEN
            s.typeweg = 'lokale weg' OR
            s.typeweg = 'overig' OR
            s.typeweg = 'straat'
        THEN 'local'
        WHEN
            s.typeweg = 'veerverbinding'
        THEN 'ferry'
        WHEN
            s.typeweg = 'startbaan, landingsbaan'
        THEN 'flight'
        ELSE
            s.typeweg
        END                              AS lod2,
        COALESCE(
            NULLIF(s.straatnaamfries, ''),
            NULLIF(s.straatnaamnl, ''),
            NULLIF(s.brugnaam, ''),
            NULLIF(s.tunnelnaam, ''),
            NULLIF(s.knooppuntnaam, ''),
            NULLIF(s.awegnummer, ''),
            NULLIF(s.nwegnummer, ''),
            NULLIF(s.swegnummer, ''),
            NULLIF(s.afritnaam, ''),
            NULLIF(s.afritnummer, ''),
            '')                          AS name,
        0                                AS z_index,
        'TOP100NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top100nl.wegdeel_lijn AS s
    WHERE
        s.typeweg != 'parkeerplaats' OR
        s.typeweg != 'parkeerplaats: carpool' OR
        s.typeweg != 'parkeerplaats: P+R';


-- TOP100NL railways
INSERT INTO visdata.infrastructure_line
    SELECT
        'railway'                        AS lod1,
        CASE
        WHEN
            s.typespoorbaan = 'trein'
        THEN 'train'
        WHEN
            s.typespoorbaan = 'metro' OR
            s.typespoorbaan = 'sneltram'
        THEN 'metro'
        WHEN
            s.typespoorbaan = 'tram'
        THEN 'tram'
            ELSE s.typespoorbaan
        END                              AS lod2,
        ''                               AS name,
        s.hoogteniveau                   AS z_index,
        'TOP100NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top100nl.spoorbaandeel_lijn AS s;


-- TOP250NL roads
INSERT INTO visdata.infrastructure_line
    SELECT
        CASE
        WHEN
            s.typeweg = 'hoofdweg' OR
            s.typeweg = 'regionale weg' OR
            s.typeweg = 'autosnelweg' OR
            s.typeweg = 'lokale weg' OR
            s.typeweg = 'overig' OR
            s.typeweg = 'straat'
        THEN 'roads'
        WHEN
            s.typeweg = 'veerverbinding'
        THEN 'ferry'
        WHEN
            s.typeweg = 'startbaan, landingsbaan' OR
            s.typeweg = 'rolbaan, platform'
        THEN 'flight'
        ELSE
            s.typeweg
        END                              AS lod1,
        CASE
        WHEN
            s.typeweg = 'autosnelweg'
        THEN 'highway'
        WHEN
            s.typeweg = 'hoofdweg' OR
            s.typeweg = 'regionale weg'
        THEN 'arterial'
        WHEN
            s.typeweg = 'lokale weg' OR
            s.typeweg = 'overig' OR
            s.typeweg = 'straat'
        THEN 'local'
        WHEN
            s.typeweg = 'veerverbinding'
        THEN 'ferry'
        WHEN
            s.typeweg = 'startbaan, landingsbaan'
        THEN 'flight'
        ELSE
            s.typeweg
        END                              AS lod2,
        COALESCE(
            NULLIF(s.naam, ''),
            NULLIF(s.brugnaam, ''),
            NULLIF(s.tunnelnaam, ''),
            NULLIF(s.knooppuntnaam, ''),
            NULLIF(s.awegnummer, ''),
            NULLIF(s.nwegnummer, ''),
            NULLIF(s.swegnummer, ''),
            NULLIF(s.afritnaam, ''),
            NULLIF(s.afritnummer, ''),
            '')                          AS name,
        0                                AS z_index,
        'TOP250NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top250nl.wegdeel_lijn AS s
    WHERE
        s.typeweg != 'parkeerplaats' OR
        s.typeweg != 'parkeerplaats: carpool' OR
        s.typeweg != 'parkeerplaats: P+R';


-- TOP250NL railways
INSERT INTO visdata.infrastructure_line
    SELECT
        'railway'                        AS lod1,
        CASE
        WHEN
            s.typespoorbaan = 'trein'
        THEN 'train'
        WHEN
            s.typespoorbaan = 'metro' OR
            s.typespoorbaan = 'sneltram'
        THEN 'metro'
        WHEN
            s.typespoorbaan = 'tram'
        THEN 'tram'
        ELSE
            s.typespoorbaan
        END                              AS lod2,
        COALESCE(
            NULLIF(s.baanvaknaam, ''),
            NULLIF(s.tunnelnaam, ''),
            NULLIF(s.brugnaam, ''),
            '')                          AS name,
        0                                AS z_index,
        'TOP250NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top250nl.spoorbaandeel_lijn AS s;


-- TOP500NL roads
INSERT INTO visdata.infrastructure_line
    SELECT
        CASE
        WHEN
            s.typeweg = 'hoofdweg' OR
            s.typeweg = 'regionale weg' OR
            s.typeweg = 'autosnelweg' OR
            s.typeweg = 'lokale weg' OR
            s.typeweg = 'overig' OR
            s.typeweg = 'straat'
        THEN 'roads'
        WHEN
            s.typeweg= 'veerverbinding'
        THEN 'ferry'
        WHEN
            s.typeweg = 'startbaan, landingsbaan' OR
            s.typeweg = 'rolbaan, platform'
        THEN 'flight'
        ELSE
            s.typeweg
        END                              AS lod1,
        CASE
        WHEN
            s.typeweg = 'autosnelweg'
        THEN 'highway'
        WHEN
            s.typeweg = 'hoofdweg' OR
            s.typeweg = 'regionale weg'
        THEN 'arterial'
        WHEN
            s.typeweg = 'lokale weg' OR
            s.typeweg = 'overig' OR
            s.typeweg = 'straat'
        THEN 'local'
        WHEN
            s.typeweg = 'veerverbinding'
        THEN 'ferry'
        WHEN
            s.typeweg = 'startbaan, landingsbaan'
        THEN 'flight'
        ELSE
            s.typeweg
        END                              AS lod2,
        COALESCE(
            NULLIF(s.naam, ''),
            NULLIF(s.brugnaam, ''),
            NULLIF(s.tunnelnaam, ''),
            NULLIF(s.knooppuntnaam, ''),
            NULLIF(s.awegnummer, ''),
            NULLIF(s.nwegnummer, ''),
            NULLIF(s.swegnummer, ''),
            NULLIF(s.afritnaam, ''),
            NULLIF(s.afritnummer, ''),
            '')                          AS name,
        0                                AS z_index,
        'TOP500NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top500nl.wegdeel_lijn AS s
    WHERE
        s.typeweg != 'parkeerplaats' OR
        s.typeweg != 'parkeerplaats: carpool' OR
        s.typeweg != 'parkeerplaats: P+R';


-- TOP500NL railways
INSERT INTO visdata.infrastructure_line
    SELECT
        'railway'                        AS lod1,
        CASE
        WHEN
            s.typespoorbaan = 'trein'
        THEN 'train'
        WHEN
            s.typespoorbaan = 'metro' OR
            s.typespoorbaan = 'sneltram'
        THEN 'metro'
        WHEN
            s.typespoorbaan = 'tram'
        THEN 'tram'
        ELSE
            s.typespoorbaan
        END                              AS lod2,
        COALESCE(
            NULLIF(s.baanvaknaam, ''),
            NULLIF(s.tunnelnaam, ''),
            NULLIF(s.brugnaam, ''),
            '')                          AS name,
        0                                AS z_index,
        'TOP500NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top500nl.spoorbaandeel_lijn AS s;


-- TOP1000NL roads
INSERT INTO visdata.infrastructure_line
    SELECT
        CASE
        WHEN
            s.typeweg = 'hoofdweg' OR
            s.typeweg = 'regionale weg' OR
            s.typeweg = 'autosnelweg' OR
            s.typeweg = 'lokale weg' OR
            s.typeweg = 'overig' OR
            s.typeweg = 'straat'
        THEN 'roads'
        WHEN
            s.typeweg = 'veerverbinding'
        THEN 'ferry'
        WHEN
            s.typeweg = 'startbaan, landingsbaan' OR
            s.typeweg = 'rolbaan, platform'
        THEN 'flight'
        ELSE
            s.typeweg
        END                              AS lod1,
        CASE
        WHEN
            s.typeweg = 'autosnelweg'
        THEN 'highway'
        WHEN
            s.typeweg = 'hoofdweg' OR
            s.typeweg = 'regionale weg'
        THEN 'arterial'
        WHEN
            s.typeweg = 'lokale weg' OR
            s.typeweg = 'overig' OR
            s.typeweg = 'straat'
        THEN 'local'
        WHEN
            s.typeweg = 'veerverbinding'
        THEN 'ferry'
        WHEN
            s.typeweg = 'startbaan, landingsbaan'
        THEN 'flight'
        ELSE
            s.typeweg
        END                              AS lod2,
        COALESCE(
            NULLIF(s.naam, ''),
            NULLIF(s.brugnaam, ''),
            NULLIF(s.tunnelnaam, ''),
            NULLIF(s.knooppuntnaam, ''),
            NULLIF(s.awegnummer, ''),
            NULLIF(s.nwegnummer, ''),
            NULLIF(s.swegnummer, ''),
            NULLIF(s.afritnaam, ''),
            NULLIF(s.afritnummer, ''),
            '')                          AS name,
        0                                AS z_index,
        'TOP1000NL'                      AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top1000nl.wegdeel_lijn AS s
    WHERE
        s.typeweg != 'parkeerplaats' OR
        s.typeweg != 'parkeerplaats: carpool' OR
        s.typeweg != 'parkeerplaats: P+R';


-- TOP1000NL railways
INSERT INTO visdata.infrastructure_line
    SELECT
        'railway'                        AS lod1,
        CASE
        WHEN
            s.typespoorbaan = 'trein'
        THEN 'train'
        WHEN
            s.typespoorbaan = 'metro' OR
            s.typespoorbaan = 'sneltram'
        THEN 'metro'
        WHEN
            s.typespoorbaan = 'tram'
        THEN 'tram'
        ELSE
            s.typespoorbaan
        END                              AS lod2,
        COALESCE(
            NULLIF(s.baanvaknaam, ''),
            NULLIF(s.tunnelnaam, ''),
            NULLIF(s.brugnaam, ''),
            '')                          AS name,
        0                                AS z_index,
        'TOP1000NL'                      AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 2)))).geom::geometry(LINESTRING, 28992) AS geom
    FROM
        top1000nl.spoorbaandeel_lijn AS s;


-- Check counts
SELECT
    original_source,
    lod1,
    lod2,
    COUNT(*) AS aantal 
FROM
    visdata.infrastructure_line 
GROUP BY original_source, lod1, lod2 
ORDER BY original_source, lod1, lod2;


-- Check if there are no lines with zero length
SELECT COUNT(*) FROM visdata.infrastructure_line WHERE ST_Length(geom) = 0;
