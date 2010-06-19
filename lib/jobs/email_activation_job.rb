class EmailActivationJob < Struct.new(:client_id)
  
  def perform
    client = Client.find client_id
    client.user.deliver_activation_instructions!
  end
  
end