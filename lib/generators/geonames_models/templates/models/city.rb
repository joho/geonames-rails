class City < ActiveRecord::Base
  belongs_to :region
  has_one :country, :through => :region
end