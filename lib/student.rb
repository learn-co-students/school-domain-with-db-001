class Student

  attr_accessor :id, :name, :tagline, :github, :twitter, :blog_url, :image_url, :biography

  def self.create_table
    DB[:conn].execute ("CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, tagline TEXT, github TEXT, twitter TEXT, blog_url TEXT, image_url TEXT, biography TEXT);")
  end

  def self.drop_table
    DB[:conn].execute ("DROP TABLE students;")
  end

  def insert
    arr = [self.name, self.tagline, self.github, self.twitter, self.blog_url, self.image_url, self.biography]
    ins = DB[:conn].prepare ("INSERT INTO students (name, tagline, github, twitter, blog_url, image_url, biography) VALUES (?,?,?,?,?,?,?)")
    ins.bind_params(*arr)
    ins.execute

    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").first[0]
  end

  def self.new_from_db (row)
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

  def self.find_by_name (st_name)
    fnd = DB[:conn].execute2("SELECT * FROM students WHERE name = ?", st_name)
    Student.new_from_db(fnd[1]) if fnd[1]

  end

  def update

   upd = DB[:conn].prepare("UPDATE students SET name = ? WHERE id = ?;")
   upd.bind_params(self.name, self.id)
   upd.execute
  end

  def save
    self.id ? update : insert
  end

end
