module Bioportal

  class Ontology < ActiveRecord::Base

    has_many :submissions, -> { order :submission_id }

    def self.import(json)
      obj          = find_or_initialize_by(acronym: json['acronym'])
      obj.name     = json['name']
      obj.filename = API.instance.ontology_filename(json['acronym'])
      
      obj.save! if obj.changed?

      obj
    end

    def import_submissions
      API.instance.ontology_submissions(acronym).each do |json|
        submissions.import(json)
      end
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