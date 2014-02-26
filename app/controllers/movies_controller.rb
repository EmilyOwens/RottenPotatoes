# Thanks to:
#	Jessica Lynch

class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
	@all_ratings = Movie.getRatings

	if params[:sort_by] == 'title'
		@title_header = 'hilite'
		@movies = Movie.order("title")
	end
	
	if params[:sort_by] == 'rating'
		@rating_header = 'hilite'
		@movies = Movie.order("rating")
	end

	if params[:sort_by] == 'release_date'
		@date_header = 'hilite'
		@movies = Movie.order("release_date")
	end

	# Check to see if params are empty. If not, 	
	if !(params[:ratings].nil?)
		session[:ratings] = params[:ratings]
		@movies = @movies.select {|movie| params[:ratings].include?(movie.rating)}
	
	elsif !(session[:ratings].nil?)
		@movies = @movies.select {|movie| session[:ratings].include?(movie.rating)}
	end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
