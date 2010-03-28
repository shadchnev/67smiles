class SmsController < ApplicationController
  
  USER_ID = 'txtlocal'
  PASSWORD = 'innocentsms'
  
  before_filter :authenticate

  def create
    Sms.create do |sms|
      sms.from = params[:sender]
      sms.to = params[:inNumber]
      sms.text = params[:content]
    end
    render :text => ''
  end
  
  def update
    sms = Sms.find(params[:id])
    raise "Invalid incoming request: our number (#{sms.to}) <> their number(#{params[:number]})" unless sms.addressee?(params[:number])
    case params[:status]
      when 'D' then sms.delivered!
      when 'I' then sms.invalid!
      when 'U' then sms.undelivered!
    else 
      raise "Invalid incoming request: status=#{params[:status]}"
    end
    sms.save!    
    render :text => ''
  end
  
private

  def authenticate
    authenticate_or_request_with_http_basic do |id, password| 
       id == USER_ID and password == PASSWORD
   end
  end
    
end
