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

  def self.reset_workspace
    WORKSPACE.rmtree if WORKSPACE.exist?
    WORKSPACE.mkpath
    `cd '#{WORKSPACE}' && git init`
  end

  def self.import_ontologies
    API.instance.ontologies.each do |attributes|
      Ontology.import(attributes)
    end
    puts "ontologies imported".green
  end

  def self.import_ontology_submissions
    Ontology.find_each do |ontology|
      begin
        ontology.import_submissions
        puts "submissions of #{ontology} imported".green
      rescue RestClient::RequestFailed => e
        STDERR.puts "failed to import submissions of #{ontology}: #{e.message}".red
      end
    end
  end

end
