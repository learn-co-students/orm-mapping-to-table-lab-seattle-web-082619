class Student

  attr_reader :name, :grade, :id

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students;")
  end

  def save
    DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?);", self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(hash)
    student = Student.new(hash[:name], hash[:grade])
    student.save
    student
  end


end
