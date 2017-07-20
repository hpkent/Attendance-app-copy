class Meeting < ActiveRecord::Base
  has_one :students_sitting
  belongs_to :monastic
  has_many :notes
  belongs_to :student
  belongs_to :meeting_types
end
