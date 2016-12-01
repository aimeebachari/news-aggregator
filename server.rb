require 'sinatra'
require 'pry'
require 'csv'

set :bind, '0.0.0.0'

get '/articles' do
  @articles = []
  CSV.foreach('articles.csv', headers:true) do |row|
    @articles << row.to_h
  end
  erb :articlelist
end

post '/articles/new' do
  title = params[:title]
  url = params[:url]
  description = params[:description]
  @errors = []

  if title == ""
    @errors << "You have provided an invalid title."
  end

  if !url.include?(".") || url.include?(' ')
    @errors << "You have provided an invalid url."
  end

  if description.length < 20
    @errors << "You have provided an invalid description."
  end

  if @errors.length == 0
    CSV.open('articles.csv', 'a', headers:true) do |csv|
      csv << [title, url, description]
    end

    redirect '/articles'
  else
    erb :new
  end
end

get '/articles/new' do
  erb :new
end
