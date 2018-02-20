-- Create labels_point table
DROP TABLE IF EXISTS visdata.labels_point CASCADE;

CREATE TABLE visdata.labels_point (
    lod1 TEXT,
    lod2 TEXT,
    name TEXT,
    z_index INTEGER,
    rotation DOUBLE PRECISION,
    original_source TEXT,
    original_id TEXT,
    geom GEOMETRY(POINT, 28992)
);


-- BGT
INSERT INTO visdata.labels_point
    SELECT
        'building_number'      AS lod1,
        ''                     AS lod2,
        s.tekst                AS name,
        0                      AS z_index,
        s.hoek                 AS rotation,
        'BGT'                  AS original_source,
        'NL.IMGeo.' || s."_id" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 1)))).geom::geometry(POINT, 28992) AS geom
    FROM
        bgt."Pand$nummeraanduidingreeks$positie" AS s;

INSERT INTO visdata.labels_point
    SELECT
        CASE
        WHEN
            s."openbareRuimteType" = 'Weg'
        THEN 'road'
        WHEN
            s."openbareRuimteType" = 'Spoorbaan'
        THEN 'railways'
        WHEN
            s."openbareRuimteType" = 'Water'
        THEN 'water'
        WHEN
            s."openbareRuimteType" = 'Kunstwerk'
        THEN 'functional'
        WHEN
            s."openbareRuimteType" = 'Terrein'
        THEN 'residential'
        ELSE
            s."openbareRuimteType"
        END                    AS lod1,
        s."openbareRuimteType" AS lod2,
        s."openbareRuimteNaam" AS name,
        0                      AS z_index,
        s.hoek                 AS rotation,
        'BGT'                  AS original_source,
        'NL.IMGeo.' || s."_id" AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 1)))).geom::geometry(POINT, 28992) AS geom
    FROM
        bgt."OpenbareRuimteLabel$positie" AS s;


-- TOP10NL
INSERT INTO visdata.labels_point
    SELECT
        CASE
        WHEN
            s.typegeografischgebied = 'overig' OR
            s.typegeografischgebied = 'duingebied' OR
            s.typegeografischgebied = 'bosgebied' OR
            s.typegeografischgebied = 'polder' OR
            s.typegeografischgebied = 'terp, wierde' OR
            s.typegeografischgebied = 'streek, veld' OR
            s.typegeografischgebied = 'heuvel, berg' OR
            s.typegeografischgebied = 'eiland' OR
            s.typegeografischgebied = 'heidegebied' OR
            s.typegeografischgebied = 'kaap, hoek'
        THEN 'natural_areas'
        WHEN
            s.typegeografischgebied = 'watergebied' OR
            s.typegeografischgebied = 'zeegat, zeearm' OR
            s.typegeografischgebied = 'wad' OR
            s.typegeografischgebied = 'geul, vaargeul' OR
            s.typegeografischgebied = 'bank, ondiepte, plaat' OR
            s.typegeografischgebied = 'zee'
        THEN 'water'
        ELSE
            s.typegeografischgebied
        END                         AS lod1,
        s.typegeografischgebied     AS lod2,
        COALESCE(
            NULLIF(s.naamfries, ''),
            NULLIF(s.naamnl, ''),
            '')                     AS name,
        0                           AS z_index,
        0                           AS rotation,
        'TOP10NL'                   AS original_source,
        'NL.TOP10NL.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 1)))).geom::geometry(POINT, 28992) AS geom
    FROM
        top10nl.geografischgebied AS s;

INSERT INTO visdata.labels_point
    SELECT
        'functional'                AS lod1,
        s.typefunctioneelgebied     AS lod2,
        COALESCE(
            NULLIF(s.naamfries, ''),
            NULLIF(s.naamnl, ''),
            '')                     AS name,
        0                           AS z_index,
        0                           AS rotation,
        'TOP10NL'                   AS original_source,
        'NL.TOP10NL.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s._geometry, 1)))).geom::geometry(POINT, 28992) AS geom
    FROM
        top10nl.functioneelgebied AS s;


