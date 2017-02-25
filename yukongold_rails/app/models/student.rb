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
        end
  end

  def self.active_student
    @inactive_student_type = CategoryType.where(name: "Inactive").first.id
    @inactive_student = Student.where.not(category_type_id:@inactive_student_type)
  end

  def self.inactive_student
    @inactive_student_type = CategoryType.where(name: "Inactive").first.id
    @inactive_student = Student.where(category_type_id:@inactive_student_type)
  end

end
