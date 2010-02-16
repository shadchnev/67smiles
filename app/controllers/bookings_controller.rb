class BookingsController < ApplicationController
  
  def new
    @cleaner = Cleaner.find(params[:cleaner_id])
    @booking = Booking.new
  end
  
  def create
    @booking = Booking.new do |b|            
      b.cleaner = Cleaner.find(params[:cleaner_id])
      %w[start_time end_time].each do |t|
        b.send("#{t}=",  Time.parse([params[:booking_date], params[:booking][t.to_sym]].join(' ')))
      end
      b.cleaning_materials_provided = params[:cleaning_materials_provided] == '0'
    end
    @booking.save ? redirect_to(cleaner_booking_path(@booking.cleaner.id, @booking)) : render(:action => :new)    
  end
  
end
