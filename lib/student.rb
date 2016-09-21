require 'pry'

# resrouces: http://www.tutorialspoint.com/ruby/ruby_database_access.htm
# DBI http://www.tutorialspoint.com/ruby/ruby_dbi_fetching_results.htm
# http://www.rubydoc.info/github/luislavena/sqlite3-ruby/SQLite3/Database
# http://sequel.jeremyevans.net/rdoc/files/doc/prepared_statements_rdoc.html
# parameter statements: http://zetcode.com/db/sqliteruby/bind/

class Student

  attr_accessor :id, :name, :tagline, :github, :twitter, :blog_url, :image_url, :biography

  def self.create_table
    DB[:conn].execute("CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    tagline TEXT,
    github TEXT,
    twitter TEXT,
    blog_url TEXT,
    image_url TEXT,
    biography TEXT);")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students;")
  end

  def insert
    # Uisng the array to insert data into the database
    insert_into_db = [self.name, self.tagline, self.github, self.twitter, self.blog_url, self.image_url, self.biography]
    # Uses prepare to INSERT data or UPDATE it
    ins = DB[:conn].prepare ("INSERT INTO students (name, tagline, github, twitter, blog_url, image_url, biography) VALUES (?, ?, ?, ?, ?, ?, ?)")
    # bind_params is used to bind values to SQL statements. THe values are passed through .execute
    ins.bind_params(*insert_into_db)
    # Use execute to SELECT data from the database
    ins.execute

    # Updating the instance with the id of the student from DB
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;").first[0]
  end

  def self.new_from_db(data)
    new_student = Student.new
    # I can insert elements as long as its the same id (data[0]) && add it to new_student
    new_student.tap do |element|
      # refactor idea: can ahve another iteration, and add the values in the DB trhough iteration and adding 1 to index.
      element.id = data[0]
      element.name = data[1]
      element.tagline = data[2]
      element.github = data[3]
      element.twitter = data[4]
      element.blog_url = data[5]
      element.image_url = data[6]
      element.biography = data[7]
    end
  end

  def self.find_by_name(name_searched)
    # binding.pry
    row = DB[:conn].execute("SELECT * FROM students WHERE name = ? LIMIT 1;", name_searched)[0]
    self.new_from_db(row) if row
  end

  def update
    DB[:conn].execute("UPDATE students
    SET name = ?, tagline = ?, github = ?, twitter = ?, blog_url = ?, image_url = ?, biography = ?
    WHERE id = ?;", [name, tagline, github, twitter, blog_url, image_url, biography, id])
  end

  def save
    #
  end

end
