###########################################
# Ruby script to retrieve speaker
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
medium_speakers_url = "/speakers/mobile_data_vimp_medium_speakers"
org_name = "WVC"

#for each video, retrieve speakers and tags from the cms
media = Medium.where(mediatype:3)
#media = Medium.where(title:"CPR for Your Practice (SA89)")
media.each do |medium|

	puts "processing: #{medium.title}"
	puts "#{root_url}#{medium_speakers_url}/#{org_name}/#{medium.vr_year}/#{medium.vr_session_code}"
	
	if (medium.vr_year!=nil && medium.vr_session_code!=nil && medium.vr_year.length > 0 && medium.vr_session_code.length > 0) then
	
		result = JSON.parse(apiFetch("#{root_url}#{medium_speakers_url}/#{org_name}/#{medium.vr_year}/#{medium.vr_session_code}"))	
		puts result
	
		result.each do |speaker|
			
			first_name = speaker["speaker"]["first_name"]
			last_name = speaker["speaker"]["last_name"]
			email = speaker["speaker"]["email"]
	
			vimp_speakers = Speaker.where(first_name:first_name,last_name:last_name,email:email)
			
			if (vimp_speakers.length == 1) then
				puts "found #{vimp_speakers[0].first_name} #{vimp_speakers[0].last_name}"
				
				#create association in vimp db between speaker and video if not already present
				MediaSpeaker.where(speaker_id:vimp_speakers[0].id,medium_id:medium.id).first_or_initialize().save()
			elsif (vimp_speakers.length > 1)
				puts "EXCEPTION: #{medium.title}: More than 1 #{first_name} #{last_name} exists in VIMP"
			elsif (vimp_speakers.length == 0)
				puts "EXCEPTION: #{medium.title}: No speaker match in VIMP for: #{first_name} #{last_name}"
			end
	
		end		
	
	else
		puts "YEAR/SESSION CODE not available for: #{medium.title}"
	end
		

end





	


	

	
	
	
	
	

