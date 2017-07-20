class SittingsController < ApplicationController
  require 'time'
  require 'date'
  layout "landing_page"

  #SITTING ROUTES
  def select_sitting
   @sitting = Sitting.where(start_date:Date.today)
   # @all_sittings = Sitting.all.order(:start_date).order(:start_time)
  end

  def build_date_from_date_picker(params)
    newDate = params.split("/")
    @datepicker_date = Date.new(newDate[2].to_i,newDate[0].to_i,newDate[1].to_i)
    @datepicker_date
  end

  def view_past_sittings
    @date = build_date_from_date_picker(params[:start_date])
    @sittings = Sitting.where(start_date:@date)
    @formatted_date = @date.strftime("%A, %B %-d, %Y")
    if @sittings.count == 0
      respond_to do |format|
        format.html { redirect_to(sittings_select_sitting_path, :alert => "No sittings available for the selected date, #{@formatted_date}.") }
      end
    elsif @sittings.count == 1
        session[:sitting_id] = @sittings.ids[0]
        sitting_date = Sitting.find(session[:sitting_id]).start_date
        redirect_sitting_view(sitting_date)
    end
  end

  def update_sitting
    session[:sitting_id] = params[:sitting_id]
    sitting_date = Sitting.find(params[:sitting_id]).start_date
    redirect_sitting_view(sitting_date)
  end

  def redirect_sitting_view(sitting_date)  
    if sitting_date < Date.today 
      respond_to do |format|
        format.html { redirect_to("/students/schedule_meetings")}
      end
    else
      respond_to do |format|
        format.html { redirect_to("/students/attendance")}
      end
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

  def update
    @update_flag = Sitting.where(start_date:params[:sitting][:start_date], start_time:params[:sitting][:start_time]).first_or_initialize
    respond_to do |format|
      if (@update_flag.update(sitting_params))
        format.html { redirect_to '/students/schedule_meetings' }
        format.json 
        format.js   
      else
        format.html { redirect_to '/students/schedule_meetings'}
      end
    end
  end

  private

    def sitting_params
      params.require(:sitting).permit(:event_title, :start_date, :end_date, :start_time, :end_time, :note_id, :no_meeting_flag)
      # params.permit(:sitting, :event_title, :start_date, :end_date, :start_time, :end_time, :note_id)
    end

    def students_sitting_params
      params.require(:students_sitting).permit(:sitting_id, :student_id, :attendance_status_type_id, :special_status_type_id, :meeting_id, :hatto)
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


