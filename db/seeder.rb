require 'sqlite3'

class Seeder

  def self.seed!
    db.execute('DROP TABLE IF EXISTS spel')
  end

  def self.create_tables
    db.execute('CREATE TABLE spel (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                pris INTEGER,
                description TEXT,
                ')
  end

  def self.populate_tables
    db.execute('INSERT INTO spelat (name, pris, description) VALUES ("apex",   6, "Ett spel.")')
    db.execute('INSERT INTO spelat (name, pris, description) VALUES ("dark souls", 8, "aaaaaaaahhhaha")')
    db.execute('INSERT INTO vill_spela (name, pris, description) VALUES ("blood born",  8, "snart")')
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