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
        @spel_klara = db.execute('SELECT * FROM spel where kategori = ?', ["true"])
        @spel_oklara = db.execute('SELECT * FROM spel where kategori = ?', ["false"])
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
        spel_kategori = params[:spel_kategori]
        db.execute('INSERT INTO spel (namn, pris, beskrivning, kategori) VALUES (?, ?, ?, ?)', [spel_namn, spel_pris, spel_beskrivning, spel_kategori])
        redirect('/spel') 
    end


    post '/spel/:id/delete' do
        id = params[:id]
        db.execute('DELETE FROM spel where id = ?', [id])
        redirect '/spel'
    end

    get '/spel/:id/edit' do |id|
        @spel = db.execute('SELECT * FROM spel WHERE id = ?', id).first
        erb(:"spel/edit")
    end

    post '/spel/:id/update' do |id|
        namn = params[:spel_namn]
        pris = params[:spel_pris]
        beskrivning = params[:spel_beskrivning]
        spel_kategori = params[:spel_kategori]
        db.execute('UPDATE spel SET namn = ?, pris = ?, beskrivning = ?, kategori = ? WHERE id = ?', [namn, pris, beskrivning, spel_kategori, id])
        redirect "/spel"
    end

    get '/spel/loggin' do
        erb(:"spel/loggin")
    end


end
