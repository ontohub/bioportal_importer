require 'ontohub/api'
require 'ontohub/category_mapping'

module Ontohub

  def self.config=(options)
    Base.site           = options['site']
    API.repository_path = options['repository_path']
  end

end
