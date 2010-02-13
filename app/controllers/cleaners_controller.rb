class CleanersController < ApplicationController
  
  def create
    @cleaner = Cleaner.new(params[:cleaner])
    @cleaner.save ? redirect_to(cleaner_path(@cleaner)) : render(:action => :new)
  end
  
  def show
    @cleaner = Cleaner.find(params[:id])
  end
  
  def new
    @cleaner = Cleaner.new
    @cleaner.name = Name.new
    @cleaner.postcode = Postcode.new
    @cleaner.contact_details = ContactDetails.new
    @cleaner.skills = Skills.new
    @cleaner.availability = Availability.new
  end
  
  def availability
    @cleaner = Cleaner.find(params[:id])
    respond_to do |wants|
      wants.json {
        render :json => @cleaner.availability.to_hash.to_json
      }
    end
  end
  
end
