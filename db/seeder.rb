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
  end

  def self.create_tables
    db.execute('CREATE TABLE spel (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                namn TEXT NOT NULL,
                pris INTEGER,
                beskrivning TEXT,
                kategori bolean)
                ')
  end

  def self.populate_tables
    db.execute('INSERT INTO spel (namn, pris, beskrivning, kategori ) VALUES ("apex",   6, "Ett spel", "true")')
    db.execute('INSERT INTO spel (namn, pris, beskrivning, kategori) VALUES ("dark souls", 8, "aaaaaaaahhhaha", "false")')
    db.execute('INSERT INTO spel (namn, pris, beskrivning, kategori) VALUES ("blood born",  8, "snart", "true")')
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