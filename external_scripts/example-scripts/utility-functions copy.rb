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



#add tagsets to medium
def addMediumTags(tag_array,tag_type_id,medium_id)

  #loop through all the sets of tags
  puts "tag_array: #{tag_array} , tag_type : #{tag_type_id}"
  tag_array.each do |tagset|
    puts "tagset: #{tagset}"
      
    parent_ids = [] #store all the parent ids for a tagset
          
    tagset.each_with_index do |tag,i|
      
      #set parent_id
      if (i > 0) then #child tag

        #get the parent_id of the current tag, add to parent_ids
        rows = Tag.where(name:tagset[i-1],parent_id:parent_ids[i-1],vr_tag_type_id:tag_type_id,level:i-1).order('id DESC')
        parent_ids << rows.first['id']
        
        rows = Tag.where(name:tag,parent_id:parent_ids[i],vr_tag_type_id:tag_type_id)
        if (rows.count == 0) then
          puts "-- creating new child tag: #{tag} --\n"
            result = Tag.new({name:tag,level:i,leaf:0,parent_id:parent_ids[i],vr_tag_type_id:tag_type_id}).save()
        else
          puts "**-- NOT CREATING child tag: #{tag} --**\n"
        end

          
      else #root-level tag
      
        rows = Tag.where(name:tag,vr_tag_type_id:tag_type_id,level:0)
        parent_ids << 0
        
        if (rows.count == 0) then
          puts "-- creating new root tag: #{tag} --\n"
            result = Tag.new({name:tag,level:i,leaf:0,parent_id:parent_ids[0],vr_tag_type_id:tag_type_id}).save()
          end
            
      end
            
    end #tagset.each_with_index do |tag,i|
  
    
    if ( tagset.length > 0 ) then
    
      parent_id = parent_ids.last

      puts "parent_id: #{parent_id}"
  
      #set leaf value to true
      updatetag = Tag.where(name:tagset.last,parent_id:parent_id,vr_tag_type_id:tag_type_id)[0].update_attributes({leaf:1})
  
      mediumrow = Medium.select('mid').where(mid:medium_id)

      tagrow = Tag.select('id').where(name:tagset.last,parent_id:parent_id,vr_tag_type_id:tag_type_id)

      puts "medium id: #{mediumrow.first.id} | tag id: #{tagrow.first.id}"
      
      rows = TagsMedium.select('id').where(medium_id:mediumrow.first['mid'],vr_tag_id:tagrow.first['id'])

      if (rows.count==0) then
        puts "\t\t-- creating relationship between tag #{tagrow.first['id']} and medium #{mediumrow.first['mid']} --\n"                   
        result = TagsMedium.new({vr_tag_id:tagrow.first['id'],medium_id:mediumrow.first['id']}).save()
      end     
    end
    
  end #tag_array.each do |tagset|         

  #return true

end 

#verify the media tagsets have been correctly inserted in the database
def verifyTagset(tag_array,tag_type_id,medium_id)

      
      tag_array.each do |tagset|

        result = ''
        link_text = ''
        parent_id = 0
        tagset.each_with_index do |tag,i|
          
          if (i==0) then
            tag_result = Tag.where(name:tag,level:i,parent_id:parent_id,vr_tag_type_id:tag_type_id)
            if (tag_result.length == 1) then
              result += "#{tag}".green
              parent_id = tag_result.first['id']
            else
              result += "MISSING #{tag}".red
              next 
            end

          else
            tag_result = Tag.where(name:tag,level:i,parent_id:parent_id,vr_tag_type_id:tag_type_id)
            if (tag_result.length == 1) then
              result += " --> #{tag}".green
              parent_id = tag_result.first['id']
            else
              result += " --> MISSING #{tag}".red
              next
            end

            #if it's a leaf, verify tag is linked to session
            if (tag_result.length == 1 && tag_result.first['leaf']==true) then
              link_result = TagsMedium.where(medium_id:medium_id,vr_tag_id:tag_result.first['id'])
              if (link_result.length == 1) then
                link_text = "media/tag link verified".green
              else
                link_text = "MEDIUM/TAG LINK MISSING".red
              end
            end

          end



        end

        puts "#{medium_id}  | #{result} |  #{link_text}"
      end
end

