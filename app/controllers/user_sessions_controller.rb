class UserSessionsController < ApplicationController
  
  def create
    @user_session = UserSession.new(:login => params[:login], :password => params[:password])
    puts @user_session.inspect
    if @user_session.save
      render :text => 'success'
    else
      render :text => 'The username or password is incorrect'
    end
  end
  
  def destroy
    current_user_session.destroy if current_user_session
    flash[:notice] = "Looking forward to seeing you again!"
    redirect_to '/'
  end  
  
end
