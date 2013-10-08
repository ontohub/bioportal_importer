module Bioportal

  class Submission < ActiveRecord::Base

    belongs_to :ontology

    def self.import(json)
      # find existing submission
      obj = find_or_initialize_by(submission_id: json['submissionId'])

      obj.created_at = Time.parse(json['creationDate'])
      obj.language   = json['hasOntologyLanguage']
      obj.version    = json['version']

      if contact = json['contact'][0]
        obj.contact_name  = contact['name']
        obj.contact_email = contact['email']
      end

      obj.save! if obj.changed?

      obj
    end
  end


end