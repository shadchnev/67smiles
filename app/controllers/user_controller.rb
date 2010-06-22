class UserController < ApplicationController
  
  def confirm_email
    user = User.find_using_perishable_token(params[:activation_code], 1.week) or (raise 'Sorry, there was an error during email confirmation. Please email hello@varsitycleaners.co.uk for assistance')
    raise 'Sorry, this email has already been confirmed' if user.email_confirmed?
    user.confirm_email! or (raise 'Sorry, the email cannot be confirmed. Please email hello@varsitycleaners.co.uk for assistance')
    flash[:notice] = 'Thank you. Your email has been confirmed'
  rescue Exception => e
    logger.error e.message
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
    logger.error e.message
    flash[:error] = e.message
  ensure
    redirect_to '/'
  end
  
  def send_password_link
    render :text => 'no email provided' and return unless params[:email]
    cd = ContactDetails.find_by_email(params[:email].strip)
    render :text => 'no email found in the db' and return unless cd
    logger.info("Found ContactDetails #{cd.id}")
    person = Client.find_by_contact_details_id(cd.id) || Cleaner.find_by_contact_details_id(cd.id)
    logger.info("Found #{person.class} id=#{person.id}")
    person.user.deliver_password_recovery_link!
    logger.info("Sent password recovery link")
    render :text => ''
  end
  
  def reset_password
    user = User.find_using_perishable_token(params[:reset_password_code], 1.week) or (raise 'Sorry, there was an error during password recovery. Please email hello@varsitycleaners.co.uk for assistance')    
    new_password = user.reset_password!
    Sms.create do |s|
      s.to = user.owner.phone
      s.text = SmsContent.new_password(new_password)
    end
    sms.dispatch or raise 'Sorry, there was a problem sending your password'    
    flash[:notice] = 'Thank you, you password has been reset. New password was sent to your mobile phone.'
  rescue Exception => e
    logger.error e.message
    flash[:error] = e.message
  ensure
    redirect_to '/'    
  end
    
end 