require 'test_helper'
require "authlogic/test_case"

class BookingsControllerTest < ActionController::TestCase
  
  setup :activate_authlogic
  
  def setup
    Sms.any_instance.stubs(:dispatch).returns(true)
    @cleaner = Cleaner.build!        
    @client = Client.build!
    UserSession.find.destroy # users are automatically logged in when created
  end
  
  test "a stranger can book a cleaner" do
    post :provisionally_create, booking_params
    assert_redirected_to :controller => :clients, :action => :new
  end
 
  test "parameters are parsed properly" do
    login @client
    post :create, booking_params
    booking = Booking.first
    assert booking 
    assert_redirected_to cleaner_path(@cleaner)
    assert_equal Time.parse('15-02-2010 08:00'), booking.start_time
    assert_equal Time.parse('15-02-2010 10:00'), booking.end_time
    assert_equal true, booking.cleaning_materials_provided
    assert_equal @cleaner.id, booking.cleaner.id
    assert_equal @client.id, booking.client.id
  end
  
  test "'no cleaning materials' is parsed" do
    login @client
    updated_params = booking_params
    updated_params["booking"]["cleaning_materials_provided"] = '0'
    post :create, updated_params
    booking = Booking.first
    assert !booking.cleaning_materials_provided
  end
  
  test "cleaner can access their bookings" do
    login(@cleaner)
    get :index, {"cleaner_id" => @cleaner.id}
    assert_template 'cleaners_index'
  end
  
  test "client can access their bookings" do
    login(@client)
    get :index, {"client_id" => @client.id}
    assert_template 'clients_index'
  end
  
  test "stranger cannot access clients bookings" do
    get :index, {"client_id" => @client.id}
    assert_redirected_to '/'
  end
  
  test "stranger cannot access cleaners bookings" do
    get :index, {"cleaner_id" => @cleaner.id}
    assert_redirected_to '/'
  end
  
  test "stranger can try to book a cleaner if id is supplied" do
    get :new, {"cleaner_id" => @cleaner.id}
    assert_template 'new'
  end
    
  test "client can try to book a cleaner if id is supplied" do
    login @client
    get :new, {"cleaner_id" => @cleaner.id}
    assert_template 'new'
  end
    
  test "client can not try to book a wrong cleaner" do
    login @client
    assert_raises(ActiveRecord::RecordNotFound) {
      get :new, {"cleaner_id" => 0}    
    }
  end
  
  test "cleaner cannot try to book a cleaner" do
    login @cleaner
    get :new, {"cleaner_id" => @cleaner.id}
    assert_redirected_to '/'
  end
    
  test "clients may create bookings" do
    login @client
    post :create, booking_params
    assert_redirected_to cleaner_path(@cleaner)
  end
    
  test "strangers may not create bookings" do
    post :create, booking_params
    assert_redirected_to '/'
  end
    
  test "cleaners may not create bookings" do
    login @cleaner
    post :create, booking_params
    assert_redirected_to '/'
  end
  
  test "cleaner can accept a booking" do
    booking = Booking.build!
    login booking.cleaner
    post :accept, {"id" => booking.id, "cleaner_id" => booking.cleaner.id}
    assert_match /Booking was accepted/, flash[:notice]
  end
    
  test "cleaner can decline a booking" do
    booking = Booking.build!
    login booking.cleaner
    post :decline, {"id" => booking.id, "cleaner_id" => booking.cleaner.id}
    assert_match /Booking was declined/, flash[:notice]
  end
    
  test "cleaner can cancel a booking" do
    booking = Booking.build!
    login booking.cleaner
    post :cancel, {"id" => booking.id, "cleaner_id" => booking.cleaner.id}
    assert_match /Booking was cancelled/, flash[:notice]
  end
    
  test "cleaner cannot cancel a booking they don't own" do
    booking = Booking.build!
    login @cleaner
    post :cancel, {"id" => booking.id, "cleaner_id" => booking.cleaner.id}
    assert_match /not authorized/, flash[:warn]
  end
    
  test "client cannot accept a booking" do
    booking = Booking.build!
    login booking.client
    post :accept, {"id" => booking.id, "cleaner_id" => booking.cleaner.id}
    assert_match /not authorized/, flash[:warn]
  end
    
  test "client cannot decline a booking" do
    booking = Booking.build!
    login booking.client
    post :decline, {"id" => booking.id, "cleaner_id" => booking.cleaner.id}
    assert_match /not authorized/, flash[:warn]
  end
    
  test "client can cancel a booking" do
    booking = Booking.build!
    login booking.client
    post :cancel, {"id" => booking.id, "cleaner_id" => booking.cleaner.id}
    assert_match /Booking was cancelled/, flash[:notice]
  end
    
  test "client cannot cancel a booking they don't own" do
    booking = Booking.build!
    login @client
    post :cancel, {"id" => booking.id, "cleaner_id" => booking.cleaner.id}
    assert_match /not authorized/, flash[:warn]
  end
    
private

  def booking_params
    {"booking_date"=>"1266192000", "booking"=>{"start_time"=>"8", "end_time"=>"10", "cleaning_materials_provided"=>"1"}, "commit"=>"Hire Emma", "cleaner_id"=>@cleaner.id, "client_id"=>@client.id}
  end

  def login(person)
    UserSession.create(person.user)
  end

end
