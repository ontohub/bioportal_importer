module Ontohub

  class Base < ActiveResource::Base
  end

  class Category < Base
    # a mapping from category name to its id
    def self.mapping
      @map ||= Hash[Ontohub::Category.all.map{|c| [c.name, c.id] }]
    end

    # maps category names to category ids
    # non existing categories are discarded
    def self.ids_for_names(names)
      names.map{|name| mapping[name] }.compact.uniq
    end
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
            description:  bio_ontology.description,
            name:         bio_ontology.name,
            category_ids: Ontohub.map_categories_to_ids(bio_ontology.categories.split "\n")
        end
      end
    end
  end

end
