class ClientsController < ApplicationController
  
  def new
    @client = Client.new        
    @client.name = Name.new
    @client.address = Address.new
    @client.address.postcode = Postcode.new
    @client.contact_details = ContactDetails.new
    @client.user = User.new
  end
  
  def create
    postcode = find_or_create_postcode
    preprocess_params
    @client = Client.new(params[:client])
    @client.address.postcode = postcode    
    message = "Thank you for the registration! Now you can book a cleaner in just couple of clicks."
    begin
      Client.transaction do
        booking = Booking.new(session[:attempted_booking]) if session[:attempted_booking]
        if booking
          booking.client = @client
          booking.save!
          booking.sms!       
          message = "Thank you for the registration! You have successfully booked #{booking.cleaner.first_name}" 
        else
          @client.save!          
        end
      end
      flash[:notice] = message
      redirect_to('/')
    rescue Exception => e
      flash[:error] = e.message
      render(:action => :new)
    end
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

  def preprocess_params
    params[:client][:address_attributes].delete(:postcode_attributes)
    params[:client][:user_attributes][:login] = params[:client][:contact_details_attributes][:email]        
  end

  def find_or_create_postcode
    Postcode.find_or_create_by_normalized_value(params[:client][:address_attributes][:postcode_attributes][:value])
  end

end
