class Notifier < ActionMailer::Base

  def activation_instructions(user)
    subject       "Varsity Cleaners: Activation Instructions"
    from          "robot@varsitycleaners.co.uk"
    recipients    user.owner.email
    sent_on       Time.now
    body          :account_activation_url => activate_url(:activation_code => user.perishable_token)
  end

  def activation_confirmation(user)
    subject       "Varsity Cleaners: Activation Complete"
    from          "robot@varsitycleaners.co.uk"
    recipients    user.owner.email
    sent_on       Time.now
    body          :root_url => root_url
  end
  
  def test
    subject       "Test"
    from          "robot@varsitycleaners.co.uk"
    recipients    "evgeny.shadchnev@gmail.com"
    sent_on       Time.now
    body          :root_url => root_url
  end
  

end
