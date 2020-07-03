# GeoNames

[GeoNames](http://www.geonames.org/ "GeoNames") is a geographical database available and accessible through various web services, under a Creative Commons attribution license.

## Database and web services

The GeoNames database contains over 12,000,000 geographical names corresponding to over 7,500,000 unique features. All features are categorized into one out of nine feature classes and further subcategorized into one out of 645 feature codes. Beyond names of places in various languages, data stored include latitude, longitude, elevation, population, administrative subdivision and postal codes. All coordinates use the World Geodetic System 1984 (WGS84).

Those data are accessible free of charge through a number of Web services and a daily database export. The Web services include direct and reverse geocoding, finding places through postal codes, finding places next to a given place, and finding Wikipedia articles about neighbouring places.

## The project

The result is a Linux shell script that allows you to download the GeoNames data dumps from  the official site and create a database structure in which you can import that dumps. 

The script has two different operation modes 
- Downloading the Geonames data dumps
- Importing the data into a database management system (MySQL or PostgreSQL)

## Usage

The script can perform the following options:
```shell
./geonames.sh [option] [argument] ...
```

| Option | Description                                                                        |
|:------:|------------------------------------------------------------------------------------|
| -a     | Executes an action with the provided argument. Check the action arguments below    |
| -m     | Set the database management system. It can be either "mysql" or "postgresql"       |
| -u     | Connects to the database management system with the provided user for login        |
| -w     | Connects to the database management system with the provided password for login    |
| -h     | Connects to the database management system with the provided hostname              |
| -p     | Connects to the database management system with the provided port                  |
| -d     | Connects to the database management system with the provided database              |
| -s     | Connects to the database management system with the provided schema for PostgreSQL |

Those are the actions available:

| Action          | Description                                                                                                         |
|-----------------|---------------------------------------------------------------------------------------------------------------------|
| all             | Performs the following actions respectively: download-data, db-create, tables-create, db-import and download-delete |
| db-create       | Drop the geonames database and create a new one                                                                     |
| db-drop         | Drop the geonames database                                                                                          |
| db-import       | Import GeoNames data dumps into the current database                                                                |
| db-truncate     | Truncate all GeoNames tables from the current database                                                              |
| download-data   | Download the GeoNames data dumps                                                                                    |
| download-delete | Delete the folders with the GeoNames data dump                                                                      |
| tables-create   | Create the GeoNames tables                                                                                          |

When no options to connect to MySQL are specified, it will use the default settings:
```shell
./geonames.sh -a all -m mysql -u root -w root -h localhost -p 3306 -d geonames
```

To execute with PostgreSQL, just change the value in -m option and provide the database and schema:
```shell
./geonames.sh -a all -m postgresql -u root -w root -h localhost -p 3306 -d postgres -s geonames
```

You can visit anytime the help section to know all the commands and actions available:

```shell
./geonames.sh --help
```

## Install and Run

First, clone the project and go in the geonames folder:

```shell
git clone ...
cd geonames
```

Another recommend option is to set an executable permission using the chmod command as follows:

```shell
chmod +x geonames.sh
```

Finally launch (this will import the GeoNames data dump into your local database):

```shell
./geonames.sh -a all
```