-- TOP50NL: doesn't contain "plaats" or "geografisch gebied"
INSERT INTO visdata.labels_point
    SELECT
        'functional'                     AS lod1,
        s.typefunctioneelgebied          AS lod2,
        COALESCE(
            NULLIF(s.naamfries, ''),
            NULLIF(s.naamnl, ''),
            '')                          AS name,
        0                                AS z_index,
        0                                AS rotation,
        'TOP50NL'                        AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 1)))).geom::geometry(POINT, 28992) AS geom
    FROM
        top50nl.functioneelgebied_punt AS s;


-- TOP100NL: doesn't contain "plaats" or "geografisch gebied"
INSERT INTO visdata.labels_point
    SELECT
        'functional'                     AS lod1,
        s.typefunctioneelgebied          AS lod2,
        COALESCE(
            NULLIF(s.naamfries, ''),
            NULLIF(s.naamnl, ''),
            '')                          AS name,
        0                                AS z_index,
        0                                AS rotation,
        'TOP100NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 1)))).geom::geometry(POINT, 28992) AS geom
    FROM
        top100nl.functioneelgebied_punt AS s;


-- TOP250NL
INSERT INTO visdata.labels_point
    SELECT
        'functional'                     AS lod1,
        s.typefunctioneelgebied          AS lod2,
        COALESCE(
            NULLIF(s.naamfries, ''),
            NULLIF(s.naamnl, ''),
            '')                          AS name,
        0                                AS z_index,
        0                                AS rotation,
        'TOP250NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 1)))).geom::geometry(POINT, 28992) AS geom
    FROM
        top250nl.functioneelgebied_punt AS s;

INSERT INTO visdata.labels_point
    SELECT
        CASE
        WHEN
            s.typegeografischgebied = 'watergebied' OR
            s.typegeografischgebied = 'zeegat, zeearm' OR
            s.typegeografischgebied = 'bank, ondiepte, plaat'
        THEN 'water'
        WHEN
            s.typegeografischgebied = 'bosgebied'
        THEN 'natural_areas'
        ELSE
            s.typegeografischgebied
        END                              AS lod1,
        s.typegeografischgebied          AS lod2,
        COALESCE(
            NULLIF(s.naamfries, ''),
            NULLIF(s.naamnl, ''),
            '')                          AS name,
        0                                AS z_index,
        0                                AS rotation,
        'TOP250NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 1)))).geom::geometry(POINT, 28992) AS geom
    FROM
        top250nl.geografischgebied_punt AS s;

-- TOP500NL
INSERT INTO visdata.labels_point
    SELECT
        'functional'                     AS lod1,
        s.typefunctioneelgebied          AS lod2,
        COALESCE(
            NULLIF(s.naamfries, ''),
            NULLIF(s.naamnl, ''),
            '')                          AS name,
        0                                AS z_index,
        0                                AS rotation,
        'TOP500NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 1)))).geom::geometry(POINT, 28992) AS geom
    FROM
        top500nl.functioneelgebied_punt AS s;

INSERT INTO visdata.labels_point
    SELECT
        CASE
        WHEN
            s.typegeografischgebied = 'watergebied' OR
            s.typegeografischgebied = 'zeegat, zeearm' OR
            s.typegeografischgebied = 'bank, ondiepte, plaat'
        THEN 'water'
        WHEN
            s.typegeografischgebied = 'bosgebied'
        THEN 'natural_areas'
        ELSE
            s.typegeografischgebied
        END                              AS lod1,
        s.typegeografischgebied          AS lod2,
        COALESCE(
            NULLIF(s.naamfries, ''),
            NULLIF(s.naamnl, ''),
            '')                          AS name,
        0                                AS z_index,
        0                                AS rotation,
        'TOP500NL'                       AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 1)))).geom::geometry(POINT, 28992) AS geom
    FROM
        top500nl.geografischgebied_punt AS s;


