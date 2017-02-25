namespace :update_sittings do
  desc "Update the sittings table from the google calendar WWZC-calendar"
  task update_table: :environment do
    puts "refreshing the sittings to match the google calendar..."
    Sitting.refresh_calendar
  end  
end

#this is run using a crontab. On the server type "crontab -e" to open or create a crontab. For documentation see: http://tutorials.jumpstartlab.com/topics/systems/automation.html
#Then write the whole path to the app. To find the path, type "which rake"
#For example: cd /home/deploy/octopus-wwzc-attendance-app/yukongold_rails && /usr/local/rvm/gems/ruby-2.1.5@wwzc-attendance/bin/rake RAILS_ENV=production update_sittings:update_table
#00 00 * * 0 (Run at 00:00 every Sunday.)
# Currently in crobtab on server: 00 00 * * 0 cd /home/deploy/octopus-wwzc-attendance-app/yukongold_rails && /usr/local/rvm/gems/ruby-2.1.5@wwzc-attendance/bin/rake RAILS_ENV=production update_sittings:update_table



