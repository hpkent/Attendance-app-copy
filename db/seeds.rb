# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).



# # attendance_status_types

# attendance_status_type = [
# 'present',
# 'absent',
# 'scheduled'
# ]

# attendance_status_type.each do |name|
#   AttendanceStatusType.find_or_create_by(name: name)
# end

# # meetings

# meetings = [
# [1,1,1],
# [2,2,2],
# [3,3,3]
# ]

# meetings.each do |student_id, monastic_id, sitting_id|
#   Meeting.find_or_create_by(student_id:student_id, monastic_id:monastic_id, sitting_id:sitting_id)
# end

# #monastics

# monastics = [
# ['Camelia', 'Barnard', 'CB'],
# ['Chaya', 'Raker', 'CR'],
# ['Wynell', 'Crowder', 'WC']
# ]

# monastics.each do |first_name, last_name, initials|
#   Monastic.find_or_create_by(first_name:first_name, last_name:last_name, initials:initials)
# end

# #note_types

# note_type = [
# 'meetings',
# 'sittings'
# ]

# note_type.each do |name|
#   NoteType.find_or_create_by(name: name)
# end


# #notes


# notes = [
# [1,'cloudy day'],
# [1, 'sunny day'],
# [2, 'windy day']
# ]

# notes.each do |note_type_id, content|
#   Note.find_or_create_by(note_type_id:note_type_id, content:content)
# end


# #sittings

# sittings = [
# '2014-01-31',
# '2015-07-12',
# '2013-01-31'
# ]

# sittings.each do |date|
#   Sitting.find_or_create_by(date:date)
# end

# students
students = [
  ['Bobbie', 'Schacht', 1, '1986-01-31'],
  ['Leticia', 'Catto', 2, '1997-01-31'],  
  ['Armand', 'Charlebois', 1, '1994-01-31'],
  ['Len', 'Allis', 2, '2001-01-31'],
  ['Garrett', 'Charpentier', 1, '2011-01-13'], 
  ['Isabelle', 'Lombardi', 2, '1996-01-31'], 
  [ 'Kermit', 'Wheat', 1, '1998-01-31'], 
  [ 'Traci', 'South', 2, '2010-01-31'],
  ['Maisie', 'Barahona', 1, '1998-01-31'], 
  [ 'Lindy', 'Crochet', 2, '1998-01-31']
]

students.each do |first_name, last_name, category_type_id, acceptance_date|
  Student.find_or_create_by(first_name: first_name, last_name: last_name, category_type_id: category_type_id, acceptance_date: acceptance_date)
end

#student_sittings

# #users
# user = CreateAdminService.new.call
# puts 'CREATED ADMIN USER: ' << user.email

