class Country < ActiveRecord::Base
  has_many :regions
  has_many :cities, :through => :regions
end