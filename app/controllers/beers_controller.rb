class BeersController < ApplicationController

  before_filter :authenticate, :except => [:index, :show]
  
  def index
    @beers = Beer.all
  end

  def show
    @beer = Beer.find(params[:id])
  end

  def new
    @beer = Beer.new
  end

  def create
    @beer = Beer.new(params[:beer])
    if @beer.save
      redirect_to @beer, :notice => "Successfully created beer."
    else
      render :action => 'new'
    end
  end

  def edit
    @beer = Beer.find(params[:id])
  end

  def update
    @beer = Beer.find(params[:id])
    if @beer.update_attributes(params[:beer])
      redirect_to @beer, :notice  => "Successfully updated beer."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @beer = Beer.find(params[:id])
    @beer.destroy
    redirect_to beers_url, :notice => "Successfully destroyed beer."
  end
end
