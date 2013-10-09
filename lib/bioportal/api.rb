module Bioportal

  class API
    include Singleton
    class_attribute :apikey

    BASE_URI = 'http://data.bioontology.org/'

    def ontologies
      get 'ontologies'
    end

    def ontology_submissions(acronym)
      get "ontologies/#{acronym}/submissions"
    end

    def ontology_filename(acronym)
      response = head "ontologies/#{acronym}/download"
      response.headers[:content_disposition].match(/filename="(.+)"/)[1]
    rescue RestClient::ResourceNotFound
      nil # no filename
    end

    def download_ontology(acronym, submission_id, output)
      `curl --silent '#{BASE_URI}ontologies/#{acronym}/submissions/#{submission_id}/download' -H 'Authorization: #{authorization}' > '#{output}'`
      if $?.to_i != 0
        `rm '#{output}'`
        raise "download failed"
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