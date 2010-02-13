# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def round_if_possible(value)    
    (value - value.round).abs < 0.1 ? value.round.to_i : value
  end
  
end
