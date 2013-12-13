require 'csv'

module Ontohub

  def self.categories_file
    BASEDIR.join("category-mapping.csv")
  end

  # Returns a mapping from a bioportal category name
  # the corresponding ontology category names
  def self.category_mapping
    @category_mapping ||= begin
      if categories_file.exist?
        map = {}
        CSV.foreach categories_file, headers: true do |row|
          # find category_ids for all target* columns
          map[row['acronym']] = row.to_hash.map{|k,v| v if k =~ /^target/ }.compact
        end
        map
      end
    end
  end

  # map category names to cagegory_ids
  def self.map_categories(names)
    if category_mapping
      names.inject [] do |memo,name|
        memo += category_mapping[name] || []
      end
    else
      STDERR.puts "no #{categories_file} found, use direct category mapping".red
      names
    end
  end

  def self.map_categories_to_ids(names)
    Category.ids_for_names map_categories(names)
  end

end
