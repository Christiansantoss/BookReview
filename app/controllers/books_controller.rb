class BooksController < ApplicationController
    before_action :find_book, only: [:show, :edit, :update, :destroy]
    def index
        @books = Book.all.order("created_at DESC") #display all books from the model
    end

    def show
    end

    def new
        @book = Book.new
    end

    def create
        @book = Book.new(book_params)

        if @book.save # If book saves redirect to root path 
            redirect_to root_path
        else 
            render 'new'
        end
    end

    def edit 
    end

    def update
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
            params.require(:book).permit(:title, :description, :author)
        end

        def find_book
            @book = Book.find(params[:id])
        end

end

# @ instances variables are what we use in our views/html template 