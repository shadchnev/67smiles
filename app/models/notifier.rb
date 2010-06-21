class Notifier < ActionMailer::Base

  def email_confirmation_instructions(user)
    @headers['Reply-to'] = '"Varsity Cleaners" <hello@varsitycleaners.co.uk>'
    @headers['Return-path'] = '"Varsity Cleaners" <hello@varsitycleaners.co.uk>'    
    subject       "Varsity Cleaners: Email Confirmation Instructions"
    from          '"Varsity Cleaners" <hello@varsitycleaners.co.uk>'
    recipients    user.owner.email
    sent_on       Time.now
    body          :email_confirmation_url => confirm_email_url(:activation_code => user.perishable_token), :user => user
  end

  def activation_instructions(user)
    @headers['Reply-to'] = '"Varsity Cleaners" <hello@varsitycleaners.co.uk>'
    @headers['Return-path'] = '"Varsity Cleaners" <hello@varsitycleaners.co.uk>'    
    subject       "Varsity Cleaners: Activation Instructions"
    from          '"Varsity Cleaners" <hello@varsitycleaners.co.uk>'
    recipients    user.owner.email
    sent_on       Time.now
    body          :activation_url => activate_url(:activation_code => user.perishable_token), :user => user
  end

  def test
    @headers['Reply-to'] = '"Varsity Cleaners" <hello@varsitycleaners.co.uk>'
    @headers['Return-path'] = '"Varsity Cleaners" <hello@varsitycleaners.co.uk>'
    subject       "Test"
    from          '"Varsity Cleaners" <hello@varsitycleaners.co.uk>'
    recipients    "evgeny.shadchnev@gmail.com"
    sent_on       Time.now
    body          :root_url => root_url
  end
  

end
