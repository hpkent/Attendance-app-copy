class Student < ActiveRecord::Base

  has_many :students_sittings
  has_many :sittings, through: :students_sittings
  has_many :meetings
  has_many :students_groups
  belongs_to :category_type
  
  scope :search_by_name, lambda { |q|
   (q ? where(["first_name LIKE ? or last_name LIKE ? or concat(first_name, ' ', last_name) like ?", '%'+ q + '%', '%'+ q + '%','%'+ q + '%' ])  : {})
  }
  
  
  def calc_last_seen(sitting_id,s)

   
    @sitting = Sitting.find(sitting_id)   
    now = @sitting.start_date 

    @default_date = (now - 100)

    # @attending_students.each do |s|

      # m = s.meetings.where('meetings.start_date!=?',Date.today)

      m = s.meetings.where('meetings.start_time!=?',@sitting.start_time)

      if m.length == 0 then

        Student.find(s.id).update(:date_last_seen => @default_date)
        Student.find(s.id).update(:days_since_last_seen => (now - @default_date).to_i)
        puts "test test: #{s.meetings.length}"

      elsif m.length > 0
         s.date_last_seen = m.order('start_date DESC').first.start_date
         Student.find(s.id).update(:date_last_seen => s.date_last_seen)
         Student.find(s.id).update(:days_since_last_seen => (now - s.date_last_seen).to_i)
         puts "test test: #{s.meetings.length}"
       else
       end
    # end
  end


  # def days_since_last_seen

  #   @student_sitting = StudentsSitting.where(student_id = @student).first
  #   @sitting_id = t.sitting_id
  #   m = Sitting.find(@sitting_id)

  #   @date = m.start_date
  #   Student.

  #   m = Meeting.where(sitting_id:params[:meeting][:sitting_id], student_id:params[:meeting][:student_id]).first_or_initialize
  #   m.update(meeting_params)
  #   students_sitting = StudentsSitting.where(sitting_id:params[:meeting][:sitting_id],student_id:params[:meeting][:student_id]).first_or_initialize
  #   students_sitting.meeting = m
  #   students_sitting.save
  #   For @student
  #     if student.studentsittings.meetings != nil
  #       @sitting_id = StudentsSittings.meetings.sitting_id.first
  #       @sitting = Sitting.find(@sitting_id)
  #       @days = Date.today - Sitting.start_date.to_i
  #       puts @days
  #     else
  #       puts 100
  #     end
  # end


end
