class ApplicationController < Sinatra::Base
    configure do
      set :public_folder, 'public'
      set :views, 'app/views'
    end

    # code actions here!

    get '/' do
        erb :'/index'
    end

    post '/upload' do
        csv_data = CSV.read(params[:camp][:upload][:tempfile], headers:true, encoding:'iso-8859-1:utf-8')
        filename = params[:camp][:upload][:filename]
        Parser.new(filename, csv_data).import
        binding.pry
        puts 'hi'
    end

  end