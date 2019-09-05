class Student
  attr_accessor :name, :grade
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table()
    #students table
    sql = <<-SQL
      CREATE TABLE students (
        "id" INTEGER PRIMARY KEY,
        "name" TEXT, 
        "grade" INTEGER
      );
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students;
    SQL
    DB[:conn].execute(sql)
  end

  def self.create(student)
    student = Student.new(student[:name], student[:grade])
    student.save()
    return student
  end
  
  def save()
    if @id
      sql = <<-SQL
        UPDATE students
        SET name=?, grade=?
        WHERE id=?
      SQL
      DB[:conn].execute(sql, @name, @grade, @id)
    else
      sql = <<-SQL
        INSERT INTO students ("name", "grade")
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, @name, @grade)

      sql = <<-SQL
        SELECT students.id FROM students
        ORDER BY students.id DESC
        LIMIT 1
      SQL
      @id = DB[:conn].execute(sql)[0][0]
    end
  end

end







