class ClientsController < ApplicationController
  
  def new
    @client = Client.new        
    @client.name = Name.new
    @client.address = Address.new
    @client.address.postcode = Postcode.new
    @client.contact_details = ContactDetails.new
    @client.user = User.new
    check_attempted_booking
  end
    
  def create
    postcode = find_or_create_postcode
    preprocess_params
    @client = Client.new(params[:client])
    @client.address.postcode = postcode
    return if redirect_due_to_confirmation_code    
    check_attempted_booking
    if @booking and @booking.valid?
      if @client.valid? 
        save_booking
      else
        render :action => :new
        return
      end
    else
      render :action => :new and return unless @client.save
      flash[:notice] = "Thank you for the registration! Now you can book a cleaner in just couple of clicks."
    end
    Delayed::Job.enqueue EmailConfirmationJob.new(@client.id)
    @client.user.activate! # because we have already confirmed their phone number, that's the most important bit
    UserSession.create(@client.user)
    redirect_to '/'
  end
  
  def update
    @client = Client.find(params[:id])
    @client.address.postcode = find_or_create_postcode
    preprocess_params
    if @client.update_attributes(params[:client])
      flash[:notice] = "Your profile has been updated."
      redirect_to('/')
    else
      render(:action => :new)
    end    
  end
  
  def edit
    @client = Client.find(params[:id])
    render :action => :new
  end

private
  
  def save_booking    
    @booking.save!
    begin
      @booking.ask_cleaner! 
      flash[:notice] = "Thank you for the registration! You have successfully booked #{@booking.cleaner.first_name}." 
    rescue Exception => e
      e.backtrace.each{|msg| logger.error msg}
      logger.error "Could not send the activation message, activating."        
      @booking.destroy
      flash[:error] = 'Sorry, there was a problem making the booking you requested. Please try again'        
    end          
  end

  def redirect_due_to_confirmation_code
    @confirmation_code = params[:confirmation_code]    
    return if @confirmation_code_correct = confirmation_code_correct?
    @client.errors.add_to_base("Your phone confirmation code is not correct")
    render :action => :new
    true
  end
  
  def check_attempted_booking
    return unless session[:attempted_booking] and params[:booking] == 'yes'
    @booking = Booking.new(session[:attempted_booking]) 
    @booking.client = @client
  end  

  def confirmation_code_correct?
    value = params[:confirmation_code]
    return unless value and !value.blank?
    code = PhoneConfirmationCode.find_by_value(value)
    return unless code
    Phone.normalize(code.phone) == Phone.normalize(params[:client][:contact_details_attributes][:phone])
  end

  def preprocess_params
    params[:client][:address_attributes].delete(:postcode_attributes)
    params[:client][:user_attributes][:login] = params[:client][:contact_details_attributes][:phone]        
  end

  def find_or_create_postcode
    Postcode.find_or_create_by_normalized_value(params[:client][:address_attributes][:postcode_attributes][:value])
  end

end
