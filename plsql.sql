

-- DB Object 정의서
set SERVEROUTPUT on;
 
-- 관리자 계정 정의
-- 관리자계정 로그인
CREATE OR REPLACE PROCEDURE procAdminLogin(
    ptel VARCHAR,
    ppw NUMBER
)
IS
    vnum NUMBER;
    vrow tblAdmin%rowtype;
BEGIN
    SELECT count(*) INTO vnum FROM tblAdmin WHERE tel = ptel AND ssn = ppw;
    IF vnum = 1 THEN
        SELECT * INTO vrow FROM tblAdmin WHERE tel = ptel AND ssn = ppw;
        dbms_output.put_line(vrow.name || '님 반갑습니다.');
        dbms_output.put_line('관리자 로그인 성공!');
    ELSIF vnum = 0 THEN
        dbms_output.put_line('없는 정보입니다. 확인 후 다시 로그인 해주세요.');
    END IF;
END;
/








--기초 정보 관리
-- 과정명 생성
CREATE OR REPLACE PROCEDURE procCreateCourse (
    pname VARCHAR
)
IS
    vnum NUMBER;
BEGIN
    SELECT count(*) INTO vnum FROM tblCourse WHERE WHERE lower(name) = lower(pname);
    IF vnum = 1 THEN
        dbms_output.put_line('중복된 과정명이 존재합니다. 다른 이름의 과정명을 만들어주세요.');
    ELSIF vnum = 0 THEN
        INSERT INTO tblCourse VALUES(seqCourse.nextVal, pname);
        dbms_output.put_line('''' || pname || ''' 과정 만들기에 성공하셨습니다.');
    END IF;
END;
/

-- 과정명 수정
CREATE OR REPLACE PROCEDURE procUpdateCourse (
    pid NUMBER,
    pname VARCHAR
)
IS
    vnum NUMBER;
    vbeforename tblCourse.name%type;
BEGIN
    SELECT count(*) INTO vnum FROM tblCourse WHERE id = pid;
    IF vnum = 1 THEN
        SELECT name INTO vbeforename FROM tblCourse WHERE id = pid;
        IF vbeforename = pname THEN
            UPDATE tblCourse SET name = pname WHERE id = pid;
            dbms_output.put_line('같은 이름입니다.');
        ELSE 
            UPDATE tblCourse SET name = pname WHERE id = pid;
            dbms_output.put_line('''' || vbeforename || ''' 과정명을 ' || '''' || pname || '''로 수정하셨습니다.');
        END IF;
    ELSIF vnum = 0 THEN
        dbms_output.put_line('해당 과정명이 없습니다. 다시 확인해주세요.');
    END IF;
END;
/

-- 과목명 생성
CREATE OR REPLACE PROCEDURE procCreateSubject (
    pname VARCHAR
)
IS
    vnum NUMBER;
BEGIN
    SELECT count(*) INTO vnum FROM tblSubject WHERE lower(name) = lower(pname);
    IF vnum = 1 THEN
        dbms_output.put_line('중복된 과목명이 존재합니다. 다른 이름의 과목명을 만들어주세요.');
    ELSIF vnum = 0 THEN
        INSERT INTO tblSubject VALUES(seqSubject.nextVal, pname);
        dbms_output.put_line('''' || pname || ''' 과목 만들기에 성공하셨습니다.');
    END IF;
END;
/

-- 과목명 수정
CREATE OR REPLACE PROCEDURE procUpdateSubject (
    pid NUMBER,
    pname VARCHAR
)
IS
    vnum NUMBER;
    vbeforename tblSubject.name%type;
BEGIN
    SELECT count(*) INTO vnum FROM tblSubject WHERE id = pid;
    IF vnum = 1 THEN
        SELECT name INTO vbeforename FROM tblSubject WHERE id = pid;
        IF vbeforename = pname THEN
            UPDATE tblSubject SET name = pname WHERE id = pid;
            dbms_output.put_line('바꿀 과목명이 같습니다.');
        ELSE 
            UPDATE tblSubject SET name = pname WHERE id = pid;
            dbms_output.put_line('''' || vbeforename || ''' 과목명을 ' || '''' || pname || '''로 수정하셨습니다.');
        END IF;
    ELSIF vnum = 0 THEN
        dbms_output.put_line('해당 과목명이 없습니다. 다시 확인해주세요.');
    END IF;
END;
/

-- 강의실명 생성
CREATE OR REPLACE PROCEDURE procCreateClassroom (
    pname VARCHAR,
    pcapacity NUMBER
)
IS
    vnum NUMBER;
BEGIN
    SELECT count(*) INTO vnum FROM tblClassroom WHERE lower(name) = lower(pname);
    IF vnum = 1 THEN
        dbms_output.put_line('중복된 강의실명이 존재합니다. 다른 이름의 강의실명을 만들어주세요.');
    ELSIF vnum = 0 THEN
        INSERT INTO tblClassroom VALUES(seqClassroom.nextVal, pname, pcapacity);
        dbms_output.put_line('''' || pname || ''' 강의실 만들기에 성공하셨습니다.');
    END IF;
END;
/

-- 강의실명 수정
CREATE OR REPLACE PROCEDURE procUpdateClassroom (
    pid NUMBER,
    pname VARCHAR,
    pcapacity NUMBER
)
IS
    vnum NUMBER;
    vrow tblClassroom%rowtype;
BEGIN
    SELECT count(*) INTO vnum FROM tblClassroom WHERE id = pid;
    IF vnum = 1 THEN
        SELECT * INTO vrow FROM tblClassroom WHERE id = pid;
        IF vrow.name = pname AND vrow.capacity = pcapacity THEN
            dbms_output.put_line('바꿀 강의실명의 내용이 같습니다.');
        ELSE 
            UPDATE tblClassroom SET name = pname, capacity = pcapacity WHERE id = pid;
            dbms_output.put_line('''' || vrow.name || '''(' || vrow.capacity || ') 강의실명을 ' 
                || '''' || pname || '''(' || pcapacity || ')로 수정하셨습니다.');
        END IF;
    ELSIF vnum = 0 THEN
        dbms_output.put_line('해당 강의실명이 없습니다. 다시 확인해주세요.');
    END IF;
END;
/

-- 교재명 생성
CREATE OR REPLACE PROCEDURE procCreateBook(
    pname VARCHAR,
    pauthor VARCHAR,
    ppublish VARCHAR,
    pissueDate DATE
)
IS
    vnum NUMBER;
BEGIN
    SELECT count(*) INTO vnum FROM tblBook WHERE lower(name) = lower(pname) 
        AND lower(author) = lower(pauthor) AND lower(publish) = lower(ppublish) AND issueDate = pissueDate;
    IF vnum = 1 THEN
        dbms_output.put_line('중복된 교재명이 존재합니다. 다른 교재명을 만들어주세요.');
    ELSIF vnum = 0 THEN
        INSERT INTO tblBook VALUES(seqBook.nextVal, pname, pauthor, ppublish, pissueDate);
        dbms_output.put_line('''' || pauthor || '''의 ' || '''' || pname || ''' 교재 만들기에 성공하셨습니다.');
    END IF;
END;
/

-- 교재명 수정
CREATE OR REPLACE PROCEDURE procUpdateBook(
    pid NUMBER,
    pname VARCHAR,
    pauthor VARCHAR,
    ppublish VARCHAR,
    pissueDate DATE
)
IS
    vnum NUMBER;
    vrow tblBook%rowtype;
BEGIN
    SELECT count(*) INTO vnum FROM tblBook WHERE id = pid;
    IF vnum = 1 THEN
        SELECT * INTO vrow FROM tblBook WHERE id = pid;
        IF vrow.name = pname AND vrow.author = pauthor
            AND vrow.publish = ppublish  AND vrow.issueDate = pissueDate THEN
            dbms_output.put_line('바꿀 교재명의 내용이 같습니다.');
        ELSE 
            UPDATE tblBook SET name = pname, author = pauthor, publish = ppublish, issueDate = pissueDate WHERE id = pid;
            dbms_output.put_line('''' || vrow.name || '''(' || vrow.author || ', ' || vrow.publish 
             || ', ' || vrow.issueDate || ') 교재명을 ' 
                || '''' || pname || '''(' || pauthor || ', ' || ppublish 
             || ', ' || pissueDate || ')로 수정하셨습니다.');
        END IF;
    ELSIF vnum = 0 THEN
        dbms_output.put_line('해당 교재명이 없습니다. 다시 확인해주세요.');
    END IF;
END;
/







--교사 계정 관리
-- 교사목록 조회
CREATE OR REPLACE PROCEDURE procTeacherList
IS
    vindex NUMBER;
    vname tblSubject.name%type;
    vrow tblTeacher%rowtype;
    CURSOR vcursor
    IS
    SELECT * FROM tblTeacher;
    CURSOR vcursorSubject
    IS
    SELECT subjectName FROM vwTeacherSubject WHERE teacherId = vrow.id;
BEGIN
    dbms_output.put_line('============================================================================');
    dbms_output.put_line('                                  교사목록');
    OPEN vcursor;
    LOOP
        FETCH vcursor INTO vrow;
        EXIT WHEN vcursor%notfound;
        
        dbms_output.put_line('============================================================================');
        dbms_output.put_line('     이름     주민번호뒷자리       전화번호           강의가능과목목록');
        dbms_output.put_line('============================================================================');
        vindex := 1;
        OPEN vcursorSubject;
        LOOP
            FETCH vcursorSubject INTO vname;
            EXIT WHEN vcursorSubject%notfound;
            IF vindex = 1 THEN
                dbms_output.put_line('    ' || vrow.name || '        ' || vrow.ssn || '         ' || vrow.tel || '           ' || vname );
               
            ELSE 
                dbms_output.put_line('                                                          ' || vname );
            END IF;
            vindex := vindex + 1;
        END LOOP;
        CLOSE vcursorSubject;
    END LOOP;
    CLOSE vcursor;
    
    dbms_output.put_line('============================================================================');
END;
/

-- 특정교사 조회
CREATE OR REPLACE PROCEDURE procTeacherInfo(
    pid NUMBER
)
IS
    vindex NUMBER;
    
    vcourseId tblOpenCourse.id%type;
    vcourseName tblOpenCourse.name%type;
    vcourseStartDate tblOpenCourse.startDate%type;
    vcourseEndDate tblOpenCourse.endDate%type;
    
    vsubjectName tblOpenSubject.name%type;
    vsubjectStartDate tblOpenSubject.startDate%type;
    vsubjectEndDate tblOpenSubject.endDate%type;
    vbookName tblBook.name%type;
    vclassroomName tblClassroom.name%type;

    CURSOR vcursor
    IS
    SELECT 
        DISTINCT
        openCourseId AS courseId,
        openCourseName AS name,
        to_char(openCourseStartDate, 'yyyy-mm-dd') AS startDate,
        to_char(openCourseEndDate, 'yyyy-mm-dd') AS endDate
    FROM vwStudentCourseInfo 
        WHERE teacherId = pid ORDER BY startDate;
    
    CURSOR vcursorSubject
    IS
    SELECT 
        DISTINCT
        openSubjectName AS name,
        openSubjectStartDate AS startDate,
        openSubjectEndDate AS endDate,
        b.name AS bookName,
        c.name AS classroomName
    FROM vwStudentCourseInfo sci
        INNER JOIN tblBook b ON b.id = sci.bookId
        INNER JOIN tblClassroom c ON c.id = sci.classroomId
        WHERE teacherId = pid AND openCourseId = vcourseId
        ORDER BY startDate;
        
BEGIN
    OPEN vcursor;
    LOOP
        FETCH vcursor INTO vcourseId, vcourseName, vcourseStartDate, vcourseEndDate;
        EXIT WHEN vcursor%notfound;
        dbms_output.put_line('╔════════════════════════════════════════════════════════════════════════════════════════════╗');
        dbms_output.put_line('');
        dbms_output.put_line(' 과정명: ' || vcourseName);
        dbms_output.put_line(' 과정기간: ' || to_char(vcourseStartDate, 'yyyy-mm-dd') 
            || ' ~ ' || to_char(vcourseEndDate, 'yyyy-mm-dd'));
        dbms_output.put_line('');

        OPEN vcursorSubject;
        LOOP
            FETCH vcursorSubject 
                INTO vsubjectName, vsubjectStartDate, vsubjectEndDate, vbookName, vclassroomName;
            EXIT WHEN vcursorSubject%notfound;
            
            dbms_output.put_line(' ════════════════════════════════════════════════════════════════════════════════════════════');
            dbms_output.put_line(' 과목명(과목기간): ' || vsubjectName 
                || '(' || to_char(vsubjectStartDate, 'yyyy-mm-dd') 
                || ' ~ ' || to_char(vsubjectEndDate, 'yyyy-mm-dd') || ')');
            dbms_output.put_line(' ════════════════════════════════════════════════════════════════════════════════════════════');
            dbms_output.put_line(' 교재명: ' || vbookName); 
            dbms_output.put_line(' 강의실명: ' || vclassroomName); 
            IF sysdate < vsubjectStartDate THEN
                dbms_output.put_line(' 강의상태: 강의 예정');
            ELSIF sysdate > vsubjectEndDate THEN
                dbms_output.put_line(' 강의상태: 강의 종료');
            ELSE 
                dbms_output.put_line(' 강의상태: 강의 중');
            END IF;
            vindex := vindex + 1;
        END LOOP;
        CLOSE vcursorSubject;
        dbms_output.put_line('╚════════════════════════════════════════════════════════════════════════════════════════════╝');
    END LOOP;
    
    CLOSE vcursor;
END;
/



--개설 과정 관리 
-- 개설과정 생성
CREATE OR REPLACE PROCEDURE procCreateOpenCourse (
    pname VARCHAR2,
    pstartDate DATE,
    pendDate DATE,
    pcourseId NUMBER,
    pclassroomId NUMBER,
    pcapacity NUMBER
)
IS
    vname tblClassroom.name%type;
    vcount NUMBER;
BEGIN
    SELECT name, capacity INTO vname, vcount FROM tblClassroom WHERE id = pclassroomId;
    IF vcount < pcapacity THEN  
        dbms_output.put_line(vname || ' 강의실의 정원수가 충분하지 않습니다.');
    ELSE 
        SELECT count(*) INTO vcount FROM vwClassroomList WHERE classroomId = pclassroomId 
            AND endDate >= pstartDate AND startDate <= pendDate
            OR startDate <= pstartDate AND endDate >= pendDate OR pstartDate <= startDate AND endDate <= pendDate;
        
        IF vcount = 0 THEN
            dbms_output.put_line('해당 기간에 강의실이 비어있지 않습니다.');      
        ELSE 
            INSERT INTO tblOpenCourse VALUES (seqOpenCourse.nextVal, pname, pstartDate, pendDate, pcourseId, pclassroomId);
            dbms_output.put_line('''' || pname || '''(' || to_char(pstartDate, 'yyyy-mm-dd') || ' ~ '
                || to_char(pendDate, 'yyyy-mm-dd') || ') 과정이 신설되었습니다.' );
        END IF;    
    END IF;   
END;
/

-- 특정개설과정 조회
CREATE OR REPLACE PROCEDURE procOpenCourseInfo (
    pid NUMBER
)
IS
    vsubjectName tblOpenSubject.name%type;
    vstartDate tblOpenSubject.startDate%type;
    vendDate tblOpenSubject.endDate%type;
    vbookName tblBook.name%type;
    vteacherName tblTeacher.name%type;
    
    vid tblStudent.id%type;
    vname tblStudent.name%type;
    vssn tblStudent.ssn%type;
    vtel tblStudent.tel%type;
    vregDate tblStudent.regDate%type;
    vstate tblCompletion.state%type;
    
    CURSOR vcursor
    IS
    SELECT DISTINCT openSubjectName, openSubjectStartDate, openSubjectEndDate, b.name, teacherName
        FROM vwStudentCourseInfo sci
        INNER JOIN tblBook b ON b.id = sci.bookId
        WHERE openCourseId = pid
        ORDER BY openSubjectStartDate;
        
    CURSOR vcursorStudent
    IS
    SELECT DISTINCT studentName, studentSSN, studentTel, studentRegDate, completionState
        FROM vwStudentCourseInfo 
        WHERE openCourseId = pid
        ORDER BY studentName;
BEGIN
    dbms_output.put_line('╔════════════════════════════════════════════════════════════════════════════════════════════════════════════╗');
    dbms_output.put_line('                                                 과목 정보');
    dbms_output.put_line(' ════════════════════════════════════════════════════════════════════════════════════════════════════════════');
    dbms_output.put_line('   교사명          기간                과목명                           교재명');
    dbms_output.put_line(' ════════════════════════════════════════════════════════════════════════════════════════════════════════════');

    OPEN vcursor;
    LOOP 
        FETCH vcursor INTO vsubjectName, vstartDate, vendDate, vbookName, vteacherName;        
        EXIT WHEN vcursor%notfound;
        dbms_output.put_line( '   ' || vteacherName || '   ' ||  to_char(vstartDate, 'yyyy-mm-dd') || ' ~ ' 
        ||  to_char(vendDate, 'yyyy-mm-dd') || '   ' || rpad(vsubjectName, 20, ' ') || '     ' || rpad(vbookName, 40, ' '));
    END LOOP;
    CLOSE vcursor;
    dbms_output.put_line('╚════════════════════════════════════════════════════════════════════════════════════════════════════════════╝');

    dbms_output.put_line('╔════════════════════════════════════════════════════════════════════════════════════════════════════════════╗');
    dbms_output.put_line('                                              교육생 정보');
    dbms_output.put_line(' ════════════════════════════════════════════════════════════════════════════════════════════════════════════');
    dbms_output.put_line('      이름              주민번호               전화번호            등록일                수료상태');
    dbms_output.put_line(' ════════════════════════════════════════════════════════════════════════════════════════════════════════════');

    OPEN vcursorStudent;
    LOOP
        FETCH vcursorStudent INTO vname, vssn, vtel, vregDate, vstate;        
        EXIT WHEN vcursorStudent%notfound;
        dbms_output.put_line( '    ' || vname ||  '               ' || vssn || '             ' 
            || vtel ||  '         ' || vregDate ||  '                ' || vstate);
    END LOOP;
    CLOSE vcursorStudent;
    dbms_output.put_line('╚════════════════════════════════════════════════════════════════════════════════════════════════════════════╝');
END;
/


 
--개설 과목 관리 
-- 개설과목 생성

-- 특정 개설 과정 선택시 개설 과목 정보 출력 및 개설 과목 신규 등록을 한다. 개설 과목 정보 입력시 기초 정보 관리로 등록된 과목명과 교재명, 과목기간, 교사명을 입력한다
-- 교재는 미리 등록된 과목별 교재에서 선택적으로 추가한다. 
-- 교사 명단은 현재 과목과 강의 가능 과목이 일치하는 교사 명단만 볼 수 있다.
-- 개설과목 조회
CREATE OR REPLACE PROCEDURE procOpenSubjectList (
    pid NUMBER
)
IS
    vsubjectName tblOpenSubject.name%type;
    vstartDate tblOpenSubject.startDate%type;
    vendDate tblOpenSubject.endDate%type;
    vbookName tblBook.name%type;
    vteacherName tblTeacher.name%type;
    
    CURSOR vcursor
    IS
    SELECT DISTINCT openSubjectName, openSubjectStartDate, openSubjectEndDate, b.name, teacherName
        FROM vwStudentCourseInfo sci
        INNER JOIN tblBook b ON b.id = sci.bookId
        WHERE openCourseId = pid 
        ORDER BY openSubjectStartDate;
        
    CURSOR vcursorStudent
    IS
    SELECT DISTINCT studentName, studentSSN, studentTel, studentRegDate, completionState
        FROM vwStudentCourseInfo 
        WHERE openCourseId = pid
        ORDER BY studentName;
BEGIN
    dbms_output.put_line('╔════════════════════════════════════════════════════════════════════════════════════════════╗');
    dbms_output.put_line('                                           과목 정보');
    dbms_output.put_line(' ════════════════════════════════════════════════════════════════════════════════════════════');
    dbms_output.put_line('   교사명          기간            과목명                      교재명');
    dbms_output.put_line(' ════════════════════════════════════════════════════════════════════════════════════════════');

    OPEN vcursor;
    LOOP 
        FETCH vcursor INTO vsubjectName, vstartDate, vendDate, vbookName, vteacherName;        
        EXIT WHEN vcursor%notfound;
        dbms_output.put_line( '   ' || vteacherName || '   ' || vstartDate || ' ~ ' || vendDate || '   ' || rpad(vsubjectName, 10, ' ') || '     ' || vbookName);
    END LOOP;
    CLOSE vcursor;
    dbms_output.put_line('╚════════════════════════════════════════════════════════════════════════════════════════════╝');

END;
/

 
 
 
 
 
--교육생 관리 
-- 전체 교육생 목록 조회
CREATE OR REPLACE PROCEDURE procStudentList
IS 
BEGIN
    -- 타이틀
  DBMS_OUTPUT.PUT_LINE('╔═════════════════════════════════════════════════════════════════════════════════╗');
    DBMS_OUTPUT.PUT_LINE('                              전체 교육생 목록 조회');    
    DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════════════════════════');
    -- 학생정보 출력
    FOR c IN (
    SELECT DISTINCT
        studentId AS 교육생번호,
        studentName AS 교육생이름,
        studentSsn AS 주민번호,
        studentTel AS 연락처,
        studentRegDate AS 등록일,
        openCourseName AS 과정명,
        openCourseStartDate AS 시작날짜,
        openCourseEndDate AS 종료날짜,
        cr.name AS 강의실명,
        teacherName AS 교사명,
        completionState AS 수료상태, 
        completionCompletiondate AS 수료날짜,
        add_months(completionCompletiondate, 3) AS 재취업지원종료날짜
    FROM vwStudentCourseInfo vwsc
        LEFT OUTER JOIN tblclassroom cr
            ON vwsc.classroomId = cr.id
                ORDER BY vwsc.studentId)
    LOOP
        DBMS_OUTPUT.PUT_LINE('ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ');
        DBMS_OUTPUT.PUT_LINE(' 번    호 : '|| c.교육생번호);  
        DBMS_OUTPUT.PUT_LINE(' 이    름 : '|| c.교육생이름);
        DBMS_OUTPUT.PUT_LINE(' 주민번호 : '|| c.주민번호||'(뒷자리)'); 
        DBMS_OUTPUT.PUT_LINE(' 연 락 처 : '|| c.연락처);  
        DBMS_OUTPUT.PUT_LINE(' 등 록 일 : '|| c.등록일);  
        DBMS_OUTPUT.PUT_LINE(' 과 정 명 : '|| c.과정명);  
        DBMS_OUTPUT.PUT_LINE(' 과정기간 : '|| c.시작날짜 || ' - ' || c.종료날짜);  
        DBMS_OUTPUT.PUT_LINE(' 강의실명 : '|| c.강의실명);  
        DBMS_OUTPUT.PUT_LINE(' 교 사 명 : '|| c.교사명);  
        DBMS_OUTPUT.PUT_LINE(' 수료상태 : '|| c.수료상태);  
        DBMS_OUTPUT.PUT_LINE(' 사후처리기간 : '|| c.수료날짜 || ' - ' || c.재취업지원종료날짜);     
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('╚═════════════════════════════════════════════════════════════════════════════════╝');
END procStudentList;
/

--실행
BEGIN
procStudentList;
END;
/


-- 특정 교육생을 검색기능
CREATE OR REPLACE PROCEDURE procStudentInfo(
    pstId tblStudent.id%TYPE)
IS
    vstNum tblStudent.id%TYPE;
    vstName tblStudent.name%TYPE;
    vocName tblOpenCourse.name%TYPE;
    vocSDate tblOpenCourse.startDate%TYPE;
    vocEDate tblOpenCourse.endDate%TYPE;
    vcrName tblClassRoom.name%TYPE;
    vtName tblTeacher.name%TYPE;
    vcpState tblCompletion.State%TYPE;
    vcpDate tblCompletion.completionDate%TYPE;
BEGIN
    SELECT DISTINCT
        studentId AS 교육생번호,
        studentName AS 교육생이름,
        openCourseName AS 과정명,
        openCourseStartDate AS 시작날짜,
        openCourseEndDate AS 끝날짜,
        cr.Name AS 강의실명,
        teacherName AS 교사명,
        completionState AS 수강상태, 
        completionCompletiondate AS 수료및중도탈락날짜
    INTO
        vstNum,vstName,vocName,vocSDate,vocEDate,vcrName,vtName, vcpState,vcpDate
        FROM vwStudentCourseInfo vwsc
        INNER JOIN tblClassroom cr
        ON cr.id = vwsc.classroomId
    where studentId = pstId;
    DBMS_OUTPUT.PUT_LINE('╔═════════════════════════════════════════════════════════════════════════════════╗');
    DBMS_OUTPUT.PUT_LINE('                            ['|| vstName ||'] 교육생의 정보');    
    DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════════════════════════');
    DBMS_OUTPUT.PUT_LINE(' 이    름 : ' || vstName);  
    DBMS_OUTPUT.PUT_LINE(' 과 정 명 : ' || vocName);    
    DBMS_OUTPUT.PUT_LINE(' 과정기간 : ' || vocSDate || ' ~ ' || vocEDate); 
    DBMS_OUTPUT.PUT_LINE(' 강의실명 : ' || vcrName); 
    DBMS_OUTPUT.PUT_LINE(' 교 사 명 : ' || vtName);  
    DBMS_OUTPUT.PUT_LINE(' 수강상태 : ' || vcpState);  
    DBMS_OUTPUT.PUT_LINE(' 수료및중도탈락날짜 : ' || vcpDate);  
    DBMS_OUTPUT.PUT_LINE('╚═════════════════════════════════════════════════════════════════════════════════╝');
END procStudentInfo;
/

-- 실행
BEGIN
procStudentInfo(1);
END;
/


-- 특정 개설 과정이 수료한 경우 등록된 교육생 전체에 대해서 수료날짜를 지정할 수 있어야 한다. 단, 중도 탈락자는 제외한다.
CREATE OR REPLACE PROCEDURE procCompletCourse(
    pocId tblOpenCourse.id%TYPE) --개설과정번호
IS
    vcpSId tblCompletion.tblStudent_Id%TYPE;
    vcpOcId tblCompletion.tblOpenCourse_Id%TYPE;
    vcpState tblCompletion.State%TYPE;
    vcpDate tblCompletion.completiondate%TYPE;
    vocEDate tblOpenCourse.endDate%TYPE;
    CURSOR vcursor IS
    SELECT 
        cp.tblStudent_Id AS 학생번호,
        cp.tblOpenCourse_Id AS 개설과정번호,
        cp.state AS 수강상태, 
        cp.completiondate AS 수료및중도탈락날짜,
        oc.endDate AS 과정종료날짜
    INTO
        vcpSId, vcpOcId, vcpState, vcpDate, vocEDate
        FROM tblCompletion cp
            INNER JOIN tblOpenCourse oc
                ON cp.tblopencourse_id = oc.id
                    WHERE tblOpenCourse_Id = pocId AND state <> '중도탈락';
BEGIN
    OPEN vcursor;
        LOOP
        FETCH vcursor INTO vcpSId, vcpOcId, vcpState, vcpDate, vocEDate;
        EXIT WHEN vcursor%notfound;
        
        vcpState := '수료';
        vcpDate := vocEDate;
        
        update tblCompletion set state = vcpState, completiondate = vcpDate where id = vcpSId ;
        DBMS_OUTPUT.PUT_LINE('학생번호: '||vcpSId||', 과정번호: '||vcpOcId||', 상태: '||vcpState||', 날짜: '||vcpDate);
        
        END LOOP;
    CLOSE vcursor; 
END procCompletCourse;
/

--실행
BEGIN
procCompletCourse(13);
END;
/



 
--시험 관리 및 성적 조회 
-- 과목별 성적 조회
CREATE OR REPLACE PROCEDURE procSubjectGrade (
    pid NUMBER
)
IS
BEGIN
    FOR tbl IN (
        SELECT
            DISTINCT
            os.id,
            os.startDate
        FROM tblSubject s
            INNER JOIN tblOpenSubject os ON s.id = os.tblSubject_id
            INNER JOIN tblGrade g ON os.id = g.tblOpenSubject_id
            WHERE s.id = pid
            ORDER BY os.startDate
    ) LOOP
        procOpenSubjectGrade(tbl.id);
    END LOOP;
END;
/

-- 개설 과목별 성적 조회
CREATE OR REPLACE PROCEDURE procOpenSubjectGrade (
    pid NUMBER
)
IS
    vcourseName tblOpenCourse.name%type;
    vcourseStartDate tblOpenCourse.startDate%type;
    vcourseEndDate tblOpenCourse.endDate%type;
    vsubjectId tblOpenSubject.id%type;
    vsubjectName tblOpenSubject.name%type;
    vsubjectStartDate tblOpenSubject.startDate%type;
    vsubjectEndDate tblOpenSubject.endDate%type;
    vclassroomName tblClassroom.name%type;
    vteacherName tblTeacher.name%type;
    vbookName tblBook.name%type;
    
    vstudentId tblStudent.id%type;
    vstudentName tblStudent.name%type;
    vstudentSSN tblStudent.ssn%type;
    vattend NUMBER;
    vwrite tblAllotment.write%type;
    vpractice tblAllotment.write%type;
    
    CURSOR vcursor
    IS
    SELECT 
        DISTINCT
        openCourseName,
        openCourseStartDate,
        openCourseEndDate,
        openSubjectId,
        openSubjectName,
        openSubjectStartDate,
        openSubjectEndDate,
        c.name AS classroomName,
        teacherName,
        b.name AS bookName
    FROM vwStudentCourseInfo sci
        INNER JOIN tblClassroom c ON c.id = sci.classroomId
        INNER JOIN tblBook b ON b.id = sci.bookId
        INNER JOIN tblGrade g ON studentId = g.tblStudent_id AND openSubjectId = g.tblOpenSubject_Id
        WHERE openSubjectId = pid;
        
    CURSOR vcursorStudent
    IS
    SELECT
        s.name AS studentName,
        s.ssn AS studentSSN,
        round((SELECT
            sum(fnReturnAttendScore(attendanceState))
            FROM vwstudentAttendDetail
            WHERE studentId = s.id AND attendanceDate BETWEEN os.startDate AND os.endDate)
        / ((SELECT count(*) FROM tblAttendance
            WHERE tblStudent_id = s.id AND attendanceDate BETWEEN os.startDate AND os.endDate) * 3) * a.attendance) AS attend,
        g.write AS write,
        g.practice AS practice
    FROM tblStudent s
        INNER JOIN tblGrade g ON s.id = g.tblStudent_id
        INNER JOIN tblOpenSubject os ON os.id = g.tblOpenSubject_id
        INNER JOIN tblCompletion c ON s.id = c.tblStudent_id 
        INNER JOIN tblAllotment a ON os.id = a.tblOpenSubject_id
        Where a.tblOpenSubject_id = vsubjectId
        AND (c.state <> '중도탈락' OR (c.state = '중도탈락' AND c.completionDate > a.examDate))
        ORDER BY studentName;
BEGIN
    OPEN vcursor;
    FETCH vcursor INTO vcourseName, vcourseStartDate, vcourseEndDate, vsubjectId, vsubjectName, 
        vsubjectStartDate, vsubjectEndDate, vclassroomName, vteacherName, vbookName;        

    dbms_output.put_line('╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════╗');
    dbms_output.put_line(' ' || vcourseName || '(' || to_char(vcourseStartDate, 'yyyy-mm-dd') 
        || ' ~ ' || to_char(vcourseEndDate, 'yyyy-mm-dd') || ')' );
    dbms_output.put_line(' ══════════════════════════════════════════════════════════════════════════════════════════════════════════════');
    dbms_output.put_line(' ' || vsubjectName || '(' || to_char(vsubjectStartDate, 'yyyy-mm-dd') 
        || ' ~ ' || to_char(vsubjectEndDate, 'yyyy-mm-dd') || ')' );
    dbms_output.put_line( ' 강의실명: ' || vclassroomName);
    dbms_output.put_line( ' 교사명: ' || vteacherName);
    dbms_output.put_line( ' 교재명: ' || vbookName);
    dbms_output.put_line(' ══════════════════════════════════════════════════════════════════════════════════════════════════════════════');
    dbms_output.put_line('     교육생이름     주민번호뒷자리                 출결                 필기                 실기');
    dbms_output.put_line(' ══════════════════════════════════════════════════════════════════════════════════════════════════════════════');
    OPEN vcursorStudent;
    LOOP 
        FETCH vcursorStudent INTO vstudentName, vstudentSSN, vattend, vwrite, vpractice;        
        EXIT WHEN vcursorStudent%notfound;
        dbms_output.put_line( '       ' || vstudentName || '           ' || vstudentSSN 
            || '                      ' || lpad(vattend, 2, ' ') || '                    ' 
            || lpad(vwrite, 2, ' ') || '                   ' || lpad(vpractice, 2, ' '));
    END LOOP;
    CLOSE vcursorStudent;
    dbms_output.put_line('╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════╝');
    CLOSE vcursor;
END;
/

-- 교육생 개인별 성적 조회
CREATE OR REPLACE PROCEDURE procStudentGrade (
    pid NUMBER
)
IS
    vrow tblStudent%rowtype;
    
    vcourseId tblOpenCourse.id%type;
    vcourseName tblOpenCourse.name%type;
    vcourseStartDate tblOpenCourse.startDate%type;
    vcourseEndDate tblOpenCourse.endDate%type;
    vclassroomName tblClassroom.name%type;
    
    vsubjectId tblOpenSubject.id%type;
    vsubjectName tblOpenSubject.name%type;
    vsubjectStartDate tblOpenSubject.startDate%type;
    vsubjectEndDate tblOpenSubject.endDate%type;
    vteacherName tblTeacher.name%type;
    vattend NUMBER;
    vwrite tblAllotment.write%type;
    vpractice tblAllotment.write%type;
    
    CURSOR vcursor
    IS
    SELECT 
        DISTINCT
        oc.id AS courseId,
        oc.name AS courseName,
        oc.startDate AS courseStartDate,
        oc.endDate AS courseEndDate,
        cr.name AS classroomName
    FROM tblOpenCourse oc
        INNER JOIN tblCompletion c ON oc.id = c.tblOpenCourse_id
        INNER JOIN tblClassroom cr ON cr.id = oc.tblClassroom_id
        WHERE c.tblStudent_id = pid;
        
    CURSOR vcursorSubject
    IS
    SELECT
        os.name AS subjectName,
        os.startDate AS subjectStartDate,
        os.endDate AS subjectEndDate,
        t.name AS teacherName,
        round((SELECT
            sum(fnReturnAttendScore(attendanceState))
            FROM vwstudentAttendDetail
            WHERE studentId = pid AND attendanceDate BETWEEN os.startDate AND os.endDate)
        / ((SELECT count(*) FROM tblAttendance
            WHERE tblStudent_id = pid AND attendanceDate BETWEEN os.startDate AND os.endDate) * 3) * a.attendance) AS attend,
        g.write AS write,
        g.practice AS practice
    FROM tblStudent s
        INNER JOIN tblGrade g ON s.id = g.tblStudent_id
        INNER JOIN tblOpenSubject os ON os.id = g.tblOpenSubject_id
        INNER JOIN tblCompletion c ON s.id = c.tblStudent_id 
        INNER JOIN tblAllotment a ON os.id = a.tblOpenSubject_id
        INNER JOIN tblTeacher t ON t.id = os.tblTeacher_id
        Where s.id = pid
        AND (c.state <> '중도탈락' OR (c.state = '중도탈락' AND c.completionDate > a.examDate))
        ORDER BY subjectStartDate;
BEGIN    
    SELECT * INTO vrow FROM tblStudent WHERE id = pid;
    dbms_output.put_line('╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗');
    dbms_output.put_line(' ' || vrow.name || '(' || vrow.ssn || ')' );
    dbms_output.put_line('╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝');
    
    OPEN vcursor;
    LOOP 
        FETCH vcursor INTO vcourseId, vcourseName, vcourseStartDate, vcourseEndDate, vclassroomName;
        EXIT WHEN vcursor%notfound;
        dbms_output.put_line('╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗');
        dbms_output.put_line(' ' || vcourseName || '(' || to_char(vcourseStartDate, 'yyyy-mm-dd') 
            || ' ~ ' || to_char(vcourseEndDate, 'yyyy-mm-dd') || ') - ' || vclassroomName);
        dbms_output.put_line(' ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        dbms_output.put_line('     개설과목명                 개설과목기간             교사명          출결              필기            실기');
        dbms_output.put_line(' ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        OPEN vcursorSubject;
        LOOP 
            FETCH vcursorSubject INTO vsubjectName, vsubjectStartDate, vsubjectEndDate, vteacherName, vattend, vwrite, vpractice;        
            EXIT WHEN vcursorSubject%notfound;
            dbms_output.put_line( '  ' || rpad(vsubjectName, 20, ' ') || '     ' || to_char(vsubjectStartDate, 'yyyy-mm-dd')
                || ' ~ ' || to_char(vsubjectEndDate, 'yyyy-mm-dd') || '        ' || vteacherName || '           ' 
                || lpad(vattend, 2, ' ') || '                ' || lpad(vwrite, 2, ' ') || '               ' || lpad(vpractice, 2, ' '));
        END LOOP;
        CLOSE vcursorSubject;
        dbms_output.put_line('╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝');
        
    END LOOP;
    CLOSE vcursor;
END;
/

 
 
--출결 관리 및 출결 조회 
--1. 특정 개설 과정을 선택하는 경우 모든 교육생의 출결을 조회 할 수 있다.

CREATE OR REPLACE PROCEDURE procCourseAttendance (
    pid IN NUMBER
)
IS
    CURSOR vcursor
    IS
    SELECT s.name, a.attendanceDate, ad.inTime, ad.outTime 
        FROM tblAttendance a
        INNER JOIN tblAttendDetail ad ON a.id = ad.tblAttendance_id
        INNER JOIN tblStudent s ON s.id = a.tblStudent_id
        WHERE tblOpenCourse_id = pid
        ORDER BY s.name, a.attendanceDate;

    vname tblStudent.name%type;
    vattendanceDate tblAttendance.attendanceDate%type;
    vinTime tblAttendDetail.inTime%type;
    voutTime tblAttendDetail.outTime%type;
    vprevName tblStudent.name%type := NULL; -- 이전 학생의 이름 저장
    
BEGIN
    OPEN vcursor;
    
    LOOP
        FETCH vcursor INTO vname, vattendanceDate, vinTime, voutTime;
        EXIT WHEN vcursor%notfound;
        
        -- 새로운 학생의 이름이 나오면 이름과 테이블 헤더 출력
        IF vprevName IS NULL OR vprevName <> vname THEN
            IF vprevName IS NOT NULL THEN
                
                dbms_output.put_line('             ----------------------------------------------------------');
            END IF;
            
            dbms_output.put_line('');
            dbms_output.put_line('             ==========================================================');
            dbms_output.put_line('           |   이  름   |    날  짜    |   입실 시간   |   퇴실 시간  |');
            dbms_output.put_line('             ==========================================================');
            dbms_output.put_line('           |   ' || vname || '   |   '   || vattendanceDate || '   |   ' || vinTime || '   |   ' || voutTime || '   |');
            
            vprevName := vname;
            
            FETCH vcursor INTO vname, vattendanceDate, vinTime, voutTime;
            
        END IF;
        
        -- 출결 정보 출력
        dbms_output.put_line('           |              |   ' || vattendanceDate || '   |   ' || vinTime || '   |   ' || voutTime || '   |');
        
    END LOOP;
    
    dbms_output.put_line('             ----------------------------------------------------------');

    CLOSE vcursor;
END;
/

-- 실행
BEGIN 
    procCourseAttendance(1); -- 해당 과정 시퀀스 입력 
END;
/




--2. 출결 현황은 기간별(년,월,일)로 조회 할 수 있다.
-- 특정 날짜를 원할 때 
CREATE OR REPLACE PROCEDURE procDateAttendance (
    pdate IN DATE
)
IS
    CURSOR vcursor
    IS
    SELECT oc.name, s.name, a.attendancedate, ad.inTime, ad.outTime 
    FROM tblAttendance a
    INNER JOIN tblAttendDetail ad ON ad.tblAttendance_id  = a.id
    INNER JOIN tblStudent s ON s.id = a.tblStudent_id
    INNER JOIN tblOpenCourse oc ON oc.id = a.tblOpenCourse_id
        WHERE a.attendancedate = pdate 
        ORDER BY oc.name, s.name, a.attendanceDate;
    
    vcname tblOpenCourse.name%type;
    vsname tblStudent.name%type;
    vdate tblAttendance.attendanceDate%type;
    vinTime tblAttendDetail.inTime%type;
    voutTime tblAttendDetail.outTime%type;
    vprevName tblOpenCourse.name%type := NULL; -- 이전 강좌의 이름 저장
    vprevDate tblAttendance.attendanceDate%type := NULL; -- 이전 날짜 저장 
BEGIN
    
    OPEN vcursor;
    
    LOOP
        FETCH vcursor INTO vcname, vsname, vdate, vinTime, voutTime;
        EXIT WHEN vcursor%notfound;
        
        -- 새로운 강좌가 나오면 이름과 테이블 헤더 출력
        IF vprevName <> vcname THEN
            IF vprevName IS NOT NULL THEN
                dbms_output.put_line('          -----------------------------------------------------------');
            END IF;
            
            dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
            dbms_output.put_line('      ' || vcname);
            dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
            
            
            dbms_output.put_line('          ===========================================================');
            dbms_output.put_line('          |    날  짜    |   이  름   |   입실 시간   |   퇴실 시간  |');
            dbms_output.put_line('          ===========================================================');
            dbms_output.put_line('          |   ' || vdate || '   |   '   || vsname || '   |   ' || vinTime || '   |   ' || voutTime || '   |');
            
            FETCH vcursor INTO vcname, vsname, vdate, vinTime, voutTime;
            
            vprevName := vcname;
            
        ELSIF vprevName IS NULL THEN
        
            dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
            dbms_output.put_line('      ' || vcname);
            dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
            
            vprevName := vcname;
            
        END IF;
        
        -- 새로운 날짜가 나오면 날짜와 테이블 헤더 출력
        IF vprevDate IS NULL OR vprevDate <> vdate THEN
            IF vprevDate IS NOT NULL THEN
                dbms_output.put_line('          -----------------------------------------------------------');
            END IF;
            
            dbms_output.put_line('          ===========================================================');
            dbms_output.put_line('          |    날  짜    |   이  름   |   입실 시간   |   퇴실 시간  |');
            dbms_output.put_line('          ===========================================================');
            dbms_output.put_line('          |   ' || vdate || '   |   '   || vsname || '   |   ' || vinTime || '   |   ' || voutTime || '   |');
            
            vprevDate := vdate;
            
            FETCH vcursor INTO vcname, vsname, vdate, vinTime, voutTime;
            
        END IF;
        
        dbms_output.put_line('          |              |   '   || vsname || '   |   ' || vinTime || '   |   ' || voutTime || '   |');
            
        
    
    END LOOP;        
    
    dbms_output.put_line('          -----------------------------------------------------------');
        
    CLOSE vcursor;
    
END;
/

BEGIN
    procDateAttendance('2023-03-03');
END;
/



-- 특정 기간 사이의 날짜를 원할 때 
CREATE OR REPLACE PROCEDURE procDatePeriodAttendance (
    pstartDate IN DATE,
    pendDate IN DATE 
)
IS
    CURSOR vcursor
    IS
    SELECT oc.name, s.name, a.attendancedate, ad.inTime, ad.outTime 
    FROM tblAttendance a
    INNER JOIN tblAttendDetail ad ON ad.tblAttendance_id  = a.id
    INNER JOIN tblStudent s ON s.id = a.tblStudent_id
    INNER JOIN tblOpenCourse oc ON oc.id = a.tblOpenCourse_id
        WHERE a.attendancedate BETWEEN pstartDate AND pendDate
        ORDER BY oc.name, s.name, a.attendanceDate;
    
    vcname tblOpenCourse.name%type;
    vsname tblStudent.name%type;
    
    vdate tblAttendance.attendanceDate%type;
    vinTime tblAttendDetail.inTime%type;
    voutTime tblAttendDetail.outTime%type;
    
    vprevCname tblOpenCourse.name%type := NULL; -- 이전 강좌의 이름 저장
    vprevSname tblStudent.name%type := NULL; -- 이전 학생의 이름  저장 
    
    
BEGIN
    
    OPEN vcursor;
    
    LOOP
        FETCH vcursor INTO vcname, vsname, vdate, vinTime, voutTime;
        EXIT WHEN vcursor%notfound;
        
        -- 새로운 강좌가 나오면 이름과 테이블 헤더 출력
        IF vprevCname <> vcname THEN
            
            dbms_output.put_line('             ---------------------------------------------------------');
            
            dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
            dbms_output.put_line('      ' || vcname);
            dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
            
            vprevCname := vcname;
            vprevSname := NULL;   -- 새로운 강좌가 시작되면 학생 이름 초기화
            
        ELSIF vprevCname IS NULL THEN
        
            dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
            dbms_output.put_line('    ' || vcname);
            dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
            
            vprevCname := vcname;
            
        END IF;
        
        -- 새로운 학생 이름이 나오면 이름과 테이블 헤더 출력 
        IF vprevSname IS NULL OR vprevSname <> vsname THEN
            IF vprevSname IS NOT NULL THEN
                dbms_output.put_line('             ---------------------------------------------------------');
            END IF;
            
            dbms_output.put_line('             =========================================================');
            dbms_output.put_line('          |   이  름   |    날  짜    |   입실 시간  |   퇴실 시간  |');
            dbms_output.put_line('             =========================================================');
            dbms_output.put_line('          |   ' || vsname || '     |   '   || vdate || '   |   ' || vinTime || '   |   ' || voutTime || '   |');
            
            FETCH vcursor INTO vcname, vsname, vdate, vinTime, voutTime;
            
            
            vprevSname := vsname;
            
            
        END IF;
        
        dbms_output.put_line('          |              |   ' || vdate || '   |   ' || vinTime || '   |   ' || voutTime || '   |');
            
        
    
    END LOOP;        
    
    dbms_output.put_line('             ---------------------------------------------------------');
        
    CLOSE vcursor;
    
END;
/

BEGIN
    procDatePeriodAttendance('2024-08-01', '2024-08-11');
END;
/



--3. 특정 과정별 출결 현황 조회시 (과정명, 출결날짜, 근태상황, 인원)을 출력 할 수 있다.

CREATE OR REPLACE PROCEDURE procCourseAttendDetail (
    pid IN NUMBER
)
IS
    CURSOR vcursor 
    IS
    SELECT openCourseName, attendanceDate, studentCount, normalAttendance, late, late_earlyLeave, earlyLeave, outing, sickDay, absence
    FROM vwAttendState
        WHERE openCourseId = pid
            ORDER BY openCourseId;
    
    vcname vwAttendState.openCourseName%type;
    vdate vwAttendState.attendanceDate%type;
    
    vstudentCount NUMBER;
    vnormalAttendance NUMBER;
    vlate NUMBER;
    vlate_earlyLeave NUMBER;
    vearlyLeave NUMBER;
    vouting NUMBER;
    vsickDay NUMBER;
    vabsence NUMBER;
    
    vprevCname vwAttendState.openCourseName%type := NULL; -- 강좌의 이름 저장
    
BEGIN

    OPEN vcursor;
        
    LOOP
        
        FETCH vcursor INTO vcname, vdate, vstudentCount, vnormalAttendance, vlate, vlate_earlyLeave, vearlyLeave, vouting, vsickDay, vabsence;
        EXIT WHEN vcursor%notfound;
        
        -- 강좌 이름과 테이블 헤더 출력
        IF vprevCname IS NULL THEN
            
            dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
            dbms_output.put_line('     ' || vcname);
            dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
            dbms_output.put_line('  ===============================================================================');
            dbms_output.put_line('      날짜    인원   정상출석   지각   지각/조퇴   조퇴   외출   병가   결석');
            dbms_output.put_line('  ===============================================================================');
            
            vprevCname := vcname;
           
        END IF;
                                                                                                
        dbms_output.put_line('|     ' || vdate || '    ' || vstudentCount || '명     ' || vnormalAttendance 
        || '명      ' || vlate || '명       ' || vlate_earlyLeave || '명        ' || vearlyLeave || '명    ' || vouting || '명    ' 
        || vsickDay || '명    ' || vabsence || '명   ' || '|');
        
    
    END LOOP;
    
    dbms_output.put_line('|______________________________________________________________________________|');
    
    
    CLOSE vcursor;

END;
/



BEGIN
    procCourseAttendDetail(1);
END;
/



--4. 특정 수강생별 개인 출결 현황 조회시 (수강생 이름, 출결날짜, 근태상황)을 출력 할 수 있다.

CREATE OR REPLACE PROCEDURE procStudentAttendance (
    pid NUMBER
)
IS
    CURSOR vcursor 
    IS
    SELECT studentName, attendanceDate, attendanceState
    FROM vwstudentatted
        WHERE studentId = pid
            ORDER BY attendanceDate;
    
    vstudentName vwstudentatted.studentName%type;
    vattendanceDate vwstudentatted.attendanceDate%type;
    vattendanceState vwstudentatted.attendanceState%type;

    vprevName vwstudentatted.studentName%type := NULL; -- 학생 이름 저장
    
BEGIN

    OPEN vcursor;
            
        LOOP
            FETCH vcursor INTO vstudentName, vattendanceDate, vattendanceState;
            EXIT WHEN vcursor%notfound;
            
            IF vprevName IS NULL THEN
                
                dbms_output.put_line('  ︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵');
                dbms_output.put_line('|                                        |');
                dbms_output.put_line('|          ' || vstudentName || ' 학생의 출결 정보        |');
                dbms_output.put_line('|                                        |');
                dbms_output.put_line(' ︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶');
                dbms_output.put_line(' =========================================');
                dbms_output.put_line('|        날   짜        근태 상황         |');
                dbms_output.put_line(' =========================================');
                
                vprevName := vstudentName;
            
            END IF;
            
            IF vattendanceState = '지각/조퇴' THEN
            
                dbms_output.put_line('|        '  || vattendanceDate || '        ' || vattendanceState || '           |');
                FETCH vcursor INTO vstudentName, vattendanceDate, vattendanceState;
            
            END IF;
            
            dbms_output.put_line('|        '  || vattendanceDate || '          ' || vattendanceState || '            |');
            
        END LOOP;
        
        dbms_output.put_line(' -----------------------------------------');
                
    CLOSE vcursor;

END;
/

BEGIN
    procStudentAttendance(1);
END;
/





 
 
 
--교육생 면접 및 선발 기능 
-- 특정 관리자가 담당하는 지원서 조회
CREATE OR REPLACE PROCEDURE procResumesByAdmin (
    pAdmin_id NUMBER
) AS
    CURSOR resumeCursor IS
        SELECT * FROM tblResume WHERE tblAdmin_id = pAdmin_id;
BEGIN
    DBMS_OUTPUT.PUT_LINE('-----------------------');
    FOR resumeRecord IN resumeCursor LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || resumeRecord.id || '|| Name: ' || resumeRecord.name);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-----------------------');
END;






--교육생 상담일지 관리 
-- 특정 교육생의 상담일지 조회
CREATE OR REPLACE PROCEDURE procCounselByStudent (
    pstudent_id IN NUMBER
) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    FOR rec IN (
        SELECT
            Id AS 상담번호,
            tblTeacher_id AS 교사번호,
            tblStudent_id AS 교육생번호,
            Content AS 상담내용,
            counselDate AS 상담일자
        FROM tblCounsel
        WHERE tblStudent_id = pstudent_id
        ORDER BY counselDate DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('상담번호: ' || rec.상담번호);
        DBMS_OUTPUT.PUT_LINE('교사번호: ' || rec.교사번호);
        DBMS_OUTPUT.PUT_LINE('교육생번호: ' || rec.교육생번호);
        DBMS_OUTPUT.PUT_LINE('상담내용: ' || rec.상담내용);
        DBMS_OUTPUT.PUT_LINE('상담일자: ' || TO_CHAR(rec.상담일자, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('------------------------------');
    END LOOP;
END;




 
 
 
--과목별 교재 관리 
-- 과목별 교재 조회
CREATE OR REPLACE PROCEDURE procBookList (
    pid NUMBER
)
IS
    vcount NUMBER;
    vname tblSubject.name%type;
    vrow tblBook%rowtype;
    
    CURSOR vcursor
    IS
    SELECT
        b.id,
        b.name,
        b.author,
        b.publish,
        b.issueDate
    FROM tblSubject s
        INNER JOIN tblSubjectTextbook st ON s.id = st.tblSubject_id
        INNER JOIN tblBook b ON b.id = st.tblBook_id
        WHERE s.id = pid
        ORDER BY b.name;
BEGIN
    SELECT count(*) INTO vcount FROM tblSubject s
        INNER JOIN tblSubjectTextbook st ON s.id = st.tblSubject_id
        WHERE s.id = pid;

    IF vcount = 0 THEN
        dbms_output.put_line('해당 과목에 연결된 교재가 존재하지 않습니다');
    ELSE 
        SELECT name INTO vname FROM tblSubject WHERE id = pid;
        dbms_output.put_line('╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗');
        dbms_output.put_line(' ' || vname);
        dbms_output.put_line(' ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        dbms_output.put_line('                     교재명                                     저자                       출판사                발행일');
        dbms_output.put_line(' ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        OPEN vcursor;
        LOOP 
            FETCH vcursor INTO vrow;        
            EXIT WHEN vcursor%notfound;
            dbms_output.put_line( '  ' || rpad(vrow.name, 50, ' ') || '     '
                || '   ' || rpad(vrow.author, 20, ' ') || '   ' || rpad(vrow.publish, 25, ' ')
                || '  ' || to_char(vrow.issueDate, 'yyyy-mm-dd'));
        END LOOP;
        CLOSE vcursor;
        dbms_output.put_line('╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝');
    END IF;
END;
/


 
 
 
 
 
 
--사후 처리 관리 
-- 과정을 수강한 교육생들의 취업정보를 조회 및 관리한다.
-- 수료생들의 취업정보를 조회
CREATE OR REPLACE PROCEDURE procJobResult
IS 
BEGIN
    -- 타이틀    DBMS_OUTPUT.PUT_LINE('╔═════════════════════════════════════════════════════════════════════════════════╗');
    DBMS_OUTPUT.PUT_LINE('                   전체 수료생들의 취업정보');    
    DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════════════════════════');
    -- 학생정보 출력
    FOR c IN (
    SELECT
        oc.name AS 과정명,
        vwse.studentTel AS 전화번호,
        vwse.studentId AS 교육생번호,
        vwse.studentName AS 교육생이름,
        vwse.completionState AS 수료상태,
        vwse.completionCompletiondate AS 수료날짜,
        CASE WHEN employListState LIKE '취업' THEN '취업' ELSE '미취업' END AS 취업상태,
        vwse.employListHireDate AS 취업날짜,
        vwarn.companyName AS 기업이름,
        vwarn.recruitNoticeJob AS 직무,
        vwarn.recruitNoticeSalary AS 연봉,
        vwarn.contractTypeType AS 계약형태
    FROM vwStudentEmployInfo vwse
        LEFT OUTER JOIN vwApplyRecruitNoticeInfo vwarn
            ON vwse.employListTblApplyList_id = vwarn.applyListId
                 JOIN tblOpenCourse oc
                    ON oc.id = vwse.completionTblopencourse_id
    WHERE vwse.completionState like '수료'
        ORDER BY vwse.studentId)
    LOOP
        DBMS_OUTPUT.PUT_LINE('ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ');
        DBMS_OUTPUT.PUT_LINE(' 번    호 : '|| c.교육생번호);  
        DBMS_OUTPUT.PUT_LINE(' 이    름 : '|| c.교육생이름);  
        DBMS_OUTPUT.PUT_LINE(' 연 락 처 : '|| c.전화번호);  
        DBMS_OUTPUT.PUT_LINE(' 취업상태 : '|| c.취업상태);  
        DBMS_OUTPUT.PUT_LINE(' 취업날짜 : '|| c.취업날짜);  
        DBMS_OUTPUT.PUT_LINE(' 기업이름 : '|| c.기업이름);  
        DBMS_OUTPUT.PUT_LINE(' 직    무 : '|| c.직무);  
        DBMS_OUTPUT.PUT_LINE(' 계약형태 : '|| c.계약형태);  
        DBMS_OUTPUT.PUT_LINE(' 연    봉 : '|| c.연봉);  
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('╚═════════════════════════════════════════════════════════════════════════════════╝');
END procJobResult;
/

--실행
BEGIN
procJobResult;
END;
/



-- 특정 교육생의 취업정보를 조회,
CREATE OR REPLACE PROCEDURE procStudentEmploy(
    pstId tblStudent.id%TYPE) --교육생번호선택
IS
BEGIN
    FOR s IN (
    SELECT
        vwse.studentName AS 교육생이름,
        vwse.completionCompletiondate AS 수료날짜,
        vwse.employListState AS 취업상태,
        vwse.employListHireDate AS 취업날짜,
        vwarn.companyName AS 기업이름,
        vwarn.recruitNoticeJob AS 직무,
        vwarn.recruitNoticeSalary AS 연봉,
        vwarn.contractTypeType AS 계약형태
    FROM vwStudentEmployInfo vwse
        INNER JOIN vwApplyRecruitNoticeInfo vwarn
            ON vwse.employListTblApplyList_id = vwarn.applyListId
    WHERE vwse. studentId = pstId)
    LOOP
        DBMS_OUTPUT.PUT_LINE('╔═════════════════════════════════════════════════════════════════════════════════╗');
        DBMS_OUTPUT.PUT_LINE('                            ['|| s.교육생이름 ||'] 님의 취업정보');    
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════════════════════════');
        DBMS_OUTPUT.PUT_LINE('╔═════════════════════════════════════════════════════════════════════════════════╗');
        DBMS_OUTPUT.PUT_LINE(' 이    름 : ' || s.교육생이름);  
        DBMS_OUTPUT.PUT_LINE(' 수료날짜 : ' || s.수료날짜);    
        DBMS_OUTPUT.PUT_LINE(' 취업상태 : ' || s.취업상태); 
        DBMS_OUTPUT.PUT_LINE(' 취업날짜 : ' || s.취업날짜); 
        DBMS_OUTPUT.PUT_LINE(' 기업이름 : ' || s.기업이름); 
        DBMS_OUTPUT.PUT_LINE(' 직    무 : ' || s.직무); 
        DBMS_OUTPUT.PUT_LINE(' 연    봉 : ' || s.연봉); 
        DBMS_OUTPUT.PUT_LINE(' 계약형태 : ' || s.계약형태);
        DBMS_OUTPUT.PUT_LINE('╚═════════════════════════════════════════════════════════════════════════════════╝');
    END LOOP;
       
END procStudentEmploy;
/

--실행
BEGIN
procStudentEmploy(1);
END;
/




 
--채용기업과 채용공고 관리 
-- 기업별 채용공고를 조회
CREATE OR REPLACE PROCEDURE procCompanyRecruitNotice(
pcId tblCompany.id%Type)
IS
    vname tblCompany.name%TYPE; 
    vtel tblCompany.tel%TYPE;
    vmanager tblCompany.manager%TYPE;
    vcooperation tblCompany.cooperation%TYPE; 
BEGIN
    -- 기업정보 출력
    SELECT name, tel, manager, cooperation into vname, vtel, vmanager, vcooperation FROM tblCompany WHERE id = pcId;
    DBMS_OUTPUT.PUT_LINE('╔═════════════════════════════════════════════════════════════════════════════════╗');
    DBMS_OUTPUT.PUT_LINE('   [ '|| vname ||' ]');
    DBMS_OUTPUT.PUT_LINE('   담당자 : '|| vmanager || ' ' || vtel ||' ('|| vcooperation ||')');  
    DBMS_OUTPUT.PUT_LINE(' ══════════════════════════════════════════════════════════════════════════════════');
        
        -- 채용공고 출력
        FOR r IN (
        SELECT
            recruitNoticeId AS 공고번호,
            recruitNoticeJob AS 직무,
            recruitNoticeStartDate AS 시작날짜,
            recruitNoticeEndDate AS 종료날짜,
            recruitNoticeSalary AS 연봉,
            recruitNoticeState AS 채용상태,
            contractTypeType AS 계약형태,
            count(recruitNoticeId) AS 지원자수
            FROM vwApplyRecruitNoticeInfo
                WHERE companyId = pcid
                    GROUP BY recruitNoticeId, recruitNoticeJob, recruitNoticeStartDate, recruitNoticeEndDate, recruitNoticeSalary, recruitNoticeState, contractTypeType
                        ORDER BY recruitNoticeId)              
        LOOP
            DBMS_OUTPUT.PUT_LINE(' ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ');
            DBMS_OUTPUT.PUT_LINE(' 공고번호 : '|| r.공고번호);  
            DBMS_OUTPUT.PUT_LINE(' 직    무 : '|| r.직무);  
            DBMS_OUTPUT.PUT_LINE(' 계약형태 : '|| r.계약형태); 
            DBMS_OUTPUT.PUT_LINE(' 연    봉 : '|| r.연봉);  
            DBMS_OUTPUT.PUT_LINE(' 채용기간 : '|| r.시작날짜 || ' ~ ' || r.종료날짜);  
            DBMS_OUTPUT.PUT_LINE(' 채용상태 : '|| r.채용상태);  
            DBMS_OUTPUT.PUT_LINE(' 지원자수 : '|| r.지원자수|| '명'); 
        END LOOP;

    DBMS_OUTPUT.PUT_LINE('╚═════════════════════════════════════════════════════════════════════════════════╝');
END procCompanyRecruitNotice;
/

--실행
BEGIN
procCompanyRecruitNotice(1);
END;
/


 
 
--교사 평가 기능 
--과정을 수강하는 교육생들이 작성한 교사 평가 정보를 조회 및 관리한다. 
--- 관리자는 교육생들이 제출한 교사 평가 정보를 조회할 수 있다. 
--- 교사 평가 정보에는 과정명, 평가일, 교육생들의 평가항목 5가지(난이도, 전달력, 강의 속도, 종합만족도, 추천의사)를 포함한다. 
--- 특정 과정의 전체 평가 정보를 교사별로 출력할 수 있다. 












--구내식당 식단표 관리 
--1. 해당 날짜의 한식(일품, PLUS)메뉴를 등록한다. 
-- 원하는 날짜가 식단표에 등록되어 있지 않을 경우 등록한다.
CREATE OR REPLACE PROCEDURE procMenuReg (
    pdate DATE,
    pdiv NUMBER,
    pmenu VARCHAR2
)
IS
    vwnum NUMBER;
    vmnum NUMBER;  
    vwid NUMBER;
    vmid NUMBER;
    vdate DATE;
BEGIN
    IF to_char(to_date(pdate, 'yy/mm/dd'), 'd') BETWEEN 2 AND 6 THEN
        SELECT count(*) INTO vwnum FROM tblWeeklyMenu WHERE menuDate = pdate;
        IF vwnum = 0 THEN
            dbms_output.put_line('해당 날짜의 등록된 식단표가 없습니다. 식단표를 생성합니다.');
            vdate := pdate - (to_char(to_date(pdate, 'yy/mm/dd'), 'd')) + 2;
            FOR i IN 1..5 LOOP  
                INSERT INTO tblWeeklyMenu VALUES (seqWeeklyMenu.nextVal, vdate);
                vdate := vdate + 1;
            END LOOP;
        END IF;
        
        SELECT id INTO vwid FROM tblWeeklyMenu WHERE menuDate = pdate;
            IF pdiv = 1 THEN
                dbms_output.put_line('한식 메뉴를 등록합니다.');
                INSERT INTO tblKoreanMenu VALUES (seqKoreanMenu.nextVal, pmenu);
                SELECT id INTO vmid 
                FROM (SELECT * FROM tblKoreanMenu pm WHERE menu = pmenu ORDER BY id DESC) a 
                    WHERE rownum = 1;       
                INSERT INTO tblKoreanList VALUES (seqKoreanList.nextVal, vwid, vmid);
                dbms_output.put_line('한식 메뉴를 등록이 완료되었습니다.');
            ELSIF pdiv = 2 THEN
                IF to_char(to_date(pdate, 'yy/mm/dd'), 'd') IN (3, 5) THEN
                    dbms_output.put_line('일품 메뉴를 등록합니다.');
                    INSERT INTO tblPremiumMenu VALUES (seqPremiumMenu.nextVal, pmenu);
                    SELECT id INTO vmid 
                    FROM (SELECT * FROM tblPremiumMenu pm WHERE menu = pmenu ORDER BY id DESC) a 
                        WHERE rownum = 1;       
                    INSERT INTO tblPremiumList VALUES (seqPremiumList.nextVal, vwid, vmid);
                    dbms_output.put_line('일품 메뉴를 등록이 완료되었습니다.');
                ELSIF to_char(to_date(pdate, 'yy/mm/dd'), 'd') IN (2, 4, 6) THEN
                    dbms_output.put_line('일품 메뉴의 날짜는 화요일 또는 목요일이어야만 합니다.');
                END IF;
            ELSIF pdiv = 3 THEN
                dbms_output.put_line('PLUS 메뉴를 등록합니다.');
                INSERT INTO tblPlusMenu VALUES (seqPlusMenu.nextVal, pmenu);
                SELECT id INTO vmid 
                FROM (SELECT * FROM tblPlusMenu pm WHERE menu = pmenu ORDER BY id DESC) a 
                    WHERE rownum = 1;
                INSERT INTO tblPlusList VALUES (seqPlusList.nextVal, vwid, vmid);
                dbms_output.put_line('PLUS 메뉴를 등록이 완료되었습니다.');
                
            ELSIF pdiv NOT IN (1, 2, 3) THEN
                dbms_output.put_line('한식 메뉴는 1번, 일품 메뉴는 2번, PLUS 메뉴는 3번을 눌러주세요.');
            END IF;
    ELSIF to_char(to_date(pdate, 'yy/mm/dd'), 'd') IN (1, 7) THEN
        dbms_output.put_line('식단표의 날짜는 평일만 가능합니다.');
    END IF;
END;
/


BEGIN
    procMenuReg('2024-09-03', 2, '그린샐러드');
END;
/


--2. 해당 날짜의 한식(일품, PLUS)메뉴를 조회한다.
CREATE OR REPLACE PROCEDURE procDivMenu (
    pdate DATE,
    pdiv NUMBER
)
IS  
    CURSOR kcursor
    IS
    SELECT km.menu AS 한식
        FROM tblKoreanMenu km
        INNER JOIN tblKoreanList kl ON km.id = kl.tblKoreanMenu_id
        INNER JOIN tblWeeklyMenu wm ON wm.id = kl.tblWeeklyMenu_id
            WHERE wm.menuDate = pdate;
            
    CURSOR prcursor
    IS 
    SELECT pm.menu AS 일품
        FROM tblPremiumMenu pm
        INNER JOIN tblPremiumList pl ON pm.id = pl.tblPremiumMenu_id
        INNER JOIN tblWeeklyMenu wm ON wm.id = pl.tblWeeklyMenu_id  
            WHERE wm.menuDate = pdate;
    
    CURSOR plcursor
    IS
    SELECT pm.menu AS PLUS메뉴
        FROM tblPlusMenu pm
        INNER JOIN tblPlusList pl ON pm.id = pl.tblPlusMenu_id
        INNER JOIN tblWeeklyMenu wm ON wm.id = pl.tblWeeklyMenu_id
            WHERE wm.menuDate = pdate;
            
    vname VARCHAR2(50);
    vnum NUMBER;
    vholiday tblHoliday.holiday%type;
BEGIN
    SELECT count(*) INTO vnum FROM tblHoliday WHERE holidayDate = pdate;
    
    IF vnum = 0 THEN 

        IF to_char(to_date(pdate, 'yy/mm/dd'), 'd') BETWEEN 2 AND 6 THEN
            
            dbms_output.put_line('20' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'yy') || '년 ' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'mm') 
            || '월 ' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'dd') || '일 ' || to_char(to_date(pdate, 'yy/mm/dd'), 'dy') || '요일');
            
            IF pdiv = 1 THEN
                OPEN kcursor;

                    dbms_output.put_line('한식 메뉴');
                    dbms_output.put_line('');
                    LOOP 
                        FETCH kcursor INTO vname;
                        EXIT WHEN kcursor%notfound;
                        dbms_output.put_line(vname);
                    END LOOP;
                CLOSE kcursor;
            ELSIF pdiv = 2 THEN
                IF to_char(to_date(pdate, 'yy/mm/dd'), 'd') IN (3, 5) THEN
                    OPEN prcursor;
                        
                        dbms_output.put_line('일품 메뉴');
                        dbms_output.put_line('');
                        LOOP 
                            FETCH prcursor INTO vname;
                            EXIT WHEN prcursor%notfound;
                            dbms_output.put_line(vname);
                        END LOOP;
                    CLOSE prcursor;
                ELSIF to_char(to_date(pdate, 'yy/mm/dd'), 'd') IN (2, 4, 6) THEN    
                    dbms_output.put_line('일품 메뉴는 화요일, 목요일에만 해당됩니다.');
                END IF;
            ELSIF pdiv = 3 THEN
                OPEN plcursor;
                    dbms_output.put_line('PLUS 메뉴');
                    dbms_output.put_line('');
                    LOOP 
                        FETCH plcursor INTO vname;
                        EXIT WHEN plcursor%notfound;
                        dbms_output.put_line(vname);
                    END LOOP;        
                CLOSE plcursor;
            ELSIF pdiv NOT IN (1, 2, 3) THEN
                dbms_output.put_line('한식 메뉴는 1번, 일품 메뉴는 2번, PLUS 메뉴는 3번을 눌러주세요.');
            END IF;        
        ELSIF to_char(to_date(pdate, 'yy/mm/dd'), 'd') IN (1, 7) THEN
            dbms_output.put_line('식단표의 날짜는 평일만 가능합니다.');
        END IF;
        
    ELSIF vnum = 1 THEN
        SELECT holiday INTO vholiday FROM tblHoliday WHERE holidayDate = pdate;
        dbms_output.put_line(vholiday || '입니다.');
        dbms_output.put_line('공휴일에는 식당 운영을 하지 않습니다.');
    END IF;
END;
/

BEGIN
    procDivMenu('2024-08-17', 3);
END;
/


--3. 원하는 날짜의 구내식당 식단표(날짜, 요일, 한식, 일품, PLUS 메뉴)를 조회한다.
CREATE OR REPLACE PROCEDURE procDateMenu (
    pdate DATE
)
IS  
    CURSOR kcursor
    IS
    SELECT km.menu AS 한식
        FROM tblKoreanMenu km
        INNER JOIN tblKoreanList kl ON km.id = kl.tblKoreanMenu_id
        INNER JOIN tblWeeklyMenu wm ON wm.id = kl.tblWeeklyMenu_id
            WHERE wm.menuDate = pdate;
            
    CURSOR prcursor
    IS 
    SELECT pm.menu AS 일품
        FROM tblPremiumMenu pm
        INNER JOIN tblPremiumList pl ON pm.id = pl.tblPremiumMenu_id
        INNER JOIN tblWeeklyMenu wm ON wm.id = pl.tblWeeklyMenu_id  
            WHERE wm.menuDate = pdate;
    
    CURSOR plcursor
    IS
    SELECT pm.menu AS PLUS메뉴
        FROM tblPlusMenu pm
        INNER JOIN tblPlusList pl ON pm.id = pl.tblPlusMenu_id
        INNER JOIN tblWeeklyMenu wm ON wm.id = pl.tblWeeklyMenu_id
            WHERE wm.menuDate = pdate;
            
    vname VARCHAR2(50);
    vnum NUMBER;
    vholiday tblHoliday.holiday%type;
    
BEGIN
    OPEN kcursor;
    OPEN prcursor;
    OPEN plcursor;

    SELECT count(*) INTO vnum FROM tblHoliday WHERE holidayDate = pdate;
    
    
    IF vnum = 0 THEN 
    
        IF to_char(to_date(pdate, 'yy/mm/dd'), 'd') BETWEEN 2 AND 6 THEN
        
        dbms_output.put_line('20' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'yy') || '년 ' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'mm') 
        || '월 ' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'dd') || '일 ' || to_char(to_date(pdate, 'yy/mm/dd'), 'dy') || '요일');
        
        dbms_output.put_line('한식 메뉴');
        dbms_output.put_line('');
        LOOP 
            FETCH kcursor INTO vname;
            EXIT WHEN kcursor%notfound;
            dbms_output.put_line(vname);
        END LOOP;
    
        IF to_char(to_date(pdate, 'yy/mm/dd'), 'd') IN (3, 5) THEN
            dbms_output.put_line('');
            dbms_output.put_line('');
            dbms_output.put_line('일품 메뉴');
            dbms_output.put_line('');
            LOOP 
                FETCH prcursor INTO vname;
                EXIT WHEN prcursor%notfound;
                dbms_output.put_line(vname);
            END LOOP;
        END IF;    
        
        dbms_output.put_line('');
        dbms_output.put_line('');
        dbms_output.put_line('PLUS 메뉴');
        dbms_output.put_line('');
        LOOP 
            FETCH plcursor INTO vname;
            EXIT WHEN plcursor%notfound;
            dbms_output.put_line(vname);
        END LOOP;    
            
        ELSIF to_char(to_date(pdate, 'yy/mm/dd'), 'd') IN (1, 7) THEN
            dbms_output.put_line('식단표의 날짜는 평일만 가능합니다.');
        END IF;
        
    ELSIF vnum = 1 THEN
        SELECT holiday INTO vholiday FROM tblHoliday WHERE holidayDate = pdate;
        dbms_output.put_line(vholiday || '입니다.');
        dbms_output.put_line('공휴일에는 식당 운영을 하지 않습니다.');
    END IF;        
    
    CLOSE prcursor;
    CLOSE kcursor;
    CLOSE plcursor;

END;
/

BEGIN
    procDateMenu('2024-08-13');
END;
/




 
 
 
 
--대여 서비스 관리 
--1. 대여 물품 등록
-- 대여 물품 정보 입력시 기본 내용은 물품 이름, 물품 수량(tblItemState > insert 개수), 등록일으로한다.


--------------------------------- 물품 등록 ------------------------------------

CREATE OR REPLACE PROCEDURE procItemReg (
    pname tblItemList.name%type,
    pqty NUMBER
)
IS
  vnum NUMBER;  
  vid NUMBER;
BEGIN
    SELECT count(*) INTO vnum FROM tblItemList WHERE name = pname;
    
    IF vnum = 0 THEN 
        dbms_output.put_line(pname || ' 물품 등록을 진행합니다.');
        INSERT INTO tblItemList(id, name, regDate) VALUES(seqItemList.nextVal, pname, sysdate);
        dbms_output.put_line(pname || ' 물품 등록이 완료되었습니다.');
        dbms_output.put_line('');
        
        dbms_output.put_line('수량 '|| pqty || '개 등록을 진행합니다.');
        
        SELECT id INTO vid FROM tblItemList WHERE name = pname;
        
        FOR i IN 1..pqty LOOP
            INSERT INTO tblItemState(id, state, tblItemList_id) VALUES(seqItemState.nextVal, default, vid);
        END LOOP;
        
        dbms_output.put_line('수량 '|| pqty || '개 등록이 완료되었습니다.');
        
    ELSIF vnum = 1 THEN 
        dbms_output.put_line(pname || '이(가) 이미 등록되어있습니다. 수량 추가를 진행합니다.');
        
        SELECT id INTO vid FROM tblItemList WHERE name = pname;
        
        FOR i IN 1..pqty LOOP
            INSERT INTO tblItemState(id, state, tblItemList_id) VALUES(seqItemState.nextVal, default, vid);
        END LOOP;
        
        dbms_output.put_line('수량 '|| pqty || '개 추가 등록이 완료되었습니다.');
        
    END IF;
    
END;
/

BEGIN
    procItemReg('손수건', 1);
END;
/


--------------------------------- 물품 삭제 ------------------------------------

CREATE OR REPLACE PROCEDURE procItemDelete (
    pname tblItemList.name%type,
    pqty NUMBER
)
IS
    CURSOR vcursor
    IS
    SELECT tis.id 
    FROM tblItemState tis INNER JOIN tblItemList il ON il.id = tis.tblItemList_id
    WHERE il.name = pname AND tis.state = '대여가능';

    vlnum NUMBER;  
    vsnum NUMBER;
    vtnum NUMBER;
    vlid NUMBER;
    vsid NUMBER;
BEGIN
    
    OPEN vcursor;
    
    SELECT count(*) INTO vlnum FROM tblItemList WHERE name = pname;
    
    IF vlnum = 0 THEN 
        dbms_output.put_line(pname || '이(가) 등록되어있지 않습니다.');
    ELSIF vlnum = 1 THEN 
    
        SELECT id INTO vlid FROM tblItemList WHERE name = pname;
        SELECT count(*) INTO vsnum FROM tblItemState WHERE tblItemList_id = vlid AND state = '대여중';
        SELECT count(*) INTO vtnum FROM tblItemState WHERE tblItemList_id = vlid;
        
        IF vsnum = 0 THEN
            IF vtnum - pqty >= 0 THEN
                IF vtnum = pqty THEN
                    dbms_output.put_line('교육생이 대여중인 물품이 없으므로 물품을 완전히 삭제합니다.');
                    DELETE FROM tblItemState WHERE tblItemList_id = vlid;
                    DELETE FROM tblItemList WHERE id = vlid;
                ELSIF vtnum > pqty THEN
                    dbms_output.put_line('총수량보다 적은 수량을 입력하셨습니다. ' || pqty || '개의 물품을 삭제합니다.');
                    FOR i IN 1..pqty LOOP
                        FETCH vcursor INTO vsid;
                         DELETE FROM tblItemState WHERE id = vsid;
                    END LOOP;
                END IF;
            ELSIF vtnum - pqty < 0 THEN
                dbms_output.put_line('총수량보다 많은 양의 수를 입력하셨습니다. 대여중인 학생이 없으므로 ');
                dbms_output.put_line(pqty - (pqty - vtnum) || '개의 물품을 완전히 삭제합니다.');
                FOR i IN 1..pqty - vtnum LOOP
                    FETCH vcursor INTO vsid;
                    DELETE FROM tblItemState WHERE id = vsid;
                    DELETE FROM tblItemList WHERE id = vlid;
                END LOOP;
            END IF;
        ELSIF vsnum > 0 THEN
            IF vtnum - pqty >= 0 THEN
                IF vtnum - vsnum > 0 THEN
                    IF vtnum - vsnum >= pqty THEN
                        dbms_output.put_line(pqty || '개의 물품을 삭제합니다.');
                        FOR i IN 1..pqty LOOP
                            FETCH vcursor INTO vsid;
                            DELETE FROM tblItemState WHERE id = vsid;
                        END LOOP;
                    ELSIF vtnum - vsnum < pqty THEN
                        dbms_output.put_line('교육생이 대여중인 물품이 있습니다.');
                        dbms_output.put_line(vtnum - vsnum || '개의 물품만 삭제합니다.');
                        FOR i IN 1..vtnum - vsnum LOOP
                            FETCH vcursor INTO vsid;
                            DELETE FROM tblItemState WHERE id = vsid;
                        END LOOP;
                    END IF;
                ELSIF vtnum - vsnum <= 0 THEN
                    dbms_output.put_line('입력하신 물품의 수량 모두 교육생이 대여중이므로 물품 삭제를 진행하지 못합니다.');           
                END IF;
            ELSIF vtnum - pqty < 0 THEN
                dbms_output.put_line('총수량보다 많은 양의 수를 입력하셨습니다. 다시 확인해주세요.');
            END IF;
        END IF; 
    END IF;
    
    CLOSE vcursor;
    
END;
/

BEGIN
    procItemDelete('손수건', 2);
END;
/



--2. 대여 서비스 관리
-- 수강생들의 대여 및 반납 현황 조회
-- 특정 물품 이름 입력 > 해당 대여 및 반납 현황 조회

CREATE OR REPLACE PROCEDURE procItemRentalRecord (
    pname VARCHAR2
)
IS
    CURSOR vcursor
    IS
    SELECT studentName, studentTel, itemName, rentalDate, returnDate 
    FROM vwStudentRentalList
    WHERE itemName = pname;
    
    vsname tblStudent.name%type;
    vstel tblStudent.tel%type;
    viName tblItemList.name%type;
    vrentalDate tblItemRental.rentalDate%type;
    vreturnDate tblItemRental.returnDate%type;
    
    vnum NUMBER;
    
BEGIN
    
    OPEN vcursor;
    
    SELECT count(*) INTO vnum
    FROM vwStudentRentalList
    WHERE itemName = pname;

    
    IF vnum = 0 THEN
        dbms_output.put_line('입력하신 정보의 물품 대여 신청 및 반납 내용이 없습니다. ');
    ELSIF vnum > 0 THEN
        dbms_output.put_line('');
        dbms_output.put_line('   ﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊');
        dbms_output.put_line('                        ' || pname || ' 물품 대여 기록');
        dbms_output.put_line('   ﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎');
        dbms_output.put_line('  =============================================================================');
        dbms_output.put_line('        교육생 이름       교육생 전화번호         대여일          반납일     ');
        dbms_output.put_line('  =============================================================================');
        LOOP
            
            FETCH vcursor INTO vsname, vstel, viName, vrentalDate, vreturnDate;
            EXIT WHEN vcursor%notfound;
            
            IF vreturnDate IS NULL THEN
                dbms_output.put_line('|         ' || vsname || '        ' || vstel || '         ' || vrentalDate || '       ' || '     X' || '            |');
            ELSIF vreturnDate IS NOT NULL THEN
                dbms_output.put_line('|         ' || vsname || '        ' || vstel || '         ' || vrentalDate || '        ' || vreturnDate || '         |');
            END IF;
        
        END LOOP;
        
        dbms_output.put_line('  -----------------------------------------------------------------------------');
        
    END IF;
    
    CLOSE vcursor;
END;
/

BEGIN
    procItemRentalRecord('삼성 노트북 충전기');
END;
/















--커리큘럼 관리 
-- 특정 과정의 커리큘럼 조회
CREATE OR REPLACE PROCEDURE procCurriculumByCourse (
    pOpenCourse_id NUMBER
) AS
    CURSOR curiCursor IS
        SELECT s.name, cr.levels, cr.content
        FROM tblCuri cr
        JOIN tblSubject s ON s.id = cr.tblOpenSubject_id
        WHERE cr.tblOpenCourse_id = pOpenCourse_id;
BEGIN
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------------------------------------------');
    FOR curiRecord IN curiCursor LOOP
        DBMS_OUTPUT.PUT_LINE('과목명: ' || curiRecord.name || '|| 레벨: ' || curiRecord.levels || '|| 과목설명: ' || curiRecord.content);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------------------------------------------');
END;









--교사 계정 정의 
-- 교사계정 로그인
CREATE OR REPLACE PROCEDURE procTeacherLogin(
    ptel VARCHAR,
    ppw NUMBER
)
IS
    vnum NUMBER;
    vrow tblTeacher%rowtype;
BEGIN
    SELECT count(*) INTO vnum FROM tblTeacher WHERE tel = ptel AND ssn = ppw;
    IF vnum = 1 THEN
        SELECT * INTO vrow FROM tblTeacher WHERE tel = ptel AND ssn = ppw;
        dbms_output.put_line(vrow.name || '님 반갑습니다.');
        dbms_output.put_line('교사 로그인 성공!');
    ELSIF vnum = 0 THEN
        dbms_output.put_line('없는 정보입니다. 확인 후 다시 로그인 해주세요.');
    END IF;
END;
/











--배점 입출력 
-- 개설과정별 배점 조회
CREATE OR REPLACE PROCEDURE procOpenCourseAllot (
    pid NUMBER
)
IS
    vrow tblOpenCourse%rowtype;
    
    vsubjectName tblOpenSubject.name%type;
    vstartDate tblOpenSubject.startDate%type;
    vendDate tblOpenSubject.endDate%type;
    vstate VARCHAR2(20);
    vbookName tblBook.name%type;
    
    CURSOR vcursor
    IS
    SELECT 
        os.name,
        os.startDate,
        os.endDate,
        CASE
            WHEN a.id IS NOT NULL THEN 'TURE'
            ELSE 'FALSE'
        END,
        b.name
    FROM tblOpenCourse oc
        INNER JOIN tblOpenSubject os ON oc.id = os.tblOpenCourse_id
        LEFT JOIN tblAllotment a ON os.id = a.tblOpenSubject_id
        INNER JOIN tblBook b ON b.id = os.tblBook_id
        WHERE oc.id = pid
        ORDER BY os.startDate;
BEGIN
    SELECT * INTO vrow FROM tblOpenCourse oc WHERE id = pid;
    
    dbms_output.put_line('╔════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗');
    dbms_output.put_line(' ' || vrow.name || '(' || to_char(vrow.startDate, 'yyyy-mm-dd') || ' ~ ' 
        ||  to_char(vrow.endDate, 'yyyy-mm-dd') || ')');
    dbms_output.put_line(' ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
    dbms_output.put_line('       개설과목명             개설과목기간            배점입력 여부                         교재명');
    dbms_output.put_line(' ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');

    OPEN vcursor;
    LOOP 
        FETCH vcursor INTO vsubjectName, vstartDate, vendDate, vstate, vbookName;        
        EXIT WHEN vcursor%notfound;
        dbms_output.put_line( ' ' || rpad(vsubjectName, 20, ' ') || '    ' ||  to_char(vstartDate, 'yyyy-mm-dd') || ' ~ ' 
        ||  to_char(vendDate, 'yyyy-mm-dd') || '            ' || rpad(vstate, 6, ' ') || '          ' || rpad(vbookName, 40, ' '));
    END LOOP;
    CLOSE vcursor;
    dbms_output.put_line('╚════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝');
END;
/







--성적 입출력
-- 교사별 강의과목 성적등록여부 조회
CREATE OR REPLACE PROCEDURE procTeacherGrade (
    pid NUMBER
)
IS
    vcourseId tblOpenCourse.id%type;
    vcourseName tblOpenCourse.name%type;
    vcourseStartDate tblOpenCourse.startDate%type;
    vcourseEndDate tblOpenCourse.endDate%type;
    
    vsubjectId tblOpenSubject.id%type;
    
    vsubjectName tblOpenSubject.name%type;
    vstartDate tblOpenSubject.startDate%type;
    vendDate tblOpenSubject.endDate%type;
    vattend tblAllotment.attendance%type;
    vwrite tblAllotment.write%type;
    vpractice tblAllotment.practice%type;
    vstate VARCHAR2(20);
    vbookName tblBook.name%type;
    
    CURSOR vcursor
    IS
    SELECT
        DISTINCT
        oc.id,
        oc.name,
        oc.startDate,
        oc.endDate
    FROM tblOpenSubject os
        INNER JOIN tblAllotment a ON os.id = a.tblOpenSubject_id
        INNER JOIN tblOpenCourse oc ON oc.id = os.tblOpenCourse_id
        WHERE os.tblTeacher_id = pid AND a.examDate < sysdate
        ORDER BY oc.startDate;
        
    CURSOR vcursorSubjectId
    IS
    SELECT
        DISTINCT
        os.id
    FROM tblOpenSubject os
        INNER JOIN tblAllotment a ON os.id = a.tblOpenSubject_id
        INNER JOIN tblOpenCourse oc ON oc.id = os.tblOpenCourse_id
        WHERE oc.id = vcourseId AND a.examDate < sysdate;
    
    CURSOR vcursorSubject
    IS
    SELECT
        os.name,
        os.startDate,
        os.endDate,
        a.attendance,
        a.write,
        a.practice,
        CASE
            WHEN (SELECT count(*) FROM tblGrade WHERE tblOpenSubject_id = os.id) > 0 THEN '등록'
            ELSE '미등록'
        END,
        b.name
    FROM tblOpenSubject os
        INNER JOIN tblAllotment a ON os.id = a.tblOpenSubject_id
        INNER JOIN tblBook b ON b.id = os.tblBook_id
        WHERE os.id = vsubjectId;
BEGIN
    OPEN vcursor;
    LOOP
        FETCH vcursor INTO vcourseId, vcourseName, vcourseStartDate, vcourseEndDate;
        EXIT WHEN vcursor%notfound;

        dbms_output.put_line('╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗');
        dbms_output.put_line(' ' || vcourseName || '(' || to_char(vcourseStartDate, 'yyyy-mm-dd') || ' ~ ' 
            ||  to_char(vcourseEndDate, 'yyyy-mm-dd') || ')');
        dbms_output.put_line(' ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        dbms_output.put_line('       개설과목명             개설과목기간        배점(출결/필기/실기)    성적등록여부                   교재명');
        dbms_output.put_line(' ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        
        OPEN vcursorSubjectId;
        LOOP
            FETCH vcursorSubjectId INTO vsubjectId;  
            EXIT WHEN vcursorSubjectId%notfound;
            OPEN vcursorSubject;
            FETCH vcursorSubject INTO vsubjectName, vstartDate, vendDate, vattend, vwrite, vpractice, vstate, vbookName;  
            dbms_output.put_line( ' ' || rpad(vsubjectName, 20, ' ') || '    ' ||  to_char(vstartDate, 'yyyy-mm-dd') || ' ~ ' 
            ||  to_char(vendDate, 'yyyy-mm-dd') || '        ' || vattend || ' / ' 
            || vwrite || ' / ' || vpractice || '            ' || vstate || '          ' || rpad(vbookName, 40, ' '));
            CLOSE vcursorSubject;
        END LOOP;
        CLOSE vcursorSubjectId;
        dbms_output.put_line('╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝');
    END LOOP;
    CLOSE vcursor;
END;
/



-- 특정 개설과목 성적 출력
CREATE OR REPLACE PROCEDURE procTeacherGradeInfo (
    pid NUMBER
)
IS
    vstudentName tblStudent.name%type;
    vstudentTel tblStudent.tel%type;
    vattend NUMBER;
    vwrite tblAllotment.write%type;
    vpractice tblAllotment.practice%type;
    vstate tblCompletion.state%type;
    completionDate tblCompletion.completionDate%type;

    CURSOR vcursor
    IS
    SELECT
        DISTINCT
        s.name,
        s.tel,
        CASE
            WHEN g.id IS NULL THEN 0
            ELSE 
                round(
                    (SELECT
                        sum(fnReturnAttendScore(attendanceState))
                        FROM vwstudentAttendDetail
                        WHERE studentId = s.id AND attendanceDate BETWEEN os.startDate AND os.endDate)
                    / (
                    (SELECT count(*) FROM tblAttendance
                        WHERE tblStudent_id = s.id AND attendanceDate BETWEEN os.startDate AND os.endDate)
                         * 3) * (SELECT attendance FROM tblAllotment WHERE os.id = tblOpenSubject_id))
        END,
        CASE
            WHEN g.id IS NULL THEN 0
            ELSE g.write
        END,
        CASE
            WHEN g.id IS NULL THEN 0
            ELSE g.practice
        END,
        c.state,
        c.completionDate
    FROM tblCompletion c
        INNER JOIN tblStudent s ON s.id = c.tblStudent_id
        INNER JOIN tblOpenCourse oc ON oc.id = c.tblOpenCourse_id
        INNER JOIN tblOpenSubject os ON oc.id = os.tblOpenCourse_id
        LEFT OUTER JOIN tblGrade g ON os.id = tblOpenSubject_id AND s.id = g.tblStudent_id
        WHERE os.id = pid
        ORDER BY s.name;
        
BEGIN
    dbms_output.put_line('╔════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗');
    dbms_output.put_line('          이름              전화번호               출결     필기     실기            수료상태              비고');
    dbms_output.put_line(' ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        
    OPEN vcursor;
    LOOP
        FETCH vcursor INTO vstudentName, vstudentTel, vattend, vwrite, vpractice, vstate, completionDate;
        EXIT WHEN vcursor%notfound;
        IF vstate = '중도탈락' THEN
            dbms_output.put_line( '         ' || vstudentName || '           ' || vstudentTel || '             ' 
            || lpad(vattend, 2, ' ') || '        ' || lpad(vwrite, 2, ' ') || '       ' || lpad(vpractice, 2, ' ') 
            || '             ' || vstate || '           ' || to_char(completionDate, 'yyyy-mm-dd'));
        ELSE
            dbms_output.put_line( '         ' || vstudentName || '           ' || vstudentTel || '             ' 
            || lpad(vattend, 2, ' ') || '        ' || lpad(vwrite, 2, ' ') || '       ' || lpad(vpractice, 2, ' ') 
            || '               ' || vstate);
        END IF;
    END LOOP;
    CLOSE vcursor;
    
    dbms_output.put_line('╚════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝');
END;
/










--출결 관리
--1. 수강생들의 출결 현황을 기간별(년, 월, 일) 조회할 수 있다.
-- 특정 날짜를 원할 때 

CREATE OR REPLACE PROCEDURE procStudentAttendance (
    pid NUMBER
)
IS
    CURSOR vcursor 
    IS
    SELECT studentName, attendanceDate, attendanceState
    FROM vwstudentatted
        WHERE studentId = pid
            ORDER BY attendanceDate;
    
    vstudentName vwstudentatted.studentName%type;
    vattendanceDate vwstudentatted.attendanceDate%type;
    vattendanceState vwstudentatted.attendanceState%type;

    vprevName vwstudentatted.studentName%type := NULL; -- 학생 이름 저장
    
BEGIN

    OPEN vcursor;
            
        LOOP
            FETCH vcursor INTO vstudentName, vattendanceDate, vattendanceState;
            EXIT WHEN vcursor%notfound;
            
            IF vprevName IS NULL THEN
                
                dbms_output.put_line('  ︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵');
                dbms_output.put_line('|                                        |');
                dbms_output.put_line('|          ' || vstudentName || ' 학생의 출결 정보        |');
                dbms_output.put_line('|                                        |');
                dbms_output.put_line(' ︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶');
                dbms_output.put_line(' =========================================');
                dbms_output.put_line('|        날   짜        근태 상황         |');
                dbms_output.put_line(' =========================================');
                
                vprevName := vstudentName;
            
            END IF;
            
            IF vattendanceState = '지각/조퇴' THEN
            
                dbms_output.put_line('|        '  || vattendanceDate || '        ' || vattendanceState || '           |');
                FETCH vcursor INTO vstudentName, vattendanceDate, vattendanceState;
            
            END IF;
            
            dbms_output.put_line('|        '  || vattendanceDate || '          ' || vattendanceState || '            |');
            
        END LOOP;
        
        dbms_output.put_line(' -----------------------------------------');
                
    CLOSE vcursor;

END;
/

BEGIN
    procStudentAttendance(1);
END;
/


-- 특정 기간 사이의 날짜를 원할 때 
CREATE OR REPLACE PROCEDURE procTeacherPeriodAttendance (
    ptid IN NUMBER,
    pstartDate IN DATE,
    pendDate IN DATE 
)
IS
    CURSOR vcursor
    IS
    SELECT oc.name, s.name, a.attendancedate, ad.inTime, ad.outTime 
    FROM tblAttendance a
    INNER JOIN tblAttendDetail ad ON ad.tblAttendance_id = a.id
    INNER JOIN tblStudent s ON s.id = a.tblStudent_id
    INNER JOIN tblOpenCourse oc ON oc.id = a.tblOpenCourse_id
    INNER JOIN vwTeacherCourse tc ON tc.openCourseId = oc.id 
        WHERE a.attendancedate BETWEEN pstartDate AND pendDate AND tc.teacherId = ptid
        ORDER BY oc.id, oc.name, s.name, a.attendanceDate;
        
    
    vcname tblOpenCourse.name%type;
    vsname tblStudent.name%type;
    
    vdate tblAttendance.attendanceDate%type;
    vinTime tblAttendDetail.inTime%type;
    voutTime tblAttendDetail.outTime%type;
    
    vprevCname tblOpenCourse.name%type := NULL; -- 이전 강좌의 이름 저장
    vprevSname tblStudent.name%type := NULL; -- 이전 학생의 이름  저장 
    
    vtnum NUMBER;
    vdnum NUMBER;
    
BEGIN
    
    OPEN vcursor;
    
    SELECT count(*) INTO vtnum FROM vwTeacherCourse WHERE teacherId = ptid AND pstartDate >= startDate 
                                                                           AND pendDate <= endDate;
    SELECT count(*) INTO vdnum FROM vwTeacherCourse WHERE pstartDate >= startDate 
                                                      AND pendDate <= EndDate;
    
    IF vtnum >= 1 AND vdnum >= 1 THEN
    
        LOOP
            FETCH vcursor INTO vcname, vsname, vdate, vinTime, voutTime;
            EXIT WHEN vcursor%notfound;
        
            -- 새로운 강좌가 나오면 이름과 테이블 헤더 출력
            IF vprevCname <> vcname THEN
                
                
                dbms_output.put_line('           ----------------------------------------------------------');
                
                dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
                dbms_output.put_line('  ' || vcname);
                dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
                
                vprevCname := vcname;
                vprevSname := NULL;   -- 새로운 강좌가 시작되면 학생 이름 초기화
                
            ELSIF vprevCname IS NULL THEN
            
                dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
                dbms_output.put_line('  ' || vcname);
                dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
                
                vprevCname := vcname;
                
            END IF;
            
            -- 새로운 학생 이름이 나오면 이름과 테이블 헤더 출력 
            IF vprevSname IS NULL OR vprevSname <> vsname THEN
                IF vprevSname IS NOT NULL THEN
                    dbms_output.put_line('           ----------------------------------------------------------');
                END IF;
                
                dbms_output.put_line('           ==========================================================');
                dbms_output.put_line('          |   이  름   |    날  짜    |   입실 시간   |   퇴실 시간  |');
                dbms_output.put_line('           ==========================================================');
                dbms_output.put_line('          |   ' || vsname || '   |   '   || vdate || '   |   ' || vinTime || '   |   ' || voutTime || '   |');
                
                FETCH vcursor INTO vcname, vsname, vdate, vinTime, voutTime;
                
                
                vprevSname := vsname;
                
                
            END IF;
            
            dbms_output.put_line('          |              |   ' || vdate || '   |   ' || vinTime || '   |   ' || voutTime || '   |');
               
    END LOOP;        
    
    dbms_output.put_line('           ----------------------------------------------------------');
    
    ELSIF vdnum = 0 THEN              
        dbms_output.put_line('잘못된 날짜를 입력하셨습니다.');
          
    ELSIF vtnum = 0 THEN
        dbms_output.put_line('해당 날짜의 강좌에 대한 출결 정보 열람 권한이 없습니다.');
            
    END IF;
        
    CLOSE vcursor;
    
END;
/

BEGIN
    procTeacherPeriodAttendance(4, '2023-07-13', '2023-07-17');
END;
/


2. 특정 과정(과정명, 출결날짜, 근태상황, 인원)에 대한 출결 현황을 조회할 수 있다.

CREATE OR REPLACE PROCEDURE procTeacherCourseAttendDetail (
    ptid IN NUMBER,
    pcid IN NUMBER
)
IS
    CURSOR vcursor 
    IS
    SELECT openCourseName, attendanceDate, studentCount, normalAttendance, late, late_earlyLeave, earlyLeave, outing, sickDay, absence
        FROM vwAttendState vas
        INNER JOIN tblOpenSubject os ON os.tblOpenCourse_id = vas.openCourseId
        INNER JOIN tblTeacher t ON t.id = os.tblTeacher_id
        WHERE openCourseId = pcid AND t.id = ptid
            ORDER BY openCourseId;
    
    vcname vwAttendState.openCourseName%type;
    vdate vwAttendState.attendanceDate%type;
    
    vstudentCount NUMBER;
    vnormalAttendance NUMBER;
    vlate NUMBER;
    vlate_earlyLeave NUMBER;
    vearlyLeave NUMBER;
    vouting NUMBER;
    vsickDay NUMBER;
    vabsence NUMBER;
    
    vprevCname vwAttendState.openCourseName%type := NULL; -- 강좌의 이름 저장
    
    vnum NUMBER;
    
BEGIN

    OPEN vcursor;
        
    SELECT count(DISTINCT openCourseId) INTO vnum
        FROM vwAttendState vas
            INNER JOIN tblOpenSubject os ON os.tblOpenCourse_id = vas.openCourseId
            INNER JOIN tblTeacher t ON t.id = os.tblTeacher_id
            WHERE t.id = ptid AND openCourseId = pcid
            ORDER BY openCourseId;    
    
    IF vnum = 1 THEN
       
        LOOP
            
            FETCH vcursor INTO vcname, vdate, vstudentCount, vnormalAttendance, vlate, vlate_earlyLeave, vearlyLeave, vouting, vsickDay, vabsence;
            EXIT WHEN vcursor%notfound;
            
        
            
                -- 강좌 이름과 테이블 헤더 출력
                IF vprevCname IS NULL THEN
                    
                    dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
                    dbms_output.put_line('  ' || vcname);
                    dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
                    dbms_output.put_line('  ===============================================================================');
                    dbms_output.put_line('      날짜    인원   정상출석   지각   지각/조퇴   조퇴   외출   병가   결석');
                    dbms_output.put_line('  ===============================================================================');
                    
                    vprevCname := vcname;
                   
                END IF;
                                                                                                        
                dbms_output.put_line('|     ' || vdate || '    ' || vstudentCount || '명     ' || vnormalAttendance 
                || '명      ' || vlate || '명       ' || vlate_earlyLeave || '명       ' || vearlyLeave || '명    ' || vouting || '명    ' 
                || vsickDay || '명    ' || vabsence || '명    ' || '  |');
                
            
            END LOOP;
            
            dbms_output.put_line('|______________________________________________________________________________|');
    
    ELSIF vnum = 0 THEN
        dbms_output.put_line('해당 강좌에 대한 출결 정보 열람 권한이 없습니다.');
    END IF; 
    
    CLOSE vcursor;

END;
/



BEGIN
    procTeacherCourseAttendDetail(4, 1);
END;
/


--3. 특정 교육생(교육생 이름, 출결날짜, 근태상황)에 대한 출결 현황을 조회할 수 있다.

CREATE OR REPLACE PROCEDURE procTeacherStudentAttendance (
    ptid NUMBER,
    psid NUMBER
)
IS
    CURSOR vcursor 
    IS
    SELECT studentName, attendanceDate, attendanceState
    FROM vwstudentAttendDetail sad 
    INNER JOIN vwTeacherOpenCourseList tos ON sad.openCourseId = tos.tblOpenCourse_id
    INNER JOIN tblTeacher t ON t.id = tos.tblTeacher_id
        WHERE studentId = psid AND tblTeacher_id = ptid
            ORDER BY attendanceDate;
    
    vstudentName vwstudentatted.studentName%type;
    vattendanceDate vwstudentatted.attendanceDate%type;
    vattendanceState vwstudentatted.attendanceState%type;

    vprevName vwstudentatted.studentName%type := NULL; -- 학생 이름 저장
    
    vnum NUMBER;
    
BEGIN

    OPEN vcursor;
    
    SELECT count(DISTINCT tblTeacher_id) INTO vnum
    FROM vwstudentAttendDetail sad 
    INNER JOIN vwTeacherOpenCourseList tos ON sad.openCourseId = tos.tblOpenCourse_id
    INNER JOIN tblTeacher t ON t.id = tos.tblTeacher_id
    WHERE studentId = psid AND tblTeacher_id = ptid;
    
    
    
    IF vnum = 1 THEN
    
        LOOP
            FETCH vcursor INTO vstudentName, vattendanceDate, vattendanceState;
            EXIT WHEN vcursor%notfound;
            
            IF vprevName IS NULL THEN
                
                dbms_output.put_line('  ︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵');
                dbms_output.put_line('|                                        |');
                dbms_output.put_line('|          ' || vstudentName || ' 학생의 출결 정보        |');
                dbms_output.put_line('|                                        |');
                dbms_output.put_line(' ︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶');
                dbms_output.put_line(' =========================================');
                dbms_output.put_line('|        날   짜        근태 상황         |');
                dbms_output.put_line(' =========================================');
                
                vprevName := vstudentName;
            
            END IF;
            
            IF vattendanceState = '지각/조퇴' THEN
            
                dbms_output.put_line('|        '  || vattendanceDate || '        ' || vattendanceState || '           |');
                FETCH vcursor INTO vstudentName, vattendanceDate, vattendanceState;
            
            END IF;
            
            dbms_output.put_line('|        '  || vattendanceDate || '          ' || vattendanceState || '            |');
            
        END LOOP;
        
        dbms_output.put_line(' -----------------------------------------');
    
    ELSIF vnum = 0 THEN
        dbms_output.put_line('해당 학생에 대한 출결 정보 열람 권한이 없습니다.');
    END IF;
        
    CLOSE vcursor;

END;
/

BEGIN
    procTeacherStudentAttendance(4, 1);
END;
/







BEGIN
    procEvaluationCourse(4, 1);
END;
/



--교사 평가 조회
-- 과정별 교사평가 조회
CREATE OR REPLACE PROCEDURE procEvaluationCourse (
    pteacherId NUMBER,
    pcourseId NUMBER
)
IS
    vcount NUMBER;

    vname tblOpenCourse.name%type;
    vstartDate tblOpenCourse.startDate%type;
    vendDate tblOpenCourse.startDate%type;
    vdifficulty VARCHAR2(15);
    vcommunicationSkills VARCHAR2(15);
    vlecturePace VARCHAR2(15);
    vsatisfaction VARCHAR2(15);
    vrecommendation VARCHAR2(15);
    vevaluationDate tblEvaluation.evaluationDate%type;
    
BEGIN
    SELECT
        count(*)
    INTO
        vcount
    FROM (SELECT
            oc.name,
            oc.startDate,
            oc.endDate,
            fnEvaluation(avg(e.difficulty)),
            fnEvaluation(avg(e.communicationSkills)),
            fnEvaluation(avg(e.lecturePace)),
            fnEvaluation(avg(e.satisfaction)),
            fnEvaluation(avg(e.recommendation)),
            e.evaluationdate
    FROM tblOpenCourse oc
        INNER JOIN tblOpenSubject os ON oc.id = os.tblOpenCourse_id
        INNER JOIN tblTeacher t ON t.id = os.tblTeacher_id AND t.id = pteacherId
        INNER JOIN tblCompletion c ON oc.id = c.tblOpenCourse_id AND oc.id = pcourseId
        INNER JOIN tblStudent s ON s.id = c.tblStudent_id
        INNER JOIN tblEvaluation e ON t.id = e.tblTeacher_id AND s.id = e.tblStudent_id
        group by oc.name, oc.startDate, oc.endDate, e.evaluationdate);
        
    IF vcount = 0 THEN
        dbms_output.put_line('교사평가가 존재하지 않습니다.');
    ELSE
        SELECT
            oc.name,
            oc.startDate,
            oc.endDate,
            fnEvaluation(avg(e.difficulty)),
            fnEvaluation(avg(e.communicationSkills)),
            fnEvaluation(avg(e.lecturePace)),
            fnEvaluation(avg(e.satisfaction)),
            fnEvaluation(avg(e.recommendation)),
            e.evaluationdate
        INTO
            vname, 
            vstartDate, 
            vendDate, 
            vdifficulty, 
            vcommunicationSkills, 
            vlecturePace,
            vsatisfaction,
            vrecommendation,
            vevaluationDate
        FROM tblOpenCourse oc
            INNER JOIN tblOpenSubject os ON oc.id = os.tblOpenCourse_id
            INNER JOIN tblTeacher t ON t.id = os.tblTeacher_id AND t.id = pteacherId
            INNER JOIN tblCompletion c ON oc.id = c.tblOpenCourse_id AND oc.id = pcourseId
            INNER JOIN tblStudent s ON s.id = c.tblStudent_id
            INNER JOIN tblEvaluation e ON t.id = e.tblTeacher_id AND s.id = e.tblStudent_id
            group by oc.name, oc.startDate, oc.endDate, e.evaluationdate;
        
        dbms_output.put_line('');dbms_output.put_line('');dbms_output.put_line('');dbms_output.put_line('');dbms_output.put_line('');dbms_output.put_line('');
        dbms_output.put_line('╔═════════════════════════════════════════════════════════════════════════╗');
        dbms_output.put_line('');
        dbms_output.put_line('                ' || vname || '(' || to_char(vstartDate, 'yyyy-mm-dd') || ' ~ ' || to_char(vendDate, 'yyyy-mm-dd') || ')');
        dbms_output.put_line('                평가일: ' || to_char(vevaluationDate, 'yyyy-mm-dd'));
        dbms_output.put_line('');
        dbms_output.put_line(' ══════════════════════════════════════════════════════════════════════════');
        dbms_output.put_line('               난이도             전달력               강의속도               종합 만족도               추천의사         ');
        dbms_output.put_line(' ══════════════════════════════════════════════════════════════════════════');
        dbms_output.put_line('               ' || rpad(vdifficulty, 13, ' ') || '      ' || rpad(vcommunicationSkills, 15, ' ')
            || '      ' || rpad(vlecturePace, 17, ' ') || '      ' || rpad(vsatisfaction, 15, ' ')
            || '        ' || rpad(vrecommendation, 15, ' '));
        dbms_output.put_line('╚═════════════════════════════════════════════════════════════════════════╝');
        dbms_output.put_line('');dbms_output.put_line('');dbms_output.put_line('');dbms_output.put_line('');dbms_output.put_line('');dbms_output.put_line('');
    END IF;
END;
/


-- 연도별 교사평가 조회
CREATE OR REPLACE PROCEDURE procEvaluationYear (
    pteacherId NUMBER,
    pyear NUMBER
)
IS
    vcount NUMBER;

    vdifficulty VARCHAR2(15);
    vcommunicationSkills VARCHAR2(15);
    vlecturePace VARCHAR2(15);
    vsatisfaction VARCHAR2(15);
    vrecommendation VARCHAR2(15);
    vevaluationDate tblEvaluation.evaluationDate%type;
    
    CURSOR vcursor
    IS
    SELECT
        fnEvaluation(avg(e.difficulty)),
        fnEvaluation(avg(e.communicationSkills)),
        fnEvaluation(avg(e.lecturePace)),
        fnEvaluation(avg(e.satisfaction)),
        fnEvaluation(avg(e.recommendation)),
        e.evaluationdate
    FROM tblOpenCourse oc
        INNER JOIN tblOpenSubject os ON oc.id = os.tblOpenCourse_id
        INNER JOIN tblTeacher t ON t.id = os.tblTeacher_id AND t.id = pteacherId
        INNER JOIN tblCompletion c ON oc.id = c.tblOpenCourse_id
        INNER JOIN tblStudent s ON s.id = c.tblStudent_id
        INNER JOIN tblEvaluation e ON t.id = e.tblTeacher_id AND s.id = e.tblStudent_id
        WHERE to_char(e.evaluationDate, 'yyyy') = pyear 
        group by oc.id, e.evaluationdate;
BEGIN
    SELECT
        count(*)
    INTO
        vcount
    FROM (SELECT
            fnEvaluation(avg(e.difficulty)),
            fnEvaluation(avg(e.communicationSkills)),
            fnEvaluation(avg(e.lecturePace)),
            fnEvaluation(avg(e.satisfaction)),
            fnEvaluation(avg(e.recommendation)),
            e.evaluationdate
    FROM tblOpenCourse oc
        INNER JOIN tblOpenSubject os ON oc.id = os.tblOpenCourse_id
        INNER JOIN tblTeacher t ON t.id = os.tblTeacher_id AND t.id = pteacherId
        INNER JOIN tblCompletion c ON oc.id = c.tblOpenCourse_id
        INNER JOIN tblStudent s ON s.id = c.tblStudent_id
        INNER JOIN tblEvaluation e ON t.id = e.tblTeacher_id AND s.id = e.tblStudent_id
        WHERE to_char(e.evaluationDate, 'yyyy') = pyear 
        group by oc.name, e.evaluationdate);
        
    IF vcount = 0 THEN
        dbms_output.put_line('교사평가가 존재하지 않습니다.');
    ELSE
        dbms_output.put_line('╔════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗');
        dbms_output.put_line(' ' || pyear || '연도 교사평가');
        dbms_output.put_line(' ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        dbms_output.put_line('            난이도            전달력           강의속도           종합 만족도          추천의사          평가일');
        dbms_output.put_line(' ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        
        OPEN vcursor;
        LOOP
            FETCH vcursor INTO vdifficulty, vcommunicationSkills, vlecturePace,
                vsatisfaction, vrecommendation, vevaluationDate;
            EXIT WHEN vcursor%notfound;
            
            dbms_output.put_line('            ' || rpad(vdifficulty, 15, ' ') || '   ' || rpad(vcommunicationSkills, 15, ' ')
                || '     ' || rpad(vlecturePace, 15, ' ') || '    ' || rpad(vsatisfaction, 15, ' ')
                || '     ' || rpad(vrecommendation, 15, ' ') || to_char(vevaluationDate, 'yyyy-mm-dd'));
            
        END LOOP;
        CLOSE vcursor;
        dbms_output.put_line('╚════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝');
    END IF;
END;
/












--구내식당 식단표 조회
--- 구내식단 식단표 조회 (해당 주의 메뉴만 조회 가능하다.)
--- 해당 주에 배식되는 구내식단 메뉴를 조회한다. 
--- 한식, 일식, PLUS 메뉴로 구성되어있으며, 각각의 메뉴를 주 단위로 조회할 수 있다. 

CREATE OR REPLACE PROCEDURE procWeeklyMenu 
IS
    TYPE menuList IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;
    
    vKoreanMenus  menuList;
    vPremiumMenus menuList;
    vPlusMenus    menuList;
    
    vday PLS_INTEGER;
    maxLength PLS_INTEGER := 6;
    
    startDate DATE := trunc(sysdate, 'IW'); 
    
    CURSOR kcursor IS
        SELECT wm.menuDate, km.menu AS 한식
        FROM tblKoreanMenu km
        INNER JOIN tblKoreanList kl ON km.id = kl.tblKoreanMenu_id
        INNER JOIN tblWeeklyMenu wm ON wm.id = kl.tblWeeklyMenu_id
        WHERE wm.menuDate BETWEEN startDate AND startDate + 4
        ORDER BY wm.menuDate;

    CURSOR prcursor IS
        SELECT wm.menuDate, pm.menu AS 일품
        FROM tblPremiumMenu pm
        INNER JOIN tblPremiumList pl ON pm.id = pl.tblPremiumMenu_id
        INNER JOIN tblWeeklyMenu wm ON wm.id = pl.tblWeeklyMenu_id
        WHERE wm.menuDate BETWEEN startDate AND startDate + 4
        ORDER BY wm.menuDate;

    CURSOR plcursor IS
        SELECT wm.menuDate, pm.menu AS PLUS메뉴
        FROM tblPlusMenu pm
        INNER JOIN tblPlusList pl ON pm.id = pl.tblPlusMenu_id
        INNER JOIN tblWeeklyMenu wm ON wm.id = pl.tblWeeklyMenu_id
        WHERE wm.menuDate BETWEEN startDate AND startDate + 4
        ORDER BY wm.menuDate;

BEGIN

    FOR i IN 1..5 LOOP
        vKoreanMenus(i) := '';
        vPremiumMenus(i) := '';
        vPlusMenus(i) := '';
    END LOOP;


    FOR krec IN kcursor LOOP
        vday := krec.menuDate - startDate + 1;
        vKoreanMenus(vday) := vKoreanMenus(vday) || krec.한식 || chr(10); 
    END LOOP;


    FOR prec IN prcursor LOOP
        vday := prec.menuDate - startDate + 1; 
        vPremiumMenus(vday) := vPremiumMenus(vday) || prec.일품 || chr(10); 
    END LOOP;


    FOR plrec IN plcursor LOOP
        vday := plrec.menuDate - startDate + 1;
        vPlusMenus(vday) := vPlusMenus(vday) || plrec.PLUS메뉴 || chr(10); 
    END LOOP;

    dbms_output.put_line('');  
    dbms_output.put_line('    ' || startDate || ' ~ ' || to_date(sysdate - (to_char(to_date(sysdate, 'yy/mm/dd'), 'd')) + 6, 'yy/mm/dd'));
    dbms_output.put_line(' ︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵');
    dbms_output.put_line('|                                                                                                                   |');
    dbms_output.put_line('|                                                    주간 메뉴표                                                    |');
    dbms_output.put_line('|                                                                                                                   |');
    dbms_output.put_line(' ︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶');
    dbms_output.put_line('');
    dbms_output.put_line('==================================================================================================================');
    dbms_output.put_line('         월요일                화요일                수요일                목요일                금요일');
    dbms_output.put_line('==================================================================================================================');
    dbms_output.put_line('');
    
    FOR i IN 1..maxLength LOOP

        IF i = 3 THEN
            dbms_output.put('한식');
        ELSIF i IN (1, 2, 4, 5, 6) THEN
            dbms_output.put('    ');
        END IF;

        dbms_output.put_line(
            '    ' || RPAD(NVL(SUBSTR(vKoreanMenus(1), 1, INSTR(vKoreanMenus(1), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vKoreanMenus(2), 1, INSTR(vKoreanMenus(2), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vKoreanMenus(3), 1, INSTR(vKoreanMenus(3), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vKoreanMenus(4), 1, INSTR(vKoreanMenus(4), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vKoreanMenus(5), 1, INSTR(vKoreanMenus(5), chr(10))-1), ' '), 20)
        );
        
        vKoreanMenus(1) := SUBSTR(vKoreanMenus(1), INSTR(vKoreanMenus(1), chr(10))+1);
        vKoreanMenus(2) := SUBSTR(vKoreanMenus(2), INSTR(vKoreanMenus(2), chr(10))+1);
        vKoreanMenus(3) := SUBSTR(vKoreanMenus(3), INSTR(vKoreanMenus(3), chr(10))+1);
        vKoreanMenus(4) := SUBSTR(vKoreanMenus(4), INSTR(vKoreanMenus(4), chr(10))+1);
        vKoreanMenus(5) := SUBSTR(vKoreanMenus(5), INSTR(vKoreanMenus(5), chr(10))+1);
    END LOOP;
    
    dbms_output.put_line('');
    dbms_output.put_line('------------------------------------------------------------------------------------------------------------------');
    dbms_output.put_line('');
    
    FOR i IN 1..maxLength LOOP

        IF i = 3 THEN
            dbms_output.put('일품');
        ELSIF i IN (1, 2, 4, 5, 6) THEN
            dbms_output.put('    ');
        END IF;

        dbms_output.put_line(
            '    ' || RPAD(NVL(SUBSTR(vPremiumMenus(1), 1, INSTR(vPremiumMenus(1), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPremiumMenus(2), 1, INSTR(vPremiumMenus(2), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPremiumMenus(3), 1, INSTR(vPremiumMenus(3), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPremiumMenus(4), 1, INSTR(vPremiumMenus(4), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPremiumMenus(5), 1, INSTR(vPremiumMenus(5), chr(10))-1), ' '), 20)
        );

        vPremiumMenus(1) := SUBSTR(vPremiumMenus(1), INSTR(vPremiumMenus(1), chr(10))+1);
        vPremiumMenus(2) := SUBSTR(vPremiumMenus(2), INSTR(vPremiumMenus(2), chr(10))+1);
        vPremiumMenus(3) := SUBSTR(vPremiumMenus(3), INSTR(vPremiumMenus(3), chr(10))+1);
        vPremiumMenus(4) := SUBSTR(vPremiumMenus(4), INSTR(vPremiumMenus(4), chr(10))+1);
        vPremiumMenus(5) := SUBSTR(vPremiumMenus(5), INSTR(vPremiumMenus(5), chr(10))+1);

    END LOOP;
    
    dbms_output.put_line('');
    dbms_output.put_line('------------------------------------------------------------------------------------------------------------------');
    dbms_output.put_line('');
    
    FOR i IN 1..maxLength LOOP

        IF i = 2 THEN
            dbms_output.put('PLUS');
        ELSIF i IN (1, 3, 4, 5) THEN
            dbms_output.put('    ');
        END IF;

        dbms_output.put_line(
            '    ' || RPAD(NVL(SUBSTR(vPlusMenus(1), 1, INSTR(vPlusMenus(1), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPlusMenus(2), 1, INSTR(vPlusMenus(2), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPlusMenus(3), 1, INSTR(vPlusMenus(3), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPlusMenus(4), 1, INSTR(vPlusMenus(4), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPlusMenus(5), 1, INSTR(vPlusMenus(5), chr(10))-1), ' '), 20)
        );

        vPlusMenus(1) := SUBSTR(vPlusMenus(1), INSTR(vPlusMenus(1), chr(10))+1);
        vPlusMenus(2) := SUBSTR(vPlusMenus(2), INSTR(vPlusMenus(2), chr(10))+1);
        vPlusMenus(3) := SUBSTR(vPlusMenus(3), INSTR(vPlusMenus(3), chr(10))+1);
        vPlusMenus(4) := SUBSTR(vPlusMenus(4), INSTR(vPlusMenus(4), chr(10))+1);
        vPlusMenus(5) := SUBSTR(vPlusMenus(5), INSTR(vPlusMenus(5), chr(10))+1);

    END LOOP;
    
    dbms_output.put_line('------------------------------------------------------------------------------------------------------------------');
    

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('오류: 데이터가 없습니다.');
    WHEN OTHERS THEN
        dbms_output.put_line('오류: ' || SQLERRM);
END;
/

-- 프로시저 실행
BEGIN
    procWeeklyMenu;
END;
/




 
--상담일지 작성 및 조회 
--– 상담일지 작성
CREATE OR REPLACE PROCEDURE procCounselInsert (
    ptblTeacher_id IN NUMBER,
    ptblStudent_id IN NUMBER,
    pcontent IN VARCHAR2,
    pcounselDate IN DATE
) IS
BEGIN
    INSERT INTO tblCounsel (
        Id,
        Content,
        counselDate,
        tblStudent_id,
        tblTeacher_id
    ) VALUES (
        seqCounsel.NEXTVAL,
        pcontent,
        pcounselDate,
        ptblStudent_id,
        ptblTeacher_id
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('상담일지가 등록되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('상담일지 등록 중 오류가 발생하였습니다: ' || SQLERRM);
END;
/


--– 특정 교육생의 상담일지 조회
CREATE OR REPLACE PROCEDURE procCounselByStudent (
    pstudent_id IN NUMBER
) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    FOR c IN (
        SELECT
            Id AS 상담번호,
            tblTeacher_id AS 교사번호,
            tblStudent_id AS 교육생번호,
            Content AS 상담내용,
            counselDate AS 상담일자
        FROM tblCounsel
        WHERE tblStudent_id = pstudent_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('상담번호: ' || c.상담번호);
        DBMS_OUTPUT.PUT_LINE('교사번호: ' || c.교사번호);
        DBMS_OUTPUT.PUT_LINE('교육생번호: ' || c.교육생번호);
        DBMS_OUTPUT.PUT_LINE('상담내용: ' || c.상담내용);
        DBMS_OUTPUT.PUT_LINE('상담일자: ' || TO_CHAR(c.상담일자, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('------------------------------');
    END LOOP;
END;





--사후 처리 조회
-- 특정 개설과정에 대한 취업현황을 조회할 수 있다. 과정정보(과정명, 과정 기간(시작년원일,끝연월일))과 수료생들의 취업현황(학생번호,이름, 취업상태,회사,취업직무)이 같이 열람될 수 있도록 한다.

-- 과정별 수료생들의 취업상태와 현황 조회

CREATE OR REPLACE PROCEDURE procCourseJobResult(
    pocId tblOpenCourse.id%TYPE) --과정번호선택
IS
    vname tblOpenCourse.name%TYPE; 
    vstartDate tblOpenCourse.startDate%TYPE; 
    vendDate tblOpenCourse.endDate%TYPE; 
BEGIN
    -- 과정명 타이틀,과정기간 출력
    SELECT name, startDate, endDate into vname, vstartDate, vendDate FROM tblOpenCourse WHERE id = pocId;
    DBMS_OUTPUT.PUT_LINE('╔═════════════════════════════════════════════════════════════════════════════════╗');
    DBMS_OUTPUT.PUT_LINE(' ['|| vname ||']');
    DBMS_OUTPUT.PUT_LINE('                      [ '|| vstartDate || ' ~ ' || vendDate ||' ]');  
    DBMS_OUTPUT.PUT_LINE('                   과정을 수강한 수료생의 취업정보');    
    DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════════════════════════');
    DBMS_OUTPUT.PUT_LINE(' [번호]  [교육생이름]  [취업상태]    [     기업이름        -        직무        ]');     
    -- 학생정보 출력
    FOR c IN (
    SELECT
        oc.id AS 과정번호,
        vwse.studentId AS 교육생번호,
        vwse.studentName AS 교육생이름,
        vwse.completionState AS 수료상태,
        vwse.completionCompletiondate AS 수료날짜,
        CASE WHEN employListState LIKE '취업' THEN '취업' ELSE '미취업' END AS 취업상태,
        vwse.employListHireDate AS 취업날짜,
        vwarn.companyName AS 기업이름,
        vwarn.recruitNoticeJob AS 직무,
        vwarn.recruitNoticeSalary AS 연봉,
        vwarn.contractTypeType AS 계약형태
    FROM vwStudentEmployInfo vwse
        LEFT OUTER JOIN vwApplyRecruitNoticeInfo vwarn
            ON vwse.employListTblApplyList_id = vwarn.applyListId
                 JOIN tblOpenCourse oc
                    ON oc.id = vwse.completionTblopencourse_id
    WHERE oc.id = pocId and vwse.completionState like '수료'
        ORDER BY vwse.studentId)
    LOOP

        DBMS_OUTPUT.PUT_LINE(' ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ');
        DBMS_OUTPUT.PUT_LINE('  '|| c.교육생번호||'      '|| c.교육생이름||'       '||c.취업상태||'        '||c.기업이름||'  -  '||c.직무);  

    END LOOP;
    DBMS_OUTPUT.PUT_LINE('╚═════════════════════════════════════════════════════════════════════════════════╝');
END procCourseJobResult;
/

--실행
BEGIN
procCourseJobResult(2);
END;
/










--교육생 계정 정의
-- 교육생계정 로그인
CREATE OR REPLACE PROCEDURE procStudentLogin(
    ptel VARCHAR,
    ppw NUMBER
)
IS
    vnum NUMBER;
    vrow tblStudent%rowtype;
BEGIN
    SELECT count(*) INTO vnum FROM tblStudent WHERE tel = ptel AND ssn = ppw;
    IF vnum = 1 THEN
        SELECT * INTO vrow FROM tblStudent WHERE tel = ptel AND ssn = ppw;
        dbms_output.put_line(vrow.name || '님 반갑습니다.');
        dbms_output.put_line('교육생 로그인 성공!');
    ELSIF vnum = 0 THEN
        dbms_output.put_line('없는 정보입니다. 확인 후 다시 로그인 해주세요.');
    END IF;
END;
/





--성적 조회
-- 개인별 수강과정의 성적 조회
CREATE OR REPLACE PROCEDURE procStudentGradeInfo (
    pstudentId NUMBER,
    pcourseId NUMBER
)
IS
    vcount NUMBER;
    vrow tblStudent%rowtype;
    
    vcourseId tblOpenCourse.id%type;
    vcourseName tblOpenCourse.name%type;
    vcourseStartDate tblOpenCourse.startDate%type;
    vcourseEndDate tblOpenCourse.endDate%type;
    vclassroomName tblClassroom.name%type;
    
    vsubjectId tblOpenSubject.id%type;
    vsubjectName tblOpenSubject.name%type;
    vsubjectStartDate tblOpenSubject.startDate%type;
    vsubjectEndDate tblOpenSubject.endDate%type;
    vteacherName tblTeacher.name%type;
    vallotDate tblAllotment.examDate%type;
    vattendAllot tblAllotment.attendance%type;
    vwriteAllot tblAllotment.write%type;
    vpracticeAllot tblAllotment.write%type;
    vattend tblAllotment.attendance%type;
    vwrite tblAllotment.write%type;
    vpractice tblAllotment.write%type;
    
    CURSOR vcursor
    IS
    SELECT
        os.name AS subjectName,
        os.startDate AS subjectStartDate,
        os.endDate AS subjectEndDate,
        t.name AS teacherName,
        a.examDate AS allotDate,
        a.attendance AS allotAttend,
        a.write AS allotWrite,
        a.practice AS allotPractice,
        round((SELECT
            sum(fnReturnAttendScore(attendanceState))
            FROM vwstudentAttendDetail
            WHERE studentId = pstudentId AND attendanceDate BETWEEN os.startDate AND os.endDate)
        / ((SELECT count(*) FROM tblAttendance
            WHERE tblStudent_id = pstudentId AND attendanceDate BETWEEN os.startDate AND os.endDate) * 3) * a.attendance) AS attend,
        g.write AS write,
        g.practice AS practice
    FROM tblStudent s
        INNER JOIN tblGrade g ON s.id = g.tblStudent_id
        INNER JOIN tblOpenSubject os ON os.id = g.tblOpenSubject_id
        INNER JOIN tblCompletion c ON s.id = c.tblStudent_id 
        INNER JOIN tblAllotment a ON os.id = a.tblOpenSubject_id
        INNER JOIN tblTeacher t ON t.id = os.tblTeacher_id
        Where s.id = pstudentId AND os.tblOpenCourse_id = pcourseId
        AND (c.state <> '중도탈락' OR (c.state = '중도탈락' AND c.completionDate > a.examDate))
        ORDER BY subjectStartDate;
BEGIN
    SELECT count(*) INTO vcount FROM tblStudent s 
        INNER JOIN tblCompletion c ON s.id = c.tblStudent_id
        INNER JOIN tblOpenCourse oc ON oc.id = c.tblOpenCourse_id
        WHERE s.id = pstudentId AND oc.id = pcourseId;

    IF vcount = 0 THEN
        dbms_output.put_line('해당 데이터가 존재하지 않습니다');
    ELSE 
        SELECT * INTO vrow FROM tblStudent WHERE id = pstudentId;
        dbms_output.put_line('╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗');
        dbms_output.put_line(' ' || vrow.name || '(' || vrow.ssn || ')' );
        dbms_output.put_line('╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝');
        
        SELECT
            DISTINCT
            oc.id AS courseId,
            oc.name AS courseName,
            oc.startDate AS courseStartDate,
            oc.endDate AS courseEndDate,
            cr.name AS classroomName
            INTO vcourseId, vcourseName, vcourseStartDate, vcourseEndDate, vclassroomName
        FROM tblOpenCourse oc
            INNER JOIN tblCompletion c ON oc.id = c.tblOpenCourse_id
            INNER JOIN tblClassroom cr ON cr.id = oc.tblClassroom_id
            WHERE c.tblStudent_id = pstudentId AND oc.id = pcourseId;
            
        dbms_output.put_line('╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗');
        dbms_output.put_line(' ' || vcourseName || '(' || to_char(vcourseStartDate, 'yyyy-mm-dd') 
            || ' ~ ' || to_char(vcourseEndDate, 'yyyy-mm-dd') || ') - ' || vclassroomName);
        dbms_output.put_line(' ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        dbms_output.put_line('     개설과목명                 개설과목기간             교사명       시험날짜        출결         필기         실기');
        dbms_output.put_line(' ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        OPEN vcursor;
        LOOP 
            FETCH vcursor INTO vsubjectName, vsubjectStartDate, vsubjectEndDate, vteacherName, vallotDate, vattendAllot, vwriteAllot, vpracticeAllot, vattend, vwrite, vpractice;        
            EXIT WHEN vcursor%notfound;
            dbms_output.put_line( '  ' || rpad(vsubjectName, 20, ' ') || '     ' || to_char(vsubjectStartDate, 'yyyy-mm-dd')
                || ' ~ ' || to_char(vsubjectEndDate, 'yyyy-mm-dd') || '        ' || vteacherName || '       ' || to_char(vallotDate, 'yyyy-mm-dd') 
                || '     ' || lpad(vattend, 2, ' ') || ' / ' || vattendAllot || '       ' || lpad(vwrite, 2, ' ') 
                || ' / ' || vwriteAllot || '      ' || lpad(vpractice, 2, ' ') || ' / ' || vpracticeAllot);
        END LOOP;
        CLOSE vcursor;
        dbms_output.put_line('╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝');
    END IF;
END;
/






--출결 관리 및 출결 조회
--1. 매일 출석을 기록해야 한다. 출근 1회, 퇴근 1회 기록한다. 외출(출근, 퇴근 2회씩 기록) 중에 해당되는 사항이 있을 경우 기록한다. 


-------------------------------------- 출근 ------------------------------------

CREATE OR REPLACE PROCEDURE procInTimeRecord (
    psid NUMBER,
    pcid NUMBER,
    pdate DATE
)
IS
    
    CURSOR vcursor
    IS
    SELECT tblStudent_id FROM tblCompletion c
    WHERE tblOpenCourse_id = pcid AND state <> '중도탈락';
    
    vsnum NUMBER;
    vcnum NUMBER;
    vsid NUMBER;
    
    vaid NUMBER;
    vdnum NUMBER;
    vtnum NUMBER;
    
    vname tblStudent.name%type;
    
BEGIN
    
    SELECT COUNT(*) INTO vsnum FROM tblAttendance WHERE tblStudent_id = psid AND TRUNC(attendanceDate) = TRUNC(pdate);
    SELECT COUNT(*) INTO vcnum FROM tblAttendance WHERE tblOpenCourse_id = pcid AND TRUNC(attendanceDate) = TRUNC(pdate);
    
    IF vcnum = 0 THEN 
    
        OPEN vcursor;
    
            LOOP
            
                FETCH vcursor INTO vsid;
                EXIT WHEN vcursor%notfound;
                
                INSERT INTO tblAttendance(id, attendancedate, tblStudent_id, tblOpenCourse_id) 
                VALUES (seqAttendance.nextVal, pdate, vsid, pcid);
                
            END LOOP;
            
            dbms_output.put_line('╔═════════════════════════════════════════╗');
            dbms_output.put_line('');
            dbms_output.put_line('            ' || '20' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'yy') || '년 ' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'mm') 
            || '월 ' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'dd') || '일 출결 정보를 생성하였습니다.');
            dbms_output.put_line('');
            dbms_output.put_line('╚═════════════════════════════════════════╝');
            
            
        CLOSE vcursor;
        
    END IF;
    
    
    SELECT a.id, s.name INTO vaid, vname FROM tblAttendance a INNER JOIN tblStudent s ON a.tblStudent_id = s.id 
         WHERE tblStudent_id = psid AND tblOpenCourse_id = pcid AND TRUNC(attendanceDate) = TRUNC(pdate); 
    
    SELECT count(*) INTO vdnum FROM tblAttendDetail WHERE tblAttendance_id = vaid;
    SELECT count(*) INTO vtnum FROM tblAttendDetail WHERE tblAttendance_id = vaid AND outTime IS NOT NULL;
    
    IF vdnum = 0 THEN
        INSERT INTO tblAttendDetail(id, inTime, outTime, tblAttendance_id) 
        VALUES (seqAttendDetail.nextVal, to_char(sysdate, 'hh24:mi:ss'), null, vaid);
        
        IF to_char(sysdate, 'hh24:mi:ss') BETWEEN '07:00:00' AND '09:00:00' THEN
            
            dbms_output.put_line('╔═════════════════════════════════════════╗');
            dbms_output.put_line('');
            dbms_output.put_line('            ' || vname || '님 ' || to_char(sysdate, 'hh24') || '시 ' || to_char(sysdate, 'mi') || '분 ' 
            || to_char(sysdate, 'hh24:mi:ss') || '초 정상 입실하셨습니다.');
                        dbms_output.put_line('');
            dbms_output.put_line('╚═════════════════════════════════════════╝');
        
        ELSIF to_char(sysdate, 'hh24:mi:ss') > '09:00:00' THEN
            dbms_output.put_line('╔═════════════════════════════════════════╗');
            dbms_output.put_line('');
            dbms_output.put_line('            ' || vname || '님 ' || to_char(sysdate, 'hh24') || '시 ' || to_char(sysdate, 'mi') || '분 ' 
            || to_char(sysdate, 'hh24:mi:ss') || '초 지각하셨습니다.');
            dbms_output.put_line('');
            dbms_output.put_line('╚═════════════════════════════════════════╝');
        
        END IF;
        
    ELSIF vdnum = 1 AND vtnum = 1 THEN
        INSERT INTO tblAttendDetail(id, inTime, outTime, tblAttendance_id) 
        VALUES (seqAttendDetail.nextVal, to_char(sysdate, 'hh24:mi:ss'), null, vaid);
        dbms_output.put_line('╔═════════════════════════════════════════╗');
        dbms_output.put_line('');
        dbms_output.put_line('            ' || vname || '님 ' || to_char(sysdate, 'hh24') || '시 ' || to_char(sysdate, 'mi') || '분 ' 
                          || to_char(sysdate, 'hh24:mi:ss') || '초 재입실하셨습니다.');
        dbms_output.put_line('');
        dbms_output.put_line('╚═════════════════════════════════════════╝');
    
    ELSIF vdnum = 1 AND vtnum = 0 THEN
        dbms_output.put_line('╔═════════════════════════════════════════╗');
        dbms_output.put_line('');
        dbms_output.put_line('            ' || vname || '님 ' || '아직 퇴실 전입니다. 퇴실 후에 재입실 가능합니다.');
        dbms_output.put_line('');
        dbms_output.put_line('╚═════════════════════════════════════════╝');
        
    END IF;
        
    
END;
/

BEGIN
    procInTimeRecord(350, 16, '24-09-01');
END;
/
-------------------------------------- 퇴근 ------------------------------------

CREATE OR REPLACE PROCEDURE procOutTimeRecord (
    psid NUMBER,
    pcid NUMBER,
    pdate DATE
)
IS
    vaid NUMBER;
    vnum NUMBER;
    vname tblStudent.name%type;
BEGIN
    
    SELECT a.id, s.name INTO vaid, vname FROM tblAttendance a INNER JOIN tblStudent s ON a.tblStudent_id = s.id 
        WHERE tblStudent_id = psid AND tblOpenCourse_id = pcid AND TRUNC(attendanceDate) = TRUNC(pdate); 

    
    SELECT count(*) INTO vnum FROM tblAttendDetail WHERE tblAttendance_id = vaid AND inTime IS NOT NULL;
    
    IF vnum = 0 THEN 
    
        dbms_output.put_line('아직 입실 전입니다.');
    
    ELSIF vnum = 1 THEN 
    
        UPDATE tblAttendDetail SET outTime = to_char(sysdate, 'hh24:mi:ss') WHERE tblAttendance_id = vaid;
        
        IF to_char(sysdate, 'hh24:mi:ss') >= '18:00:00' THEN
            
            dbms_output.put_line('╔═════════════════════════════════════════╗');
            dbms_output.put_line('');
            dbms_output.put_line('            ' || vname || '님 ' || to_char(sysdate, 'hh24') || '시 ' || to_char(sysdate, 'mi') || '분 ' 
                                 || to_char(sysdate, 'hh24:mi:ss') || '초 퇴실하셨습니다.');
            dbms_output.put_line('');
            dbms_output.put_line('╚═════════════════════════════════════════╝');
            
            
        ELSIF to_char(sysdate, 'hh24:mi:ss') < '18:00:00' THEN
            
            dbms_output.put_line('╔═════════════════════════════════════════╗');
            dbms_output.put_line('');
            dbms_output.put_line('            ' || vname || '님 ' || to_char(sysdate, 'hh24') || '시 ' || to_char(sysdate, 'mi') || '분 ' 
                                 || to_char(sysdate, 'ss') || '초 조퇴하셨습니다.');
            dbms_output.put_line('');
            dbms_output.put_line('╚═════════════════════════════════════════╝');
            
            
        END IF;
    
    ELSIF vnum = 2 THEN
        dbms_output.put_line('╔═════════════════════════════════════════╗');
        dbms_output.put_line('');
        dbms_output.put_line('            ' || vname || '님 ' || to_char(sysdate, 'hh24') || '시 ' || to_char(sysdate, 'mi') || '분 ' 
                                 || to_char(sysdate, 'hh24:mi:ss') || '초 퇴실하셨습니다.');
        dbms_output.put_line('                        ' || '외출 처리 되셨습니다.');
        dbms_output.put_line('');
        dbms_output.put_line('╚═════════════════════════════════════════╝');
        
        
    END IF;

EXCEPTION

     when NO_DATA_FOUND then
        dbms_output.put_line('아직 입실 전입니다.');
    
END;
/

BEGIN
    procOutTimeRecord(350, 16, '24-09-01');
END;
/


- 병가 중에 해당되는 사항이 있을 경우 기록한다.
CREATE OR REPLACE PROCEDURE procSickRecord (
        psid NUMBER,
        pcid NUMBER,
        pdate DATE
)
IS
    CURSOR vcursor
    IS
    SELECT tblStudent_id FROM tblCompletion WHERE tblOpenCourse_id = pcid AND state <> '중도탈락';
    
    vsnum NUMBER;
    vcnum NUMBER;
    
    vsid NUMBER;
    vaid NUMBER;
    vdnum NUMBER;
    
    vrnum NUMBER;
    vname tblStudent.name%type;
    
BEGIN
    
    SELECT COUNT(*) INTO vsnum FROM tblAttendance WHERE tblStudent_id = psid AND TRUNC(attendanceDate) = TRUNC(pdate);
    SELECT COUNT(*) INTO vcnum FROM tblAttendance WHERE tblOpenCourse_id = pcid AND TRUNC(attendanceDate) = TRUNC(pdate);
    
    IF vcnum = 0 THEN 
    
        OPEN vcursor;
    
            LOOP
            
                FETCH vcursor INTO vsid;
                EXIT WHEN vcursor%notfound;
                
                INSERT INTO tblAttendance(id, attendancedate, tblStudent_id, tblOpenCourse_id) 
                VALUES (seqAttendance.nextVal, pdate, vsid, pcid);
                
            END LOOP;
            
            dbms_output.put_line('╔═════════════════════════════════════════╗');
            dbms_output.put_line('');
            dbms_output.put_line('            ' ||'20' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'yy') || '년 ' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'mm') 
            || '월 ' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'dd') || '일 출결 정보를 생성하였습니다.');
            dbms_output.put_line('');
            dbms_output.put_line('╚═════════════════════════════════════════╝');
            
            
        CLOSE vcursor;
        
    END IF;
    
    SELECT a.id, s.name INTO vaid, vname FROM tblAttendance a INNER JOIN tblStudent s ON a.tblStudent_id = s.id 
        WHERE tblStudent_id = psid AND tblOpenCourse_id = pcid AND TRUNC(attendanceDate) = TRUNC(pdate); 
    
    SELECT count(*) INTO vrnum FROM tblSickRecord WHERE tblAttendance_id = vaid;
    
    IF vrnum = 0 THEN
        INSERT INTO tblSickRecord VALUES(seqSickRecord.nextVal, vaid);
        
        dbms_output.put_line('╔═════════════════════════════════════════╗');
        dbms_output.put_line('');
        dbms_output.put_line('         20' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'yy') || '년 ' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'mm') 
                             || '월 ' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'dd') || '일 ' || vname || '님의 병결 처리가 완료되었습니다.');
        dbms_output.put_line('');
        dbms_output.put_line('╚═════════════════════════════════════════╝');
        
        
    ELSIF vrnum = 1 THEN    
        dbms_output.put_line('╔═════════════════════════════════════════╗');
        dbms_output.put_line('');
        dbms_output.put_line('      20' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'yy') || '년 ' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'mm') 
                     || '월 ' || to_char(to_date(pdate, 'yyyy-mm-dd'), 'dd') || '일 ' || vname || '님의 병결 처리가 이미 완료되었습니다.');
        dbms_output.put_line('');
        dbms_output.put_line('╚═════════════════════════════════════════╝');
        
        
    END IF;
    
    
END;
/

BEGIN
    procSickRecord(350, 16, '24-09-01');
END;
/


2. 매일 금일 출석을 조회할 수 있다. 
-- 금일 출석 현황에는 교육생 이름, 과정명, 날짜, 근태 상황이 포함된다.
CREATE OR REPLACE PROCEDURE procDailyAttendance (
    pid NUMBER
)
IS
    CURSOR vcursor 
    IS
    SELECT studentId, studentName, attendanceDate, attendanceState, openCourseName
    FROM vwstudentAttendDetail 
    WHERE studentId = pid AND TRUNC(attendanceDate) = TRUNC(SYSDATE)
    ORDER BY attendanceDate;
    
    vstudentId vwstudentAttendDetail.studentId%TYPE;
    vstudentName vwstudentAttendDetail.studentName%TYPE;
    vattendanceDate vwstudentAttendDetail.attendanceDate%TYPE;
    vattendanceState vwstudentAttendDetail.attendanceState%TYPE;
    vcourseName vwstudentAttendDetail.openCourseName%TYPE;
   
BEGIN

    OPEN vcursor;
            
        LOOP
            FETCH vcursor INTO vstudentId, vstudentName, vattendanceDate, vattendanceState, vcourseName;
            EXIT WHEN vcursor%NOTFOUND;
            
        END LOOP;
        
        
            dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
            dbms_output.put_line('  ' || vcourseName);
            dbms_output.put_line('〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰');
            
            
            dbms_output.put_line('                    ︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵');
            dbms_output.put_line('                  |                                        |');
            dbms_output.put_line('                  |          ' || vstudentName || ' 학생의 출결 정보        |');
            dbms_output.put_line('                  |                                        |');
            dbms_output.put_line('                   ︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶');
            
            
            dbms_output.put_line('                   =========================================');
            dbms_output.put_line('                  |        날   짜        근태 상황         |');
            dbms_output.put_line('                   =========================================');
            
            IF vattendanceState = '지각/조퇴' THEN
                
                dbms_output.put_line('                  |                                         |');
                dbms_output.put_line('                  |        '  || vattendanceDate || '        ' || vattendanceState || '           |');
                dbms_output.put_line('                  |                                         |');
                
            END IF;
            
            
            dbms_output.put_line('                  |                                         |');
            dbms_output.put_line('                  |        '  || vattendanceDate || '          ' || vattendanceState || '            |');
            dbms_output.put_line('                  |                                         |');
        
        dbms_output.put_line('                   -----------------------------------------');
                
    CLOSE vcursor;

END;
/

BEGIN
    procDailyAttendance(351);
END;
/





요구사항번호 
D-4
작성일 
2024-08-16
요구사항명 
상담일지 조회
작성자 
김남덕
– 특정교육생의 상담일지 조회
CREATE OR REPLACE PROCEDURE procCounselByStudent (
    pstudent_id IN NUMBER
) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    FOR rec IN (
        SELECT
            Id AS 상담번호,
            tblTeacher_id AS 교사번호,
            tblStudent_id AS 교육생번호,
            Content AS 상담내용,
            counselDate AS 상담일자
        FROM tblCounsel
        WHERE tblStudent_id = pstudent_id
        ORDER BY counselDate DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('상담번호: ' || rec.상담번호);
        DBMS_OUTPUT.PUT_LINE('교사번호: ' || rec.교사번호);
        DBMS_OUTPUT.PUT_LINE('교육생번호: ' || rec.교육생번호);
        DBMS_OUTPUT.PUT_LINE('상담내용: ' || rec.상담내용);
        DBMS_OUTPUT.PUT_LINE('상담일자: ' || TO_CHAR(rec.상담일자, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('------------------------------');
    END LOOP;
END;









--사후 처리 조회
-- 교육생 > 채용공고목록 조회기능
-- 특정 수료생의 취업지원활동을 조회할 경우 지원한 공고정보(지원기업명, 지원직무, 계약형태, 연봉, 합격결과)를 확인 할 수 있다.
SELECT
    c.name AS 지원기업명,
    rn.job AS 채용직무,
    ct.type AS 계약형태,
    rn.salary AS 연봉,
    al.pass AS 합격여부
FROM tblStudent s
    INNER JOIN tblCompletion cp
        ON s.id = cp.tblStudent_id
            INNER JOIN tblApplyList al
                ON cp.id = al.tblCompletion_id
                    INNER JOIN tblRecruitNotice rn
                        ON rn.id = al.tblRecruitNotice_id
                            INNER JOIN tblCompany c
                                ON c.id = rn.tblCompany_id
                                    INNER JOIN tblContractType ct
                                        ON ct.id = rn.tblCompany_id
                                            GROUP BY s.id, c.name, rn.job, ct.type, rn.salary, al.pass
                                                HAVING s.id = <교육생번호>;












--대여 신청 및 반납 
--1. 대여 가능한 물품을 조회한다. 
-- 대여 물품 내용에는 물품 이름을 조회할 수 있다.
-- 특정 물품을 선택하여 특정 물품의 상태(대여 가능, 대여중)를 확인 가능하다. 
CREATE OR REPLACE PROCEDURE procSearchItem (
    pname VARCHAR2
)
IS
    vlnum NUMBER;
    vsnum NUMBER;
BEGIN
    SELECT count(*) INTO vlnum FROM tblItemList WHERE name = pname;
    SELECT count(*) INTO vsnum 
    FROM tblItemList il 
    INNER JOIN tblItemState tis ON tis.tblItemList_id = il.id 
        WHERE name = pname AND tis.state = '대여가능';
    
    IF vlnum >= 1 THEN
        IF vsnum > 0 THEN
            dbms_output.put_line(pname || '이(가) 대여 가능합니다.');
        ELSIF vsnum <= 0 THEN
            dbms_output.put_line(pname || '의 대여 가능한 수량이 남아있지 않습니다.');
        END IF;
    ELSIF vlnum = 0 THEN
        dbms_output.put_line(pname || '이(가) 등록되어있지 않습니다.');
    END IF;
    
END;
/

BEGIN
    procSearchItem('손수건');
END;
/



--2. 물품 대여 신청
-- 필요한 물품을 신청을 통해 대여한다. 
-- 신청서 내용에는 교육생 이름, 교육생 전화번호, 물품 이름, 신청 날짜, 반납 마감 날짜를 포함한다.  
CREATE OR REPLACE PROCEDURE procRentalApplication (
    pid NUMBER,
    pname VARCHAR2
)
IS
    vstartDate DATE := sysdate;
    vendDate DATE := sysdate + 7;
    vlnum NUMBER;
    vsnum NUMBER;
    vid NUMBER;
BEGIN
    
    SELECT count(*) INTO vlnum FROM tblItemList WHERE name = pname;
    SELECT count(*) INTO vsnum 
    FROM tblItemList il 
    INNER JOIN tblItemState tis ON tis.tblItemList_id = il.id 
        WHERE name = pname AND tis.state = '대여가능';
    
    IF vlnum >= 1 THEN
        IF vsnum > 0 THEN
            
            dbms_output.put_line(pname || '이(가) 대여 가능합니다.');
            dbms_output.put_line('신청서를 접수합니다.');
            dbms_output.put_line('대여 마감일은 ' || vendDate || '입니다.');
            
            SELECT a.* INTO vid 
            FROM (SELECT tis.id FROM tblItemState tis INNER JOIN tblItemList il ON tis.tblItemList_id = il.id 
                  WHERE il.name = pname and state = '대여가능') a 
            WHERE ROWNUM = 1;
        
            INSERT INTO tblItemRental VALUES (seqItemRental.nextVal, vstartDate, null, vid, pid);   
            UPDATE tblItemState SET state = '대여중' WHERE id = vid;
            
        ELSIF vsnum <= 0 THEN
            dbms_output.put_line(pname || '의 대여 가능한 수량이 남아있지 않습니다.');
        END IF;
    ELSIF vlnum = 0 THEN
        dbms_output.put_line(pname || '이(가) 등록되어있지 않습니다.');
    END IF;
    
END;
/

BEGIN
    procRentalApplication(350, '우산');
END;
/


--3. 물품 대여 신청서 조회
-- 본인이 작성한 대여 신청서를 조회할 수 있다.
-- 대여 신청서 내용에는 교육생 이름, 교육생 전화번호, 물품 이름, 신청 날짜, 반납 마감 날짜를 포함한다.  
CREATE OR REPLACE PROCEDURE procRentalRecord (
    pid NUMBER,
    pname VARCHAR2
)
IS
    
    vsname tblStudent.name%type;
    vstel tblStudent.tel%type;
    viName tblItemList.name%type;
    vrentalDate tblItemRental.rentalDate%type;
    vreturnDate tblItemRental.returnDate%type;
    
    vnum NUMBER;
    
BEGIN
    
    SELECT count(*) INTO vnum
    FROM vwStudentRentalList
    WHERE studentId = pid AND itemName = pname;
    
    IF vnum = 0 THEN
        dbms_output.put_line('입력하신 정보의 물품 대여 신청 내용이 없습니다. ');
    ELSIF vnum > 0 THEN
        
        SELECT studentName, studentTel, itemName, rentalDate, returnDate 
        INTO vsname, vstel, viName, vrentalDate, vreturnDate
        FROM vwStudentRentalList
        WHERE studentId = pid AND itemName = pname;
        
        IF vreturnDate IS NULL THEN
            IF to_date(vrentalDate + 7, 'yyyy-mm-dd') > to_date(sysdate, 'yyyy-mm-dd') THEN 
                dbms_output.put_line('╔════════════════════════════════════════════════╗');
                dbms_output.put_line('');
                dbms_output.put_line('                 ' ||  vsname || ' 교육생의 ' || pname || ' 대여 반납 기한이');
                dbms_output.put_line('                            ' || to_char(to_date(vrentalDate + 7, 'yyyy-mm-dd') - to_date(sysdate, 'yyyy-mm-dd')) || '일 남았습니다.');
                dbms_output.put_line('');
                dbms_output.put_line('╚════════════════════════════════════════════════╝');
            ELSIF to_date(vrentalDate + 7, 'yyyy-mm-dd') = to_date(sysdate, 'yyyy-mm-dd') THEN
                dbms_output.put_line('╔══════════════════════════════════════════════════════════════════╗');
                dbms_output.put_line('');
                dbms_output.put_line('                 ' ||  vsname || ' 교육생의 ' || pname || ' 대여 반납 기한이');
                dbms_output.put_line('                            오늘입니다. 대여 물품을 반납해주세요.');
                dbms_output.put_line('');
                dbms_output.put_line('╚══════════════════════════════════════════════════════════════════╝');
            ELSIF to_date(vrentalDate + 7, 'yyyy-mm-dd') < to_date(sysdate, 'yyyy-mm-dd') THEN
                dbms_output.put_line('╔═══════════════════════════════════════╗');
                dbms_output.put_line('');
                dbms_output.put_line('               ' ||  vsname || ' 교육생의 ' || pname || ' 대여 반납 기한이');
                dbms_output.put_line('               지났습니다. 대여 물품을 반납해주세요.');
                dbms_output.put_line('');
                dbms_output.put_line('╚═══════════════════════════════════════╝');
            END IF;
            dbms_output.put_line('====================================================================');
            dbms_output.put_line('       교육생 이름    교육생 전화번호     대여일      반납 마감 기한     ');
            dbms_output.put_line('====================================================================');
            dbms_output.put_line('|         ' || vsname || '        ' || vstel || '     ' || vrentalDate || '        ' || to_date(vrentalDate  + 7, 'yyyy-mm-dd') || '    |');
            dbms_output.put_line('--------------------------------------------------------------------');
        ELSIF vreturnDate IS NOT NULL THEN
            dbms_output.put_line('╔══════════════════════════════════════════════════════════════════╗');
            dbms_output.put_line('');
            dbms_output.put_line('             ' ||  vsname || ' 교육생의 ' || pname || ' 대여 반납이 완료 되었습니다.');
            dbms_output.put_line('');
            dbms_output.put_line('╚══════════════════════════════════════════════════════════════════╝');
            dbms_output.put_line('====================================================================');
            dbms_output.put_line('       교육생 이름      교육생 전화번호         대여일          반납일     ');
            dbms_output.put_line('====================================================================');
            dbms_output.put_line('|         ' || vsname || '        ' || vstel || '        ' || vrentalDate || '       ' || vreturnDate || '   |');
            dbms_output.put_line('--------------------------------------------------------------------');
  
        END IF;
    END IF;
END;
/

BEGIN
    procRentalRecord(349, '머리끈');
END;
/


--4. 대여 물품 반납
-- 대여한 물품을 반납한다. 반납 시 교육생 이름, 교육생 전화번호,  물품 이름, 신청 날짜, 반납 날짜를 작성한다.
CREATE OR REPLACE PROCEDURE procRentalReturn (
    pid NUMBER,
    pname VARCHAR2
)
IS
    vrentalDate tblItemRental.rentalDate%type;
    vreturnDate tblItemRental.returnDate%type;
    vname tblStudent.name%type;
    vtel tblStudent.tel%type;
    
    vlnum NUMBER;
    vrnum NUMBER;
    
    vsid NUMBER;
    
BEGIN
        
    SELECT count(*) INTO vlnum
    FROM vwStudentRentalList 
    WHERE StudentId = pid AND ItemName = pname;
    
    IF vlnum >= 1 THEN
    
        SELECT count(*) INTO vrnum
        FROM vwStudentRentalList 
        WHERE StudentId = pid AND ItemName = pname AND returnDate IS NULL;
        
        IF vrnum = 1 THEN 
            SELECT studentName, studentTel, rentalDate, returnDate, itemStateId INTO vname, vtel, vrentalDate, vreturnDate, vsid
            FROM vwStudentRentalList 
            WHERE StudentId = pid AND ItemName = pname AND returnDate IS NULL;
            
            UPDATE tblItemRental 
            SET returnDate = TRUNC(sysdate) 
            WHERE tblStudent_Id = pid AND tblItemState_id = vsid AND returnDate IS NULL;
            
            UPDATE tblItemState SET state = '대여가능' WHERE id = vsid;
            dbms_output.put_line('반납 완료');
            
        ELSIF vrnum = 0 THEN
        
            dbms_output.put_line(vname || '님의 ' || pname || ' 대여는 ' 
            || to_char(to_date(vreturnDate, 'yyyy-mm-dd'), 'yy') || '년 ' 
            || to_char(to_date(vreturnDate, 'yyyy-mm-dd'), 'mm') || '월 ' 
            || to_char(to_date(vreturnDate, 'yyyy-mm-dd'), 'dd') || '일에 이미 반납 완료되었습니다.');
            
        END IF;
        
    ELSIF vlnum = 0 THEN
        dbms_output.put_line('입력하신 정보의 물품 대여 신청 내용이 없습니다.');
    END IF;
    
END;
/

BEGIN
    procRentalReturn(350, '우산');
END;
/





 
 
--커리큘럼 조회
--– 특정 과정에 따른 커리큘럼 조회
CREATE OR REPLACE PROCEDURE procCurriculumByCourse (
    pOpenCourse_id NUMBER
) AS
    CURSOR curiCursor IS
        SELECT s.name, cr.levels, cr.content
        FROM tblCuri cr
        JOIN tblSubject s ON s.id = cr.tblOpenSubject_id
        WHERE cr.tblOpenCourse_id = pOpenCourse_id;
BEGIN
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------------------------------------------');
    FOR curiRecord IN curiCursor LOOP
        DBMS_OUTPUT.PUT_LINE('과목명: ' || curiRecord.name || '|| 레벨: ' || curiRecord.levels || '|| 과목설명: ' || curiRecord.content);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------------------------------------------');
END;





--구내식당 식단표 조회
--- 구내식단 식단표 조회 (해당 주의 메뉴만 조회 가능하다.)
--- 해당 주에 배식되는 구내식단 메뉴를 조회한다. 
--- 한식, 일식, PLUS 메뉴로 구성되어있으며, 각각의 메뉴를 주 단위로 조회할 수 있다. 


CREATE OR REPLACE PROCEDURE procWeeklyMenu 
IS
    TYPE menuList IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;
    
    vKoreanMenus  menuList;
    vPremiumMenus menuList;
    vPlusMenus    menuList;
    
    vday PLS_INTEGER;
    maxLength PLS_INTEGER := 6;
    
    startDate DATE := trunc(sysdate, 'IW'); 
    
    CURSOR kcursor IS
        SELECT wm.menuDate, km.menu AS 한식
        FROM tblKoreanMenu km
        INNER JOIN tblKoreanList kl ON km.id = kl.tblKoreanMenu_id
        INNER JOIN tblWeeklyMenu wm ON wm.id = kl.tblWeeklyMenu_id
        WHERE wm.menuDate BETWEEN startDate AND startDate + 4
        ORDER BY wm.menuDate;

    CURSOR prcursor IS
        SELECT wm.menuDate, pm.menu AS 일품
        FROM tblPremiumMenu pm
        INNER JOIN tblPremiumList pl ON pm.id = pl.tblPremiumMenu_id
        INNER JOIN tblWeeklyMenu wm ON wm.id = pl.tblWeeklyMenu_id
        WHERE wm.menuDate BETWEEN startDate AND startDate + 4
        ORDER BY wm.menuDate;

    CURSOR plcursor IS
        SELECT wm.menuDate, pm.menu AS PLUS메뉴
        FROM tblPlusMenu pm
        INNER JOIN tblPlusList pl ON pm.id = pl.tblPlusMenu_id
        INNER JOIN tblWeeklyMenu wm ON wm.id = pl.tblWeeklyMenu_id
        WHERE wm.menuDate BETWEEN startDate AND startDate + 4
        ORDER BY wm.menuDate;

BEGIN

    FOR i IN 1..5 LOOP
        vKoreanMenus(i) := '';
        vPremiumMenus(i) := '';
        vPlusMenus(i) := '';
    END LOOP;


    FOR krec IN kcursor LOOP
        vday := krec.menuDate - startDate + 1;
        vKoreanMenus(vday) := vKoreanMenus(vday) || krec.한식 || chr(10); 
    END LOOP;


    FOR prec IN prcursor LOOP
        vday := prec.menuDate - startDate + 1; 
        vPremiumMenus(vday) := vPremiumMenus(vday) || prec.일품 || chr(10); 
    END LOOP;


    FOR plrec IN plcursor LOOP
        vday := plrec.menuDate - startDate + 1;
        vPlusMenus(vday) := vPlusMenus(vday) || plrec.PLUS메뉴 || chr(10); 
    END LOOP;

    dbms_output.put_line('');  
    dbms_output.put_line('    ' || startDate || ' ~ ' || to_date(sysdate - (to_char(to_date(sysdate, 'yy/mm/dd'), 'd')) + 6, 'yy/mm/dd'));
    dbms_output.put_line(' ︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵︵');
    dbms_output.put_line('|                                                                                                                   |');
    dbms_output.put_line('|                                                    주간 메뉴표                                                    |');
    dbms_output.put_line('|                                                                                                                   |');
    dbms_output.put_line(' ︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶︶');
    dbms_output.put_line('');
    dbms_output.put_line('==================================================================================================================');
    dbms_output.put_line('         월요일                화요일                수요일                목요일                금요일');
    dbms_output.put_line('==================================================================================================================');
    dbms_output.put_line('');
    
    FOR i IN 1..maxLength LOOP

        IF i = 3 THEN
            dbms_output.put('한식');
        ELSIF i IN (1, 2, 4, 5, 6) THEN
            dbms_output.put('    ');
        END IF;

        dbms_output.put_line(
            '    ' || RPAD(NVL(SUBSTR(vKoreanMenus(1), 1, INSTR(vKoreanMenus(1), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vKoreanMenus(2), 1, INSTR(vKoreanMenus(2), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vKoreanMenus(3), 1, INSTR(vKoreanMenus(3), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vKoreanMenus(4), 1, INSTR(vKoreanMenus(4), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vKoreanMenus(5), 1, INSTR(vKoreanMenus(5), chr(10))-1), ' '), 20)
        );
        
        vKoreanMenus(1) := SUBSTR(vKoreanMenus(1), INSTR(vKoreanMenus(1), chr(10))+1);
        vKoreanMenus(2) := SUBSTR(vKoreanMenus(2), INSTR(vKoreanMenus(2), chr(10))+1);
        vKoreanMenus(3) := SUBSTR(vKoreanMenus(3), INSTR(vKoreanMenus(3), chr(10))+1);
        vKoreanMenus(4) := SUBSTR(vKoreanMenus(4), INSTR(vKoreanMenus(4), chr(10))+1);
        vKoreanMenus(5) := SUBSTR(vKoreanMenus(5), INSTR(vKoreanMenus(5), chr(10))+1);
    END LOOP;
    
    dbms_output.put_line('');
    dbms_output.put_line('------------------------------------------------------------------------------------------------------------------');
    dbms_output.put_line('');
    
    FOR i IN 1..maxLength LOOP

        IF i = 3 THEN
            dbms_output.put('일품');
        ELSIF i IN (1, 2, 4, 5, 6) THEN
            dbms_output.put('    ');
        END IF;

        dbms_output.put_line(
            '    ' || RPAD(NVL(SUBSTR(vPremiumMenus(1), 1, INSTR(vPremiumMenus(1), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPremiumMenus(2), 1, INSTR(vPremiumMenus(2), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPremiumMenus(3), 1, INSTR(vPremiumMenus(3), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPremiumMenus(4), 1, INSTR(vPremiumMenus(4), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPremiumMenus(5), 1, INSTR(vPremiumMenus(5), chr(10))-1), ' '), 20)
        );

        vPremiumMenus(1) := SUBSTR(vPremiumMenus(1), INSTR(vPremiumMenus(1), chr(10))+1);
        vPremiumMenus(2) := SUBSTR(vPremiumMenus(2), INSTR(vPremiumMenus(2), chr(10))+1);
        vPremiumMenus(3) := SUBSTR(vPremiumMenus(3), INSTR(vPremiumMenus(3), chr(10))+1);
        vPremiumMenus(4) := SUBSTR(vPremiumMenus(4), INSTR(vPremiumMenus(4), chr(10))+1);
        vPremiumMenus(5) := SUBSTR(vPremiumMenus(5), INSTR(vPremiumMenus(5), chr(10))+1);

    END LOOP;
    
    dbms_output.put_line('');
    dbms_output.put_line('------------------------------------------------------------------------------------------------------------------');
    dbms_output.put_line('');
    
    FOR i IN 1..maxLength LOOP

        IF i = 2 THEN
            dbms_output.put('PLUS');
        ELSIF i IN (1, 3, 4, 5) THEN
            dbms_output.put('    ');
        END IF;

        dbms_output.put_line(
            '    ' || RPAD(NVL(SUBSTR(vPlusMenus(1), 1, INSTR(vPlusMenus(1), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPlusMenus(2), 1, INSTR(vPlusMenus(2), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPlusMenus(3), 1, INSTR(vPlusMenus(3), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPlusMenus(4), 1, INSTR(vPlusMenus(4), chr(10))-1), ' '), 20) || '  ' ||
            RPAD(NVL(SUBSTR(vPlusMenus(5), 1, INSTR(vPlusMenus(5), chr(10))-1), ' '), 20)
        );

        vPlusMenus(1) := SUBSTR(vPlusMenus(1), INSTR(vPlusMenus(1), chr(10))+1);
        vPlusMenus(2) := SUBSTR(vPlusMenus(2), INSTR(vPlusMenus(2), chr(10))+1);
        vPlusMenus(3) := SUBSTR(vPlusMenus(3), INSTR(vPlusMenus(3), chr(10))+1);
        vPlusMenus(4) := SUBSTR(vPlusMenus(4), INSTR(vPlusMenus(4), chr(10))+1);
        vPlusMenus(5) := SUBSTR(vPlusMenus(5), INSTR(vPlusMenus(5), chr(10))+1);

    END LOOP;
    
    dbms_output.put_line('------------------------------------------------------------------------------------------------------------------');
    

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('오류: 데이터가 없습니다.');
    WHEN OTHERS THEN
        dbms_output.put_line('오류: ' || SQLERRM);
END;
/

-- 프로시저 실행
BEGIN
    procWeeklyMenu;
END;
/












--교사 번호와 개설 과정의 번호 연결
CREATE OR REPLACE VIEW vwTeacherOpenCourseList
AS
SELECT tblTeacher_id, tblOpenCourse_id FROM tblOpenSubject 
GROUP BY tblTeacher_id, tblOpenCourse_id 
ORDER BY tblOpenCourse_id;


--교사와 연결된 개설 과정 조회
CREATE OR REPLACE VIEW vwTeacherCourse
AS
SELECT DISTINCT t.id AS teacherId, t.name AS teacherName, oc.id openCourseId, oc.name openCourseName, oc.startDate AS startDate, oc.endDate AS endDate 
    FROM tblOpenSubject os
    INNER JOIN tblTeacher t ON os.tblTeacher_id = t.id
    INNER JOIN tblOpenCourse oc ON os.tblOpenCourse_id = oc.id
        ORDER BY openCourseId;





--전체 날짜의 학생 근태 상황 확인
CREATE OR REPLACE VIEW vwStudentAttend
AS
SELECT a.id AS id, s.id AS studentId, s.name AS studentName, a.attendancedate AS attendanceDate, 
    CASE 
        WHEN ad.inTime <= '09:00:00' AND ad.outTime >= '18:00:00' THEN '정상'
        WHEN ad.inTime > '09:00:00' AND ad.outTime >= '18:00:00' THEN '지각'
        WHEN ad.outTime < '18:00:00' AND ad.inTime <= '09:00:00' THEN '조퇴'
        WHEN ad.inTime > '09:00:00' AND  
             ad.outTime < '18:00:00' AND
             (to_number(to_date(ad.outTime, 'hh24:mi:ss') - to_date(ad.inTime, 'hh24:mi:ss')) * 24) >= 4 THEN '지각/조퇴'
        WHEN sr.tblAttendance_id = a.id THEN '병가'
        WHEN (to_number(to_date(ad.outTime, 'hh24:mi:ss') - to_date(ad.inTime, 'hh24:mi:ss')) * 24) < 4 THEN '결석'
        WHEN  ad.id IS NULL AND sr.id IS NULL THEN '결석'
        ELSE '외출'
    END AS attendanceState
    FROM tblAttendance a
    FULL OUTER JOIN tblAttendDetail ad ON a.id = ad.tblAttendance_id
    INNER JOIN tblOpenCourse oc ON oc.id = a.tblOpenCourse_id
    FULL OUTER JOIN tblSickRecord sr ON sr.tblAttendance_id = a.id
    INNER JOIN tblStudent s ON s.id = a.tblStudent_id;




--전체 학생 및 날짜의 근태 상황과 과정 연결 뷰
create or replace view vwstudentAttendDetail
AS
select s.studentId, s.studentName, s.attendanceDate, s.attendanceState, c.name AS openCourseName, c.id AS openCourseId
    FROM vwstudentattend s 
    inner join tblAttendance a on a.id = s.id
    inner join tblOpenCourse c on c.id = a.tblOpenCourse_id;
                            WHEN ad.outTime > '18:00:00' THEN to_date('18:00:00', 'hh24:mi:ss') 
                            ELSE to_date(ad.outTime, 'hh24:mi:ss') 
                        END - to_date(ad.inTime, 'hh24:mi:ss')) * 24) < 4
                 THEN 1
                WHEN  ad.id IS NULL AND sr.id IS NULL THEN 1
           END)  
    AS absence
    FROM tblAttendance a
    FULL OUTER JOIN tblAttendDetail ad ON a.id = ad.tblAttendance_id
    INNER JOIN tblOpenCourse oc ON oc.id = a.tblOpenCourse_id
    FULL OUTER JOIN tblSickRecord sr ON sr.tblAttendance_id = a.id
        GROUP BY oc.name, a.attendancedate, oc.id
            ORDER BY attendanceDate;






--전체 날짜의 과정별 근태 상황 확인
CREATE OR REPLACE VIEW vwAttendState 
AS
SELECT oc.id AS openCourseId, oc.name AS openCourseName, a.attendancedate AS attendanceDate, count(*) AS studentCount,
    count(CASE 
        WHEN ad.inTime <= '09:00:00' AND ad.outTime >= '18:00:00' THEN 1
    END) AS normalAttendance,
    count(CASE
        WHEN ad.inTime > '09:00:00' AND ad.outTime >= '18:00:00' THEN 1
    END) AS late,
    count(CASE
        WHEN ad.inTime > '09:00:00' AND  
             ad.outTime < '18:00:00' AND
             (to_number(to_date(ad.outTime, 'hh24:mi:ss') - to_date(ad.inTime, 'hh24:mi:ss')) * 24) >= 4 THEN 1
    END) AS late_earlyLeave,
    count(CASE
        WHEN ad.outTime < '18:00:00' AND ad.inTime <= '09:00:00' THEN 1
    END) AS earlyLeave,
    (count(*) 
        - count(CASE WHEN ad.inTime <= '09:00:00' AND ad.outTime >= '18:00:00' THEN 1 END) 
        - count(CASE WHEN ad.inTime > '09:00:00' AND ad.outTime >= '18:00:00' THEN 1 END) 
        - count(CASE WHEN ad.outTime < '18:00:00' AND ad.inTime <= '09:00:00' THEN 1 END) 
        - count(CASE
                   WHEN ((CASE 
                                WHEN ad.outTime > '18:00:00' THEN to_date('18:00:00', 'hh24:mi:ss') 
                                ELSE to_date(ad.outTime, 'hh24:mi:ss') 
                            END - to_date(ad.inTime, 'hh24:mi:ss')) * 24) < 4
                     THEN 1
                    WHEN  ad.id IS NULL AND sr.id IS NULL THEN 1
               END)  
        - count(CASE WHEN sr.tblAttendance_id = a.id THEN 1 END)) 
        - count(CASE
        WHEN ad.inTime > '09:00:00' AND  
             ad.outTime < '18:00:00' AND
             (to_number(to_date(ad.outTime, 'hh24:mi:ss') - to_date(ad.inTime, 'hh24:mi:ss')) * 24) >= 4 THEN 1
    END) 
    AS outing,
    count(CASE
        WHEN sr.tblAttendance_id = a.id THEN 1
    END) AS sickDay,
    count(CASE
               WHEN ((CASE 
                            WHEN ad.outTime > '18:00:00' THEN to_date('18:00:00', 'hh24:mi:ss') 
                            ELSE to_date(ad.outTime, 'hh24:mi:ss') 
                        END - to_date(ad.inTime, 'hh24:mi:ss')) * 24) < 4
                 THEN 1
                WHEN  ad.id IS NULL AND sr.id IS NULL THEN 1
           END)  
    AS absence
    FROM tblAttendance a
    FULL OUTER JOIN tblAttendDetail ad ON a.id = ad.tblAttendance_id
    INNER JOIN tblOpenCourse oc ON oc.id = a.tblOpenCourse_id
    FULL OUTER JOIN tblSickRecord sr ON sr.tblAttendance_id = a.id
        GROUP BY oc.name, a.attendancedate, oc.id
            ORDER BY attendanceDate;





--  전체 대여 기록과 학생 및 대여 물품 연결 
CREATE OR REPLACE VIEW vwStudentRentalList 
AS
select s.id AS StudentId, s.name AS studentName, s.tel AS studentTel, il.id AS itemId, il.name AS itemName, ir.rentalDate AS rentalDate, ir.returnDate AS returnDate, tis.id AS itemStateId  
from tblItemRental ir 
inner join tblStudent s on s.id = ir.tblStudent_id 
inner join tblItemState tis ON tis.id = ir.tblItemState_id 
inner join tblItemList il on il.id = tis.tblItemList_id;





--  교사계정 관리
CREATE OR REPLACE VIEW vwTeacherSubject
AS
SELECT 
    t.id AS teacherId,
    t.name AS teacherName,
    t.ssn AS teacherSSN,
    t.tel AS teacherTel,
    s.id AS subjectId,
    s.name AS subjectName
FROM tblTeacher t
    LEFT OUTER JOIN tblSubjectList sl ON t.id = sl.tblTeacher_id
    INNER JOIN tblSubject s ON s.id = sl.tblSubject_id;




--강의실목록 생성
CREATE OR REPLACE VIEW vwClassroomList
AS
SELECT 
    c.id AS classroomId,
    c.name AS classroomName,
    c.name AS classroomCapacity,
    oc.id AS openCourseId,
    oc.name AS openCourseName,
    oc.startDate AS startDate,
    oc.endDate AS endDate,
    oc.tblCourse_id AS courseId
FROM tblClassroom c
    INNER JOIN tblOpenCourse oc ON c.id= oc.tblClassroom_id
        ORDER BY c.id;




--교육생+수료정보+개설과정+개설과목+교사 연결
CREATE OR REPLACE VIEW vwStudentCourseInfo
AS
SELECT
    s.id AS studentId,
    s.name AS studentName,
    s.ssn AS studentSsn,
    s.tel AS studentTel,
    s.regDate AS studentRegDate,
    oc.id AS openCourseId,
    oc.name AS openCourseName,
    oc.startdate AS openCourseStartDate,
    oc.enddate AS openCourseEndDate,
    oc.tblClassroom_id AS classroomId,
    os.id AS openSubjectId,
    os.name AS openSubjectName,
    os.startDate AS openSubjectStartDate,
    os.endDate AS openSubjectEndDate,
    os.tblBook_Id AS bookId,
    os.tblSubject_Id AS subjectId,
    t.id  AS teacherId,
    t.name AS teacherName,
    cp.id completionId,
    cp.state AS completionState, 
    cp.completiondate AS completionCompletiondate
FROM tblStudent s
    INNER JOIN tblCompletion cp
        ON s.id = cp.tblStudent_id
            INNER JOIN tblOpenCourse oc
                ON oc.id = cp.tblOpenCourse_id
                    INNER JOIN tblOpenSubject os
                        ON oc.id = os.tblOpenCourse_id
                            INNER JOIN tblTeacher t
                                ON t.id = tblTeacher_id;






-- 관리자를 위한 교육생 뷰(상담횟수)
CREATE OR REPLACE VIEW vwResumeAdminInfo
AS
SELECT  
    a.name AS adminName,
    s.id AS studentId, 
    s.name AS studentName, 
    s.tel AS studentTel,  
    c.state AS completionState,
    COALESCE(COUNT(cs.tblStudent_id), 0) AS counselCount
FROM tblStudent s
    JOIN tblResume r   
        ON s.id = r.id
            JOIN tblAdmin a 
                ON r.tblAdmin_id = a.id  
                    JOIN tblCompletion c
                        ON s.id = c.tblStudent_id
                            LEFT JOIN tblCounsel cs    
                                ON s.id = cs.tblStudent_id
                                    GROUP BY a.name, s.id, s.name, s.tel, c.state
                                        ORDER BY s.id, a.name, c.state;




--  교육생+수료정보+취업목록 연결
CREATE OR REPLACE VIEW vwStudentEmployInfo
AS
SELECT
    s.id AS studentId,
    s.name AS studentName,
    s.ssn AS studentSsn,
    s.tel AS studentTel,
    s.regDate AS studentRegDate,
    cp.id completionId,
    cp.state AS completionState, 
    cp.completiondate AS completionCompletiondate,
    cp.tblopencourse_id AS completionTblopencourse_id,
    el.state AS employListState,
    el.hireDate AS employListHireDate,
    el.tblApplyList_id AS employListTblApplyList_id
FROM tblStudent s
    LEFT OUTER JOIN tblCompletion cp
        ON s.id = cp.tblStudent_id
            LEFT OUTER JOIN tblEmployList el
                ON cp.id = el.tblCompletion_id;





--취업지원목록+채용공고+회사+근로계약
CREATE OR REPLACE VIEW vwApplyRecruitNoticeInfo
AS
SELECT
    al.id AS applyListId,
    al.pass AS applyListPass,
    al.tblCompletion_id AS applyListTblCompletion_id,
    c.id AS companyId,
    c.name AS companyName,
    c.tel AS companyTel,
    c.manager AS companyManager,
    c.cooperation AS companyCooperation,
    rn.id AS recruitNoticeId,
    rn.job AS recruitNoticeJob,
    rn.startDate AS recruitNoticeStartDate,
    rn.endDate AS recruitNoticeEndDate,
    rn.salary AS recruitNoticeSalary,
    rn.state AS recruitNoticeState,
    ct.type AS contractTypeType
FROM tblApplyList al
    INNER JOIN tblRecruitNotice rn
        ON rn.id = al.tblRecruitNotice_id
            INNER JOIN tblCompany c
                ON c.id = rn.tblCompany_id
                    INNER JOIN tblContractType ct
                        ON ct.id = rn.tblContractType_id;





--  교사평가 조회
CREATE OR REPLACE VIEW vwEvaluation 
AS
SELECT 
    t.id AS teacherId,
    t.name AS teacherName,

    oc.id AS courseId,
    oc.name AS courseName,
    e.evaluationDate AS evaluationDate,
    e.difficulty AS difficulty,
    e.communicationSkills AS communicationSkills,
    e.lecturePace AS lecturePace,
    e.satisfaction AS satisfaction,
    e.recommendation AS recommendation
FROM tblEvaluation e
    INNER JOIN tblTeacher t
        ON t.id = e.tblTeacher_id
            INNER JOIN tblStudent s
                ON s.id = e.tblStudent_id
                    INNER JOIN tblCompletion c
                        ON s.id = c.tblStudent_id
                            INNER JOIN tblOpenCourse oc
                                ON oc.id = c.tblOpenCourse_id
                                    ORDER BY oc.id;



--  출결점수 반환
CREATE OR REPLACE FUNCTION fnReturnAttendScore (
    state VARCHAR2
) RETURN  NUMBER
IS
BEGIN
    RETURN CASE(state)
        WHEN '정상' THEN 3
        WHEN '지각' THEN 1
        WHEN '조퇴' THEN 1
        WHEN '결석' THEN 0
        WHEN '지각/조퇴' THEN 2
        WHEN '병가' THEN 3
    END;
END;
/



--  교사평가 반환
CREATE OR REPLACE FUNCTION fnEvaluation (
    pnum NUMBER
) RETURN VARCHAR2
IS
BEGIN
    RETURN CASE(round(pnum))
        WHEN 1 THEN '매우불만족'
        WHEN 2 THEN '불만족'
        WHEN 3 THEN '보통'
        WHEN 4 THEN '만족'
        WHEN 5 THEN '매우만족'
    END;
END;
/

CREATE OR REPLACE PROCEDURE procMenuReg (
    pdate DATE, pdiv NUMBER, pmenu VARCHAR2
)
IS
    vwnum NUMBER;
BEGIN
    SELECT COUNT(*) INTO vwnum FROM tblWeeklyMenu WHERE menuDate = pdate;
    IF vwnum = 0 THEN
        INSERT INTO tblWeeklyMenu VALUES (seqWeeklyMenu.NEXTVAL, pdate);
    END IF;
    INSERT INTO tblKoreanMenu VALUES (seqKoreanMenu.NEXTVAL, pmenu);
END;
/

