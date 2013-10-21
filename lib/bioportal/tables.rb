
ActiveRecord::Base.connection.create_table(:ontologies) do |t|
  t.string :acronym, :name, null: false
  t.string :filename
  t.text   :categories, :projects
end
ActiveRecord::Base.connection.change_table(:ontologies) do |t|
  t.index :acronym, unique: true
end

ActiveRecord::Base.connection.create_table(:submissions) do |t|
  t.references :ontology, null: false
  t.integer :submission_id, null: false
  t.datetime :created_at, null: false
  t.datetime :committed_at
  t.string :language
  t.string :version
  t.text   :description
  t.string :contact_name, :contact_email
end
ActiveRecord::Base.connection.change_table(:submissions) do |t|
  t.index [:ontology_id, :submission_id], unique: true
end