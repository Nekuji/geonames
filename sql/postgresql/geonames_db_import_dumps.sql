BEGIN;

--     DROP SCHEMA IF EXISTS :geonames_schema CASCADE;
--     CREATE SCHEMA :geonames_schema;

--     -- DROP TABLE IF EXISTS :geonames_schema.admin1Codes;
--     CREATE TABLE :geonames_schema.admin1Codes (
--         code varchar(15) DEFAULT NULL,
--         name text,
--         nameAscii text,
--         geonameid int DEFAULT NULL
--     );

--     -- DROP TABLE IF EXISTS :geonames_schema.admin2Codes;
--     CREATE TABLE :geonames_schema.admin2Codes (
--         code varchar(50) DEFAULT NULL,
--         name text,
--         nameAscii text,
--         geonameid int DEFAULT NULL
--     );

--     -- DROP TABLE IF EXISTS :geonames_schema.alternatename;
--     CREATE TABLE :geonames_schema.alternatename (
--         alternatenameId int NOT NULL,
--         geonameid int DEFAULT NULL,
--         isoLanguage varchar(7) DEFAULT NULL,
--         alternateName varchar(200) DEFAULT NULL,
--         isPreferredName boolean DEFAULT NULL,
--         isShortName boolean DEFAULT NULL,
--         isColloquial boolean DEFAULT NULL,
--         isHistoric boolean DEFAULT NULL,
--         "from" varchar(20) DEFAULT NULL,
--         "to" varchar(20) DEFAULT NULL
--     );

--     -- DROP TABLE IF EXISTS :geonames_schema.continentCodes;
--     CREATE TABLE :geonames_schema.continentCodes (
--         code varchar(2) DEFAULT NULL,
--         name varchar(20) DEFAULT NULL,
--         geonameid int DEFAULT NULL
--     );

--     -- DROP TABLE IF EXISTS :geonames_schema.countryinfo;
--     CREATE TABLE :geonames_schema.countryinfo (
--         iso_alpha2 char(2) DEFAULT NULL,
--         iso_alpha3 char(3) DEFAULT NULL,
--         iso_numeric integer DEFAULT NULL,
--         fips_code varchar(3) DEFAULT NULL,
--         name varchar(200) DEFAULT NULL,
--         capital varchar(200) DEFAULT NULL,
--         areainsqkm double precision DEFAULT NULL,
--         population integer DEFAULT NULL,
--         continent varchar(2) DEFAULT NULL,
--         tld varchar(3) DEFAULT NULL,
--         currency varchar(3) DEFAULT NULL,
--         currencyName varchar(20) DEFAULT NULL,
--         phone varchar(20) DEFAULT NULL,
--         postalCodeFormat varchar(100) DEFAULT NULL,
--         postalCodeRegex varchar(255) DEFAULT NULL,
--         geonameid int DEFAULT NULL,
--         languages varchar(200) DEFAULT NULL,
--         neighbors varchar(100) DEFAULT NULL,
--         equivalentFipsCode varchar(10) DEFAULT NULL
--     );

--     -- DROP TABLE IF EXISTS :geonames_schema.featurecodes;
--     CREATE TABLE :geonames_schema.featurecodes (
--         code varchar(7) DEFAULT NULL,
--         name varchar(200) DEFAULT NULL,
--         description text
--     );

--     -- DROP TABLE IF EXISTS :geonames_schema.geoname;
--     CREATE TABLE :geonames_schema.geoname (
--         geonameid int NOT NULL,
--         name varchar(200) DEFAULT NULL,
--         asciiname varchar(200) DEFAULT NULL,
--         alternatenames text DEFAULT NULL,
--         latitude float DEFAULT NULL,
--         longitude float DEFAULT NULL,
--         fclass char(1) DEFAULT NULL,
--         fcode varchar(10) DEFAULT NULL,
--         country varchar(2) DEFAULT NULL,
--         cc2 varchar(200) DEFAULT NULL,
--         admin1 varchar(20) DEFAULT NULL,
--         admin2 varchar(80) DEFAULT NULL,
--         admin3 varchar(20) DEFAULT NULL,
--         admin4 varchar(20) DEFAULT NULL,
--         population bigint DEFAULT NULL,
--         elevation int DEFAULT NULL,
--         gtopo30 int DEFAULT NULL,
--         timezone varchar(40) DEFAULT NULL,
--         moddate date DEFAULT NULL
--     );

