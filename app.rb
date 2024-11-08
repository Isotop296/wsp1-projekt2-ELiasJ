class App < Sinatra::Base
    def db
        return @db if @db

        @db = SQLite3::Database.new("db/fruits.sqlite")
        @db.results_as_hash = true

        return @db
    end


    get '/' do
        erb(:"new")
    end

    get '/spel' do
        @spel = db.execute('SELECT * FROM fruits')
        erb(:"spel/index")
    end

    get '/spel/:id' do | id |
        result = db.execute('SELECT beskrivning FROM spel WHERE id = ?', [id]).first
        @spel_info = result["description"] if result 
        erb(:"fruits/show")
    end
end
