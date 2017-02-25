# -*- coding: utf-8 -*-
#from PHP land
def addslashes(str)
  str.gsub(/['"\\\x0]/,'\\\\\0')
end

#true/false on whether input is a number
def is_number(num)
    true if Float(num) rescue false
end

#utility function to auto-retry url
def apiFetch(url) 

   retries = 10

   begin
     Timeout::timeout(150){
       open(url) do |f|
       	return f.read	
       end
     }
   rescue Timeout::Error
     retries -= 1
     if (retries >= 0) then
     	 puts "open uri request fail, sleep 4 sec, retry #{10-retries} of 10"
       sleep 4 and retry
     else
       raise
     end

 		rescue
    	puts "Connection failed: #{$!}\n"
    
  	end
  
end



