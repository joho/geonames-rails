module GeonamesRails
  
  class Loader
    
    def initialize(puller, logger = nil)
      @logger = logger || STDOUT
      @puller = puller
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

          iso_code = country_mapping[:iso_code_two_letter]
          c = Country.find_or_initialize_by_iso_code_two_letter(iso_code)
          
          log_message "#{c.new_record? ? 'Creating' : 'Updating'} db record for #{iso_code}"
          
          c.attributes = country_mapping.slice(:iso_code_two_letter,
                                               :iso_code_three_letter,
                                               :iso_number,
                                               :name,
                                               :capital,
                                               :continent,
                                               :geonames_id)
          c.save!
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
        
        country = Country.find_by_iso_code_two_letter(country_code)
        
        log_message "Processing #{country.name}(#{country_code}) with #{cities.length} cities"

        cities.each do |city_mapping|          
          city = City.find_or_initialize_by_geonames_id(city_mapping[:geonames_id])
          city.country = country
          
          city.attributes = city_mapping.slice(:name,
                                               :latitude,
                                               :longitude,
                                               :country_iso_code_two_letters,
                                               :population,
                                               :geonames_timezone_id)
          
          city.save!
        end
      end
    end
    
    def log_message(message)
      @logger << message
      @logger << "\n"
    end
  end
end