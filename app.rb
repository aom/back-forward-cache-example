require 'sinatra/base'
require 'json'
require 'rdiscount'

class App < Sinatra::Base

  enable :sessions

  configure do
    xmen = [
      { id: "1", name: "Charles Francis Xavier", alias: "Professor X" },
      { id: "2", name: "Scott Summers", alias: "Cyclops" },
      { id: "3", name: "Robert Louis \"Bobby\" Drake", alias: "Iceman" },
      { id: "4", name: "Warren Kenneth Worthington III", alias: "Angel" },
      { id: "5", name: "Henry Philip \"Hank\" McCoy", alias: "Beast" },
      { id: "6", name: "Jean Grey-Summers", alias: "Phoenix" },
      { id: "7", name: "James \"Logan\" Howlett", alias: "Wolverine" }
    ]
    set :memorydb, { items: xmen }
  end

  after do
    if session[:responsefix] == true
      response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
      response.headers['Pragma'] = 'no-cache'
      response.headers['Expires'] = '0'
      response.headers['Response-Fix'] = 'enabled'
    else
      response.headers['Response-Fix'] = 'disabled'
    end
  end

  get '/' do
    session[:ua] = request.user_agent
    session[:db] = settings.memorydb[:items]
    session[:listCount] = 0
    session[:metafix] = session[:metafix] || false
    session[:responsefix] = session[:responsefix] || false
    session[:eventfix] = session[:eventfix] || false
    erb :welcome, locals: {
      metafix: false
    }
  end

  get '/enable/:fix' do
    session[params[:fix].to_s] = true
    redirect "/"
  end

  get '/disable/:fix' do
    session[params[:fix].to_s] = false
    redirect "/"
  end

  get '/list' do
    redirect "/" if all_items.nil?

    session[:listCount] = (session[:listCount] || 0).to_i + 1
    erb :list, locals: {
      items: all_items
    }
  end

  get '/list/:id' do
    redirect "/" if all_items.nil?

    erb :show, locals: {
      item: find_by_id(params[:id])
    }
  end

  delete '/list/:id' do
    all_items.delete(find_by_id(params[:id]))
    "DELETED #{params[:id]}"
  end

  post '/list/:id' do
    all_items.each do |obj|
      if obj[:id] == params[:id]
        obj[:alias] = params[:alias]
        obj[:name] = params[:name]
      end
    end
    "UPDATED #{params[:id]}"
  end

  get '/readme' do
    erb :readme
  end

  def all_items
    session[:db]
  end

  def find_by_id(id)
    all_items.select {|obj| obj[:id] == id }.first
  end
end
