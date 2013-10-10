module Bioportal

  class Ontology < ActiveRecord::Base

    has_many :submissions, -> { order :submission_id }

    def self.import(json)
      obj          = find_or_initialize_by(acronym: json['acronym'])
      obj.name     = json['name']
      
      obj.save! if obj.changed?

      obj
    end

    def import_submissions
      API.instance.ontology_submissions(acronym).each do |json|
        submissions.import(json)
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