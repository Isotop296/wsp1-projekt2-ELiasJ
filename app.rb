class App < Sinatra::Base
    @user = "anonym"

    def db
        return @db if @db

        @db = SQLite3::Database.new("db/spel.sqlite")
        @db.results_as_hash = true

        return @db
    end
 

    get '/' do
        redirect('/loggin')
    end

    get '/loggin' do
        erb(:"spel/loggin")
    end

    post "/loggin/check" do
        username = params[:username]
        password = params[:password]
    
        user_exists = db.execute('SELECT * FROM users WHERE username = ?', [username]).first
        @admin_status = db.execute('SELECT admin FROM users WHERE username = ?', [username]).first
    
        if user_exists
            @user = username
            if @admin_status["admin"] == "admin"
                redirect('/admin')
            else
                redirect('/spel') 
            end
        else 
            @error_message = "user dosent exist or you have spelt somthing wrong"
            return erb(:"spel/loggin")
        end
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
        db.execute('INSERT INTO users (username, password, admin) VALUES (?, ?, false)', [username, password_hash])
        @user = username
        redirect('/spel')
        end
    end


    get '/admin' do 
        erb(:"spel/admin_site")
    end

    post '/admin/redirect' do
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
        user = @user
        db.execute('INSERT INTO spel (namn, pris, beskrivning, kategori, kreator) VALUES (?, ?, ?, ?, ?)', [spel_namn, spel_pris, spel_beskrivning, spel_kategori, user])
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




end
