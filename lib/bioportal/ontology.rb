module Bioportal

  class Ontology < ActiveRecord::Base

    has_many :submissions, -> { order :submission_id }
    before_create :refresh_subresources
    delegate :description, to: :last_submission

    def self.import(json)
      obj            = find_or_initialize_by(acronym: json['acronym'])
      obj.name       = json['name']
      obj.filename ||= API.instance.ontology_filename(json['acronym'])
      obj.save! if obj.changed?

      obj
    end

    def to_s
      acronym
    end

    def last_submission
      submissions.last
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

    # commits all submissions into to the repository
    def commit
      submissions.each(&:commit)
    end

    def filesize
      submissions.last.try(:filesize)
    end

    def max_filesize
      submissions.maximum(:filesize)
    end

    def normalized_filename
      if match = filename.to_s.match(/.+\.([a-z]{3,5})/i)
        "#{acronym}.#{match[1].downcase}"
      else
        acronym
      end
    end
  end
  
end