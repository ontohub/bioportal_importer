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

Configuration
-------------

Copy the `config.yml.sample` to `config.yml` and fill in your credentials.

    cp config.yml.sample config.yml

If you want to specify a mapping of categories from bioportal to categories from bioportal, then create a `category-mapping.csv` in the project repository with the following columns:

```
acronym,target1,target2,target3
Chemical,Chemistry,Biochemistry,
Mouse_Anatomy,Space,Biology,Veterinary
```

A bioportal category can map to multiple ontohub categories.
Just add as many target* columns as you want.

Usage
-----

Start the interactive ruby console:

    ./console

Download metadata of ontologies and submissions:

    Bioportal.import_all

Download the file for each sumission:

    Bioportal::Downloader.run

Create a repository with all downloaded submissions of ontologies below 1 megabyte:

    Bioportal.reset_workspace
    Bioportal::Submission.uncommitted.downloaded.order(:created_at).each do |s|
        s.commit if s.ontology.max_filesize < 1024*1024
    end

Now you can find the repository in ./workspace/.git

After pushing the repository to Ontohub you can update the ontologies metadata at Ontohub:

    Ontohub::API.instance.update_metadata
