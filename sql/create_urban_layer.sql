-- Create urban_polygon table
DROP TABLE IF EXISTS visdata.urban_polygon CASCADE;

CREATE TABLE visdata.urban_polygon (
    lod1 TEXT,
    lod2 TEXT,
    name TEXT,
    z_index INTEGER,
    original_source TEXT,
    original_id TEXT,
    geom GEOMETRY(POLYGON, 28992)
);


-- BGT
INSERT INTO visdata.urban_polygon
    SELECT
        'buildings'                 AS lod1,
        'main_building'             AS lod2,
        ''                          AS name,
        s."relatieveHoogteligging"  AS z_index,
        'BGT'                       AS original_source,
        'NL.IMGeo.' || s."lokaalID" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        bgt."Pand" AS s;

INSERT INTO visdata.urban_polygon
    SELECT
        'buildings'                 AS lod1,
        'other_buildings'           AS lod2,
        ''                          AS name,
        s."relatieveHoogteligging"  AS z_index,
        'BGT'                       AS original_source,
        'NL.IMGeo.' || s."lokaalID" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        bgt."OverigBouwwerk" AS s;

INSERT INTO visdata.urban_polygon
    SELECT
        'buildings'                 AS lod1,
        'other_buildings'           AS lod2,
        ''                          AS name,
        s."relatieveHoogteligging"  AS z_index,
        'BGT'                       AS original_source,
        'NL.IMGeo.' || s."lokaalID" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        bgt."Kunstwerkdeel" AS s;

INSERT INTO visdata.urban_polygon
    SELECT
        'buildings'                 AS lod1,
        'other_buildings'           AS lod2,
        ''                          AS name,
        s."relatieveHoogteligging"  AS z_index,
        'BGT'                       AS original_source,
        'NL.IMGeo.' || s."lokaalID" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        bgt."GebouwInstallatie" AS s;

INSERT INTO visdata.urban_polygon
    SELECT
        'buildings'                 AS lod1,
        'walls'                     AS lod2,
        ''                          AS name,
        s."relatieveHoogteligging"  AS z_index,
        'BGT'                       AS original_source,
        'NL.IMGeo.' || s."lokaalID" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        bgt."OverigeScheiding" AS s;

INSERT INTO visdata.urban_polygon
    SELECT
        'buildings'                 AS lod1,
        'walls'                     AS lod2,
        ''                          AS name,
        s."relatieveHoogteligging"  AS z_index,
        'BGT'                       AS original_source,
        'NL.IMGeo.' || s."lokaalID" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        bgt."Scheiding" AS s;


