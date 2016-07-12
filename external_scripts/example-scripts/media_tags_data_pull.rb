###########################################
# Ruby script to retrieve tag
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
medium_tags_url = "/sessions/mobile_data_vimp_medium_tags"
org_name = "WVC"

#for each video, retrieve speakers and tags from the cms
media = Medium.all().order('vr_year ASC')
#media = Medium.where(title:"CPR for Your Practice (SA89)")
media.each do |medium|

	puts "processing: #{medium.title}"

	if (medium.vr_year!=nil && medium.vr_session_code!=nil && medium.vr_year.length > 0 && medium.vr_session_code.length > 0) then

		puts "#{root_url}#{medium_tags_url}/#{org_name}/#{medium.vr_year}/#{medium.vr_session_code}"

		result = JSON.parse(apiFetch("#{root_url}#{medium_tags_url}/#{org_name}/#{medium.vr_year}/#{medium.vr_session_code}"))	
		if (result["tags"].length===0) then
			puts "NO CMS MATCH FOR: #{medium.vr_year}/#{medium.vr_session_code}"
		else
			#puts result["tags"]
	
			#if medium is a video, update the title
			#and meta_description fields
			if (medium.mediatype==0)
				if ( result["session_title"]!=nil && result["session_title"].length > 0 ) then
					medium.update_attributes(title:result["session_title"])
				end

				if ( result["session_description"]!=nil && result["session_description"].length > 0 ) then
					medium.update_attributes(meta_description:result["session_description"])
				end
			
				#prepend Videos:year to each tagset
				result["tags"].each do |tagset|
					tagset = tagset.insert(0,medium.vr_year) 
					tagset = tagset.insert(0,"Videos") 
				end

			elsif (medium.mediatype==3) #PDFs, which are conference notes
				if ( result["session_title"]!=nil && result["session_title"].length > 0 ) then
					medium.update_attributes(title:result["session_title"])
				end

				if ( result["session_description"]!=nil && result["session_description"].length > 0 ) then
					medium.update_attributes(meta_description:result["session_description"])
				end

				#prepend Notes:year to each tagset
				result["tags"].each do |tagset|
					tagset = tagset.insert(0,medium.vr_year) 
					tagset = tagset.insert(0,"Notes") 
				end

			end

			## add tagsets to database ##	
			tag_type_id = TagType.where(name:'media').first.id
			addMediumTags(result["tags"],tag_type_id,medium.mid)
			puts result["tags"]
			#verify the tags were created correctly
			verifyTagset(result["tags"],tag_type_id,medium.mid)
		end
	else
		puts "YEAR/SESSION CODE not available for: #{medium.title}"
	end
end





	


	

	
	
	
	
	

