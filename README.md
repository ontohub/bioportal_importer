Bioportal Importer
==================

Some ruby code to import metadata of ontologies and submissions from [bioontology.org](http://data.bioontology.org/documentation) into a local SQLite Database.

Requirements
------------

You need Ruby 2.0 and sqlite3


Installation
------------

    git clone git://github.com/ontohub/bioportal_importer.git
    cd bioportal_importer
    bundle install


Usage
-----

Start the interactive ruby console:

    APIKEY=<your-bioportal-apikey> ./console

Download metadata of ontologies and submissions:

    Bioportal.import_all

Download the file for each sumission:

    Bioportal::Downloader.run
