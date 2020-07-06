BEGIN;

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

COMMIT;