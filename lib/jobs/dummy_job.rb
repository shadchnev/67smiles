class DummyJob < Struct.new(:text)
  
  def perform
    Rails.logger.info("Dummy job completed: #{text}")
  end
  
end