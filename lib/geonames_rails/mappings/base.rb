module GeonamesRails
  module Mappings
    class Base < Hash
      def initialize(line = nil)
        if line
          fields_from_line = line.split("\t")
          mappings.each do |k,v|
            self[k] = fields_from_line[v]
          end
        else
          super
        end
      end
    end
  end
end