class CreateGeonamesTables < ActiveRecord::Migration
  def self.up
    # blah
    
    # create countries
    # create regions
    # create cities
  end
  
  def self.down
    # drop all the tables
    # %w(countries regions cities) { |t| drop_table t }
  end
end