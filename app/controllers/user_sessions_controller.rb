class UserSessionsController < ApplicationController
  
  def create
    @user_session = UserSession.new(:login => params[:login], :password => params[:password])
    if @user_session.save
      render :text => 'success'
    else
      user = User.find_by_login(params[:login])
      render :text => 'The username/password is incorrect or you haven\'t activated your account (check your spam folder)'
    end
  end
  
  def destroy
    current_user_session.destroy if current_user_session
    flash[:notice] = "Looking forward to seeing you again!"
    redirect_to '/'
  end  
  
end
