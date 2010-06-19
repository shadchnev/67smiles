class PhoneConfirmationCodesController < ApplicationController
  
  def create    
    phone = Phone.normalize(params[:phone])
    raise 'invalid' unless phone
    code = PhoneConfirmationCode.find_or_initialize_by_phone(phone)
    raise 'sent' unless code.new_record?
    code.generate!
    code.dispatch!
    render :text => 'ok'
  rescue Exception => e
    logger.info "#{e.message}. Phone: #{params[:phone]}"
    code.destroy if code
    render :text => e.message
  end
  
end