-- TOP1000NL
INSERT INTO visdata.labels_point
    SELECT
        'functional'                     AS lod1,
        s.typefunctioneelgebied          AS lod2,
        COALESCE(
            NULLIF(s.naamfries, ''),
            NULLIF(s.naamnl, ''),
            '')                          AS name,
        0                                AS z_index,
        0                                AS rotation,
        'TOP1000NL'                      AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 1)))).geom::geometry(POINT, 28992) AS geom
    FROM
        top1000nl.functioneelgebied_punt AS s;

INSERT INTO visdata.labels_point
    SELECT
        'water'                          AS lod1,
        s.typegeografischgebied          AS lod2,
        COALESCE(
            NULLIF(s.naamfries, ''),
            NULLIF(s.naamnl, ''),
            '')                          AS name,
        0                                AS z_index,
        0                                AS rotation,
        'TOP1000NL'                      AS original_source,
        s.namespace || '.' || s.lokaalid AS original_id,
        (ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 1)))).geom::geometry(POINT, 28992) AS geom
    FROM
        top1000nl.geografischgebied_punt AS s;


-- Check counts
SELECT
    original_source,
    lod1,
    COUNT(*) AS aantal
FROM
    visdata.labels_point
GROUP BY original_source, lod1
ORDER BY original_source, lod1;


------------------------------------------
-- Create place name labels
------------------------------------------
-- TOP10NL
-- These labels are reused on the scale levels where TOP50NL, TOP100NL, and TOP250NL data is shown.
DROP TABLE IF EXISTS visdata.labels_point_v1 CASCADE;

CREATE TABLE visdata.labels_point_v1 AS
	SELECT
		namespace,
		lokaalid,
		'TOP10NL'::text AS original_source,
		aantalinwoners::INTEGER,
		COALESCE(
			NULLIF(naamofficieel, ''),
			NULLIF(naamfries, ''),
			NULLIF(naamnl, ''),
			'') AS name,
		(ST_Dump(ST_ForceRHR(ST_CollectionExtract(_geometry,1)))).geom::geometry(POINT, 28992) AS wkb_geometry
	FROM
		top10nl.plaats;

DROP TABLE IF EXISTS visdata.top10_labels_point_from_polygon CASCADE;

CREATE TABLE visdata.top10_labels_point_from_polygon AS
	SELECT
		ST_Area(_geometry) AS area,
		namespace,
		lokaalid,
		'TOP10NL'::text AS original_source,
		aantalinwoners::INTEGER,
		COALESCE(
			NULLIF(naamofficieel, ''),
			NULLIF(naamfries, ''),
			NULLIF(naamnl, ''),
			'') AS name,
		(ST_Dump(ST_PointOnSurface(_geometry))).geom::geometry(POINT, 28992) AS wkb_geometry
	FROM
		top10nl.plaats
	WHERE (GeometryType(_geometry) = 'POLYGON' AND typegebied = 'buurtschap')
		OR typegebied = 'gehucht'
		OR typegebied = 'woonkern'
	GROUP BY
		namespace,
		lokaalid,
		original_source,
		aantalinwoners,
		name,
		_geometry;

DELETE
	FROM
		visdata.top10_labels_point_from_polygon a
	USING visdata.top10_labels_point_from_polygon b
	WHERE
		a.area < b.area
		AND a.name = b.name;

INSERT INTO visdata.labels_point_v1
	SELECT
		namespace,
		lokaalid,
		original_source::text,
		aantalinwoners::INTEGER,
		name,
		wkb_geometry
	FROM
		visdata.top10_labels_point_from_polygon;


