require 'ontohub/api'

module Ontohub

  def self.config=(options)
    Base.site           = options['site']
    API.repository_path = options['repository_path']
  end

end
