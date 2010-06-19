class UserSessionsController < ApplicationController
  
  def create
    @user_session = UserSession.new(:login => Phone.normalize(params[:login]), :password => params[:password])
    if @user_session.save
      render :text => 'success'
    else
      user = User.find_by_login(Phone.normalize(params[:login]))
      error_message = 'The phone/password is incorrect'
      error_message += ' (have you activated your account?)' if user and user.cleaner?
      render :text => error_message
    end
  end
  
  def destroy
    current_user_session.destroy if current_user_session
    flash[:notice] = "Looking forward to seeing you again!"
    redirect_to '/'
  end  
  
end
