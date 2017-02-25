

class StudentsController < ApplicationController

require 'date'


  def home
    if session[:sitting_id] != nil
      respond_to do |format|
        format.html { redirect_to("/students/attendance") }
      end
    else
      respond_to do |format|
        format.html { redirect_to("/sittings/select_sitting") }
      end
    end
  end  

  #STUDENT ROUTES
  def attendance

    @sitting_id = session[:sitting_id]
    @sitting = Sitting.find(@sitting_id)
    @sitting_event_title = Sitting.find(@sitting_id).event_title
    @sitting_start_date = Sitting.find(@sitting_id).start_date.strftime("%A, %B %-d, %Y")
    @attendance_status_type_id_scheduled = AttendanceStatusType.where(name: "scheduled").first.id
    @attendance_status_type_id_present = AttendanceStatusType.where(name: "present").first.id

    
    @scheduled_students = Student.select('students.id, students.first_name, students.last_name, special_status_types.name AS special_status, students_sittings.id AS students_sittings_id, students_sittings.hatto AS hatto, category_types.name AS category_name, category_types.order AS category_order').joins('
      INNER JOIN students_sittings ON students_sittings.student_id = students.id 
      INNER JOIN attendance_status_types ON attendance_status_types.id = students_sittings.attendance_status_type_id
      LEFT OUTER JOIN special_status_types ON special_status_types.id = students_sittings.special_status_type_id
      LEFT OUTER JOIN category_types ON category_types.id = students.category_type_id'  
      ).where(" 
      students_sittings.attendance_status_type_id =? AND students_sittings.sitting_id =?", @attendance_status_type_id_scheduled, @sitting_id).order("category_types.order ASC").order(:first_name)

    @attending_students = Student.select('students.id, students.first_name, students.last_name, special_status_types.name AS special_status, students_sittings.id AS students_sittings_id, students_sittings.meeting_id AS meeting_id, students_sittings.hatto AS hatto, category_types.name AS category_name, category_types.order AS category_order').joins('
      INNER JOIN students_sittings ON students_sittings.student_id = students.id 
      INNER JOIN attendance_status_types ON attendance_status_types.id = students_sittings.attendance_status_type_id
      LEFT OUTER JOIN special_status_types ON special_status_types.id = students_sittings.special_status_type_id
      LEFT OUTER JOIN category_types ON category_types.id = students.category_type_id'  
      ).where(" 
      students_sittings.attendance_status_type_id =? AND students_sittings.sitting_id =?", @attendance_status_type_id_present, @sitting_id).order("category_types.order ASC").order(:first_name)

    @students = Student.all
    @students_sittings = StudentsSitting.new
    @students_sittings_loc = StudentsSitting.new
    @all_groups = Group.all
    @students_groups = StudentsGroup.new
    @note = Note.new
    @current_note = Note.where(id:@sitting.note_id).first

  end


  def autocomplete
    @students = Student.search_by_name(params[:term]).active_student
    render json: @students, root: false, each_serializer: AutocompleteSerializer
  end

  def update_students_sitting_autocomplete

   students_sitting = StudentsSitting.where(sitting_id:params[:students_sitting][:sitting_id],student_id:params[:students_sitting][:student_id]).first_or_initialize
   
    respond_to do |format|

      if (students_sitting.update(students_sitting_params))
        format.html { redirect_to("/students/attendance") }
      else
        format.html { redirect_to("/students/attendance") }
      end
    end
  end

  def list_all

    @sitting_id = session[:sitting_id]

    @students = Student.active_student.order(:first_name)
    @students_sittings = StudentsSitting.new
  
    @attendance_status_type_id_present = AttendanceStatusType.where(name: "present").first.id
    @attendance_status_type_id_scheduled = AttendanceStatusType.where(name: "scheduled").first.id

  end

  def cancel_attendance
     students_sittings = StudentsSitting.find(params[:students_sittings_id])
     students_sittings.destroy    
    
   respond_to do |format|
      format.html { redirect_to '/students/attendance' }
      format.json
      format.js 
   end
  end

  def schedule_meetings

    @sitting_id = session[:sitting_id]
    @sitting = Sitting.find(@sitting_id)
    @current_note = Note.where(id:@sitting.note_id).first
    @sitting_event_title = Sitting.find(@sitting_id).event_title
    @sitting_start_date = Sitting.find(@sitting_id).start_date.strftime("%A, %B %-d, %Y")

    @attendance_status_type_id_scheduled = AttendanceStatusType.where(name: "scheduled").first.id
    @attendance_status_type_id_present = AttendanceStatusType.where(name: "present").first.id

    @attending_students_search = Student.joins('
      INNER JOIN students_sittings ON students_sittings.student_id = students.id 
      INNER JOIN attendance_status_types ON attendance_status_types.id = students_sittings.attendance_status_type_id' 
      ).where(" 
      students_sittings.attendance_status_type_id =? AND students_sittings.sitting_id =?", 
      @attendance_status_type_id_present, @sitting_id).order("days_since_last_seen DESC")


      @attending_students_search.each do |s|

        s.calc_last_seen(@sitting_id,s)
      
      end

    @attending_students = Student.select('students.id, students.first_name, students.last_name, students.bench, students.acceptance_date, students.date_last_seen, students.days_since_last_seen, special_status_types.name AS special_status, students_sittings.sitting_id AS sitting_id, students_sittings.meeting_id AS meeting_id, students_sittings.hatto AS hatto, category_types.name AS category_name').joins('

    INNER JOIN students_sittings ON students_sittings.student_id = students.id 
    INNER JOIN attendance_status_types ON attendance_status_types.id = students_sittings.attendance_status_type_id
    LEFT OUTER JOIN special_status_types ON special_status_types.id = students_sittings.special_status_type_id
    LEFT OUTER JOIN category_types ON category_types.id = students.category_type_id'  
    ).where(" 
    students_sittings.attendance_status_type_id =? AND students_sittings.sitting_id =?", 
    @attendance_status_type_id_present, @sitting_id).where("category_types.name !=? AND category_types.name !=?","Formal", "Monastic").order("hatto DESC").order("days_since_last_seen DESC").order(:first_name)

    @attending_monastics = Student.select('students.id, students.first_name, students.last_name, students.bench, students.acceptance_date, students.date_last_seen, students.days_since_last_seen, special_status_types.name AS special_status, students_sittings.sitting_id AS sitting_id, students_sittings.meeting_id AS meeting_id, students_sittings.hatto AS hatto, category_types.name AS category_name').joins('
    
    INNER JOIN students_sittings ON students_sittings.student_id = students.id 
    INNER JOIN attendance_status_types ON attendance_status_types.id = students_sittings.attendance_status_type_id
    LEFT OUTER JOIN special_status_types ON special_status_types.id = students_sittings.special_status_type_id
    LEFT OUTER JOIN category_types ON category_types.id = students.category_type_id'  
    ).where(" 
    students_sittings.attendance_status_type_id =? AND students_sittings.sitting_id =?",
    @attendance_status_type_id_present, @sitting_id).where("category_types.name =? OR category_types.name =?","Formal", "Monastic").order(:first_name)
  end


  def admin
  end

  def new_dropdown

    @sitting_id = session[:sitting_id]
    @attendance_status_type_id_scheduled = AttendanceStatusType.where(name: "scheduled").first.id
    @group = Group.find(params[:students_group][:group_id])



    @students_in_groups = Student.select('students.id, students.first_name, students.last_name, students_groups.id AS students_groups_id, groups.name AS group_name, category_types.name AS category_name').joins('
    INNER JOIN students_groups ON students_groups.student_id = students.id 
    INNER JOIN groups ON students_groups.group_id = groups.id
    LEFT OUTER JOIN category_types ON category_types.id = students.category_type_id' 
    ).where(" 
    groups.id =?", @group.id)

    @students_sittings = StudentsSitting.new
    @students = Student.all

    if (@students_in_groups.each != nil) then
      @students_in_groups.each do |student|

        @students_sitting_entry = StudentsSitting.where(sitting_id:@sitting_id, student_id:student.id).first_or_initialize do |ss|
            ss.attendance_status_type_id = @attendance_status_type_id_scheduled
        end
         
         @students_sitting_entry.save

      end
    end

    respond_to do |format|
      format.html { redirect_to("/students/attendance")}
    end
  
  end

  def update_student_status

   @students_sittings = StudentsSitting.where(sitting_id:params[:students_sitting][:sitting_id],student_id:params[:students_sitting][:student_id]).first_or_initialize
   
    respond_to do |format|

      if (@students_sittings.update(students_sitting_params))
        format.html { redirect_to '/students/attendance' }
        format.json 
        format.js   
      else
        format.html { redirect_to("/students/attendance")}
      end
    end
  end

  def update_location_status

   @students_sittings_loc = StudentsSitting.where(sitting_id:params[:students_sitting][:sitting_id],student_id:params[:students_sitting][:student_id]).first_or_initialize
   
    respond_to do |format|

      if (@students_sittings_loc.update(students_sitting_params))
        format.html { redirect_to '/students/attendance' }
        format.json 
        format.js   
      else
        format.html { redirect_to("/students/attendance")}
      end
    end
  end

  def update_list_all_student

   @students_sitting = StudentsSitting.where(sitting_id:params[:students_sitting][:sitting_id],student_id:params[:students_sitting][:student_id]).first_or_initialize
   
    respond_to do |format|

      if (@students_sitting.update(students_sitting_params))
        format.html { redirect_to("/students/list_all") }
        format.json
        format.js
      else
        format.html { redirect_to("/students/list_all") }
      end
    end
  end


 

# def js_add_student_to_sitting
  
#   students_sitting = StudentsSitting.where(sitting_id:params[:sitting_id],student_id:params[:student_id]).first_or_initialize
#   ast_id = AttendanceStatusType.where(name:"present").first.id

#     respond_to do |format|
#       format.js
#     end

# end


#SPECIAL STATUS METHODS

 def new_special_status

    @sitting_id = session[:sitting_id]
    @student_id = params[:student_id]
    @student = Student.find(@student_id)
    @students_sittings = StudentsSitting.new

  end


  def update_special_status
   students_sitting = StudentsSitting.where(sitting_id:params[:students_sitting][:sitting_id],student_id:params[:students_sitting][:student_id]).first_or_initialize
   
    respond_to do |format|

      if (students_sitting.update(students_sitting_params))
        format.html { redirect_to("/students/attendance/")}
      else
        format.html { redirect_to("/students/attendance/")}
      end
    end
  end


  def update_location
   students_sitting = StudentsSitting.where(sitting_id:params[:students_sitting][:sitting_id],student_id:params[:students_sitting][:student_id]).first_or_initialize
   
    respond_to do |format|

      if (students_sitting.update(students_sitting_params))
        format.html { redirect_to("/students/attendance/")}
      else
        format.html { redirect_to("/students/attendance/")}
      end
    end
  end




# STUDENT ACTIONS

  def manage_students
    @students = Student.active_student.order(:category_type_id).order(:first_name)

  end

  def manage_inactive_students
    @students = Student.inactive_student.order(:first_name)
    
  end

  def new
    @student = Student.new
  end

  def history
    @student_id = params[:id]
    @student = Student.find(@student_id)
    @attendance_status_type_id_present = AttendanceStatusType.where(name: "present").first.id

    @show_meetings = Meeting.select('meetings.start_date, meetings.student_id, sittings.event_title AS event_title, monastics.initials AS initials').joins('
      INNER JOIN students ON students.id = meetings.student_id
      LEFT OUTER JOIN monastics ON monastics.id = meetings.monastic_id
      LEFT OUTER JOIN sittings ON sittings.id = meetings.sitting_id'
      ).where(" 
      meetings.student_id =?", @student).order("start_date DESC")

    @show_attendance = StudentsSitting.select('students_sittings.student_id, sittings.event_title AS event_title, sittings.start_date AS start_date, attendance_status_types.id AS attendance_status_type').joins('
    LEFT OUTER JOIN sittings ON sittings.id = students_sittings.sitting_id
    LEFT OUTER JOIN attendance_status_types ON attendance_status_types.id = students_sittings.attendance_status_type_id'
    ).where(" 
    students_sittings.student_id =? AND students_sittings.attendance_status_type_id=?", @student, @attendance_status_type_id_present).order("start_date DESC")

  end

  def edit
    @student = Student.find(params[:id])
  end

  def create
    @student = Student.new(student_params).first_or_initialize
 
      if @student.save
        redirect_to @student
      else
        render 'new'
      end
  end
 
  def update
      @student = Student.where(id:params[:id]).first_or_initialize
 
    if @student.update(student_params)
      redirect_to students_manage_students_path
    else
      render 'edit'
    end
  end

  def destroy
    @student = Student.find(params[:id])
      @student.destroy
 
      redirect_to students_manage_students_path
  end



  private
    def student_params
      params.require(:student).permit(:first_name, :last_name, :category_type_id, :acceptance_date, :email, :dietary_restrictions, :other, :bench)
    end

    def students_sitting_params
      params.require(:students_sitting).permit(:sitting_id, :student_id, :attendance_status_type_id, :special_status_type_id, :meeting_id, :hatto)
    end
    
end

