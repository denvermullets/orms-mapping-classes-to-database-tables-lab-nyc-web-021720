require 'pry'
class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  

  # app to keep track of students
  # each student has 2 attributes (name, grade (9th, 10th, 11th), id=nil)
  attr_reader :name, :grade, :id
  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade


  end 

  # create table in database
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end 

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end 

  def save
    sql = <<-SQL 
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    # binding.pry
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end 

  # creates a new student instance and saves it using metaprogramming
  # w/hash of attributes
  def self.create(name:, grade:)
    students = Student.new(name, grade)
    students.save
    students

  end 
end
