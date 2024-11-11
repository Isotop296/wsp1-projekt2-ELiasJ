class App < Sinatra::Base
    def db
        return @db if @db

        @db = SQLite3::Database.new("db/spel.sqlite")
        @db.results_as_hash = true

        return @db
    end


    get '/' do
        redirect('/spel')
    end

    get '/spel' do
        @spel = db.execute('SELECT * FROM spel')
        erb(:"spel/index")
    end
end
