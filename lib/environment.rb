#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'rest-client'
require 'json'
require 'yaml'
require 'pathname'
require 'active_record'
require 'active_resource'

$:.unshift File.dirname(__FILE__)

require 'string'
require 'bioportal'
require 'ontohub'


BASEDIR   = Pathname.new(File.dirname(__FILE__)).join("..")
WORKSPACE = BASEDIR.join("workspace")
CONFIG    = YAML.load_file BASEDIR.join('config.yml')

Bioportal.apikey = CONFIG['bioportal']['apikey']
Ontohub.config   = CONFIG['ontohub']

require 'sqlite3'
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => "db.sqlite3")
ActiveRecord::Base.logger = Logger.new(STDOUT)

if !Bioportal::Ontology.table_exists?
  require 'bioportal/tables'
end
