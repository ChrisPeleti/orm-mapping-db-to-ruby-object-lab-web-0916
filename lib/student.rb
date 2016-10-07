class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student=self.new
    new_student.id=row[0]
    new_student.name=row[1]
    new_student.grade=row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql=<<-SQL
    SELECT * FROM students
    SQL
      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql=<<-SQL
    SELECT * FROM students
    WHERE name = ?
    LIMIT(1)
    SQL
    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
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
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    sql=<<-SQL
    SELECT COUNT(students.grade) FROM students
    WHERE grade = 9
    SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql=<<-SQL
    SELECT * FROM students
    WHERE grade < 12
    SQL
    DB[:conn].execute(sql)
  end

  # def self.first_x_students_in_grade_10(num)
  #   sql=<<-SQL
  #   SELECT * FROM students
  #   WHERE id <= ?
  #   SQL
  #   DB[:conn].execute(sql, num)
  # end

  def self.first_x_students_in_grade_10(x)
    sql=<<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT (?)
    SQL
    DB[:conn].execute(sql, x)
  end

  def self.first_student_in_grade_10
    sql=<<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT (1)
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_x(x)
    sql=<<-SQL
    SELECT * FROM students
    WHERE grade = ?
    SQL
    DB[:conn].execute(sql, x).map do |row|
      self.new_from_db(row)
    end
  end
end





######################################################################
# def self.find(id)
#   db.execute("SELECT * FROM taco_ingredients WHERE taco_ingredients.id=#{id}";).first.map do |row|
#     self.new_from_db.map(row)
#   end   # <---- may need a .first here
#
#
#
# end
#
# def self.new_from_db(row)
#   # create a new Student object given a row from the database
#   new_ingredient=self.new
#   new_ingredient.id=row[0]
#   new_ingredient.name=row[1]
#   new_ingredient.calories=row[2]
#   new_ingredient.vegetarian=row[3]
#   new_ingredient.cost=row[4]
#
#
#   new_ingredient
# end
#
# def self.all
#   taco_rows=db.execute("SELECT * FROM taco_ingredients")
#   taco_rows.map do |row|
#     self.new_from_db(row)
#   end
# end
#
# def destroy
#   db.execute("DELETE FROM taco_ingredients WHERE id = #{self.id};")
# end
#
# def update
#   id = self.id
#   db.execute("UPDATE taco_ingredients SET (id, name, calories, vegetarian, cost ) = (#{self.id}) WHERE [column name] = [value];")
# end
# TacoIngredients.find(1)

# ==> <OBJECT#12e323r4324523, @name='lettuce', @calories=3, @vegetarian=1, @cost=1>
