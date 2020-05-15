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
      if params.empty?
        redirect '/'
      end
        csv_data = CSV.read(params[:camp][:upload][:tempfile], headers:true, encoding:'iso-8859-1:utf-8')
        filename = params[:camp][:upload][:filename]
        p = Parser.new(path: filename, data: csv_data)
        p.import
        Camper.assign
        content_type 'application/csv'
        attachment "#{p.path}"
        csv_string = p.create
    end

  end