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

    protected

    def get(path)
      raise "apikey not set" unless apikey
      
      result = RestClient.get "#{BASE_URI}#{path}",
        accept:        :json,
        authorization: "apikey token=#{apikey}"

      JSON.parse result
    end
  end

end