-- TOP10NL
INSERT INTO visdata.urban_polygon
    SELECT
        'buildings'                AS lod1,
        CASE
        WHEN
            s.typegebouw = 'pompstation' OR
            s.typegebouw = 'stationsgebouw' OR
            s.typegebouw = 'postkantoor' OR
            s.typegebouw = 'stadion' OR
            s.typegebouw = 'crematorium' OR
            s.typegebouw = 'kerncentrale, kernreactor' OR
            s.typegebouw = 'elektriciteitscentrale' OR
            s.typegebouw = 'overig religieus gebouw' OR
            s.typegebouw = 'hotel' OR
            s.typegebouw = 'parkeerdak, parkeerdek, parkeergarage' OR
            s.typegebouw = 'gevangenis' OR
            s.typegebouw = 'manege' OR
            s.typegebouw = 'recreatiecentrum' OR
            s.typegebouw = 'klooster, abdij' OR
            s.typegebouw = 'synagoge' OR
            s.typegebouw = 'politiebureau' OR
            s.typegebouw = 'ziekenhuis' OR
            s.typegebouw = 'tankstation' OR
            s.typegebouw = 'paleis' OR
            s.typegebouw = 'universiteit' OR
            s.typegebouw = 'veiling' OR
            s.typegebouw = 'brandweerkazerne' OR
            s.typegebouw = 'markant gebouw' OR
            s.typegebouw = 'zwembad' OR
            s.typegebouw = 'bezoekerscentrum' OR
            s.typegebouw = 'fabriek' OR
            s.typegebouw = 'kliniek, inrichting, sanatorium' OR
            s.typegebouw = 'gemeentehuis' OR
            s.typegebouw = 'kunstijsbaan' OR
            s.typegebouw = 'museum' OR
            s.typegebouw = 'stadskantoor, hulpsecretarie' OR
            s.typegebouw = 'kerk' OR
            s.typegebouw = 'fort' OR
            s.typegebouw = 'kasteel' OR
            s.typegebouw = 'koepel' OR
            s.typegebouw = 'school' OR
            s.typegebouw = 'huizenblok' OR
            s.typegebouw = 'militair gebouw' OR
            s.typegebouw = 'moskee' OR
            s.typegebouw = 'psychiatrisch ziekenhuis, psychiatrisch centrum' OR
            s.typegebouw = 'sporthal'
        THEN 'main_buildings'
        WHEN
            s.typegebouw = 'overig' OR
            s.typegebouw = 'windmolen: korenmolen' OR
            s.typegebouw = 'verkeerstoren' OR
            s.typegebouw = 'toren' OR
            s.typegebouw = 'uitzichttoren' OR
            s.typegebouw = 'windmolen' OR
            s.typegebouw = 'lichttoren' OR
            s.typegebouw = 'kas, warenhuis' OR
            s.typegebouw = 'watertoren' OR
            s.typegebouw = 'gemaal' OR
            s.typegebouw = 'brandtoren' OR
            s.typegebouw = 'bunker' OR
            s.typegebouw = 'radiotoren, televisietoren' OR
            s.typegebouw = 'klokkentoren' OR
            s.typegebouw = 'reddingboothuisje' OR
            s.typegebouw = 'silo' OR
            s.typegebouw = 'vuurtoren' OR
            s.typegebouw = 'dok' OR
            s.typegebouw = 'ruïne' OR
            s.typegebouw = 'luchtwachttoren' OR
            s.typegebouw = 'tank' OR
            s.typegebouw = 'peilmeetstation' OR
            s.typegebouw = 'windturbine' OR
            s.typegebouw = 'telecommunicatietoren' OR
            s.typegebouw = 'radartoren' OR
            s.typegebouw = 'werf' OR
            s.typegebouw = 'boortoren' OR
            s.typegebouw = 'kapel' OR
            s.typegebouw = 'zendtoren' OR
            s.typegebouw = 'koeltoren' OR
            s.typegebouw = 'waterradmolen' OR
            s.typegebouw = 'schaapskooi' OR
            s.typegebouw = 'tol' OR
            s.typegebouw = 'radarpost' OR
            s.typegebouw = 'schoorsteen' OR
            s.typegebouw = 'windmolen: watermolen' OR
            s.typegebouw = 'transformatorstation' OR
            s.typegebouw = 'remise'
        THEN 'other_buildings'
        ELSE
            s.typegebouw
        END AS lod2,
        s.naam                     AS name,
        s.hoogteniveau::INTEGER    AS z_index,
        'TOP10NL'                  AS original_source,
        'NL.TOP10NL.'|| s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top10nl.gebouw AS s;


