#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'rest-client'
require 'json'

$:.unshift File.dirname(__FILE__)

require 'active_record'
require "bioportal"

require 'sqlite3'
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => "db.sqlite3")
ActiveRecord::Base.logger = Logger.new(STDOUT)

if !Bioportal::Ontology.table_exists?

  ActiveRecord::Base.connection.create_table(:ontologies) do |t|
    t.string :acronym, :name, null: false
  end
  ActiveRecord::Base.connection.change_table(:ontologies) do |t|
    t.index :acronym, unique: true
  end

  ActiveRecord::Base.connection.create_table(:submissions) do |t|
    t.references :ontology, null: false
    t.integer :submission_id, null: false
    t.datetime :created_at, null: false
    t.string :language
    t.string :version
    t.string :contact_name, :contact_email
  end
  ActiveRecord::Base.connection.change_table(:submissions) do |t|
    t.index [:ontology_id, :submission_id], unique: true
  end
end