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
url_root = "http://localhost:3000"
proxy_key = 'npqonafmatqupsecchdeovfvqoibuhcmhscipnzkkxvwfnizvd'
general_students_url = "#{url_root}/fetchgeneralstudents?proxy_key=#{proxy_key}"
associate_students_url = "#{url_root}/fetchassociatestudents?proxy_key=#{proxy_key}"

#--- FETCH GENERAL STUDENTS ---
students = JSON.parse(apiFetch(general_students_url))	

students.each do |s|

	puts "processing: #{s["name"]}"

	s_records = Student.where(email:s["email"])

	if (s_records.length == 0) then
		#acceptance_date:DateTime.strptime(s["created_at"].to_s,'%s')
		n_student = Student.new({first_name:s["name"],last_name:'',email:s["email"],level:'general'}).save()
	end
		
end

#--- FETCH ASSOCIATE STUDENTS ----
students = JSON.parse(apiFetch(associate_students_url))	

students.each do |s|

	puts "processing: #{s["name"]}"

	s_records = Student.where(email:s["email"])

	if (s_records.length == 0) then
		#acceptance_date:DateTime.strptime(s["created_at"].to_s,'%s')
		n_student = Student.new({first_name:s["name"],last_name:'',email:s["email"],level:'associate'}).save()
	end
		
end



	


	

	
	
	
	
	

