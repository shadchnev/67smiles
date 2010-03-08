class ClientsController < ApplicationController
  
  def new
    @client = Client.new        
    # @client.name = Name.new
    # @client.address = Address.new
    # @client.address.postcode = Postcode.new
    # @client.contact_details = ContactDetails.new
  end
  
  def create
    @client = Client.new(params[:client])
    @client.save ? redirect_to(client_path(@client)) : render(:action => :new)
  end
  

end
