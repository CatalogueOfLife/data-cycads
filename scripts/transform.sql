DROP SCHEMA IF EXISTS COLDP_Cycads;
CREATE SCHEMA COLDP_Cycads CHARSET utf8 COLLATE utf8_general_ci;
USE COLDP_Cycads;

DROP TABLE IF EXISTS COLDP_Cycads.`References`;
CREATE TABLE `References`
SELECT SPNUMBER AS ID,
       NULL AS citation,
       NULL AS title,
       YEAR AS year,
       CITATION AS source,
       NULL AS doi,
       NULL AS link
FROM WorkDB_Cycads.COL_Cycads;


DROP TABLE IF EXISTS COLDP_Cycads.`Name`;
CREATE TABLE COLDP_Cycads.`Name`
SELECT SPNUMBER AS ID,
       SPECIES AS scientificName,
       IF(SP2 IS NULL, AUTHOR1, AUTHOR2) AS authorship,
       COALESCE(RANK3, RANK2, RANK1, 'species') AS `rank`,
       NULL AS genus,
       NULL AS specificEpithet,
       NULL AS infraspecificEpithet,
       SPNUMBER AS publishedInID,
       NULL AS publishedInPage,
       'botanical' AS code,
       CASE TAXSTAT WHEN 'dub' THEN 'doubtful'
                    WHEN 'inv' THEN 'unavailable'
                    WHEN 'sup' THEN 'illegitimate' END AS status,
       NULL AS link
FROM WorkDB_Cycads.COL_Cycads;

DROP TABLE IF EXISTS COLDP_Cycads.`Taxon`;
CREATE TABLE COLDP_Cycads.`Taxon`
SELECT
       SPNUMBER AS ID,
       SPNUMBER AS nameID,
       IF (TAXSTAT IN ('?', 'dub'), True, False) AS provisional,
       'Calonje M., Stanberg L. & Stevenson D.' AS accordingTo,
       '0000-0001-9650-3136;;0000-0002-2986-7076' AS accordingToID,
       '2019-02-15' AS accordingToDate,
       False AS fossil,
       True AS recent,
       'Plantae' AS kingdom,
       'Tracheophyta' AS phylum,
       'Cycadopsida' AS class,
       GENUS AS genus,
       FAMILY AS family
FROM WorkDB_Cycads.COL_Cycads WHERE TAXSTAT IN ('acc', 'dub', 'hyb', '?');

DROP TABLE IF EXISTS COLDP_Cycads.`NameRel`;
CREATE TABLE COLDP_Cycads.`NameRel`
SELECT SYNOF AS nameID,
       SPNUMBER AS relatedNameID,
       CASE SYNCAT WHEN 'hom' THEN 'homotypic' WHEN 'bas' THEN 'basionym' END AS type,
       SPNUMBER AS publishedInID,
       NULL AS remarks
FROM WorkDB_Cycads.COL_Cycads WHERE SYNOF != 0 AND SYNCAT IN ('hom', 'bas');

DROP TABLE IF EXISTS COLDP_Cycads.Synonyms;
CREATE TABLE COLDP_Cycads.Synonyms
SELECT SYNOF AS taxonID,
       SPNUMBER AS nameID,
       'synonym' AS status,
       NULL AS remarks
FROM WorkDB_Cycads.COL_Cycads WHERE TAXSTAT='syn';

DROP TABLE IF EXISTS COLDP_Cycads.Distribution;
CREATE TABLE COLDP_Cycads.Distribution
SELECT SPNUMBER AS taxonID,
       COUNTRY AS area,
       'text' AS gazetteer,
       NULL AS status,
       IUCN AS threatStatus
FROM WorkDB_Cycads.COL_Cycads WHERE TAXSTAT IN ('acc', 'dub', 'hyb', '?');


SELECT * FROM WorkDB_Cycads.COL_Cycads INV INNER JOIN WorkDB_Cycads.COL_Cycads SYN ON INV.SPNUMBER = SYN.SYNOF WHERE INV.TAXSTAT="INV";

