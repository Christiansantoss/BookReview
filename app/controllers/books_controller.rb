class BooksController < ApplicationController
    before_action :find_book, only: [:show, :edit, :update, :destroy]
    def index
        @books = Book.all.order("created_at DESC") #display all books from the model
    end

    def show
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
            params.require(:book).permit(:title, :description, :author, :category_id)
        end

        def find_book
            @book = Book.find(params[:id])
        end

end

# @ instances variables are what we use in our views/html template 