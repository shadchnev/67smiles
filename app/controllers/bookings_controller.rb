class BookingsController < ApplicationController
  
  before_filter :find_both
  before_filter :authenticate, :except => [:new, :provisionally_create]
  before_filter :find_booking_and_client, :only => [:accept, :cancel, :decline]
  before_filter :authorize_person, :only => [:index, :cancel]
  before_filter :authorize_client, :only => [:create]
  before_filter :authorize_stranger, :only => [:provisionally_create]
  before_filter :authorize_cleaner, :only => [:accept, :decline]
  before_filter :stop_cleaner, :only => [:new]
  
  def index    
    @cleaner ? cleaners_index : clients_index
  end
  
  def new
    @lead_photo = @cleaner.photo.file? ? @cleaner.photo.url(:large) : 'no-photo-large.png'
    if (current_user and session[:attempted_booking] and session[:attempted_booking][:cleaner_id] == @cleaner.id)
      @booking = Booking.new(session[:attempted_booking])
      flash[:notice].now = "Please review the booking before hiring #{@booking.cleaner.first_name}"
    else
      @booking = Booking.new
    end
    @booking.cleaner = @cleaner
    @booking_date = @booking.start_time ? @booking.start_time.to_i : Time.new.tomorrow.to_i
  end
  
  def provisionally_create    
    @booking = initialize_booking
    @booking.client = NoClient.new
    if @booking.valid?
      offer_to_create_account
    else
      render :action => :new
    end
  end
  
  def create
    @lead_photo = @cleaner.photo.file? ? @cleaner.photo.url(:large) : 'no-photo-large.png'
    @booking = initialize_booking
    try_to_save_booking
  end
  
  def accept
    @booking.accept!
    flash[:notice] = 'The booking was accepted'
    redirect_back_or_to '/'
  end
  
  def cancel
    @booking.cancel!
    flash[:notice] = 'The booking was cancelled'
    redirect_back_or_to '/'
  end
  
  def decline
    @booking.decline!    
    flash[:notice] = 'The booking was declined'
    redirect_back_or_to '/'
  end
  
private
  
  def initialize_booking
    Booking.new do |b|            
      b.client = @client if @client
      b.cleaner = @cleaner
      %w[start_time end_time].each do |t|
        day, hour = params[:booking_date].to_i, params[:booking][t.to_sym].to_i*3600
        b.send("#{t}=", Time.at(day + hour))
      end      
      b.cleaning_materials_provided = params[:booking][:cleaning_materials_provided] == '1'
    end    
  end
  
  def offer_to_create_account
    @booking.client = nil
    session[:attempted_booking] = @booking.to_partial_hash
    redirect_to :controller => :clients, :action => :new, :booking => 'yes'
  end

  def try_to_save_booking
    if @booking.save
      @booking.ask_cleaner!
      redirect_to(cleaner_path(@cleaner))
      flash[:notice] = "Thank you. We have sent a text to #{@booking.cleaner.first_name} to confirm the availability. You will receive a text from us when #{@cleaner.first_name} replies."
    else
      render(:action => :new)    
    end    
  end

  def go_home(msg = 'You are not authorized to access this page')
    flash[:warn] = msg
    redirect_to '/'
  end
  
  def authenticate
    go_home if current_user.nil?
  end

  def authorize_person
    go_home unless cleaner_authorized? or client_authorized?
  end
  
  def authorize_cleaner
    go_home unless cleaner_authorized?
  end
  
  def authorize_client
    go_home unless client_authorized?
  end
  
  def authorize_stranger
    go_home if current_user
  end
  
  def stop_cleaner
    go_home if current_user and current_user.cleaner?
  end
  
  def client_authorized?
    @client == current_user.owner
  end
  
  def cleaner_authorized?
    @cleaner == current_user.owner
  end

  def find_booking_and_client
    @booking = Booking.find(params[:id]) if params[:id]    
    raise "Couldn't find a booking with id = #{params[:id]}" unless @booking
    @client = @booking.client
  end

  def find_both
    @cleaner = Cleaner.find(params[:cleaner_id]) if params[:cleaner_id]
    @client  =  Client.find(params[:client_id])  if params[:client_id]
    # raise "client not found" unless @client
    @client ||= current_user.owner if current_user and current_user.client?
    raise "Couldn't find neither client nor cleaner for a booking" unless @cleaner or @client
  end
  
  def find_cleaner
    @cleaner = Cleaner.find(params[:cleaner_id])
    raise "Could not find a cleaner for #{params[:cleaner_id]}" unless @cleaner
  end

  def cleaners_index
    render 'cleaners_index'
  end
  
  def clients_index
    render 'clients_index'
  end
  
end
