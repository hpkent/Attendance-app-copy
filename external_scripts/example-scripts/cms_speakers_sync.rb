###########################################
# Ruby script to sync speakers from CMS
# to VIMP database
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
speakers_url = "https://cms.eventkaddy.net/speakers/mobile_data_vimp"
# speakers_url = "http://eventkaddy.net:3000/speakers/mobile_data_vimp"
cms_url_prefix = "https://wvcspeakers.eventkaddy.net"

#speakers_url = "https://cms.eventkaddy.net/speakers/mobile_data_vimp/"
org_id = 1 #ARGV[0] #1, 2, 3, etc

#Speaker.destroy_all()

#MYSQL IMPORT			
begin

	dbh = Mysql2::Client.new(:host => @db_host, :username => @db_user, :password => @db_pass,:database => @db_name)
	
	speakers=[]

	record_start_id=10000000000 #larger than any conceivable id # in the db
	pg_ct=1 
	while true do
		
		puts record_start_id

		result=JSON.parse(apiFetch("#{speakers_url}/#{org_id}/#{record_start_id}"))
		if (result.length==0) then
			puts "no more results"
			break
		else
			speakers.concat(result)
			puts "adding page #{pg_ct} of results"
		end

		puts "results: #{result.length}"
		#puts "results: #{result[0..2]}"

		pg_ct+=1
		record_start_id=result.last["id"]
	end

	#for testing
	#attendees=JSON.parse(open(attendees_url+'1').read)["RegistrationInfo"]
	
	puts "total speakers: #{speakers.count}"

		
	speakers.each do |speaker|		
			
			t = Time.now
			
			#column mappings
			first_name = speaker["first_name"]
			middle_initial =speaker["middle_initial"]
			last_name = speaker["last_name"]
			honor_prefix = speaker["honor_prefix"]
			honor_suffix = speaker["honor_suffix"]
			company = speaker["company"]
			biography = speaker["biography"]			
			photo_event_file_id = speaker["photo_event_file_id"]
			email = speaker["email"]
			notes = speaker["notes"]
			address1 = speaker["address1"]
			address2 = speaker["address2"]
			address3 = speaker["address3"]
			city = speaker["city"]
			state = speaker["state"]
			zip = speaker["zip"]
			work_phone = speaker["work_phone"]
			mobile_phone = speaker["mobile_phone"]
			home_phone = speaker["home_phone"]
			speaker_type_id = speaker["speaker_type_id"]
			twitter_url = speaker["twitter_url"]
			facebook_url = speaker["facebook_url"]
			linkedin_url = speaker["linkedin_url"]

			if (speaker["photo_url"] == nil) then
				photo_url=""
			elsif (speaker["photo_url"].match("event_data")) then #dataset used internal cms url
				photo_url = "#{cms_url_prefix}#{speaker["photo_url"]}"
			else #dataset used external url from wvc
				photo_url = speaker["photo_url"]
			end

			speaker_attrs = {first_name:first_name,middle_initial:middle_initial,last_name:last_name,honor_prefix:honor_prefix,
			honor_suffix:honor_suffix,company:company,biography:biography,photo_url:photo_url,photo_event_file_id:photo_event_file_id,
			email:email,notes:notes,address1:address1,address2:address2,address3:address3,city:city,state:state,zip:zip,work_phone:work_phone,
			mobile_phone:mobile_phone,home_phone:home_phone,speaker_type_id:speaker_type_id,twitter_url:twitter_url,facebook_url:facebook_url,
			linkedin_url:linkedin_url}			
					
			puts "adding/updating speaker: #{first_name} #{last_name} #{email}"
				
			#-- add speaker --				
 			speaker = Speaker.where(first_name:first_name,last_name:last_name,email:email).first_or_initialize()
 			speaker.update_attributes(speaker_attrs)

	end #speakers.each


	
rescue Mysql2::Error => e
	puts "Error code: #{e.errno}"
	puts "Error message: #{e.error}"
	puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
	# disconnect from server
	dbh.close if dbh
end

	
	
	
	
	

