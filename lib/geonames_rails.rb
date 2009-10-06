require 'open_uri'

module GeonamesRails
  class Puller
    def pull
      @temp_geonames_files = []
      
      file_names = %w(cities1000.zip cities15000.zip cities15000.zip admin1Codes.txt countryInfo.txt)
      file_names.each do |file_name|
        url = "http://download.geonames.org/export/dump/#{file_name}"
      
        remote_file = open('url')

        target_file_name = File.join(RAILS_ROOT, 'tmp', file_name)
        File.open target_file_name, 'w' do |f|
          f.write(remote_file.read)
        end
        remote_file.close
        
        @temp_geonames_files << target_file_name
      end
    end
    
    def cleanup
      @temp_geonames_files.each do |f|
        FileUtils.rm f
      end
    end
  end
  
  class Loader
  end
end