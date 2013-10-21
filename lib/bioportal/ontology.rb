module Bioportal

  class Ontology < ActiveRecord::Base

    has_many :submissions, -> { order :submission_id }
    before_create :refresh_subresources

    def self.import(json)
      obj          = find_or_initialize_by(acronym: json['acronym'])
      obj.name     = json['name']
      
      obj.save! if obj.changed?

      obj
    end

    def import_submissions
      API.instance.ontology_resource(acronym, :submissions).each do |json|
        submissions.import(json)
      end
    end

    # Fetches projects and categories
    def refresh_subresources
      %w( projects categories ).each do |attr|
        self[attr] = API.instance.ontology_resource(acronym, attr).map{|h| h['acronym']}.join("\n")
      end
    end

    def filename
      acronym
    end

    # commits all submissions into to the repository
    def commit
      submissions.each(&:commit)
    end

    def filesize
      submissions.last.try(:filesize)
    end
  end
  
end