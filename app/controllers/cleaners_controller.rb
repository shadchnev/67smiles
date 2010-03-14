class CleanersController < ApplicationController
  
  
  def create
    params[:cleaner][:user_attributes][:login] = params[:cleaner][:contact_details_attributes][:email]
    @cleaner = Cleaner.new(params[:cleaner])
    @cleaner.save ? redirect_to(cleaner_path(@cleaner)) : render(:action => :new)
  end
  
  def show
    @cleaner = Cleaner.find(params[:id])
    @review = Review.new
    if @current_user
      @review.cleaner = @cleaner
      @review.client = @current_user.owner
    end
  end
  
  def new
    @cleaner = Cleaner.new
    @cleaner.name = Name.new
    @cleaner.postcode = Postcode.new
    @cleaner.contact_details = ContactDetails.new
    @cleaner.skills = Skills.new
    @cleaner.availability = Availability.new
    @cleaner.user = User.new
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
