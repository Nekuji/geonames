#!/bin/bash
#
# The result is a Linux shell script that allows you to download the GeoNames data dumps from
# the official site and create a database structure in which you can import that dumps.
#
# The script has two different operation modes
#   Downloading the Geonames data dumps
#   Importing the data into a database (it can be in MySQL or PostgreSQL)

# Default values for database variables.
DB_MANAGEMENT_SYS="mysql"
DB_HOST="localhost"
DB_PORT=3306
DB_NAME="geonames"
DB_SCHEMA="geonames"
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
	if [ ! -d "$DMP_DIR" ]; then
		echo "Creating directory [$DMP_DIR]"
		mkdir $DMP_DIR
	fi

	# Create the directory ZIP_DIR if not exists
	if [ ! -d "$ZIP_DIR" ]; then
		echo "Creating directory [$ZIP_DIR]"
		mkdir -p $ZIP_DIR
	fi

	dumps="admin1CodesASCII.txt admin2Codes.txt allCountries.zip alternateNamesV2.zip countryInfo.txt featureCodes_en.txt hierarchy.zip iso-languagecodes.txt timeZones.txt"
	dump_postal_codes="allCountries.zip"

	# Folder DMP_DIR
	for dump in $dumps; do
		echo "Downloading GeoNames data http://download.geonames.org/export/dump/$dump..."
		wget -c -P $DMP_DIR http://download.geonames.org/export/dump/$dump
		if [ ${dump: -4} == ".zip" ]; then
			echo "Unzip [$dump] in [$DMP_DIR]"
			unzip -j "$DMP_DIR/$dump" -d $DMP_DIR
			echo "Deleting [$dump] in [$DMP_DIR]"
			rm "$DMP_DIR/$dump"
		fi
		
		# Skip the header or the comments. It will generate a temp file and then overwrite the original with a clean content.
		case $dump in
		iso-languagecodes.txt)
			tail -n +2 "$DMP_DIR/$dump" > "$DMP_DIR/$dump.tmp" && mv "$DMP_DIR/$dump.tmp" "$DMP_DIR/$dump";
			;;
		countryInfo.txt)
			grep -v '^#' "$DMP_DIR/$dump" | head -n -2 > "$DMP_DIR/$dump.tmp" && mv "$DMP_DIR/$dump.tmp" "$DMP_DIR/$dump";
			;;
		timeZones.txt)
			tail -n +2 "$DMP_DIR/$dump" > "$DMP_DIR/$dump.tmp" && mv "$DMP_DIR/$dump.tmp" "$DMP_DIR/$dump";
			;;
		esac
	done

	# Folder ZIP_DIR
	for dump in $dump_postal_codes; do
		echo "Downloading GeoNames data http://download.geonames.org/export/zip/$dump..."
		wget -c -P $ZIP_DIR http://download.geonames.org/export/zip/$dump
		echo "Unzip [$dump] in [$ZIP_DIR]"
		unzip -j "$ZIP_DIR/$dump" -d $ZIP_DIR
		echo "Deleting [$dump] in [$ZIP_DIR]"
		rm "$ZIP_DIR/$dump"
	done
}

#######################################
# Deleting DMP_DIR and ZIP_DIR folders
# Globals:
#   DMP_DIR
#   ZIP_DIR
# Arguments:
#   None
# Returns:
#   None
#######################################
download_geonames_data_delete() {
	echo "Deleting [$DMP_DIR] folders"
	rm -R $DMP_DIR

	echo "Deleting [$ZIP_DIR] folders"
	rm -R $ZIP_DIR
}

#######################################
# Creating $DB_NAME database
# Globals:
#   DB_HOST
#   DB_PORT
#   DB_USERNAME
#   DB_PASSWORD
#	DB_NAME
#	DB_SCHEMA
# Arguments:
#   None
# Returns:
#   None
#######################################
db_create() {
	echo "Creating database [$DB_NAME] in [$DB_MANAGEMENT_SYS]..."
	if [[ "$DB_MANAGEMENT_SYS" == "mysql" ]]; then
		mysql -h $DB_HOST -P $DB_PORT -u$DB_USERNAME -p$DB_PASSWORD -Bse "DROP DATABASE IF EXISTS $DB_NAME;"
		mysql -h $DB_HOST -P $DB_PORT -u$DB_USERNAME -p$DB_PASSWORD -Bse "CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8;"
		mysql -h $DB_HOST -P $DB_PORT -u$DB_USERNAME -p$DB_PASSWORD -Bse "USE $DB_NAME;"
	else
		psql -h $DB_HOST -p $DB_PORT -U $DB_USERNAME -d $DB_NAME -c "DROP SCHEMA IF EXISTS $DB_SCHEMA CASCADE;"
		psql -h $DB_HOST -p $DB_PORT -U $DB_USERNAME -d $DB_NAME -c "CREATE SCHEMA $DB_SCHEMA;"
	fi
}

