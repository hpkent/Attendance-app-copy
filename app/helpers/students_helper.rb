module StudentsHelper

  def display_name

    @student = Student.find(@student_id)

    if @student.last_name != nil
      @student.first_name.capitalize + " " + @student.last_name.capitalize
    else
      @student.first_name
    end  

  end

end
