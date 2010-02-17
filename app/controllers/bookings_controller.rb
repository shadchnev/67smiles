class BookingsController < ApplicationController
  
  def new
    @booking = Booking.new
    @booking.cleaner = Cleaner.find(params[:cleaner_id])
  end
  
  def create
    @booking = Booking.new do |b|            
      b.cleaner = Cleaner.find(params[:cleaner_id])
      %w[start_time end_time].each do |t|
        b.send("#{t}=",  Time.parse([params[:booking_date], params[:booking][t.to_sym]].join(' ')))
      end
      b.cleaning_materials_provided = params[:cleaning_materials_provided] == '0'
    end
    if @booking.save
      redirect_to(cleaner_path(@booking.cleaner))
      flash[:notice] = "Thank you. We have sent a text to #{@booking.cleaner.first_name} to confirm the availability. You will receive an email from us when #{@booking.cleaner.first_name} replies."
    else
      render(:action => :new)    
    end
  end
  
end
