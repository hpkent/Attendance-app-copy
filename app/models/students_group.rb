class StudentsGroup < ActiveRecord::Base

  belongs_to :student 
  belongs_to :group 
  
end
