require "pry"
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student

  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students;
    SQL
    all = DB[:conn].execute(sql)
    all.map {|row| new_from_db(row)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?;
    SQL
    self.new_from_db(DB[:conn].execute(sql, name).first)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students where grade = 9;
    SQL
    ninth = DB[:conn].execute(sql)
    ninth.map {|row| new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students where grade <= 11;
    SQL
    not_twelve = DB[:conn].execute(sql)
    not_twelve.map {|row| new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students where grade = 10 LIMIT ?;
    SQL
    first_x = DB[:conn].execute(sql, x)
    first_x.map {|row| new_from_db(row)}
    #binding.pry
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students where grade = 10 LIMIT 1;
    SQL
    first = DB[:conn].execute(sql)
    new_from_db(first.first)
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students where grade = ?;
    SQL
    grade = DB[:conn].execute(sql, x)
    grade.map {|row| new_from_db(row)}
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER -- why was this datatype TEXT?
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end


end
