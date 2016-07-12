class SittingsController < ApplicationController
  require 'time'
  layout "landing_page"


  #SITTING ROUTES
  def select_sitting

   @students_sittings = StudentsSitting.new
   @sitting = Sitting.where(start_date:Date.today)
   @all_sittings = Sitting.all
  end

  def update_sitting

    student_sitting = StudentsSitting.where(sitting_id:params[:students_sittings][:sitting_id]).first_or_create
    session[:sitting_id] = student_sitting.sitting_id

    
    respond_to do |format|
        format.html { redirect_to("/students/attendance")}
    end

  end

  def refresh

    Sitting.refresh_calendar

    respond_to do |format|

      # if (sitting.update(sitting_params))
        format.html { redirect_to("/home", :notice => 'Calendar data refreshed') }
      # else
      #   format.html { redirect_to("/home", :notice => 'Did not refresh data.') }
      # end
    end

  end 

  private

  def sitting_params
    params.require(:sitting).permit(:event_title, :start_date, :end_date, :start_time, :end_time, :note_id)
    # params.permit(:sitting, :event_title, :start_date, :end_date, :start_time, :end_time, :note_id)
  end

  def students_sitting_params
    params.require(:students_sitting).permit(:sitting_id, :student_id, :attendance_status_type_id, :special_status_type_id, :meeting_id)
  end

end


      # start.date_time
      # if (sitting.start.date_time!=nil) then
      #   # t = Time.parse(sitting.start.date_time.strftime("%Y-%m-%d %H:%M:%S %z"))
      # else
      #   next
      # end
      # puts " start_time: #{sitting.start.date_time}"
      # puts " t value: #{t}"
      # #utc time offset
      # offset = t.to_s.match((/[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} (-[0-9]{4})/))
      # puts "testing offset: #{offset}"
      
      # utc_offset = offset[1].to_s
      # puts "testing utc offset: #{utc_offset}"

      # t_new = t.sub(utc_offset, '')
      # puts "t_new: #{t_new}"
    
      # utc_test = utc_offset.insert(3,":")
      # puts "utc_offset insert 3: #{utc_test}"
      # local_start_time_test = t.localtime(utc_test).to_s

      # puts "local_start_time: #{local_start_time_test}"
    
      # # end.date_time
      # if (sitting.end.date_time!=nil) then
      #   t = Time.parse(sitting.end.date_time.strftime("%Y-%m-%d %H:%M:%S %z"))  
      # else
      #   next
      # end
      # local_end_time = t.localtime(utc_offset).to_s


