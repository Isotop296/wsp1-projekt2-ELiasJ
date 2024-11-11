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

    get '/spel/:id' do | id |
        result = db.execute('SELECT beskrivning FROM spel WHERE id = ?', [id]).first
        @spel_info = result["beskrivning"] if result 
        erb(:"spel/show")
    end

    post '/spel' do 
        spel_namn = params[:spel_namn]
        spel_pris =  params[:spel_pris]
        spel_beskrivning =  params[:spel_beskrivning]
        db.execute('INSERT INTO spel (name, pris, beskrivning) VALUES (?, ?, ?)', [spel_namn, spel_pris, spel_beskrivning])
        redirect('/spel') 
    end



end
