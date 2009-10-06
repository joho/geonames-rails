namespace :geonames_rails do
  desc 'pull down the geonames data from the server'
  task :pull_data do
    # do something here
  end
  
  desc 'load geonames data into db'
  task :load_data do
    # do something
  end
  
  desc 'cleanup geonames data pulled from the server'
  task :cleanup_data do
    # do something
  end
  
  desc 'pull geonames data and load into the database'
  task :pull_and_load => [:pull_data, :load_data, :cleanup_data]
end