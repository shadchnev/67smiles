class Notifier < ActionMailer::Base

  def activation_instructions(user)
    subject       "Varsity Cleaners: Activation Instructions"
    from          "mailer@varsitycleaners.co.uk"
    recipients    user.owner.email
    sent_on       Time.now
    body          :account_activation_url => activate_url(:activation_code => user.perishable_token)
  end

  def activation_confirmation(user)
    subject       "Varsity Cleaners: Activation Complete"
    from          "mailer@varsitycleaners.co.uk"
    recipients    user.owner.email
    sent_on       Time.now
    body          :root_url => root_url
  end
  
  def test
    @headers['Reply-to'] = "Varsity Cleaners <hello@varsitycleaners.co.uk>"
    @headers['Return-path'] = "Varsity Cleaners <hello@varsitycleaners.co.uk>"
    subject       "Test"
    from          "Varsity Cleaners <mailer@varsitycleaners.co.uk>"
    recipients    "evgeny.shadchnev@gmail.com"
    sent_on       Time.now
    body          :root_url => root_url
  end
  

end
