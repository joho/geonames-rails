module GeonamesRails
  module Mappings
    class City < Base
    protected
      def mappings
        {
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
          :country_iso_code_two_letters => 8,
          # [9] cc2 : alternate country codes, comma separated, ISO-3166 2-letter country code, 60 characters
          :alternate_country_codes => 9,
          # [10] admin1 code : fipscode (subject to change to iso code), isocode for the us and ch, see file admin1Codes.txt for display names of this code; varchar(20)
          :admin_1_code => 10,
          # [11] admin2 code : code for the second administrative division, a county in the US, see file admin2Codes.txt; varchar(80)
          :admin_2_code => 11,
          # [12] admin3 code : code for third level administrative division, varchar(20)
          :admin_3_code => 12,
          # [13] admin4 code : code for fourth level administrative division, varchar(20)
          :admin_4_code => 13,
          # [14] population : integer
          :population => 14,
          # [15] elevation : in meters, integer
          :elevation => 15,
          # [16] gtopo30 : average elevation of 30'x30' (ca 900mx900m) area in meters, integer,
          :average_elevation => 16,
          # [17] timezone : the timezone id (see file timeZone.txt)
          :geonames_timezone_id => 17,
          # [18] modification date : date of last modification in yyyy-MM-dd format
          :geonames_modification_date => 18
        }
      end
    end
  end
end