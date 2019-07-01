class ReviewsController < ApplicationController
    before_action :find_book
    before_action :find_review, only: [:edit, :update, :destroy]
    before_action :authenticate_user!, only: [:new, :edit]

    def new
        @review = Review.new 
    end

    def create 
        @review = Review.new(review_params)
        @review.book_id = @book.id #sets review attribute to the current book.id
        @review.user_id = current_user.id
         #line 10-11  - associate a review with the current book and with the current user
         #instance variables/attributes available because created those migrations  
        if @review.save
            redirect_to book_path(@book)
        else 
          render 'new'
        end
    end

    def edit 
      #@review = Review.find(params[:id])
      #we are finding book so the @review instance is avialable 
    end

    def update
      #@review = Review.find(params[:id])
      if @review.update(review_params) #when a user fills out the form there passing in review params from the private method review params
        redirect_to book_path(@book)
        #line 29 at @book is avialable because we are finding the book
      else
        render 'edit'
      end
    end

    def destroy 
      @review.destroy
      redirect_to book_path(@book)
    end

    private
      def review_params
        params.require(:review).permit(:rating, :comment)
      end 

      def find_book
        @book = Book.find(params[:book_id])
        #specify :book_id instead of just :id because we are in the reviews controller
        #and a review is associated with a book_id 
      end 

      def find_review
        @review = Review.find(params[:id])
        # line 47 refactored from line 27 in a private method so we can call it from the edit, update and destroy methods.

end
end
