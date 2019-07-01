class BooksController < ApplicationController
    before_action :find_book, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, only: [:new, :edit]
    def index
        if params[:category].blank? #if the category params are blank and we didnt pass any we want to display all the books because we are not filtering
            @books = Book.all.order("created_at DESC") #display all books from the model
        else
           @category_id = Category.find_by(name: params[:category]).id # getting id of category that were passing in 
           @books = Book.where(:category_id => @category_id).order("created_at DESC") # getting books where category id is books category id 
        end
    end

    def show
        if @book.reviews.blank?
          @average_review = 0
          #if book has no reviews setting to 0
        else
            @average_review = @book.reviews.average(:rating).round(2)
            #if reviews are not blank and average them on rating attribute
        end
    end

    def new
        @book = current_user.books.build
        # line 13 explained: when we create select_tag for the dropdown menu in the form partial file,
        # options_for_select requires an arrays, which provide the text for the dropdown option (its name) 
        # and the value it represents (its id attribute)
        @categories = Category.all.map{ |c| [c.name, c.id] } # Way to access categories when we create a new book
    end

    def create
        @book = current_user.books.build(book_params)
        @book.category_id = params[:category_id] # Associate a book with a category id

        if @book.save # If book saves redirect to root path 
            redirect_to root_path
        else 
            render 'new'
        end
    end

    def edit 
        @categories = Category.all.map{ |c| [c.name, c.id] }
    end

    def update
        @book.category_id = params[:category_id]
        # Checking if book is updated successfully 
        if @book.update(book_params)
            redirect_to book_path(@book)
        else 
            render 'edit'
        end
    end

    def destroy 
        @book.destroy 
        redirect_to root_path
    end


    private 

        def book_params
            params.require(:book).permit(:title, :description, :author, :category_id, :book_img)
        end

        def find_book
            @book = Book.find(params[:id])
        end

end

# @ instances variables are what we use in our views/html template 