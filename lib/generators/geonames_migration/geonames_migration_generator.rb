class GeonamesMigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'geonames_tables.rb',"db/migrate", :migration_file_name => "create_geonames_tables"
    end
  end
end