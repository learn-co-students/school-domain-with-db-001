require 'pry'
class Student

attr_accessor :id, :name, :tagline, :github, :twitter, :blog_url, :image_url, :biography

  def initialize
  end

  def self.create_table
    DB[:conn].execute("CREATE TABLE students (id INTEGER PRIMARY KEY, 
      name TEXT, 
      tagline TEXT, 
      github TEXT, 
      twitter TEXT, 
      blog_url TEXT, 
      image_url TEXT, 
      biography TEXT);")
  end

  def insert
    DB[:conn].execute("INSERT INTO students (name, tagline, github, twitter, blog_url, image_url, biography) VALUES (?, ?, ?, ?, ?, ?, ?);", [@name, @tagline, @github, @twitter, @blog_url, @image_url, @biography])
    self.id = DB[:conn].execute("SELECT id FROM students GROUP BY id ORDER BY id DESC LIMIT 1;")[0][0]
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS students;")
  end

  def update
    DB[:conn].execute("UPDATE students SET name = ?, tagline = ?, github = ?, twitter = ?, blog_url = ?, image_url = ?, biography = ? WHERE id = #{self.id};", [@name, @tagline, @github, @twitter, @blog_url, @image_url, @biography])
  end

  def self.new_from_db(data)
    new_student = Student.new
    new_student.id = data[0]
    new_student.name = data[1]
    new_student.tagline = data[2]
    new_student.github = data[3]
    new_student.twitter = data[4]
    new_student.blog_url = data[5]
    new_student.image_url = data[6]
    new_student.biography = data[7]

    new_student

  end

  def self.find_by_name(name)
    if DB[:conn].execute("SELECT * FROM students WHERE name = ?;", [name])[0] == nil then
      return nil
      else
        Student.new_from_db(DB[:conn].execute("SELECT * FROM students WHERE name = ?;", [name])[0])
      end
  end

  def save
    if self.id == nil then
      self.insert
    else
      self.update
    end
  end


end
