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
    params[:client][:user_attributes][:login] = params[:client][:contact_details_attributes][:email]
    @client = Client.new(params[:client])
    if @client.save
      flash[:notice] = "Thank you for the registration! Now you can book a cleaner in just couple of clicks."
      redirect_to('/')
    else
      render(:action => :new)
    end
  end
  

end
