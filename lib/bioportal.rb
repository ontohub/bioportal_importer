require 'singleton'

require 'bioportal/api'
require 'bioportal/downloader'
require 'bioportal/ontology'
require 'bioportal/submission'

module Bioportal

  class DownloadError < ::Exception; end

  def self.apikey=(value)
    API.apikey = value
  end
  
  def self.import_all
    import_ontologies
    import_ontology_submissions
  end

  def self.import_files
    `cd #{WORKSPACE} && git init`
  end

  def self.import_ontologies
    API.instance.ontologies.each do |attributes|
      Ontology.import(attributes)
    end
  end

  def self.import_ontology_submissions
    Ontology.find_each(&:import_submissions)
  end

end
