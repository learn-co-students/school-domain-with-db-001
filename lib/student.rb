require 'pry'
class Student

  attr_accessor :id, :name, :tagline, :github, :twitter, :blog_url, :image_url, :biography

  def initialize
    @id
    @name
    @tagline
    @github
    @twitter
    @blog_url
    @image_url
    @biography
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY, 
      name TEXT, 
      tagline TEXT, 
      github TEXT,
      twitter TEXT,
      blog_url TEXT,
      image_url TEXT,
      biography TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def insert
    sql = <<-SQL
    INSERT INTO students (name, tagline, github, twitter, blog_url, image_url, biography)
    VALUES (?, ?, ?, ?, ?, ?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.tagline, self.github, self.twitter, self.blog_url, self.image_url, self.biography)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.tagline = row[2]
    student.github = row[3]
    student.twitter = row[4]
    student.blog_url = row[5]
    student.image_url = row[6]
    student.biography = row[7]
    student
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students 
    WHERE name = (?)
    SQL
    student = self.new_from_db(DB[:conn].execute(sql, name).flatten)
  end

  def update
    sql = <<-SQL
    UPDATE students 
    SET name = (?)
    WHERE id = (?)
    SQL
    DB[:conn].execute(sql, self.name, self.id)
  end

  def save
    self.update
    self.id == nil ? self.insert : nil
  end
end