#######################################
# Creating tables for $DB_NAME database
# Globals:
#   DB_HOST
#   DB_PORT
#   DB_USERNAME
#   DB_PASSWORD
#   SQL_DIR
# Arguments:
#   None
# Returns:
#   None
#######################################
db_tables_create() {
	echo "Creating tables for database [$DB_NAME] in [$DB_MANAGEMENT_SYS]..."
	if [[ "$DB_MANAGEMENT_SYS" == "mysql" ]]; then
		mysql -h $DB_HOST -P $DB_PORT -u$DB_USERNAME -p$DB_PASSWORD -Bse "USE $DB_NAME;"
		mysql -h $DB_HOST -P $DB_PORT -u$DB_USERNAME -p$DB_PASSWORD $DB_NAME <$SQL_DIR/$DB_MANAGEMENT_SYS/geonames_db_tables_create.sql
	else
		psql -h $DB_HOST -p $DB_PORT -U $DB_USERNAME -d $DB_NAME -v geonames_schema=$DB_SCHEMA -f $SQL_DIR/$DB_MANAGEMENT_SYS/geonames_db_tables_create.sql
	fi
}

#######################################
# Importing geonames dumps into database $DB_NAME
# Globals:
#   DB_HOST
#   DB_PORT
#   DB_USERNAME
#   DB_PASSWORD
#   SQL_DIR
# Arguments:
#   None
# Returns:
#   None
#######################################
db_import_dumps() {
	echo "Importing GeoNames dumps into database [$DB_NAME] in [$DB_MANAGEMENT_SYS]. Please wait a moment..."
	FILEPATH=$SQL_DIR/$DB_MANAGEMENT_SYS/geonames_db_import_dumps.sql
	if [[ "$DB_MANAGEMENT_SYS" == "mysql" ]]; then
		mysql -h $DB_HOST -P $DB_PORT -u$DB_USERNAME -p$DB_PASSWORD --local-infile=1 $DB_NAME <$FILEPATH
	else
		COPYFILE="$SQL_DIR/$DB_MANAGEMENT_SYS/import_geonames.sql"
		cp $FILEPATH $COPYFILE
		SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
		echo $SCRIPTPATH
		sed -i "s~:geonames_path~$SCRIPTPATH~g" $COPYFILE
		psql -h $DB_HOST -p $DB_PORT -U $DB_USERNAME -d $DB_NAME -v geonames_schema=$DB_SCHEMA -v geonames_path=$SCRIPTPATH -f "$COPYFILE"
		rm $COPYFILE
	fi
}

#######################################
# Dropping $DB_NAME database
# Globals:
#   DB_HOST
#   DB_PORT
#   DB_USERNAME
#   DB_PASSWORD
# Arguments:
#   None
# Returns:
#   None
#######################################
db_drop() {
	echo "Dropping [$DB_NAME] database in [$DB_MANAGEMENT_SYS]..."
	if [[ "$DB_MANAGEMENT_SYS" == "mysql" ]]; then
		mysql -h $DB_HOST -P $DB_PORT -u$DB_USERNAME -p$DB_PASSWORD -Bse "DROP DATABASE IF EXISTS $DB_NAME;"
	else
		psql -h $DB_HOST -p $DB_PORT -U $DB_USERNAME -d $DB_NAME -c "DROP SCHEMA IF EXISTS $DB_SCHEMA CASCADE;"
	fi
}

#######################################
# Truncating $DB_NAME database
# Globals:
#   DB_HOST
#   DB_PORT
#   DB_USERNAME
#   DB_PASSWORD
#   SQL_DIR
# Arguments:
#   None
# Returns:
#   None
#######################################
db_truncate() {
	echo "Truncating [$DB_NAME] database in [$DB_MANAGEMENT_SYS]..."
	if [[ "$DB_MANAGEMENT_SYS" == "mysql" ]]; then
		mysql -h $DB_HOST -P $DB_PORT -u$DB_USERNAME -p$DB_PASSWORD $DB_NAME <$SQL_DIR/$DB_MANAGEMENT_SYS/geonames_db_truncate.sql
	else
		psql -h $DB_HOST -p $DB_PORT -U $DB_USERNAME -d $DB_NAME -v geonames_schema=$DB_SCHEMA -f $SQL_DIR/$DB_MANAGEMENT_SYS/geonames_db_truncate.sql
	fi
}

