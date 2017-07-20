class StudentsSitting < ActiveRecord::Base
  belongs_to :student
  belongs_to :sitting
  belongs_to :location_type
  belongs_to :attendance_status_type
  belongs_to :special_status_type
  belongs_to :meeting, :dependent => :destroy
end
