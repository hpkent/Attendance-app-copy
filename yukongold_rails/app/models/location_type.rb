class LocationType < ActiveRecord::Base
  has_many :students_sittings
end
