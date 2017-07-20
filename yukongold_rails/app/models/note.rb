class Note < ActiveRecord::Base
  belongs_to :note_type
  belongs_to :sitting
  belongs_to :meeting
end
