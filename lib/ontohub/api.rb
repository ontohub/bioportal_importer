module Ontohub

  class Base < ActiveResource::Base
  end

  class Ontology < Base
  end

  class Repository < Base
  end

  class API
    include Singleton
    class_attribute :repository_path

    def repository
      @repository ||= Repository.where(path: repository_path).try(:first) || (raise "Repository path='#{repository_path}' not found at Ontohub")
    end
    
    # Update metadata at ontohub
    def update_metadata
      Bioportal::Ontology.find_each do |bio_ontology|
        if onto_ontology = Ontology.where(repository_id: repository.id, basepath: bio_ontology.acronym).first
          onto_ontology.update_attributes \
            description: bio_ontology.description,
            name:        bio_ontology.name
        end
      end
    end
  end

end