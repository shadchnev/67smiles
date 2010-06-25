class CleanersController < ApplicationController
  
  before_filter :find_logged_in_cleaner, :only => [:snap, :delete_photo, :edit, :update]
  
  def create
    params[:cleaner].delete(:postcode_attributes) if existing_postcode = Postcode.find_by_normalized_value(params[:cleaner][:postcode_attributes][:value]) # to prevent it from being created
    params[:cleaner][:user_attributes][:login] = params[:cleaner][:contact_details_attributes][:phone]
    @cleaner = Cleaner.new(params[:cleaner])
    @cleaner.postcode ||= existing_postcode
    if @cleaner.save
      #@cleaner.user.deliver_activation_instructions!
      Delayed::Job.enqueue AccountActivationJob.new(@cleaner.id)
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to(cleaner_path(@cleaner))
    else
      render(:action => :new)
    end
  end
  
  def update  
    existing_postcode = Postcode.find_by_normalized_value(params[:cleaner][:postcode_attributes][:value]) # to prevent it from being created
    raise "The postcode is invalid" unless existing_postcode
    params[:cleaner].delete(:postcode_attributes) 
    params[:cleaner][:user_attributes][:login] = params[:cleaner][:contact_details_attributes][:phone]
    @cleaner.postcode = existing_postcode
    @cleaner.update_attributes!(params[:cleaner]) 
    flash[:notice] = 'Your profile has been updated.'
    redirect_to(cleaner_path(@cleaner))
  rescue Exception => e
    flash[:error] = e.message      
    render(:action => :new)
  end
  
  def edit
    @lead_photo = @cleaner.photo.file? ? @cleaner.photo.url(:large) : 'lead-photo-student.png'
    render :action => :new
  end
  
  def show
    @cleaner = Cleaner.find(params[:id])
    @lead_photo = @cleaner.photo.file? ? @cleaner.photo.url(:large) : 'no-photo-large.png'
    if current_user and current_user.client?
      @review = Review.new
      @review.cleaner = @cleaner
      @review.client = current_user.owner
    end
  end
  
  def new
    @lead_photo = 'lead-photo-student.png'
    @cleaner = Cleaner.new
    @cleaner.name = Name.new
    @cleaner.name.first_name = params[:first_name]
    @cleaner.name.last_name = params[:last_name]
    @cleaner.name.honorific = params[:title]
    @cleaner.postcode = Postcode.new
    @cleaner.contact_details = ContactDetails.new
    @cleaner.contact_details.email = params[:email]
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
    render :text => @cleaner.photo.url(:large)
  end
  
  def delete_photo
    @cleaner.photo = nil
    @cleaner.save!
    @cleaner.reload
    render :text => ''
  end
  
private

  def content_type(filename)
    types = MIME::Types.type_for(filename)
    return types.first.content_type unless types.empty?
  end
  
  def find_logged_in_cleaner
    raise "You must be logged in" unless current_user
    raise "Logged in user is #{current_user.owner.class}, not a cleaner" unless current_user.cleaner?
    @cleaner = current_user.owner
  end
    
end
