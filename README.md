topotiles
=========


To make a slippy Web map, you need data at all zoom/scale levels. You also need to be able to target the same features at different zoom levels with the same styling, so that there is a consistent view as the user zooms in and out. For the Netherlands, the official geographical data for different scale levels is split between different datasets. The typology of features is not  consistent between these different datasets.

`Topotiles` exists to bring all those features into a single database with a consistent hierarchy of feature types, in order to greatly simplify making maps with Dutch open data. Instead of having to remember what roads are called in different datasets, you can simply refer to 'roads' and the  features from the most appropriate dataset will be targeted at each zoom level. This is accomplished by using vector tiles with opinionated choices about what features to serve at what zoom level. 

How to use it
-------------

There is a demo viewer at http://geodata.nationaalgeoregister.nl/beta/topotiles-viewer/#14.06/51.16399/5.84555/-68.8/49

### Endpoints

Use the following endpoints in your applications:

TileJSON endpoint: https://geodata.nationaalgeoregister.nl/beta/topotiles-viewer/styles/tilejson.json

Raw tile endpoint: http://geodata.nationaalgeoregister.nl/beta/topotiles/{z}/{x}/{y}.pbf

StyleJSON for BRT Achtergrondkaart: https://geodata.nationaalgeoregister.nl/beta/topotiles-viewer/styles/achtergrond.json (This style is based on the existing BRT Achtergrondkaart tileset)


Data structure
--------------

#### Classification

There are seven top-level layers:

layer | description | feature type
----- | ----------- | ------------
admin | administrative boundaries | polygon
water | water areas | polygon
water-line | waterways | line
terrain | land-use areas (natural and human-made) | polygon
urban | built-up areas, buildings | polygons
infra | roads, railways, ferries | line
label | names of features | point

Features within these layers have attributes `lod1` and `lod2` and sometimes `lod3` which can be used to select subsets. For example, the `infra` layer contains roads, railways, tram and metro lines, and ferries. To select only roads, you can filter on `lod1 = roads`. To further select a particular type of road, you can use `lod2`, for example, `lod2 = arterial`.

The full list of subclassifications: coming soon.

#### Original feature ID
Each feature in `visdata` has an attribute `original_id` which is a string consisting of an identifier for the source dataset, and the original ID in the source dataset. It is built up as follows: `NL.<SOURCE_DATASET>.<ORIGINAL_ID>`. There is also an attribute `original_source` which contains the name of the original source.

How it is made
------------
The source datasets are the BRT (Basisregistratie Topografie), including TOP1000, TOP500, TOP250, TOP100, TOP50 and TOP10, ranging in scale from 1:1 000 000 to 1:10 000, and the BGT (Basisregistratie Grootschalige Topografie), at a scale of 1:5 000.

#### Data sources per zoom level
zoom level | source
----------|--------
0-5| TOP1000
6-7 | TOP500
8-9 | TOP250
10-11 | TOP100
12-13 | TOP50
14-15 | TOP10
16-17 | admin: TOP10<br>all other layers: BGT
