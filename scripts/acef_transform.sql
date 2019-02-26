DROP SCHEMA IF EXISTS ACEF_Cycads;
CREATE SCHEMA ACEF_Cycads CHARSET utf8 COLLATE utf8_general_ci;

DROP TABLE IF EXISTS ACEF_Cycads.`References`;
CREATE TABLE ACEF_Cycads.`References`
SELECT SPNUMBER AS ReferenceID,
       TRIM(IF(SP2 IS NULL, SUBSTRING_INDEX(SUBSTRING_INDEX(AUTHOR1, ')', 2), ')', -1), SUBSTRING_INDEX(SUBSTRING_INDEX(AUTHOR2, ')', 2), ')', -1))) AS Authors,
       YEAR AS Year,
       NULL AS Title,
       CONCAT('In: ', CITATION) AS Details
FROM WorkDB_Cycads.COL_Cycads;

DROP TABLE IF EXISTS ACEF_Cycads.`NameReferencesLinks`;
CREATE TABLE ACEF_Cycads.`NameReferencesLinks`
SELECT SPNUMBER AS ID,
       'NomRef' AS ReferenceType,
       SPNUMBER AS ReferenceID
FROM WorkDB_Cycads.COL_Cycads;

DROP TABLE IF EXISTS ACEF_Cycads.AcceptedSpecies;
CREATE TABLE ACEF_Cycads.AcceptedSpecies
SELECT SPNUMBER                                                       AS AcceptedTaxonID,
       'Plantae'                                                      AS Kingdom,
       'Tracheophyta'                                                 AS Phylum,
       'Cycadopsida'                                                  AS Class,
       'Cycadales'                                                    AS `Order`,
       NULL                                                           AS Superfamily,
       FAMILY                                                         AS Family,
       GENUS                                                          AS Genus,
       NULL                                                           AS SubGenusName,
       SP1                                                            AS SpeciesEpithet,
       AUTHOR1                                                        AS AuthorString,
       NULL                                                           AS GSDNameStatus,
       IF(TAXSTAT IN ('dub', '?'), 4, 1)                              AS Sp2000NameStatus,
       0                                                              AS IsExtinct,
       0                                                              AS HasPreHolocene,
       1                                                              AS HasModern,
       'terrestrial'                                                  AS LifeZone,
       IF(TAXSTAT = 'hyb', CONCAT('Hybrid formula: ', SPECIES), NULL) AS AdditionalData,
       'Calonje M., Stevenson D.W., Osborne R.'                       AS LTSSpecialist,
       'Feb 2019'                                                     AS LTSDate,
       NULL                                                           AS SpeciesURL,
       NULL                                                           AS GSDTaxonGUID,
       NULL                                                           AS GSDNameGUID
FROM WorkDB_Cycads.COL_Cycads
WHERE TAXSTAT IN ('acc')
  AND SP2 IS NULL;


DROP TABLE IF EXISTS ACEF_Cycads.AcceptedInfraSpecificTaxa;
CREATE TABLE ACEF_Cycads.AcceptedInfraSpecificTaxa
SELECT INFRA.SPNUMBER                                                             AS AcceptedTaxonID,
       SP.SPNUMBER                                                                AS ParentSpeciesID,
       INFRA.SP2                                                                  AS InfraSpeciesEpithet,
       INFRA.AUTHOR2                                                              AS InfraSpeciesAuthorString,
       INFRA.RANK1                                                                AS InfraSpeciesMarker,
       NULL                                                                       AS GSDNameStatus,
       IF(INFRA.TAXSTAT IN ('dub', '?'), 4, 1)                                    AS Sp2000NameStatus,
       0                                                                          AS IsExtinct,
       0                                                                          AS HasPreHolocene,
       1                                                                          AS HasModern,
       'terrestrial'                                                              AS LifeZone,
       IF(INFRA.TAXSTAT = 'hyb', CONCAT('Hybrid formula: ', INFRA.SPECIES), NULL) AS AdditionalData,
       'Calonje M., Stevenson D.W., Osborne R.'                                   AS LTSSpecialist,
       'Feb 2019'                                                                 AS LTSDate,
       NULL                                                                       AS InfraSpeciesURL,
       NULL                                                                       AS GSDTaxonGUID,
       NULL                                                                       AS GSDNameGUID
FROM WorkDB_Cycads.COL_Cycads SP
            INNER JOIN WorkDB_Cycads.COL_Cycads INFRA
                       ON SP.GENUS = INFRA.GENUS AND SP.SP1 = INFRA.SP1 AND SP.SP2 IS NULL OR SP.SP2 = ''
WHERE INFRA.TAXSTAT IN ('acc')
  AND INFRA.SP2 IS NOT NULL;


DROP TABLE IF EXISTS ACEF_Cycads.Synonyms;
CREATE TABLE ACEF_Cycads.Synonyms
SELECT SPNUMBER AS ID,
       SYNOF AS AcceptedTaxonID,
       GENUS AS Genus,
       NULL AS SubGenusName,
       SP1 AS SpeciesEpithet,
       IF (SP2 IS NULL, AUTHOR1, NULL) AS AuthorString,
       SP2 AS InfraSpecies,
       RANK1 AS InfraSpeciesMarker,
       IF (SP2 IS NULL, NULL, AUTHOR2) AS InfraSpeciesAuthorString,
       NULL AS GSDNameStatus,
       5 AS Sp2000NameStatus,
       NULL AS GSDNameGUID
FROM WorkDB_Cycads.COL_Cycads WHERE TAXSTAT='syn' OR (TAXSTAT = 'inv' AND SYNOF != 0);

DROP TABLE IF EXISTS ACEF_Cycads.Distribution;
CREATE TABLE ACEF_Cycads.Distribution
SELECT SPNUMBER AS AcceptedTaxonID,
       COUNTRY AS DistributionElement,
       'text' AS StandardInUse,
       NULL AS DistributionStatus
FROM WorkDB_Cycads.COL_Cycads WHERE COUNTRY IS NOT NULL;


