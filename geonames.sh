#!/bin/bash
#
# The result is a Linux shell script that allows you to download the GeoNames data dumps from 
# the official site and create a MySQL database structure in which you can import that dumps. 
#
# The script has two different operation modes 
#   Downloading the Geonames data dumps
#   Importing the data into a MySQL database

# Default values for database variables.
DB_HOST="localhost"
DB_PORT=3306
DB_NAME="geonames"
DB_USERNAME="root"
DB_PASSWORD="root"

# Default values for folders.
DMP_DIR="dump"
ZIP_DIR="zip"
SQL_DIR="sql"

#######################################
# Downloading the Geonames data dumps
# Globals:
#   DMP_DIR
#   ZIP_DIR
# Arguments:
#   None
# Returns:
#   None
#######################################
download_geonames_data() {
	echo "Downloading GeoNames data (http://www.geonames.org/)..." 

	# Create the directory DMP_DIR if not exists 
	if [ ! -d "$DMP_DIR" ];then 
		echo "Creating directory '$DMP_DIR'"
		mkdir $DMP_DIR 
	fi 

	# Create the directory ZIP_DIR if not exists 
	if [ ! -d "$ZIP_DIR" ];then 
		echo "Creating directory '$ZIP_DIR'"
		mkdir -p $ZIP_DIR 
	fi 

	dumps="allCountries.zip alternateNames.zip hierarchy.zip admin1CodesASCII.txt admin2Codes.txt featureCodes_en.txt timeZones.txt countryInfo.txt"
	dump_postal_codes="allCountries.zip"

	# Folder DMP_DIR
	for dump in $dumps; do
		echo "Downloading GeoNames data http://download.geonames.org/export/dump/$dump..."
		wget -c -P $DMP_DIR http://download.geonames.org/export/dump/$dump
		if [ ${dump: -4} == ".zip" ]; then
			echo "Unzip $dump in $DMP_DIR"
			unzip -j "$DMP_DIR/$dump" -d $DMP_DIR
			echo "Deleting $DMP_DIR"
			rm "$DMP_DIR/$dump"
		fi
	done

	# Folder ZIP_DIR
	for dump in $dump_postal_codes; do
		echo "Downloading GeoNames data http://download.geonames.org/export/zip/$dump..."
		wget -c -P $ZIP_DIR http://download.geonames.org/export/zip/$dump
		echo "Unzip $dump dans $ZIP_DIR"
		unzip -j "$ZIP_DIR/$dump" -d $ZIP_DIR
		echo "Deleting $dump dans $ZIP_DIR"
		rm "$ZIP_DIR/$dump"
	done
}

db_create() {
	echo "Creating database $DB_NAME..."
	mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME -p$DB_PASSWORD -Bse "DROP DATABASE IF EXISTS $DB_NAME;"
	mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME -p$DB_PASSWORD -Bse "CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8;" 
	mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME -p$DB_PASSWORD -Bse "USE $DB_NAME;" 
}

db_tables_create() {
	echo "Creating tables for database $DB_NAME..."
	mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME -p$DB_PASSWORD -Bse "USE $DB_NAME;" 
	mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME -p$DB_PASSWORD $DB_NAME < $SQL_DIR/geonames_db_struct.sql
}

db_import_dumps() {
	echo "Importing geonames dumps into database $DB_NAME"
	mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME -p$DB_PASSWORD --local-infile=1 $DB_NAME < $SQL_DIR/geonames_import_data.sql
}

download_geonames_data
#db_create
#db_tables_create
#db_import_dumps


if [ $? == 0 ]; then 
	echo "[OK]"
else
	echo "[FAILED]"
fi

exit 0