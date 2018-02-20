-- Create visdata_counts table
DROP TABLE IF EXISTS visdata.visdata_counts;

CREATE TABLE visdata.visdata_counts (
    layer VARCHAR,
    original_source VARCHAR,
    counts INTEGER
);


-- Fill counts table
INSERT INTO visdata.visdata_counts
    SELECT
        'admin_polygon',
        original_source,
        COUNT(*)
    FROM
        visdata.admin_polygon
    GROUP BY
        original_source;

INSERT INTO visdata.visdata_counts
    SELECT
        'infrastructure_line',
        original_source,
        COUNT(*)
    FROM
        visdata.infrastructure_line
    GROUP BY
        original_source;

INSERT INTO visdata.visdata_counts
    SELECT
        'labels_point',
        original_source,
        COUNT(*)
    FROM
        visdata.labels_point
    GROUP BY
        original_source;

INSERT INTO visdata.visdata_counts
    SELECT
        'terrain_polygon',
        original_source,
        COUNT(*)
    FROM
        visdata.terrain_polygon
    GROUP BY
        original_source;

INSERT INTO visdata.visdata_counts
    SELECT
        'urban_polygon',
        original_source,
        COUNT(*)
    FROM
        visdata.urban_polygon
    GROUP BY
        original_source;

INSERT INTO visdata.visdata_counts
    SELECT
        'water_line',
        original_source,
        COUNT(*)
    FROM
        visdata.water_line
    GROUP BY
        original_source;

INSERT INTO visdata.visdata_counts
    SELECT
        'water_polygon',
        original_source,
        COUNT(*)
    FROM
        visdata.water_polygon
    GROUP BY
        original_source;


-- Show aggregated stats
SELECT
    original_source,
    SUM(counts) aantal 
FROM
    visdata.visdata_counts 
GROUP BY
    original_source 
ORDER BY
    original_source;