-- TOP500NL
INSERT INTO visdata.labels_point_v1
	SELECT
		s.namespace,
		s.lokaalid,
		'TOP500NL'::text AS original_source,
		s.aantalinwoners::INTEGER,
		COALESCE(
			NULLIF(s.naamfries, ''),
			NULLIF(s.naamnl, ''),
			'') AS name,
		(ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 1)))).geom::geometry(POINT, 28992) AS wkb_geometry
	FROM
		top500nl.plaats_punt AS s
	LEFT JOIN
		visdata.labels_point_v1 b
		ON ST_Distance(s.wkb_geometry, b.wkb_geometry) <= 5000
			AND (s.naamnl = b.name OR s.naamfries = b.name)
	WHERE
		b.name IS NULL;

DROP TABLE IF EXISTS visdata.top500_labels_point_from_polygon CASCADE;

CREATE TABLE visdata.top500_labels_point_from_polygon AS
	SELECT
		ST_Area(wkb_geometry) AS area,
		lokaalid,
		namespace,
		'TOP500NL'::text AS original_source,
		aantalinwoners::INTEGER,
		COALESCE(
			NULLIF(naamofficieel, ''),
			NULLIF(naamfries, ''),
			NULLIF(naamnl, ''),
			'') AS name,
		(ST_Dump(ST_PointOnSurface(wkb_geometry))).geom::geometry(POINT, 28992) AS wkb_geometry
	FROM
		top500nl.plaats_vlak
	WHERE (GeometryType(wkb_geometry) = 'POLYGON' AND typegebied = 'buurtschap')
		OR typegebied = 'gehucht'
		OR typegebied = 'woonkern'
	GROUP BY
		namespace,
		lokaalid,
		original_source,
		aantalinwoners,
		name,
		wkb_geometry;

DELETE
	FROM
		visdata.top500_labels_point_from_polygon a
	USING visdata.top500_labels_point_from_polygon b
	WHERE
		a.area < b.area
		AND a.name = b.name;

INSERT INTO visdata.labels_point_v1
	SELECT
		s.namespace,
		s.lokaalid,
		s.original_source::text,
		s.aantalinwoners::INTEGER,
		s.name,
		s.wkb_geometry
	FROM
		visdata.top500_labels_point_from_polygon AS s
	LEFT JOIN
		visdata.labels_point_v1 b
		ON ST_Distance(s.wkb_geometry, b.wkb_geometry) <= 5000
			AND (s.name = b.name)
	WHERE
		b.name IS NULL;


-- TOP1000NL
INSERT INTO visdata.labels_point_v1
	SELECT
		s.namespace,
		s.lokaalid,
		'TOP1000NL'::text AS original_source,
		s.aantalinwoners::INTEGER,
		COALESCE(
			NULLIF(s.naamfries, ''),
			NULLIF(s.naamnl, ''),
			'') AS name,
		(ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 1)))).geom::geometry(POINT, 28992) AS wkb_geometry
	FROM
		top1000nl.plaats_punt AS s
	LEFT JOIN
		visdata.labels_point_v1 b
		ON ST_Distance(s.wkb_geometry, b.wkb_geometry) <= 3000
			AND (s.naamnl = b.name OR s.naamfries = b.name)
	WHERE
		b.name IS NULL;

DROP TABLE IF EXISTS visdata.top1000_labels_point_from_polygon CASCADE;

CREATE TABLE visdata.top1000_labels_point_from_polygon AS
	SELECT
		ST_Area(wkb_geometry) AS area,
		lokaalid,
		namespace,
		'TOP1000NL'::text AS original_source,
		aantalinwoners::INTEGER,
		COALESCE(
			NULLIF(naamofficieel, ''),
			NULLIF(naamfries, ''),
			NULLIF(naamnl, ''),
			'') AS name,
		(ST_Dump(ST_PointOnSurface(wkb_geometry))).geom::geometry(POINT, 28992) AS wkb_geometry
	FROM
		top1000nl.plaats_vlak
	WHERE (GeometryType(wkb_geometry) = 'POLYGON' AND typegebied = 'buurtschap')
		OR typegebied = 'gehucht'
		OR typegebied = 'woonkern'
	GROUP BY
		namespace,
		lokaalid,
		original_source,
		aantalinwoners,
		name,
		wkb_geometry;

