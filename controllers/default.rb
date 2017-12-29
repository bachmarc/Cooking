class App < Sinatra::Base
	# Show the index.erb page
	get '/' do
		erb :event_registration
  end

end