-- TOP50NL
INSERT INTO visdata.urban_polygon
    SELECT
        'buildings'                      AS lod1,
        CASE
        WHEN
            s.typegebouw = 'pompstation' OR
            s.typegebouw = 'treinstation' OR
            s.typegebouw = 'postkantoor' OR
            s.typegebouw = 'stadion' OR
            s.typegebouw = 'crematorium' OR
            s.typegebouw = 'kerncentrale, kernreactor' OR
            s.typegebouw = 'elektriciteitscentrale' OR
            s.typegebouw = 'religieus gebouw' OR
            s.typegebouw = 'hotel' OR
            s.typegebouw = 'parkeerdak, parkeerdek, parkeergarage' OR
            s.typegebouw = 'gevangenis' OR
            s.typegebouw = 'manege' OR
            s.typegebouw = 'recreatiecentrum' OR
            s.typegebouw = 'klooster, abdij' OR
            s.typegebouw = 'synagoge' OR
            s.typegebouw = 'politiebureau' OR
            s.typegebouw = 'ziekenhuis' OR
            s.typegebouw = 'tankstation' OR
            s.typegebouw = 'paleis' OR
            s.typegebouw = 'universiteit' OR
            s.typegebouw = 'veiling' OR
            s.typegebouw = 'brandweerkazerne' OR
            s.typegebouw = 'markant gebouw' OR
            s.typegebouw = 'zwembad' OR
            s.typegebouw = 'bezoekerscentrum' OR
            s.typegebouw = 'fabriek' OR
            s.typegebouw = 'kliniek, inrichting, sanatorium' OR
            s.typegebouw = 'gemeentehuis' OR
            s.typegebouw = 'kunstijsbaan' OR
            s.typegebouw = 'museum' OR
            s.typegebouw = 'stadskantoor, hulpsecretarie' OR
            s.typegebouw = 'kerk' OR
            s.typegebouw = 'fort' OR
            s.typegebouw = 'kasteel' OR
            s.typegebouw = 'koepel' OR
            s.typegebouw = 'school' OR
            s.typegebouw = 'huizenblok' OR
            s.typegebouw = 'militair gebouw' OR
            s.typegebouw = 'moskee' OR
            s.typegebouw = 'psychiatrisch ziekenhuis, psychiatrisch centrum' OR
            s.typegebouw = 'sporthal' OR
            s.typegebouw = 'stadskantoor'
        THEN 'main_buildings'
        WHEN
            s.typegebouw = 'overig' OR
            s.typegebouw = 'windmolen: korenmolen' OR
            s.typegebouw = 'verkeerstoren' OR
            s.typegebouw = 'toren' OR
            s.typegebouw = 'uitzichttoren' OR
            s.typegebouw = 'windmolen' OR
            s.typegebouw = 'lichttoren' OR
            s.typegebouw = 'kas, warenhuis' OR
            s.typegebouw = 'watertoren' OR
            s.typegebouw = 'gemaal' OR
            s.typegebouw = 'brandtoren' OR
            s.typegebouw = 'bunker' OR
            s.typegebouw = 'radiotoren, televisietoren' OR
            s.typegebouw = 'klokkentoren' OR
            s.typegebouw = 'reddingboothuisje' OR
            s.typegebouw = 'silo' OR
            s.typegebouw = 'vuurtoren' OR
            s.typegebouw = 'dok' OR
            s.typegebouw = 'ruïne' OR
            s.typegebouw = 'luchtwachttoren' OR
            s.typegebouw = 'tank' OR
            s.typegebouw = 'peilmeetstation' OR
            s.typegebouw = 'windturbine' OR
            s.typegebouw = 'telecommunicatietoren' OR
            s.typegebouw = 'radartoren' OR
            s.typegebouw = 'werf' OR
            s.typegebouw = 'boortoren' OR
            s.typegebouw = 'kapel' OR
            s.typegebouw = 'zendtoren' OR
            s.typegebouw = 'koeltoren' OR
            s.typegebouw = 'waterradmolen' OR
            s.typegebouw = 'schaapskooi' OR
            s.typegebouw = 'tol' OR
            s.typegebouw = 'radarpost' OR
            s.typegebouw = 'schoorsteen' OR
            s.typegebouw = 'windmolen: watermolen' OR
            s.typegebouw = 'transformatorstation' OR
            s.typegebouw = 'remise'
        THEN 'other_buildings'
        ELSE
            s.typegebouw
        END                              AS lod2,
        s.naamnl                         AS name,
        0                                AS z_index,
        'TOP50NL'                        AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top50nl.gebouw_vlak AS s;

    INSERT INTO visdata.urban_polygon
    SELECT
        'urban_area'                     AS lod1,
        ''                               AS lod2,
        ''                               AS name,
        0                                AS z_index,
        'TOP50NL'                        AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top50nl.terrein_vlak AS s
    WHERE
        s.typelandgebruik = 'bebouwd gebied';


