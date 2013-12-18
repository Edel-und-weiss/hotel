class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authorize
  protect_from_forgery with: :exception
  
  protected
  
  	def authorize
  		unless User.find_by_id(session[:user_id])
  			redirect_to login_url, notice: "Please log in"
  		end
  		
  		if User.count.zero?
    		redirect_to new_user_path, :notice => "Please create a user" 
  		end
  	end
  
  private
  
  def current_cart
  	Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
  	cart = Cart.create
  	session[:cart_id] = cart.id
  	cart  
  end
  
  
end
