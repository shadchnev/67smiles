class UserController < ApplicationController
  
  def activate
    user = User.find_using_perishable_token(params[:activation_code], 1.week) or (raise 'Sorry, there was an error during activation. Please email hello@varsitycleaners.co.uk for assistance')
    raise 'Sorry, this user has already been activated' if user.active?
    user.activate! or (raise 'Sorry, I could not activate you. Please email hello@varsitycleaners.co.uk for assistance')
    user.deliver_activation_confirmation!
    flash[:notice] = 'Thank you. Your account has been activated'
  rescue Exception => e
    flash[:error] = e.message
  ensure
    redirect_to '/'
  end
    
end
