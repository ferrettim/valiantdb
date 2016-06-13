
class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  
  private
 
  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :tableview, :voice, :level_id, :score, :pubfourfiveone, :pubaftershock, :pubaspen, :pubavatar, :pubblackmask, :pubboom, :pubdarkhorse, :pubdc, :pubdynamite, :pubidw, :pubimage, :pubmarvel, :pubvaliant, :pubvertigo, :pubzenescope)
  end
 
  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :avatar, :tableview, :voice, :level_id, :score, :pubfourfiveone, :pubaftershock, :pubaspen, :pubavatar, :pubblackmask, :pubboom, :pubdarkhorse, :pubdc, :pubdynamite, :pubidw, :pubimage, :pubmarvel, :pubvaliant, :pubvertigo, :pubzenescope)
  end
end  