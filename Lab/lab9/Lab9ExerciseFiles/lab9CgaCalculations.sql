create or replace procedure lab9CgaCalculations authId current_user as
    /* DECLARATION SECTION */
    currentStudentId    Student.studentId%type;
    honoursCga          constant Student.cga%type := 3.5;
    studentLowCga       constant Student.cga%type := 2;
    studentCga          Student.cga%type;
    sumCredits          Course.credits%type := 0;
    gradePoint          number := 0;

    totalWeightedGradePoints number := 0;
    courseCredits        Course.credits%type;

    -- Declare the cursors for the Student and EnrollsIn tables
    cursor studentCursor is select * from Student;

    cursor enrollsInCursor is
        select * from EnrollsIn where studentId = currentStudentId;
begin
    -- Reset the Student and LowCga database tables to facilitate testing
    update Student set cga = null;
    delete from LowCga;

    -- Process each Student record
    -- The cursor studentCursor points at the current student record
    for studentRecord in studentCursor loop
        currentStudentId := studentRecord.studentId;

        sumCredits := 0;
        totalWeightedGradePoints := 0;
        studentCga := 0;

        -- Process each EnrollsIn record of the current student
        -- The cursor enrollsInCursor points at an EnrollsIn record for the current student
        for enrollsInRecord in enrollsInCursor loop
            -- Determine the grade point from the course grade
            gradePoint := greatest((enrollsInRecord.grade / 20) - 1, 0);

            select credits into courseCredits
            from Course
            where courseId = enrollsInRecord.courseId;

            sumCredits := sumCredits + courseCredits;
            totalWeightedGradePoints := totalWeightedGradePoints + (gradePoint * courseCredits);

        end loop; -- For processing each EnrollsIn record of the current student

        if sumCredits > 0 then
            studentCga := totalWeightedGradePoints / sumCredits;

            update Student set cga = studentCga where studentId = currentStudentId;
        end if;

        -- Output honours message if needed
        if studentCga >= honoursCga then
            dbms_output.put_line('>>> ' || studentRecord.firstName || ' ' || studentRecord.lastName ||
                ' (' || currentStudentId || ') with cga=' || studentCga || ' is an honours Student.');
        end if;

        if sumCredits > 0 and studentCga <= studentLowCga then
            insert into LowCga (studentId, firstName, lastName, email, phoneNo, admitYear, cga, unitId)
            values (studentRecord.studentId, studentRecord.firstName, studentRecord.lastName,
                    studentRecord.email, studentRecord.phoneNo, studentRecord.admitYear,
                    studentCga, studentRecord.unitId);
        end if;

    end loop; -- For processing each Student record
end lab9CgaCalculations;