DELETE
	FROM
		visdata.top1000_labels_point_from_polygon a
	USING visdata.top1000_labels_point_from_polygon b
	WHERE
		a.area < b.area
		AND a.name = b.name;

INSERT INTO visdata.labels_point_v1
	SELECT
		s.namespace,
		s.lokaalid,
		s.original_source::text,
		s.aantalinwoners::INTEGER,
		s.name,
		s.wkb_geometry
	FROM
		visdata.top1000_labels_point_from_polygon AS s
	LEFT JOIN
		visdata.labels_point_v1 b
		ON ST_Distance(s.wkb_geometry, b.wkb_geometry) <= 7000
			AND (s.name = b.name)
	WHERE
		b.name IS NULL;


-- Set Z-index
ALTER TABLE visdata.labels_point_v1 ADD COLUMN z_index integer;

UPDATE visdata.labels_point_v1 AS s
	SET z_index = 1000000
	WHERE
		s.name = 'Amsterdam';

UPDATE visdata.labels_point_v1 AS s
	SET z_index = 100000
	WHERE
		s.name = 'Haarlem' OR
		s.name = '''s-Gravenhage' OR
		s.name = 'Middelburg' OR
		s.name = 'Utrecht' OR
		s.name = '''s-Hertogenbosch' OR
		s.name = 'Maastricht' OR
		s.name = 'Arnhem' OR
		s.name = 'Zwolle' OR
		s.name = 'Assen' OR
		s.name = 'Groningen' OR
		s.name = 'Leeuwarden' OR
		s.name = 'Lelystad';

UPDATE visdata.labels_point_v1 AS s 
	SET z_index = 10000
	WHERE aantalinwoners >= 150000
		AND z_index IS NULL;

UPDATE visdata.labels_point_v1 AS s 
	SET z_index = 1000
	WHERE aantalinwoners < 150000
		AND aantalinwoners >= 100000
		AND z_index IS NULL;

UPDATE visdata.labels_point_v1 AS s 
	SET z_index = 100
	WHERE aantalinwoners < 100000
		AND aantalinwoners >= 50000
		AND z_index IS NULL;

UPDATE visdata.labels_point_v1 AS s 
	SET z_index = 10
	WHERE aantalinwoners < 50000
		AND aantalinwoners >= 10000
		AND z_index IS NULL;

UPDATE visdata.labels_point_v1 AS s 
	SET z_index = 1
	WHERE aantalinwoners < 10000
		AND aantalinwoners >= 1;

UPDATE visdata.labels_point_v1 AS s 
	SET z_index = 0
	WHERE aantalinwoners IS NULL
		OR aantalinwoners = 0;

SELECT
	z_index,
	COUNT(*) 
FROM
	visdata.labels_point_v1 
GROUP BY
	z_index 
ORDER BY
	z_index;

INSERT INTO visdata.labels_point
	SELECT
		'residential'                    AS lod1,
		''                               AS lod2,
		name                             AS name,
		s.z_index                        AS z_index,
		0                                AS rotation,
		s.original_source                AS original_source,
		s.namespace || '.' || s.lokaalid AS original_id,
		(ST_Dump(ST_ForceRHR(ST_CollectionExtract(s.wkb_geometry, 1)))).geom::geometry(POINT, 28992) AS geom
	FROM 
		visdata.labels_point_v1 AS s;


-- Clean up temp tables
DROP TABLE IF EXISTS visdata.top10_labels_point_from_polygon CASCADE;
DROP TABLE IF EXISTS visdata.top500_labels_point_from_polygon CASCADE;
DROP TABLE IF EXISTS visdata.top1000_labels_point_from_polygon CASCADE;
DROP TABLE IF EXISTS visdata.labels_point_v1 CASCADE;
