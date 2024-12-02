require 'sqlite3'
require 'bcrypt'
class Seeder

  def self.seed!
  drop_tables
  create_tables
  populate_tables
  end


  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS spel')
    db.execute('DROP TABLE IF EXISTS users')
  end

  def self.create_tables
    db.execute('CREATE TABLE spel (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                namn TEXT NOT NULL,
                pris INTEGER,
                beskrivning TEXT,
                kategori bolean,
                kreator text)
                ')
    db.execute('CREATE TABLE users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL,
                password integer
                )
                  ')
  end

  def self.populate_tables
    db.execute('INSERT INTO spel (namn, pris, beskrivning, kategori, kreator ) VALUES ("apex",   6, "Ett spel", "true", nil)')
    db.execute('INSERT INTO spel (namn, pris, beskrivning, kategori, kreator) VALUES ("dark souls", 8, "aaaaaaaahhhaha", "false", nil)')
    db.execute('INSERT INTO spel (namn, pris, beskrivning, kategori, kreator) VALUES ("blood born",  8, "snart", "true", "ola")')
    password_hashed = BCrypt::Password.create("123")
    db.execute('INSERT INTO users (username, password) 
			 VALUES (?, ?)', ["ola", password_hashed])

  end

  private
  def self.db
    return @db if @db
    @db = SQLite3::Database.new('db/spel.sqlite')
    @db.results_as_hash = true
    @db
  end
end

Seeder.seed!