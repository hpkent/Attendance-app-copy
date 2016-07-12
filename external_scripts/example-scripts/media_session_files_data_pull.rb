###########################################
# Ruby script to retrieve session files
# data from the cms for each video
###########################################

require 'mysql2'
require 'date'

require 'json'
require 'net/http'
require 'open-uri'

#for active record usage
require 'active_record'

#load the rails 3 environment
require_relative '../config/environment.rb'

require_relative './settings.rb' #config
require_relative './utility-functions.rb'

ActiveRecord::Base.establish_connection(
	:adapter => "mysql2",
	:host => @db_host,
	:username => @db_user,
	:password => @db_pass,
	:database => @db_name
)

#setup variables
#root_url = "http://localhost:3000"
root_url = "https://cms.eventkaddy.net"
medium_session_files_url = "sessions/mobile_data_vimp_session_files"
org_name = "WVC"

#for each video, retrieve speakers and tags from the cms
media = Medium.all().order('vr_year ASC')
#media = Medium.where(title:"CPR for Your Practice (SA89)")
media.each do |medium|

	puts "processing: #{medium.title} \n"

	if (medium.vr_year!=nil && medium.vr_session_code!=nil && medium.vr_year.length > 0 && medium.vr_session_code.length > 0) then

		puts "\n #{root_url}/#{medium_session_files_url}/#{org_name}/#{medium.vr_year}/#{medium.vr_session_code}"

		result = JSON.parse(apiFetch("#{root_url}/#{medium_session_files_url}/#{org_name}/#{medium.vr_year}/#{medium.vr_session_code}"))	
		
		#puts "result: #{result}"
		
		if (result["session_file_urls"]==nil || result["session_file_urls"].length==0) then
			puts "NO CMS MATCH FOR: #{medium.vr_year}/#{medium.vr_session_code}"
		else
			puts result["session_file_urls"]
			
			## Add Session Files to VIMP database ##
			result["session_file_urls"].each do |session_file_url|
				url = "/session_files/#{medium.vr_year}/#{File.basename(session_file_url)}"
				medium_file_type_id = MediumFileType.where(name:"conference note").first.id
				medium_file = MediumFile.where({medium_id:medium.mid,title:"Conference Note #{medium.vr_session_code}",vr_medium_file_type_id:medium_file_type_id,path:url}).first_or_initialize()
				medium_file.save()
				#aggregate all session file urls for a specific medium into
				#a convenience column in the media table
				medium_file.updateMedia() 	
			
			end
		end
	else
		puts "YEAR/SESSION CODE not available for: #{medium.title}"
	end
end





	


	

	
	
	
	
	

