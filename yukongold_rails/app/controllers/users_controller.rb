class UsersController < ApplicationController
  before_filter :authenticate_user!
  # before_filter :admin_only, :except => :show

  def index
    @users = User.all
  end

  def new
    @user = User.new
    respond_to do |format|
      format.json { render :json => @user }   
      format.xml  { render :xml => @user }
      format.html
    end
  end

  def create
    @user = User.new(secure_params_new)
    #@user.user! #set role to type :user
    if @user.save
      respond_to do |format|
        format.json { render :json => @user.to_json, :status => 200 }
        format.xml  { head :ok }
        format.html { redirect_to :action => :index }
      end
    else
      respond_to do |format|
        format.json { render :text => "Could not create user", :status => :unprocessable_entity } # placeholder
        format.xml  { head :ok }
        format.html { render :action => :new, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to :back, :alert => "Access denied."
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      format.json { render :json => @user }   
      format.xml  { render :xml => @user }
      format.html
    end
 
  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:json, :xml, :html)
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params_new)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private
    def admin_only
      unless current_user.admin?
        redirect_to :back, :alert => "Access denied."
      end
    end

    def secure_params
      params.require(:user).permit(:role)
    end

    def secure_params_new
      params.require(:user).permit(:email,:password, :password_confirmation,:role)
    end 
end
