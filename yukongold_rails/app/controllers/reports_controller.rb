class ReportsController < ApplicationController

  def new
  end

  def build_date_from_params(field_name, params)
    Date.new(params["#{field_name.to_s}(1i)"].to_i, params["#{field_name.to_s}(2i)"].to_i, params["#{field_name.to_s}(3i)"].to_i)
  end

  def attendance_report
    report_start_date = build_date_from_params("start_date", params[:report])
    report_end_date = build_date_from_params("end_date", params[:report]) 
    @attendance_status_type_id_present = AttendanceStatusType.where(name: "present").first.id
    @student_sittings_report = StudentsSitting.select('students.first_name AS student_first_name, students.last_name AS student_last_name, students_sittings.id, sittings.id AS sitting_id, sittings.start_date AS sitting_start_date, sittings.end_date AS sitting_end_date, sittings.event_title AS sitting_event_title, monastics.initials AS monastic_initials').joins('
      INNER JOIN students ON students.id = students_sittings.student_id 
      INNER JOIN sittings ON students_sittings.sitting_id = sittings.id
      LEFT OUTER JOIN meetings ON students_sittings.meeting_id = meetings.id
      LEFT OUTER JOIN monastics ON meetings.monastic_id = monastics.id'  
      ).where("students_sittings.attendance_status_type_id =? AND sittings.start_date >= ? AND sittings.start_date <=?", @attendance_status_type_id_present, report_start_date, report_end_date).order("sittings.start_date")
     render "reports/attendance_report.xlsx.axlsx"
  end

  def student_report
    @attendance_status_type_id_present = AttendanceStatusType.where(name: "present").first.id
    report_start_date = build_date_from_params("start_date", params[:report])
    report_end_date = build_date_from_params("end_date", params[:report])
    @student = params[:Name]
    @student = @student.gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '')
    puts @student
    if @student.match(" ")
      #student has two names
      student_array = @student.split(" ")
      @first_name = student_array[0]
      @last_name = student_array[1]
      puts "full name: #{@first_name}"
      @student_sittings_report = StudentsSitting.select('students.first_name AS student_first_name, students.last_name AS student_last_name, students_sittings.id, sittings.id AS sitting_id, sittings.start_date AS sitting_start_date, sittings.end_date AS sitting_end_date, sittings.event_title AS sitting_event_title, monastics.initials AS monastic_initials').joins('
        INNER JOIN students ON students.id = students_sittings.student_id 
        INNER JOIN sittings ON students_sittings.sitting_id = sittings.id
        LEFT OUTER JOIN meetings ON students_sittings.meeting_id = meetings.id
        LEFT OUTER JOIN monastics ON meetings.monastic_id = monastics.id'  
        ).where("students_sittings.attendance_status_type_id =? AND sittings.start_date >= ? AND sittings.start_date <=? AND students.first_name=? AND students.last_name=?", @attendance_status_type_id_present, report_start_date, report_end_date, @first_name, @last_name).order("sittings.start_date")
      render "reports/student_report.xlsx.axlsx"
    else
      @first_name = @student
      puts "first name only: #{@first_name}"
      @student_sittings_report = StudentsSitting.select('students.first_name AS student_first_name, students.last_name AS student_last_name, students_sittings.id, sittings.id AS sitting_id, sittings.start_date AS sitting_start_date, sittings.end_date AS sitting_end_date, sittings.event_title AS sitting_event_title, monastics.initials AS monastic_initials').joins('
      INNER JOIN students ON students.id = students_sittings.student_id 
      INNER JOIN sittings ON students_sittings.sitting_id = sittings.id
      LEFT OUTER JOIN meetings ON students_sittings.meeting_id = meetings.id
      LEFT OUTER JOIN monastics ON meetings.monastic_id = monastics.id'  
      ).where("students_sittings.attendance_status_type_id =? AND sittings.start_date >= ? AND sittings.start_date <=? AND students.first_name=?", @attendance_status_type_id_present, report_start_date, report_end_date, @first_name).order("sittings.start_date")
      render "reports/student_report.xlsx.axlsx"
    end
  end
end
