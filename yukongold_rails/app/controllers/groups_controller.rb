class GroupsController < ApplicationController

  #students_groups
  def all_students_in_group
    @group = Group.find(params[:id])
    @group_id = @group.id
    @group_name = @group.name
    @students_groups = StudentsGroup.new
    @look_up_group = Group.where(name:@group_name)
    @look_up_group_id = @look_up_group.first.id
    @students_in_groups = Student.select('students.id, students.first_name, students.last_name, students_groups.id AS students_groups_id, groups.name AS group_name, category_types.name AS category_name').joins('
    INNER JOIN students_groups ON students_groups.student_id = students.id 
    INNER JOIN groups ON students_groups.group_id = groups.id
    LEFT OUTER JOIN category_types ON category_types.id = students.category_type_id' 
    ).where(" 
    groups.id =?", @look_up_group_id).order(:first_name)
    @students = Student.active_student.order(:category_type_id)
  end

  def update_students_in_group
    @students_group = StudentsGroup.where(group_id:params[:students_group][:group_id],student_id:params[:students_group][:student_id]).first_or_initialize
    respond_to do |format|
      if (@students_group.update(students_group_params))
      @group_id = @students_group.group_id
        format.html { redirect_to("/groups/#{@group_id}/all_students_in_group") }
        format.json 
        format.js   
      else
        format.html { redirect_to("/groups/#{@group_id}/all_students_in_group") }
      end
    end
  end

  def delete_students_groups
    students_groups = StudentsGroup.find(params[:students_groups_id])
    @group_id = students_groups.group_id
    students_groups.destroy
    respond_to do |format|
      format.html { redirect_to "/groups/#{@group_id}/all_students_in_group"}
      format.json 
      format.js  
    end
  end

  #groups
  def manage_groups
     @groups = Group.all.order(:name)
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end
 
  def update
    @group = Group.where(id:params[:id]).first_or_initialize
    if @group.update(group_params)
      redirect_to groups_manage_groups_path
    else
      render 'edit'
    end
  end

  def delete_group
    group = Group.find(params[:id])
    group.destroy
    redirect_to '/groups/manage_groups'
  end

  private
    def group_params
      params.require(:group).permit(:name, :description)
    end

    def students_group_params
      params.require(:students_group).permit(:group_id, :student_id)
    end
end  






