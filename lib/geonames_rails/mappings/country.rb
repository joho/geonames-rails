module GeonamesRails
  module Mappings
    class Country < Base
    protected
      def mappings
        {
          # [0] iso alpha2
          :iso_code_two_letter => 0,
          # [1] iso alpha3
          :iso_code_three_letter => 1,
          # [2] iso numeric
          :iso_number => 2,
          # [3] fips code
          :fips_code => 3,
          # [4] name
          :name => 4,
          # [5] capital
          :capital => 5,
          # [6] areaInSqKm,
          :area_in_square_km => 6,
          # [7] population
          :population => 7,
          # [8] continent
          :continent => 8,
          # [9] top level domain
          :top_level_domain => 9,
          # [10] Currency code
          :currency_code => 10,
          # [11] Currency name
          :currency_name => 11,
          # [12] Phone
          :phone => 12,
          # [13] Postal Code Format
          :postal_code_format => 13,
          # [14] Postal Code Regex
          :postal_code_regex => 14,
          # [15] Languages
          :languages => 15,
          # [16] Geoname id
          :geonames_id => 16,
          # [17] Neighbours
          :neighbours => 17,
          # [18] Equivalent Fips Code
          :equivalent_fips_code => 18
        }
      end
    end
  end
end