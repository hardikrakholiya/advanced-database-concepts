-- Find the sid and names of students who major in 'CS'

select distinct s.sid, s.sname 
from  student s, major_students ms 
where ms.major = 'CS' and memberof(s.sid,ms.students);

-- Find the sid and names of students who major in 'CS' and 'Math'

select distinct s.sid, s.sname
from   student s, major_students ms1, major_students ms2
where  ms1.major = 'CS' and ms2.major = 'Math' and 
       memberof(s.sid,setintersection(ms1.students,ms2.students));


-- Find the sid and majors of students who also major in 'CS'

select distinct sm.sid, sm.majors
from   major_students ms, student_majors sm
where  ms.major = 'CS' and
       memberof(sm.sid,ms.students);

-- this can be flattened
select distinct sm.sid, UNNEST(sm.majors)
from   major_students ms, student_majors sm
where  ms.major = 'CS' and
       memberof(sm.sid,ms.students);

--  Find the sids of students with two majors

select  sm.sid
from    student_majors sm
where   cardinality(sm.majors) = 2;

--  Find the sid of each student who only bought books that
--  cost more than $50.

select  sb.sid
from    student_books sb
where   sb.books <@ array(select bookno from book where price >50);





