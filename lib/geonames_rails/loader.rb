module GeonamesRails
  
  class Loader
    
    def initialize(puller)
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
      File.open(File.join(RAILS_ROOT, 'tmp', 'countryInfo.txt'), 'r') do |f|
        f.each_line do |line|
          # skip comments
          next if line.match(/^#/) || line.match(/^iso/i)
          
          country_mapping = Mapping::Country.new(line)

          iso_code = country_mapping[:iso_code_two_letter]
          c = Country.find_or_initialize_by_iso_code_two_letter(iso_code)
          
          c.attributes = country_mapping.only(:iso_code_two_letter,
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
      cities = []
      File.open(File.join(RAILS_ROOT, 'tmp', "#{city_file}.txt"), 'r') do |f|
        f.each_line do |line|           
          cities << line.split("\t")
        end
      end
      
      # [8] country code : ISO-3166 2-letter country code, 2 characters
      cities_by_country_code = cities.group_by { |city_fields| city_fields[8] }
      
      cities_by_country_code.keys.each do |country_code|
        cities = cities_by_country_code[country_code]
        
        country = Country.find_by_iso_code_two_letter(country_code)
        cities.each do |city_fields|
          # [0] geonameid : integer id of record in geonames database
          geonames_city_id = city_fields[0]
          
          city = City.find_or_initialize_by_geonames_id(geonames_city_id)
          city.country = country
          city.attributes = {
            # [1] name : name of geographical point (utf8) varchar(200)
            :name => city_fields[1],
            # [4] latitude : latitude in decimal degrees (wgs84)
            :latitude => city_fields[4],
            # [5] longitude : longitude in decimal degrees (wgs84)
            :longitude => city_fields[5],
            # [8] country code : ISO-3166 2-letter country code, 2 characters
            :country_iso_code_two_letters => city_fields[8],
            # [17] timezone : the timezone id (see file timeZone.txt)
            :timezone_id => city_fields[17]
          }
          city.save!
        end
      end
    end
  end
end