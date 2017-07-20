class NotesController < ApplicationController

  def new
    @note = Note.new
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.where(id:params[:id]).first_or_initialize
    if @note.update(note_params)
      if @note.note_type_id == 2
        @sitting_id = session[:sitting_id]
        @sitting = Sitting.find(@sitting_id)
        @sitting.note_id = @note.id
        @sitting.save
      else 
      end
      redirect_to students_attendance_path
    else
    end
  end

  def destroy
    note = Note.find(params[:id])
    note.destroy
    redirect_to students_attendance_path
  end

  private
    def note_params
      params.require(:note).permit(:note_type_id, :content)
    end
end
