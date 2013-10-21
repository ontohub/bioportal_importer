#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'rest-client'
require 'json'
require 'pathname'

$:.unshift File.dirname(__FILE__)

BASEDIR   = Pathname.new(File.dirname(__FILE__)).join("..")
WORKSPACE = BASEDIR.join("workspace")
WORKSPACE.mkpath

require 'active_record'
require "bioportal"

require 'sqlite3'
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => "db.sqlite3")
ActiveRecord::Base.logger = Logger.new(STDOUT)

if !Bioportal::Ontology.table_exists?
  require 'bioportal/tables'
end