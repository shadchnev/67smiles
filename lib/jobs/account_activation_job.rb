class AccountActivationJob < Struct.new(:cleaner_id)
  
  def perform
    cleaner = Cleaner.find cleaner_id
    cleaner.user.deliver_activation_instructions!
  end
  
end