class App < Sinatra::Base
    @user = nil

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

    get '/loggin' do
        erb(:"spel/loggin")
    end

    post "/loggin/new" do
        username = params[:username]
        password = params[:password]
    
        user_exists = db.execute('SELECT * FROM users WHERE username = ?', [username]).first
    
        if user_exists
            @error_message = "username already in use or inapropriet, choose another one"
            return erb(:"spel/loggin")
        else
            password_hash = BCrypt::Password.create(password)
            db.execute('INSERT INTO users (username, password, admin) VALUES (?, ?, ?)', [username, password_hash, admin])
            redirect("/")
        end
    end
    
    get "/loggin/error" do 

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
        kreator = params[:spel_kreator]
        spel_kategori = @user
        db.execute('UPDATE spel SET namn = ?, pris = ?, beskrivning = ?, kategori = ?, kreator = ? WHERE id = ?', [namn, pris, beskrivning, spel_kategori, spel_kreator, id])
        redirect "/spel"
    end




end
