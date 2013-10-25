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

Create a repository with all downloaded submissions of ontologies below 1 megabyte:

    Bioportal.reset_workspace
    Bioportal::Submission.uncommitted.order(:created_at).each do |s|
        size = s.ontology.filesize
        s.commit if s.downloaded? && size && size < 1024*1024
    end

Now you can find the repository in ./workspace/.git
