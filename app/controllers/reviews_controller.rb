class ReviewsController < ApplicationController
  
  def create
    @review = Review.new(params[:review])
    @review.client = current_user.owner if current_user and current_user.client?
    if @review.save
      flash[:notice] = 'Thank you for your review'
      redirect_to cleaner_path(@review.cleaner)
    else
      flash[:error] = 'Sorry, there was a problem adding your review'      
      redirect_to @review.cleaner ? cleaner_path(@review.cleaner) : '/'
    end    
  end
  
end
