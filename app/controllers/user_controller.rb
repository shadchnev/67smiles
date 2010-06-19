class UserController < ApplicationController
  
  def confirm_email
    user = User.find_using_perishable_token(params[:activation_code], 1.week) or (raise 'Sorry, there was an error during email confirmation. Please email hello@varsitycleaners.co.uk for assistance')
    raise 'Sorry, this email has already been confirmed' if user.email_confirmed?
    user.confirm_email! or (raise 'Sorry, the email cannot be confirmed. Please email hello@varsitycleaners.co.uk for assistance')
    flash[:notice] = 'Thank you. Your email has been confirmed'
  rescue Exception => e
    flash[:error] = e.message
  ensure
    redirect_to '/'
  end
    
  def activate
    user = User.find_using_perishable_token(params[:activation_code], 1.week) or (raise 'Sorry, there was an error during activation. Please email hello@varsitycleaners.co.uk for assistance')
    raise 'Sorry, this user has already been activated' if user.active?
    (user.activate! and user.confirm_email!) or (raise 'Sorry, your account could not have been activated. Please email hello@varsitycleaners.co.uk for assistance')
    flash[:notice] = 'Thank you. Your account has been activated'
  rescue Exception => e
    flash[:error] = e.message
  ensure
    redirect_to '/'
  end
    
end 