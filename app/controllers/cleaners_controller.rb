class CleanersController < ApplicationController
  
  before_filter :find_logged_in_cleaner, :only => [:snap, :delete_photo]
  
  def create
    params[:cleaner].delete(:postcode_attributes) if existing_postcode = Postcode.find_by_normalized_value(params[:cleaner][:postcode_attributes][:value]) # to prevent it from being created
    params[:cleaner][:user_attributes][:login] = params[:cleaner][:contact_details_attributes][:email]
    @cleaner = Cleaner.new(params[:cleaner])
    @cleaner.postcode ||= existing_postcode
    @cleaner.save ? redirect_to(cleaner_path(@cleaner)) : render(:action => :new)
  end
  
  def update  
    params[:cleaner].delete(:postcode_attributes) if existing_postcode = Postcode.find_by_normalized_value(params[:cleaner][:postcode_attributes][:value]) # to prevent it from being created
    params[:cleaner][:user_attributes][:login] = params[:cleaner][:contact_details_attributes][:email]
    @cleaner = Cleaner.find(params[:id])
    @cleaner.postcode ||= existing_postcode    
    if @cleaner.update_attributes(params[:cleaner]) 
      flash[:notice] = 'Your profile has been updated.'
      redirect_to(cleaner_path(@cleaner))
    else
      render(:action => :new)
    end
  end
  
  def edit
    @cleaner = Cleaner.find(params[:id])
    render :action => :new
  end
  
  def show
    @cleaner = Cleaner.find(params[:id])
    if current_user and current_user.client?
      @review = Review.new
      @review.cleaner = @cleaner
      @review.client = current_user.owner
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
  
  # uploads a photo of the cleaner
  def snap
    @cleaner.photo = params[:photo][:file]
    content_type = content_type(@cleaner.photo_file_name)
    @cleaner.photo_content_type = content_type if content_type
    @cleaner.save!
    render :text => @cleaner.photo.url(:medium)
  end
  
  def delete_photo
    @cleaner.photo = nil
    puts "#{@cleaner.first_name} has photo: #{@cleaner.photo}"
    @cleaner.save!
    @cleaner.reload
    puts "#{@cleaner.first_name} has photo: #{@cleaner.photo}"
    render :text => ''
  end
  
private

  def content_type(filename)
    types = MIME::Types.type_for(filename)
    return types.first.content_type unless types.empty?
  end
  
  def find_logged_in_cleaner
    raise "The user is not logged in" unless current_user
    raise "Logged in user is #{current_user.owner.class}, not a cleaner" unless current_user.cleaner?
    @cleaner = current_user.owner
  end
    
end
