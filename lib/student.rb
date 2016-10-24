require 'pry'

class Student
  attr_accessor :id,
                :name,
                :tagline,
                :github,
                :twitter,
                :blog_url,
                :image_url,
                :biography

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students 
          ( id INTEGER PRIMARY KEY,
            name TEXT,
            tagline TEXT,
            github TEXT,
            twitter TEXT,
            blog_url TEXT,
            image_url TEXT,
            biography TEXT
          );"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute('DROP TABLE IF EXISTS students;')
  end

  def insert
    DB[:conn].execute("INSERT INTO students (name, tagline, github, twitter, blog_url, image_url, biography) VALUES (?, ?, ?, ?, ?, ?, ?);", [name, tagline, github, twitter, blog_url, image_url, biography])
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;").flatten[0]
  end

  def self.new_from_db(row)
    self.new.tap do |instance|
      instance.id = row[0]
      instance.name = row[1]
      instance.tagline = row[2]
      instance.github = row[3]
      instance.twitter = row[4]
      instance.blog_url = row[5]
      instance.image_url = row[6]
      instance.biography = row[7]
    end
  end

  def self.find_by_name(name)
    row = DB[:conn].execute("SELECT * FROM students WHERE name = ? LIMIT 1", name)[0]
    self.new_from_db(row) if row
  end

  def update
    DB[:conn].execute("UPDATE students SET name = ?, tagline = ?, github = ?, twitter = ?, blog_url = ?, image_url = ?, biography = ? WHERE id = ?;", [name, tagline, github, twitter, blog_url, image_url, biography, id])
  end

  def persisted?
    !!self.id
  end

  def save
    persisted? ? update : insert
  end
end
