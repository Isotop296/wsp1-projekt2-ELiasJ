class App < Sinatra::Base
    def db
        return @db if @db

        @db = SQLite3::Database.new("db/fruits.sqlite")
        @db.results_as_hash = true

        return @db
    end


    get '/' do
        erb(:"index")
    end

end
