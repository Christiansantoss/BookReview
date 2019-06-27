class ReviewsController < ApplicationController
    before_action :find_book

    def new
        @review = Review.new 
    end

    def create 
        @review = Review.new(review_params)
        @review.book_id = @book.id # sets review attribute to the current book.id
        @review.user_id = currrent_user.id
         # line 10-11  - associate a review with the current book and with the current user
         # @ instance variables/attributes available because created those migrations  
        if @review.save
            redirect_to book_path(@book)
        else 
          render 'new'
        end
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

end