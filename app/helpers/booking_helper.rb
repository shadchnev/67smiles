module BookingHelper
  
  def surcharge_select_content(booking)
    # [['Yes (no extra charge)', 1], [raw("No (£#{round_if_possible(booking.cleaner.surcharge)}/hour extra)"), 0]]
    options_for_select({'Yes (no extra charge)' => '1', raw("No (£#{round_if_possible(booking.cleaner.surcharge)}/hour extra)") => '0'},
      booking.cleaning_materials_provided? ? '1' : '0')
  end
end
