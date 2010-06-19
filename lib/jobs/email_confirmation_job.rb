class EmailConfirmationJob < Struct.new(:client_id)
  
  def perform
    client = Client.find client_id
    client.user.deliver_email_confirmation_instructions!
  end
  
end