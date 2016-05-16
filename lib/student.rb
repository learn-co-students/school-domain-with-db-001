require 'pry'

class Student

  attr_accessor :id, :name, :tagline, :github, :twitter, :blog_url, :image_url, :biography

  def self.create_table
    sql = "CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      tagline TEXT,
      github TEXT,
      twitter TEXT,
      blog_url TEXT,
      image_url TEXT,
      biography TEXT
      )"

    DB[:conn].execute(sql)  
  end

  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def self.new_from_db(row)
    student = Student.new
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
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1;"
    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def attribute_values
    [name, tagline, github, twitter, blog_url, image_url, biography]
  end

  def insert
    sql = "INSERT INTO students
      (name,tagline,github,twitter,blog_url,image_url,biography)
      VALUES
      (?,?,?,?,?,?,?);"
    DB[:conn].execute(sql, attribute_values)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.find_by_name(name)
    sql = "SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1;"
    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def update
    sql = "UPDATE students
      SET name = ?,tagline = ?,github = ?,twitter = ?,blog_url = ?,image_url = ?,biography = ?
      WHERE id = ?;"
    DB[:conn].execute(sql, attribute_values, id)
  end

  def persisted?
    !!self.id
  end

  def save
    persisted? ? update : insert
  end
end
