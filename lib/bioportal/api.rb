module Bioportal

  class API
    include Singleton
    class_attribute :apikey

    BASE_URI = 'http://data.bioontology.org/'

    def ontologies
      get 'ontologies'
    end

    def ontology_resource(acronym, resource_name)
      get "ontologies/#{acronym}/#{resource_name}"
    end

    def ontology_filename(acronym)
      response = head "ontologies/#{acronym}/download"
      response.headers[:content_disposition].match(/filename="(.+)"/)[1]
    rescue RestClient::ResourceNotFound
      nil # no filename
    end

    def download_ontology(acronym, submission_id, file)
      output = nil
      url    = "#{BASE_URI}ontologies/#{acronym}/submissions/#{submission_id}/download"
      args   = 'curl', url,
        '--header', "Authorization: #{authorization}",
        '--output', file.to_s,
        '--silent',
        '--fail',
        '--show-error'

      # run it and save stderr and stdout in output
      IO.popen(args, :err=>[:child, :out]){|f| output = f.gets }

      if $?.to_i != 0
        file.unlink if file.exist?
        raise DownloadError, "Download of #{url} failed: #{output}"
      end
    end

    protected

    def authorization
      "apikey token=#{apikey}"
    end

    def headers
      {
        accept:        :json,
        authorization: authorization
      }
    end

    def get(path)
      JSON.parse(call :get, path)
    end

    def head(path)
      call :head, path
    end

    def call(method, path)
      raise "apikey not set" unless apikey
      
      RestClient.send(method, "#{BASE_URI}#{path}", headers)
    end
  end

end