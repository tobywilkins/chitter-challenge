ENV['RACK_ENV'] ||= 'development'

require 'sinatra/base'
require './models/user'
require './models/peep'
require './data_mapper_setup'
require 'sinatra/flash'

class Chitter < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'

  register Sinatra::Flash

  get '/' do
    current_user
    @peeps = Peep.all
    erb(:index)
  end

  get '/register' do
    erb(:register)
  end

  post '/register' do
    @user = User.create(name: params[:name],
                        email: params[:email],
                        password: params[:password],
                        password_confirmation: params[:password_confirmation],
                        username: params[:username])
    if @user.save
      session[:user_id] = @user.id
      redirect '/'
    else
      flash.now[:errors] = @user.errors.full_messages
      erb(:register)
    end
  end

  get '/session/new' do
    erb(:new_session)
  end

  post '/session/new' do
  @user = User.authenticate(params[:username],params[:password])
    if !!@user
      session[:user_id] = @user.id
      redirect '/'
    else
      flash.now[:errors] = ["cannot authenticate - please check your username & password"]
      erb(:new_session)
    end
  end

  post '/session/end' do
    @current_user = nil
    session[:user_id] = nil
    redirect '/'
  end

  get '/peep/new' do
    erb(:new_peep)
  end

  post '/peep/new' do
    peep = Peep.create(message: params[:message])
    p peep
    current_user.peeps << peep
    current_user.save
    redirect '/'
  end

  helpers do
      def current_user
        @current_user ||= (User.get(session[:user_id]))
      end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
