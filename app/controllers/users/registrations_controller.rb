class Users::RegistrationsController < Devise::RegistrationsController

  def new
    flash[:failure] = "Registration is not allowed."
    redirect_to '/'
  end












	protected

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

end