-- TOP100NL
INSERT INTO visdata.urban_polygon
    SELECT
        'buildings'                      AS lod1,
        CASE
        WHEN
            s.typegebouw = 'pompstation' OR
            s.typegebouw = 'treinstation' OR
            s.typegebouw = 'postkantoor' OR
            s.typegebouw = 'stadion' OR
            s.typegebouw = 'crematorium' OR
            s.typegebouw = 'kerncentrale, kernreactor' OR
            s.typegebouw = 'elektriciteitscentrale' OR
            s.typegebouw = 'religieus gebouw' OR
            s.typegebouw = 'hotel' OR
            s.typegebouw = 'parkeerdak, parkeerdek, parkeergarage' OR
            s.typegebouw = 'gevangenis' OR
            s.typegebouw = 'manege' OR
            s.typegebouw = 'recreatiecentrum' OR
            s.typegebouw = 'klooster, abdij' OR
            s.typegebouw = 'synagoge' OR
            s.typegebouw = 'politiebureau' OR
            s.typegebouw = 'ziekenhuis' OR
            s.typegebouw = 'tankstation' OR
            s.typegebouw = 'paleis' OR
            s.typegebouw = 'universiteit' OR
            s.typegebouw = 'veiling' OR
            s.typegebouw = 'brandweerkazerne' OR
            s.typegebouw = 'markant gebouw' OR
            s.typegebouw = 'zwembad' OR
            s.typegebouw = 'bezoekerscentrum' OR
            s.typegebouw = 'fabriek' OR
            s.typegebouw = 'kliniek, inrichting, sanatorium' OR
            s.typegebouw = 'gemeentehuis' OR
            s.typegebouw = 'kunstijsbaan' OR
            s.typegebouw = 'museum' OR
            s.typegebouw = 'stadskantoor, hulpsecretarie' OR
            s.typegebouw = 'kerk' OR
            s.typegebouw = 'fort' OR
            s.typegebouw = 'kasteel' OR
            s.typegebouw = 'koepel' OR
            s.typegebouw = 'school' OR
            s.typegebouw = 'huizenblok' OR
            s.typegebouw = 'militair gebouw' OR
            s.typegebouw = 'moskee' OR
            s.typegebouw = 'psychiatrisch ziekenhuis, psychiatrisch centrum' OR
            s.typegebouw = 'sporthal' OR
            s.typegebouw = 'stadskantoor'
        THEN 'main_buildings'
        WHEN
            s.typegebouw = 'overig' OR
            s.typegebouw = 'windmolen: korenmolen' OR
            s.typegebouw = 'verkeerstoren' OR
            s.typegebouw = 'toren' OR
            s.typegebouw = 'uitzichttoren' OR
            s.typegebouw = 'windmolen' OR
            s.typegebouw = 'lichttoren' OR
            s.typegebouw = 'kas, warenhuis' OR
            s.typegebouw = 'watertoren' OR
            s.typegebouw = 'gemaal' OR
            s.typegebouw = 'brandtoren' OR
            s.typegebouw = 'bunker' OR
            s.typegebouw = 'radiotoren, televisietoren' OR
            s.typegebouw = 'klokkentoren' OR
            s.typegebouw = 'reddingboothuisje' OR
            s.typegebouw = 'silo' OR
            s.typegebouw = 'vuurtoren' OR
            s.typegebouw = 'dok' OR
            s.typegebouw = 'ruïne' OR
            s.typegebouw = 'luchtwachttoren' OR
            s.typegebouw = 'tank' OR
            s.typegebouw = 'peilmeetstation' OR
            s.typegebouw = 'windturbine' OR
            s.typegebouw = 'telecommunicatietoren' OR
            s.typegebouw = 'radartoren' OR
            s.typegebouw = 'werf' OR
            s.typegebouw = 'boortoren' OR
            s.typegebouw = 'kapel' OR
            s.typegebouw = 'zendtoren' OR
            s.typegebouw = 'koeltoren' OR
            s.typegebouw = 'waterradmolen' OR
            s.typegebouw = 'schaapskooi' OR
            s.typegebouw = 'tol' OR
            s.typegebouw = 'radarpost' OR
            s.typegebouw = 'schoorsteen' OR
            s.typegebouw = 'windmolen: watermolen' OR
            s.typegebouw = 'transformatorstation' OR
            s.typegebouw = 'remise'
        THEN 'other_buildings'
        ELSE
            s.typegebouw
        END                              AS lod2,
        s.naamnl                         AS name,
        0                                AS z_index,
        'TOP100NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top100nl.gebouw_vlak AS s;

INSERT INTO visdata.urban_polygon
    SELECT
        'urban_area'                     AS lod1,
        ''                               AS lod2,
        ''                               AS name,
        0                                AS z_index,
        'TOP100NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top100nl.terrein_vlak AS s
    WHERE
        s.typelandgebruik = 'bebouwd gebied';


-- TOP250NL
INSERT INTO visdata.urban_polygon
    SELECT
        'urban_area'                     AS lod1,
        ''                               AS lod2,
        s.naamnl                         AS name,
        0                                AS z_index,
        'TOP250NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top250nl.plaats_vlak AS s;


-- TOP500NL
INSERT INTO visdata.urban_polygon
    SELECT
        'urban_area'                     AS lod1,
        ''                               AS lod2,
        s.naamnl                         AS name,
        0                                AS z_index,
        'TOP500NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top500nl.plaats_vlak AS s;


-- TOP1000NL
INSERT INTO visdata.urban_polygon
    SELECT
        'urban_area'                     AS lod1,
        ''                               AS lod2,
        s.naamnl                         AS name,
        0                                AS z_index,
        'TOP1000NL'                      AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 3)))).geom::geometry(POLYGON, 28992) AS geom
    FROM
        top1000nl.plaats_vlak AS s;


-- Check counts
SELECT
    original_source,
    lod1,
    lod2,
    COUNT(*) AS aantal 
FROM
    visdata.urban_polygon 
GROUP BY original_source, lod1, lod2 
ORDER BY original_source, lod1, lod2;


-- Check if there are no polygons with zero area
SELECT COUNT(*) FROM visdata.urban_polygon WHERE ST_Area(geom) = 0;
