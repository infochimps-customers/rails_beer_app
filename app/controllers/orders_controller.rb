class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    flash[:error] = "<p>Silly chimp!  You can't really buy beer from this website!.</p><p>But please join Winnie and Dhruv for drinks at 6pm today at <a href='http://www.yelp.com/biz/doug-fir-lounge-portland#query:douglas%20fir'>Doug Fir Lounge</a>.".html_safe
    redirect_to :back
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(params[:order])
      redirect_to @order, :notice  => "Successfully updated order."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to orders_url, :notice => "Successfully destroyed order."
  end
end