--     -- DROP TABLE IF EXISTS :geonames_schema.hierarchy;
--     CREATE TABLE :geonames_schema.hierarchy (
--         parentId int DEFAULT NULL,
--         childId int DEFAULT NULL,
--         type varchar(50) DEFAULT NULL
--     );

--     -- DROP TABLE IF EXISTS :geonames_schema.iso_languagecodes;
--     CREATE TABLE :geonames_schema.iso_languagecodes (
--         iso_639_3 char(4) DEFAULT NULL,
--         iso_639_2 varchar(50) DEFAULT NULL,
--         iso_639_1 varchar(50) DEFAULT NULL,
--         language_name varchar(200) DEFAULT NULL
--     );

--     -- DROP TABLE IF EXISTS :geonames_schema.timeZones;
--     CREATE TABLE :geonames_schema.timeZones (
--         country varchar(2) DEFAULT NULL,
--         timeZoneId varchar(200) DEFAULT NULL,
--         GMT_offset numeric(3,1) DEFAULT NULL,
--         DST_offset numeric(3,1) DEFAULT NULL,
--         RAW_offset numeric(3,1) DEFAULT NULL
--     );

--     -- DROP TABLE IF EXISTS :geonames_schema.postalCodes;
--     CREATE TABLE :geonames_schema.postalCodes (
--         country varchar(2) DEFAULT NULL,
--         postal_code varchar(20) DEFAULT NULL,
--         name varchar(180) DEFAULT NULL,
--         admin1_name varchar(100) DEFAULT NULL,
--         admin1_code varchar(20) DEFAULT NULL,
--         admin2_name varchar(100) DEFAULT NULL,
--         admin2_code varchar(20) DEFAULT NULL,
--         admin3_name varchar(100) DEFAULT NULL,
--         admin3_code varchar(20) DEFAULT NULL,
--         latitude numeric(10,7) DEFAULT NULL,
--         longitude numeric(10,7) DEFAULT NULL,
--         accuracy smallint DEFAULT NULL
--     );

    ALTER TABLE ONLY :geonames_schema.admin1Codes DROP CONSTRAINT IF EXISTS pk_admin1id;
    DROP INDEX IF EXISTS :geonames_schema.index_admin1codes_on_code;
    DROP INDEX IF EXISTS :geonames_schema.index_admin1codes_on_name;
    DROP INDEX IF EXISTS :geonames_schema.index_admin1codes_on_nameascii;
    DROP INDEX IF EXISTS :geonames_schema.index_admin1codes_on_geonameid;

    ALTER TABLE ONLY :geonames_schema.admin2Codes DROP CONSTRAINT IF EXISTS pk_admin2id;
    DROP INDEX IF EXISTS :geonames_schema.index_admin2codes_on_code;
    DROP INDEX IF EXISTS :geonames_schema.index_admin2codes_on_name;
    DROP INDEX IF EXISTS :geonames_schema.index_admin2codes_on_nameascii;
    DROP INDEX IF EXISTS :geonames_schema.index_admin2codes_on_geonameid;

    ALTER TABLE ONLY :geonames_schema.alternatename DROP CONSTRAINT IF EXISTS pk_alternatenameid;
    DROP INDEX IF EXISTS :geonames_schema.index_alternatename_on_geonameid;
    DROP INDEX IF EXISTS :geonames_schema.index_alternatename_on_isolanguage;
    DROP INDEX IF EXISTS :geonames_schema.index_alternatename_on_alternatename;
    DROP INDEX IF EXISTS :geonames_schema.index_alternatename_on_geonameid_isolanguage;

    ALTER TABLE ONLY :geonames_schema.continentCodes DROP CONSTRAINT IF EXISTS pk_continentcodesid;
    DROP INDEX IF EXISTS :geonames_schema.index_continentcodes_on_code;
    DROP INDEX IF EXISTS :geonames_schema.index_continentcodes_on_name;
    DROP INDEX IF EXISTS :geonames_schema.index_continentcodes_on_geonameid;

    ALTER TABLE ONLY :geonames_schema.countryinfo DROP CONSTRAINT IF EXISTS pk_iso_alpha2;
    DROP INDEX IF EXISTS :geonames_schema.index_countryinfo_on_iso_alpha2;
    DROP INDEX IF EXISTS :geonames_schema.index_countryinfo_on_iso_alpha3;
    DROP INDEX IF EXISTS :geonames_schema.index_countryinfo_on_iso_numeric;
    DROP INDEX IF EXISTS :geonames_schema.index_countryinfo_on_fips_code;
    DROP INDEX IF EXISTS :geonames_schema.index_countryinfo_on_name;

    ALTER TABLE ONLY :geonames_schema.featurecodes DROP CONSTRAINT IF EXISTS pk_code;
    DROP INDEX IF EXISTS :geonames_schema.index_featurecodes_on_code;
    DROP INDEX IF EXISTS :geonames_schema.index_featurecodes_on_name;

    ALTER TABLE ONLY :geonames_schema.geoname DROP CONSTRAINT IF EXISTS pk_geonameid;
    DROP INDEX IF EXISTS :geonames_schema.index_geoname_on_name;
    DROP INDEX IF EXISTS :geonames_schema.index_geoname_on_asciiname;
    DROP INDEX IF EXISTS :geonames_schema.index_geoname_on_latitude;
    DROP INDEX IF EXISTS :geonames_schema.index_geoname_on_longitude;
    DROP INDEX IF EXISTS :geonames_schema.index_geoname_on_fclass;
    DROP INDEX IF EXISTS :geonames_schema.index_geoname_on_fcode;
    DROP INDEX IF EXISTS :geonames_schema.index_geoname_on_country;
    DROP INDEX IF EXISTS :geonames_schema.index_geoname_on_cc2;
    DROP INDEX IF EXISTS :geonames_schema.index_geoname_on_admin1;
    DROP INDEX IF EXISTS :geonames_schema.index_geoname_on_population;
    DROP INDEX IF EXISTS :geonames_schema.index_geoname_on_elevation;
    DROP INDEX IF EXISTS :geonames_schema.index_geoname_on_timezone;
    DROP INDEX IF EXISTS :geonames_schema.index_geoname_on_asciiname_fclass;
    -- CREATE INDEX index_geoname_on_alternatenames_fclass ON :geonames_schema.geoname (alternatenames,fclass);
    
    DROP INDEX IF EXISTS :geonames_schema.index_hierarchy_on_parentid;
    DROP INDEX IF EXISTS :geonames_schema.index_hierarchy_on_childid;

    DROP INDEX IF EXISTS :geonames_schema.index_postalcodes_on_country;
    DROP INDEX IF EXISTS :geonames_schema.index_postalcodes_on_postal_code;
    DROP INDEX IF EXISTS :geonames_schema.index_postalcodes_on_name;
    DROP INDEX IF EXISTS :geonames_schema.index_postalcodes_on_admin1_name;
    DROP INDEX IF EXISTS :geonames_schema.index_postalcodes_on_admin1_code;
    DROP INDEX IF EXISTS :geonames_schema.index_postalcodes_on_latitude;
    DROP INDEX IF EXISTS :geonames_schema.index_postalcodes_on_longitude;

    -- Truncate all tables to copy freeze the GeoNames data dump
    TRUNCATE TABLE :geonames_schema.geoname;
    TRUNCATE TABLE :geonames_schema.alternatename;
    TRUNCATE TABLE :geonames_schema.countryinfo;
    TRUNCATE TABLE :geonames_schema.iso_languagecodes;
    TRUNCATE TABLE :geonames_schema.admin1Codes;
    TRUNCATE TABLE :geonames_schema.admin2Codes;
    TRUNCATE TABLE :geonames_schema.hierarchy;
    TRUNCATE TABLE :geonames_schema.featureCodes;
    TRUNCATE TABLE :geonames_schema.timeZones;
    TRUNCATE TABLE :geonames_schema.continentCodes;
    TRUNCATE TABLE :geonames_schema.postalCodes;

    \COPY :geonames_schema.geoname (geonameid, name, asciiname, alternatenames, latitude, longitude, fclass, fcode, country, cc2, admin1, admin2, admin3, admin4, population, elevation, gtopo30, timezone, moddate) FROM ':geonames_path/dump/allCountries.txt' (FREEZE TRUE, NUll '');

    \COPY :geonames_schema.alternateName (alternatenameid, geonameid, isoLanguage, alternateName, isPreferredName, isShortName, isColloquial, isHistoric, "from", "to") FROM ':geonames_path/dump/alternateNamesV2.txt' (FREEZE TRUE, NUll '');

    \COPY :geonames_schema.iso_languagecodes (iso_639_3, iso_639_2, iso_639_1, language_name) FROM ':geonames_path/dump/iso-languagecodes.txt' (FREEZE TRUE, NUll '');

    \COPY :geonames_schema.admin1Codes (code, name, nameAscii, geonameid) FROM ':geonames_path/dump/admin1CodesASCII.txt' (FREEZE TRUE, NUll '');

    \COPY :geonames_schema.admin2Codes (code, name, nameAscii, geonameid) FROM ':geonames_path/dump/admin2Codes.txt' (FREEZE TRUE, NUll '');

    \COPY :geonames_schema.hierarchy (parentId, childId, type) FROM ':geonames_path/dump/hierarchy.txt' (FREEZE TRUE, NUll '');

    \COPY :geonames_schema.featureCodes (code, name, description) FROM ':geonames_path/dump/featureCodes_en.txt' (FREEZE TRUE, NUll '');

    \COPY :geonames_schema.timeZones (country, timeZoneId, GMT_offset, DST_offset, RAW_offset) FROM ':geonames_path/dump/timeZones.txt' (FREEZE TRUE, NUll '');

    \COPY :geonames_schema.countryinfo (iso_alpha2, iso_alpha3, iso_numeric, fips_code, name, capital, areaInSqKm, population, continent, tld, currency, currencyName, phone, postalCodeFormat, postalCodeRegex, languages, geonameid, neighbors, equivalentFipsCode) FROM ':geonames_path/dump/countryInfo.txt' (FREEZE TRUE, NUll '');

    \COPY :geonames_schema.continentCodes (code, name, geonameId) FROM ':geonames_path/sql/continentCodes.txt' (DELIMITER(','), FREEZE TRUE, NUll '');

    \COPY :geonames_schema.postalCodes (country, postal_code, name, admin1_name, admin1_code, admin2_name, admin2_code, admin3_name, admin3_code, latitude, longitude, accuracy) FROM ':geonames_path/zip/allCountries.txt' (FREEZE TRUE, NUll '');

    ALTER TABLE ONLY :geonames_schema.admin1Codes ADD CONSTRAINT pk_admin1id PRIMARY KEY (geonameid);
    CREATE INDEX index_admin1codes_on_code ON :geonames_schema.admin1Codes (code);
    CREATE INDEX index_admin1codes_on_name ON :geonames_schema.admin1Codes (name);
    CREATE INDEX index_admin1codes_on_nameascii ON :geonames_schema.admin1Codes (nameascii);
    CREATE INDEX index_admin1codes_on_geonameid ON :geonames_schema.admin1Codes (geonameid);

    ALTER TABLE ONLY :geonames_schema.admin2Codes ADD CONSTRAINT pk_admin2id PRIMARY KEY (geonameid);
    CREATE INDEX index_admin2codes_on_code ON :geonames_schema.admin2Codes (code);
    CREATE INDEX index_admin2codes_on_name ON :geonames_schema.admin2Codes (name);
    CREATE INDEX index_admin2codes_on_nameascii ON :geonames_schema.admin2Codes (nameascii);
    CREATE INDEX index_admin2codes_on_geonameid ON :geonames_schema.admin2Codes (geonameid);

    ALTER TABLE ONLY :geonames_schema.alternatename ADD CONSTRAINT pk_alternatenameid PRIMARY KEY (alternatenameId);
    CREATE INDEX index_alternatename_on_geonameid ON :geonames_schema.alternatename (geonameid);
    CREATE INDEX index_alternatename_on_isolanguage ON :geonames_schema.alternatename (isolanguage);
    CREATE INDEX index_alternatename_on_alternatename ON :geonames_schema.alternatename USING btree (alternateName);
    CREATE INDEX index_alternatename_on_geonameid_isolanguage ON :geonames_schema.alternatename (geonameid, isoLanguage);

    ALTER TABLE ONLY :geonames_schema.continentCodes ADD CONSTRAINT pk_continentcodesid PRIMARY KEY (geonameid);
    CREATE INDEX index_continentcodes_on_code ON :geonames_schema.continentCodes (code);
    CREATE INDEX index_continentcodes_on_name ON :geonames_schema.continentCodes (name);
    CREATE INDEX index_continentcodes_on_geonameid ON :geonames_schema.continentCodes (geonameid);

    ALTER TABLE ONLY :geonames_schema.countryinfo ADD CONSTRAINT pk_iso_alpha2 PRIMARY KEY (iso_alpha2);
    CREATE INDEX index_countryinfo_on_iso_alpha2 ON :geonames_schema.countryinfo (iso_alpha2);
    CREATE INDEX index_countryinfo_on_iso_alpha3 ON :geonames_schema.countryinfo (iso_alpha3);
    CREATE INDEX index_countryinfo_on_iso_numeric ON :geonames_schema.countryinfo (iso_numeric);
    CREATE INDEX index_countryinfo_on_fips_code ON :geonames_schema.countryinfo (fips_code);
    CREATE INDEX index_countryinfo_on_name ON :geonames_schema.countryinfo (name);

    ALTER TABLE ONLY :geonames_schema.featurecodes ADD CONSTRAINT pk_code PRIMARY KEY (code);
    CREATE INDEX index_featurecodes_on_code ON :geonames_schema.featurecodes (code);
    CREATE INDEX index_featurecodes_on_name ON :geonames_schema.featurecodes (name);

    ALTER TABLE ONLY :geonames_schema.geoname ADD CONSTRAINT pk_geonameid PRIMARY KEY (geonameid);
    CREATE INDEX index_geoname_on_name ON :geonames_schema.geoname USING btree (name);
    CREATE INDEX index_geoname_on_asciiname ON :geonames_schema.geoname (asciiname);
    CREATE INDEX index_geoname_on_latitude ON :geonames_schema.geoname (latitude);
    CREATE INDEX index_geoname_on_longitude ON :geonames_schema.geoname (longitude);
    CREATE INDEX index_geoname_on_fclass ON :geonames_schema.geoname (fclass);
    CREATE INDEX index_geoname_on_fcode ON :geonames_schema.geoname (fcode);
    CREATE INDEX index_geoname_on_country ON :geonames_schema.geoname (country);
    CREATE INDEX index_geoname_on_cc2 ON :geonames_schema.geoname (cc2);
    CREATE INDEX index_geoname_on_admin1 ON :geonames_schema.geoname (admin1);
    CREATE INDEX index_geoname_on_population ON :geonames_schema.geoname (population);
    CREATE INDEX index_geoname_on_elevation ON :geonames_schema.geoname (elevation);
    CREATE INDEX index_geoname_on_timezone ON :geonames_schema.geoname (timezone);
    CREATE INDEX index_geoname_on_asciiname_fclass ON :geonames_schema.geoname (asciiname, fclass);
    -- CREATE INDEX index_geoname_on_alternatenames_fclass ON :geonames_schema.geoname (alternatenames,fclass);
    
    CREATE INDEX index_hierarchy_on_parentid ON :geonames_schema.hierarchy (parentId);
    CREATE INDEX index_hierarchy_on_childid ON :geonames_schema.hierarchy (childId);

    CREATE INDEX index_postalcodes_on_country ON :geonames_schema.postalCodes (country);
    CREATE INDEX index_postalcodes_on_postal_code ON :geonames_schema.postalCodes (postal_code);
    CREATE INDEX index_postalcodes_on_name ON :geonames_schema.postalCodes (name);
    CREATE INDEX index_postalcodes_on_admin1_name ON :geonames_schema.postalCodes (admin1_name);
    CREATE INDEX index_postalcodes_on_admin1_code ON :geonames_schema.postalCodes (admin1_code);
    CREATE INDEX index_postalcodes_on_latitude ON :geonames_schema.postalCodes (latitude);
    CREATE INDEX index_postalcodes_on_longitude ON :geonames_schema.postalCodes (longitude);

COMMIT;