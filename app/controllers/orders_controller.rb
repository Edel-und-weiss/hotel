class OrdersController < ApplicationController
	skip_before_action :authorize, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all
  end
  
  def show
  end

  def new
  	@cart = current_cart
  	if @cart.line_items.empty?
  		redirect_to store_url, notice: "Your R-list is empty"
  		return
  	end
  	
  	
  
    @order = Order.new
    respond_to do |format|
    	format.html
    	format.json { render json: @order }
    end
  end

  def edit	
  end

  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(current_cart)
    case
    	when session[:first_type] == ""
    		session[:first_type_quant] = 0
    	when session[:second_type] == ""
    		session[:second_type_quant] = 0
    	when session[:third_type] == ""
    		session[:third_type_quant] = 0
    end
    @first_type = "Одноместный cтандарт"
    @second_type = "Одноместный улучшенный"
    @third_type = "Двухместный двухкомнатный"
    @order.reserved_rooms = session[:first_type_quant].to_s + " x " + @first_type + "; " +
    		session[:second_type_quant].to_s + " x " + @second_type + "; " + 
    		session[:third_type_quant].to_s + " x " + @third_type;


    respond_to do |format|
      if @order.save
      	Cart.destroy(session[:cart_id])
      	session[:cart_id] = nil
        format.html { redirect_to store_url, notice: 'Thank you for your order.' }
        format.json { render json: @order, status: :created, location: @order }
      else
      	@cart = current_cart
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
		
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
    
    rescue ActiveRecord::StaleObjectError
			flash[:error] = 'Order edit conflict. Information about order
											 editing another operator at this moment.'
			render action: 'edit'
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:name, :date_of_arrival, :date_of_departure, :reserved_rooms, :email, :mobile, :lock_version)
    end
end
