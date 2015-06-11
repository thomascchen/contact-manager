require 'sinatra'
require 'sinatra/reloader'
require "sinatra/activerecord"
require 'pry'

require_relative 'models/contact'
also_reload 'models/contact'

get '/' do
  page = params[:page]||0

  if page.to_i < 0
    redirect '/'
  elsif page.to_i > 0
    num_offset = (page.to_i) * 5
  else
    num_offset = 0
  end

  query_first = params[:first_name]
  query_second = params[:last_name]

  if query_first == nil || query_second == nil
    @contacts = Contact.limit(5).offset(num_offset)
  else
    @contacts = Contact.where(first_name: query_first, last_name: query_second)
  end

  erb :index, locals: { page: page }
end

get '/contacts/:id' do
  @contact = Contact.find(params[:id])
  erb :show
end

get '/new' do
  erb :new
end

post '/new' do
Contact.create(first_name: params[:first_name], last_name: params[:last_name], phone_number: params[:phone_number])
  redirect '/'
end
