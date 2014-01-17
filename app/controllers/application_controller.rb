class ApplicationController < ActionController::Base
  before_action :authorize
  protect_from_forgery with: :exception
  # Trying to deploy with Heroku :)
  
  protected
  
  	def authorize
  		unless User.find_by_id(session[:user_id])
  			redirect_to login_url
  			flash[:error] = 'Please log in to access this page'
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
