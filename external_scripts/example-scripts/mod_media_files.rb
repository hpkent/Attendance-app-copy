###########################################
# Ruby script to scan video meta data
# from existing VIMP media files and
# add a subset of that data to the media
# table 
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
media_files_dir = "/var/www/wvcvimp/data/web/images/source"

#for each video, retrieve the exif data and update the relevant media row
media = Medium.all()
meta_data_missing = []

#media = Medium.where(title:"CPR for Your Practice (SA89)")
media.each do |medium|

	puts "processing: #{medium.title}"
	
	if (medium.mediatype==0) then #videos
		
		begin
			item = MiniExiftool.new "#{media_files_dir}/#{medium.source_filename}"
			puts "#{media_files_dir}/#{medium.source_filename}"
			if (item.Year!=nil && item.Title!=nil) then
				medium.update_attributes(vr_year:item.Year,vr_session_code:item.Title)
			elsif (item.Album!=nil && item.Title!=nil) then
				medium.update_attributes(vr_year:item.Album,vr_session_code:item.Title)
			else
				meta_data_missing << "VIDEO | #{medium.title} | #{media_files_dir}/#{medium.source_filename}"
			end
				 
		rescue
			puts "ERROR READING FILE"
		end
	elsif (medium.mediatype==3)	#conference notes
		
		regex = /(.*)\|\|(.*)/
		if m = regex.match(medium.title)
			medium.update_attributes(vr_year:m[1],vr_session_code:m[2])
		else
			meta_data_missing << "PDF |  #{medium.title}"
		end

	end

end

puts "META DATA MISSING \n"
meta_data_missing.each do |mdm|
	puts mdm
end
	

