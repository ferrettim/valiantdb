
class RegistrationsController < Devise::RegistrationsController
 
  private
 
  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :tableview, :voice, :level_id, :score)
  end
 
  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :avatar, :tableview, :voice, :level_id, :score)
  end
end  