class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
    
  end
  
  def index
    @all_ratings = Movie.movie_ratings
    @movies = Movie.all 
    if params[:ratings].present?    
      @movies = Movie.where(rating: params[:ratings].keys)
      session[:ratings] = params[:ratings]
    end
    if params[:sort]    
      @movies = @movies.order(params[:sort]).where(rating: session[:ratings].keys)
        if params[:sort] == 'title'
          @title_header = 'hilite'
        elsif params[:sort] == 'release_date'
          @release_header ='hilite'
        end
      session[:current_sort] = params[:sort]
    end
    current_uri = request.env['PATH_INFO']
    flash[:last_search_path] = current_uri
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(:ratings => session[:ratings], :sort => session[:current_sort])
    flash.keep
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title} deleted."
    redirect_to movies_path(:ratings => session[:ratings], :sort => session[:current_sort])
  end

end
