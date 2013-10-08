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

    APIKEY=<your-bioportal-apikey> ./console
    Bioportal.import_all
    Bioportal::Ontology.count
    Bioportal::Submission.count
    exit
