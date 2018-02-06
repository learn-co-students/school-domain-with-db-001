require 'pry'
class Student
  attr_accessor :id, :name, :tagline, :github, :twitter, :blog_url, :image_url, :biography

  def self.create_table
    create = "CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, tagline TEXT, github TEXT, twitter TEXT, blog_url TEXT, image_url TEXT, biography TEXT);"
    DB[:conn].execute(create)
  end

  def self.drop_table
    drop = "DROP TABLE students;"
    DB[:conn].execute(drop)
  end

  def insert
    db = DB[:conn]
    insert = db.prepare("INSERT INTO students (name, tagline, github, twitter, blog_url, image_url, biography) VALUES (?, ?, ?, ?, ?, ?, ?);")
    rows = insert.execute(@name, @tagline, @github, @twitter, @blog_url, @image_url, @biography)
    @id = db.last_insert_row_id()
  end

  def update
    db = DB[:conn]
    update = db.prepare("UPDATE students SET name = ?, tagline = ?, github = ?, twitter = ?, blog_url = ?, image_url = ?, biography = ? WHERE students.id = ?;")
    update.execute(@name, @tagline, @github, @twitter, @blog_url, @image_url, @biography, @id)
  end

  def save
    if @id == nil
      self.insert
    else
      self.update
    end
  end

  def self.new_from_db(attrs)
    student = self.new()
    student.id = attrs[0]
    student.name = attrs[1]
    student.tagline = attrs[2]
    student.github = attrs[3]
    student.twitter = attrs[4]
    student.blog_url = attrs[5]
    student.image_url = attrs[6]
    student.biography = attrs[7]
    student
  end

  def self.find_by_name(name)
    db = DB[:conn]
    find = db.prepare("SELECT * FROM students WHERE students.name = ?")
    results = find.execute(name).to_a
    
    if results != []
      Student.new_from_db(results[0])
    else
      nil
    end
  end
end
