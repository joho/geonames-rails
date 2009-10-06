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
  end
end