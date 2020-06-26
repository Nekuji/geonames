COPY :geonames_schema.geoname
(geonameid, name, asciiname, alternatenames, latitude, longitude, fclass, fcode, country, cc2, admin1, admin2, admin3, admin4, population, elevation, gtopo30, timezone, moddate)
FROM ':geonames_path/dump/allCountries.txt';

COPY :geonames_schema.alternatename
(alternatenameid, geonameid, isoLanguage, alternateName, isPreferredName, isShortName, isColloquial, isHistoric)
FROM ':geonames_path/dump/alternateNames.txt';

COPY :geonames_schema.iso_languagecodes
(iso_639_3, iso_639_2, iso_639_1, language_name)
FROM ':geonames_path/dump/iso-languagecodes.txt';

COPY :geonames_schema.admin1Codes
(code, name, nameAscii, geonameid)
FROM ':geonames_path/dump/admin1CodesASCII.txt';

COPY :geonames_schema.admin2Codes
(code, name, nameAscii, geonameid)
FROM ':geonames_path/dump/admin2Codes.txt';

COPY :geonames_schema.hierarchy
(parentId, childId, type)
FROM ':geonames_path/dump/hierarchy.txt';

COPY :geonames_schema.featureCodes
(code, name, description)
FROM ':geonames_path/dump/featureCodes_en.txt';

CREATE TEMP TABLE timeZones_tmp (
  timeZoneId varchar(200) DEFAULT NULL,
  extra_column_1 varchar(200) DEFAULT NULL,
  GMT_offset numeric(3,1) DEFAULT NULL,
  DST_offset numeric(3,1) DEFAULT NULL,
  extra_column_2 numeric(3,1) DEFAULT NULL
);
COPY timeZones_tmp FROM ':geonames_path/dump/timeZones.txt';

INSERT INTO :geonames_schema.timeZones (timeZoneId, GMT_offset, DST_offset)
SELECT timeZoneId, GMT_offset, DST_offset FROM timeZones_tmp;

COPY :geonames_schema.countryinfo
(iso_alpha2, iso_alpha3, iso_numeric, fips_code, name, capital, areaInSqKm, population, continent, tld, currency, currencyName, phone, postalCodeFormat, postalCodeRegex, languages, geonameid, neighbors, equivalentFipsCode)
FROM ':geonames_path/dump/countryInfo.txt';

COPY :geonames_schema.continentCodes
(code, name, geonameId)
FROM ':geonames_path/sql/continentCodes.txt' (DELIMITER(','));

-- COPY :geonames_schema.postalCodes
-- (country, postal_code, name, admin1_name, admin1_code, admin2_name, admin2_code, admin3_name, admin3_code, latitude, longitude, accuracy)
-- FROM 'zip/allCountries.txt';
