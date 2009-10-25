module GeonamesRails
  
  class Loader
    
    def initialize(puller, writer, logger = nil)
      @logger = logger || STDOUT
      @puller = puller
      @writer = writer
    end
    
    def load_data
      @puller.pull if @puller # pull geonames files down
      
      load_countries
      
      load_cities
      
      @puller.cleanup if @puller # cleanup the geonames files
    end
    
  protected
    def load_countries
      log_message "opening countries file"
      File.open(File.join(RAILS_ROOT, 'tmp', 'countryInfo.txt'), 'r') do |f|
        f.each_line do |line|
          # skip comments
          next if line.match(/^#/) || line.match(/^iso/i)
          
          country_mapping = Mappings::Country.new(line)
          
          result = @writer.write_country(country_mapping)
          
          log_message result
        end
      end
    end
    
    def load_cities
      %w(cities1000 cities5000 cities15000).each do |city_file|
        load_cities_file(city_file)
      end
    end
    
    def load_cities_file(city_file)
      log_message "Loading city file #{city_file}"
      cities = []
      File.open(File.join(RAILS_ROOT, 'tmp', "#{city_file}.txt"), 'r') do |f|
        f.each_line { |line| cities << Mappings::City.new(line) }
      end
      
      log_message "#{cities.length} cities to process"
      
      cities_by_country_code = cities.group_by { |city_mapping| city_mapping[:country_iso_code_two_letters] }
      
      cities_by_country_code.keys.each do |country_code|
        cities = cities_by_country_code[country_code]
        
        result = @writer.write_cities(country_code, cities)
        
        log_message result
      end
    end
    
    def log_message(message)
      @logger << message
      @logger << "\n"
    end
  end
end