#######################################
# The command line help
#######################################
display_help() {
	filename=$(basename "$0")
	echo
	echo "This Linux shell script allows you to download the GeoNames data dumps from the official site and create a database structure in which you can import that dumps."
	echo
	echo "Usage: ./$filename [option] [argument] ..."
	echo "  -a                 : executes an action with the provided argument. Check the action arguments below."
	echo "  -m                 : set the database management system. Only the MySQL and PostgreSQL are available."
	echo "  -u                 : database user for login."
	echo "                  : database password for login."
	echo "  -h                 : database hostname."
	echo "  -p                 : database port."
	echo "  -d                 : database name."
	echo "  -s                 : database schema (for PostgreSQL)."
	echo
	echo "Action arguments:"
	echo "  all                : Performs the following actions respectively:"
	echo "                       download-data, db-create, tables-create and db-import"
	echo "  db-create          : Drop the geonames database and create a new one"
	echo "  db-drop            : Drop the geonames database"
	echo "  db-import          : Import GeoNames data dumps into the current database"
	echo "  db-truncate        : Truncate all GeoNames tables from the current database"
	echo "  download-data      : Download the GeoNames data dumps"
	echo "  download-delete    : Delete the folders with the GeoNames data dump"
	echo "  tables-create      : Create the GeoNames tables"
	echo
	echo "If no option is provided to connect, it will use the MySQL database and its default values:"
	echo "  Host     : localhost"
	echo "  Port     : 3306"
	echo "  Database : geonames"
	echo "  User     : root"
	echo "  Passowrd : root"
	echo
	echo "Example of usage for MySQL:"
	echo
	echo "  $ ./$filename -a all -m mysql -u root -w root -h localhost -p 3306 -d geonames"
	echo
	echo "Example of usage for PostgreSQL (needs to provide the schema):"
	echo
	echo "  $ ./$filename -a all -m postgresql -u root -h localhost -p 3306 -d postgres -s geonames"
	echo
}

# Deals with operation mode 2 (Database issues...)
# Parses command line parameters.
while (($#)); do
	case $1 in
	-a | --action)
		action=$2
		shift
		;;
	-m | --management)
		declare -l $2
		if [[ $2 != "mysql" && $2 != "postgresql" ]]; then
			echo "Invalid database management system: $2"
			echo "Check the --help section to see the valid command line options"
			exit 1
		fi
		DB_MANAGEMENT_SYS=$2
		echo "Set \"$DB_MANAGEMENT_SYS\" as the database management system."
		shift
		;;
	-u | --username)
		DB_USERNAME=$2
		shift
		;;
	-w | --password)
		DB_PASSWORD=$2
		shift
		;;
	-h | --host)
		DB_HOST=$2
		shift
		;;
	-p | --port)
		DB_PORT=$2
		shift
		;;
	-d | --database)
		DB_NAME=$2
		shift
		;;
	-s | --schema)
		DB_SCHEMA=$2
		shift
		;;
	-\? | --help)
		display_help
		exit 0
		;;
	--) # End of all options.
		shift
		break
		;;
	-?*)
		echo "WARN: Unknown option (ignored): $1"
		;;
	*)
		echo "Invalid option"
		echo "Check the --help section to see the valid command line options"
		exit 1
		;;
	esac
	shift
done

case "$action" in
db-create)
	db_create
	;;

tables-create)
	db_tables_create
	;;

download-data)
	download_geonames_data
	;;

download-delete)
	download_geonames_data_delete
	;;

db-import)
	db_import_dumps
	;;

db-drop)
	db_drop
	;;

db-truncate)
	db_truncate
	;;

all)
	download_geonames_data
	db_create
	db_tables_create
	db_import_dumps
	;;

*)
	echo "Invalid action"
	echo "Check the --help section to see the valid command line options"
	exit 1
	;;
esac

if [ $? == 0 ]; then
	echo "[OK]"
else
	echo "[FAILED]"
fi

exit 0
