require 'open-uri'
require 'fileutils'

module GeonamesRails
  class Puller
    def pull
      @temp_geonames_files = []
      target_dir = File.join(RAILS_ROOT, 'tmp')
      
      file_names = %w(cities1000.zip cities5000.zip cities15000.zip admin1Codes.txt countryInfo.txt)
      file_names.each do |file_name|
        url = "http://download.geonames.org/export/dump/#{file_name}"
      
        remote_file = open(url)

        target_file_name = File.join(target_dir, file_name)
        File.open target_file_name, 'w' do |f|
          f.write(remote_file.read)
        end
        remote_file.close
        
        @temp_geonames_files << target_file_name
        
        file_base_name, file_extension = file_name.split('.')
        if file_extension == 'zip'
          `unzip #{target_file_name} -d #{target_dir}`
          @temp_geonames_files << File.join(target_dir, "#{file_base_name}.txt")
        end
        
      end
    end
    
    def cleanup
      @temp_geonames_files.each do |f|
        FileUtils.rm f
      end
    end
  end
  
  class Loader
    @country_field_mappings = {
      # [0] iso alpha2
      # [1] iso alpha3
      # [2] iso numeric
      # [3] fips code
      # [4] name
      # [5] capital
      # [6] areaInSqKm
      # [7] population
      # [8] continent
      # [9] top level domain
      # [10] Currency code
      # [11] Currency name
      # [12] Phone
      # [13] Postal Code Format
      # [14] Postal Code Regex
      # [15] Languages
      # [16] Geoname id
      # [17] Neighbours
      # [18] Equivalent Fips Code
    }
    
    @city_field_mappings = {
      # [0] geonameid : integer id of record in geonames database
      :geonames_id => 0,
      # [1] name : name of geographical point (utf8) varchar(200)
      :name => 1,
      # [2] asciiname : name of geographical point in plain ascii characters, varchar(200)
      :ascii_name => 2,
      # [3] alternatenames : alternatenames, comma separated varchar(4000)
      :alternate_name => 3,
      # [4] latitude : latitude in decimal degrees (wgs84)
      :latitude => 4,
      # [5] longitude : longitude in decimal degrees (wgs84)
      :longitude => 5,
      # [6] feature class : see http://www.geonames.org/export/codes.html, char(1)
      :feature_class => 6,
      # [7] feature code : see http://www.geonames.org/export/codes.html, varchar(10)
      :feature_code => 7,
      # [8] country code : ISO-3166 2-letter country code, 2 characters,
      :
      # [9] cc2 : alternate country codes, comma separated, ISO-3166 2-letter country code, 60 characters
      # [10] admin1 code : fipscode (subject to change to iso code), isocode for the us and ch, see file admin1Codes.txt for display names of this code; varchar(20)
      # [11] admin2 code : code for the second administrative division, a county in the US, see file admin2Codes.txt; varchar(80)
      # [12] admin3 code : code for third level administrative division, varchar(20)
      # [13] admin4 code : code for fourth level administrative division, varchar(20)
      # [14] population : integer
      # [15] elevation : in meters, integer
      # [16] gtopo30 : average elevation of 30'x30' (ca 900mx900m) area in meters, integer
      # [17] timezone : the timezone id (see file timeZone.txt)
      # [18] modification date : date of last modification in yyyy-MM-dd format
    }
    
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
          
          country_elements = line.split("\t")
          iso_code = country_elements[0]
          c = Country.find_or_initialize_by_iso_code_two_letter(iso_code)
          c.attributes = { :iso_code_two_letter => iso_code,
                           # [1] iso alpha3
                           :iso_code_three_letter => country_elements[1],
                           # [2] iso numeric
                           :iso_number => country_elements[2],
                           # [4] name
                           :name => country_elements[4],
                           # [5] capital
                           :capital => country_elements[5],
                           # [8] continent
                           :continent => country_elements[8],
                           # [16] Geoname id
                           :geonames_id => country_elements[16]
                         }
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