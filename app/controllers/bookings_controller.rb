class BookingsController < ApplicationController
  
  before_filter :find_both
  before_filter :authenticate, :except => :new
  before_filter :find_booking, :only => [:accept, :cancel, :decline]
  before_filter :authorize_person, :only => [:index, :cancel]
  before_filter :authorize_client, :only => [:create]
  before_filter :authorize_cleaner, :only => [:accept, :decline]
  before_filter :stop_cleaner, :only => [:new]
  
  def index    
    @cleaner ? cleaners_index : clients_index
  end
  
  def new
    @booking = Booking.new
    @booking.cleaner = @cleaner
    @booking_date = (Time.now + 1.day).to_i # default value
  end
  
  def create
    @booking = Booking.new do |b|            
      b.cleaner, b.client = @cleaner, @client
      %w[start_time end_time].each do |t|
        day, hour = params[:booking_date].to_i, params[:booking][t.to_sym].to_i*3600
        b.send("#{t}=", Time.at(day + hour))
      end      
      b.cleaning_materials_provided = params[:booking][:cleaning_materials_provided] == '1'
    end
    if @booking.save
      @booking.sms!
      redirect_to(cleaner_path(@cleaner))
      flash[:notice] = "Thank you. We have sent a text to #{@booking.cleaner.first_name} to confirm the availability. You will receive an email from us when #{@cleaner.first_name} replies."
    else
      render(:action => :new)    
    end
  end
  
  def accept
    @booking.accept!
    flash[:notice] = 'Booking was accepted'
    redirect_back_or_to '/'
  end
  
  def cancel
    @booking.cancel!
    flash[:notice] = 'Booking was cancelled'
    redirect_back_or_to '/'
  end
  
  def decline
    @booking.decline!    
    flash[:notice] = 'Booking was declined'
    redirect_back_or_to '/'
  end
  
private

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
  
  def stop_cleaner
    go_home if current_user and current_user.cleaner?
  end
  
  def client_authorized?
    @client == current_user.owner
  end
  
  def cleaner_authorized?
    @cleaner == current_user.owner
  end

  def find_booking
    @booking = Booking.find(params[:id]) if params[:id]    
    raise "Couldn't find a booking with id = #{params[:id]}" unless @booking
  end

  def find_both
    @cleaner = Cleaner.find(params[:cleaner_id]) if params[:cleaner_id]
    @client  =  Client.find(params[:client_id])  if params[:client_id]
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
