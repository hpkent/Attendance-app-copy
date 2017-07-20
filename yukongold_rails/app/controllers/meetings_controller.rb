class MeetingsController < ApplicationController

  # MEETING METHODS
  def new
    @sitting_id = session[:sitting_id]
    @sitting_start_date = Sitting.find(@sitting_id).start_date
    @sitting_start_time = Sitting.find(@sitting_id).start_time
    @student_id = params[:student_id]
    @student = Student.find(@student_id)
    @meeting = Meeting.new
    @regular_meeting_type = MeetingType.where(name:"regular").first.id
    @attendance_status_type_id_present = AttendanceStatusType.where(name: "present").first.id
    @show_meetings = Meeting.select('meetings.start_date, meetings.student_id, sittings.event_title AS event_title, monastics.initials AS initials').joins('
      INNER JOIN students ON students.id = meetings.student_id
      LEFT OUTER JOIN monastics ON monastics.id = meetings.monastic_id
      LEFT OUTER JOIN sittings ON sittings.id = meetings.sitting_id'
      ).where(" 
      meetings.student_id =? AND meetings.start_time !=?", @student, @sitting_start_time).order("start_date DESC").limit(10)
    @show_attendance = StudentsSitting.select('students_sittings.student_id, sittings.event_title AS event_title, sittings.start_date AS start_date, attendance_status_types.id AS attendance_status_type').joins('
    LEFT OUTER JOIN sittings ON sittings.id = students_sittings.sitting_id
    LEFT OUTER JOIN attendance_status_types ON attendance_status_types.id = students_sittings.attendance_status_type_id'
    ).where(" 
    students_sittings.student_id =? AND sittings.start_time !=? AND students_sittings.attendance_status_type_id=?", @student, @sitting_start_time, @attendance_status_type_id_present).order("start_date DESC").limit(10)
  end

  def update
    meeting = Meeting.where(student_id:params[:meeting][:student_id], monastic_id:params[:meeting][:monastic_id], meeting_type_id:params[:meeting][:meeting_type_id]).first_or_initialize
    if meeting.meeting_type_id == 2
      meeting = params[:meeting]
      start_date_params = Date.new meeting["start_date(1i)"].to_i, meeting["start_date(2i)"].to_i, meeting["start_date(3i)"].to_i
      m = Meeting.where(start_date:start_date_params, start_time:start_date_params, student_id:params[:meeting][:student_id], monastic_id:params[:meeting][:monastic_id], meeting_type_id:params[:meeting][:meeting_type_id]).first_or_initialize
      respond_to do |format|
        if (m.update(meeting_params))
          format.html { redirect_to("/meetings/show_other") }
        else
          format.html { redirect_to("/meetings/show_other") }
        end
      end
    else    
      m = Meeting.where(sitting_id:params[:meeting][:sitting_id], student_id:params[:meeting][:student_id]).first_or_initialize
      m.update(meeting_params)
      students_sitting = StudentsSitting.where(sitting_id:params[:meeting][:sitting_id],student_id:params[:meeting][:student_id]).first_or_initialize
      students_sitting.meeting = m
      students_sitting.save
      respond_to do |format|
          format.html { redirect_to("/students/schedule_meetings/")}
      end
    end  
  end

  def destroy
    students_sitting = StudentsSitting.where(meeting_id:params[:meeting_id]).first_or_initialize
    students_sitting.meeting = nil
    students_sitting.save
    meeting = Meeting.find(params[:meeting_id])
    meeting.destroy
    redirect_to '/students/schedule_meetings/'
  end

  def show_other
    @other_meeting_type = MeetingType.where(name:"other").first.id
    @other_meetings = Meeting.select('meetings.start_date, meetings.student_id, meetings.id, meetings.meeting_type_id, students.first_name AS first_name, students.last_name AS last_name, monastics.id AS monastic_id, monastics.title AS monastic_title, monastics.first_name AS monastic_first_name, monastics.last_name AS monastic_last_name').joins('
      INNER JOIN students ON students.id = meetings.student_id
      LEFT OUTER JOIN monastics ON monastics.id = meetings.monastic_id'
      ).order("start_date DESC").where(meeting_type_id:@other_meeting_type)
  end  

  def new_other_meeting
    @other_meeting_type = MeetingType.where(name:"other").first.id
    @other_meeting = Meeting.new
  end 

  def autocomplete
    @students = Student.search_by_name(params[:term]).active_student
    render json: @students, root: false, each_serializer: AutocompleteSerializer
  end

  def edit_other_meeting
    @other_meeting_type = MeetingType.where(name:"other").first.id
    @other_meeting = Meeting.find(params[:meeting_id])
    @student_id = @other_meeting.student_id
    @student = Student.find(@student_id)   
  end

  def delete_other_meeting
    @other_meeting = Meeting.find(params[:meeting_id])
    @other_meeting.destroy    
    respond_to do |format|
      format.html { redirect_to '/meetings/show_other' }
      format.json
      format.js
    end   
  end

  private
    def meeting_params
      params.require(:meeting).permit(:monastic_id, :note_id, :sitting_id, :student_id, :start_date, :start_time, :meeting_type_id)
    end
end

