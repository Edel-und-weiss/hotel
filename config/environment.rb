# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Hotel::Application.initialize!

# Настраиваем конфигурацию для отправки e-mail клиентам
Hotel::Application.configure do

	config.action_mailer.delivery_method = :smtp
	
	config.action_mailer.smtp_settings = {
		address:				"smtp.gmail.com",
		port:						 587,
		domain:					"hotel-edelweiss.heroku.com",
		authentication: "plain",
		user_name: 			"edelweiss1942",
		password:				"gross_Deutschland13thcorps",
		enable_starttls_auto: true 
		}

end
