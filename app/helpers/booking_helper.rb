module BookingHelper
  
  def surcharge_select_content(booking)    
    options_for_select({'Yes (no extra charge)' => '1', raw("No (\u00A3#{round_if_possible(booking.cleaner.surcharge)}/hour extra)") => '0'},
      booking.cleaning_materials_provided? ? '1' : '0')
  end
  
  def clients_booking_messages(cleaner)
    {
      :cleaning_materials_provided => "You will be expected to provide cleaning materials for #{cleaner.first_name}",
      :cleaning_materials_not_provided => "#{cleaner.first_name} will bring cleaning materials"
    }
  end
  
  def cleaners_booking_messages(client)
    {
      :cleaning_materials_provided => "#{client.first_name} will provide cleaning materials",
      :cleaning_materials_not_provided => "You will be expected to bring your own cleaning materials"
    }
  end
  
  def new_booking_form_url
    current_user ? cleaner_bookings_path(@cleaner) : provisionally_create_cleaner_bookings_path(@cleaner)
  end
    
end
