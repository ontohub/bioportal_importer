module Bioportal

  class Submission < ActiveRecord::Base

    belongs_to :ontology
    delegate :acronym, :normalized_filename, to: :ontology

    scope :downloaded,  ->{ where "filesize IS NOT null" }
    scope :committed,   ->{ where "committed_at IS NOT null" }
    scope :uncommitted, ->{ where committed_at: nil }

    def self.import(json)
      # find existing submission
      obj = find_or_initialize_by(submission_id: json['submissionId'])

      obj.created_at  = Time.parse(json['creationDate'])
      obj.language    = json['hasOntologyLanguage']
      obj.version     = json['version']
      obj.description = json['description'].try(&:strip)

      if contact = json['contact'][0]
        obj.contact_name  = contact['name']
        obj.contact_email = contact['email']
      end

      obj.save! if obj.changed?

      obj
    end

    def to_s
      "#{acronym}-#{submission_id}"
    end

    def tmp_path
      dir = BASEDIR.join("submissions")
      dir.mkpath
      dir.join(to_s)
    end

    def download
      API.instance.download_ontology(acronym, submission_id, tmp_path)
      self.filesize = tmp_path.size
      save!
    end

    def downloaded?
      File.exists? tmp_path
    end

    def commit
      filename      = normalized_filename
      contact_name  = self.contact_name  || 'nobody'
      contact_email = self.contact_email || 'nobody@bioportal'

      env = {
        'GIT_AUTHOR_DATE'     => created_at.iso8601,
        'GIT_AUTHOR_NAME'     => contact_name,
        'GIT_AUTHOR_EMAIL'    => contact_email,
        'GIT_COMMITTER_NAME'  => contact_name,
        'GIT_COMMITTER_EMAIL' => contact_email,
      }

      Dir.chdir WORKSPACE do
        # init git repository if missing
        system 'git', 'init' unless WORKSPACE.join('.git').exist?

        # copy file to workspace
        FileUtils.copy tmp_path, filename

        # has anything changed?
        if `git status -s` != ''
          # then add and commit
          system 'git', 'add', filename

          message = version
          message = '-' if version.blank?
          
          system env, 'git', 'commit', '-m', message, filename
          raise "commit failed" if $?.to_i != 0
        end
      end

      self.committed_at = Time.now
      save!
    end
  end

end