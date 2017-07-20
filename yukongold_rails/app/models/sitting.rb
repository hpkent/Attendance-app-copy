class Sitting < ActiveRecord::Base
  has_many :students_sittings
  has_many :students, through: :students_sittings
  has_many :notes

  def sitting_info 
    "#{self.event_title} - #{self.start_date.strftime("%A, %B %-d, %Y")}" 
  end

  def self.refresh_calendar
    client = Google::APIClient.new
    t = Token.last
    t.refresh_access_token 
    # client.authorization.access_token = t.access_token
    client.authorization.access_token = Token.last.refresh_access_token
    calendar_api = client.discovered_api('calendar', 'v3')  
    result = client.execute(
      :api_method => calendar_api.events.list,
      :parameters => {
        :calendarId => '69n6c6urb2k563ekv2rkldjdg0@group.calendar.google.com',
        # :maxResults => 1000,
        :singleEvents => true,
        :orderBy => 'startTime',
        :timeMin => (Time.now - 1.month).iso8601}
      )
    puts "Upcoming events:"
    puts "No upcoming events found" if result.data.items.empty?
    # result.data.items.each do |event|
    #   start_date = event.start.date
    #   start_time = event.start.date_time
    #   end_date = event.end.date
    #   end_time = event.end.date_time
    #   event_title = event.summary 
    # end
    self.update_calendar(result.data.items)
  end

  def self.update_calendar(items)
    items.each do |sitting|
      summary = sitting.summary
      start_dt = sitting.start.date_time
      end_dt = sitting.end.date_time
      start_date = sitting.start.date
      end_date = sitting.end.date
      if (sitting.start.date_time!=nil) then
        local_start_time = Time.zone.parse(sitting.start.date_time.strftime("%Y-%m-%d %H:%M:%S"))
      end
      if (sitting.end.date_time!=nil) then
        local_end_time = Time.zone.parse(sitting.end.date_time.strftime("%Y-%m-%d %H:%M:%S"))
      end
      if (local_start_time!=nil) then
        @calendar_sitting = Sitting.where(start_time:local_start_time, event_title:summary).first_or_initialize  do |sitting_record|
            sitting_record.start_date = start_dt 
            sitting_record.end_date = end_dt
            sitting_record.end_time = local_end_time       
        end
        puts "status is: #{summary} and #{local_start_time}"
        if @calendar_sitting.save
          puts "data refreshed"
        else
          puts "data likely not refreshed"
        end     
       #if no local start time 
      else
        @calendar_sitting = Sitting.where(start_date:start_date, event_title:summary).first_or_initialize  do |sitting_record|
            sitting_record.end_date = end_date       
        end  
        puts "status is: #{summary} and #{start_date}"
        if @calendar_sitting.save
          puts "data refreshed"
        else
          puts "data likely not refreshed"
        end     
      end 
    end
  end 
end


