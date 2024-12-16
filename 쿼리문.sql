
--  과정명 관리

-- 생성
INSERT INTO tblCourse VALUES(seqCourse.nextVal, <과정명>);

-- 조회
SELECT name AS 과정명 FROM tblCourse;

-- 수정
UPDATE tblCourse SET name = <수정할 과정명> WHERE id = <수정할 과정번호>;

-- 삭제
DELETE FROM tblCourse WHERE id = <삭제할 과정번호>;


-- 과목명 관리

-- 생성
INSERT INTO tblSubject VALUES(seqSubject.nextVal, <과목명>);

-- 조회
SELECT name AS과목명 FROM tblSubject;

-- 수정
UPDATE tblSubject SET name = <수정할 과목명> WHERE id = <수정할 과목번호>;

-- 삭제
DELETE FROM tblSubject WHERE id = <삭제할 과목번호>;


-- 강의실명 관리

-- 생성
INSERT INTO tblClassroom VALUES(seqClassroom.nextVal, <강의실명>, <정원>);

-- 조회
SELECT name AS과목명 FROM tblClassroom;

-- 수정
UPDATE tblClassroom SET name = <수정할 강의실명> WHERE id = <수정할 강의실번호>;
UPDATE tblClassroom SET capacity = <수정할 강의실정원> WHERE id = <수정할 강의실번호>;

-- 삭제
DELETE FROM tblClassroom WHERE id = <삭제할 강의실번호>;


-- 교재명 관리

-- 생성
INSERT INTO tblBook VALUES(seqBook.nextVal, <교재명>, <저자>, <출판사>, <발행일>);

-- 조회
SELECT name AS 교재명, author AS 저자, publish AS 출판사, issueDate AS 출판일 FROM tblBook;

-- 수정
UPDATE tblBook SET name = <수정할 교재명> WHERE id = <수정할 교재번호>;

-- 삭제
DELETE FROM tblBook WHERE id = <삭제할 교재번호>;



요구사항번호 
B-2
작성일 
2024-08-16
요구사항명 
교사 계정 관리
작성자 
박소혜
-- 교사계정 관리

-- 생성
INSERT INTO tblTeacher VALUES(seqTeacher.nextVal, <교사명>, <주민등록번호 뒷자리>, <전화번호>);

-- 수정
UPDATE tblTeacher SET name = <개명한 교사명> WHERE id = <수정할 교사번호>;
UPDATE tblTeacher SET tel = <변경한 전화번호> WHERE id = <수정할 교사번호>;

-- 삭제
DELETE FROM tblTeacher WHERE id = <삭제할 교사번호>;

– 강의가능과목 추가
INSERT INTO tblSubjectList VALUES(seqSubjectList.nextVal, <과목번호>, <교사번호>);



요구사항번호 
B-3
작성일 
2024-08-16
요구사항명 
개설 과정 관리
작성자 
박소혜
-- 개설과정 관리

-- 조회
SELECT
    oc.name AS 개설과정명, 
    oc.startDate || ' ~ ' || oc.endDate AS 개설과정기간, 
    c.name AS 강의실명,
    CASE
        WHEN os.id IS NOT NULL THEN '등록'
        ELSE '미등록'
    END AS 개설과목등록여부,
    CASE
        WHEN (SELECT COUNT(*) 
            FROM tblOpenSubject 
            WHERE tblOpenCourse_id = oc.id
        ) > 0 THEN COUNT(cp.id) / (SELECT COUNT(*) 
            FROM tblOpenSubject 
            WHERE tblOpenCourse_id = oc.id
        ) 
        ELSE 0
    END AS 수강생등록인원
FROM tblOpenCourse oc
    INNER JOIN tblClassroom c ON c.id = oc.tblClassroom_id
    LEFT OUTER JOIN tblOpenSubject os ON oc.id = os.tblOpenCourse_id
    LEFT OUTER JOIN tblCompletion cp ON oc.id = cp.tblOpenCourse_id
    GROUP BY oc.id, oc.name, oc.startDate, oc.endDate, c.name, 
        CASE WHEN os.id IS NOT NULL THEN '등록' ELSE '미등록' END
    ORDER BY 개설과정기간;

-- 수정
UPDATE tblOpenCourse SET name = <수정할 개설과정명> WHERE id = <개설과정번호>;



요구사항번호 
B-4
작성일 
2024-08-16
요구사항명 
개설 과목 관리
작성자 
박소혜
-- 개설과목 관리

-- 생성
INSERT INTO tblOpenSubject VALUES (seqOpenSubject.nextVal, <개설과목명>, <시작날짜>, <종료날짜>, <과목번호>, <교재번호>, <교사번호>, <개설과정번호>);

-- 수정
UPDATE tbOpenlSubject SET name = <수정할 개설과목명> WHERE id = <수정할 개설과목번호>;

-- 삭제
DELETE FROM tbOpenlSubject WHERE id = <삭제할 개설과목번호>;



-- 교육생 관리
-- 생성
INSERT INTO tblStudent VALUES (seqStudent.nextVal, <교육생 이름>, <주민등록번호 뒷자리>, <전화번호>, SYSDATE);

-- 조회
SELECT s.name as 교육생이름, s.ssnas주민등록번호뒷자리, s.tel as 전화번호, s.regDateas 등록일, count(c.id) as 수강횟수
FROM tblStudent s
    INNER JOIN tblCompletion c
        ON s.id = c.tblStudent_id
            GROUP BY s.name, s.ssn, s.tel, s.regDate;

-- 수정
UPDATE tblStudent SET name = <수정할 교육생이름> WHERE id = <교육생 번호>;
UPDATE tblStudent SET ssn = <수정할 주민등록번호 뒷자리> WHERE id = <교육생 번호>;
UPDATE tblStudent SET tel = <수정할 전화번호> WHERE id = <교육생 번호>;
UPDATE tblStudent SET regDate = <수정할 등록일> WHERE id = <교육생 번호>;

-- 삭제
DELETE FROM tblStudent WHERE id = <교육생 번호>;


-- 수료정보 관리
-- 생성
INSERT INTO tblCompletion VALUES (seqCompletion.nextVal, <수료상태 = '수강중'>, <수료날짜 = null>, <교육생번호>, <과정번호>);

-- 조회
SELECT DISTINCT
studentName AS 교육생이름,
openCourseName AS 과정명,
openCourseStartDate || ' ~ ' || openCourseEndDate AS 과정기간,
completionState AS 수료상태, 
completionCompletiondate AS 수료날짜
FROM vwStudentCourseInfo;

-- 수정
UPDATE tblCompletion SET state = <수정할 수료상태> WHERE id = <수료정보 번호>;
UPDATE tblCompletion SET completionDate = <수정할 수료날짜> WHERE id = <수료정보 번호>;
UPDATE tblCompletion SET tblStudent_id = <수정할 교육생 번호> WHERE id = <수료정보 번호>;
UPDATE tblCompletion SET tblOpenCourse_id = <수정할 과정번호> WHERE id = <수료정보 번호>;

-- 삭제
DELETE FROM tblCompletion WHERE id = <수료정보 번호>;


-- 특정교육생 선택하여 조회할 경우 교육생이 신청한 개설과정정보(과정명, 과정기간)과 수료정보(수료 및 중도 탈락여부, 수료 및 중도탈락날짜)를 확인 할 수 있다.
SELECT DISTINCT
studentName AS 교육생이름,
openCourseName AS 과정명,
openCourseStartDate || ' ~ ' || openCourseEndDate AS 과정기간,
completionState AS 수료상태, 
completionCompletiondate AS 수료날짜
FROM vwStudentCourseInfo
    WHERE studentId = <교육생 번호>;


-- 수강 상태는 (수강중, 수료, 중도탈락)으로 관리
-- 중도탈락처리 및 날짜 입력 및 수정
UPDATE tblCompletion SET state = '중도탈락', completiondate = sysdate WHERE tblStudent_id = <교육생번호>; 



-- 시험 관리
SELECT
    DISTINCT
    os.name AS 개설과목명,
    os.startDate || ' ~ ' || os.endDate AS 과목기간,
    b.name AS 교재명,
    t.name AS 교사명,
    CASE
        WHEN count(*) > 0 THEN '등록'
        ELSE '미등록'
    END AS 성적등록여부,
    CASE
        WHEN a.filename IS NOT NULL THEN '등록'
        ELSE '미등록'
    END AS 시험문제파일등록여부
FROM tblOpenCourse oc
    INNER JOIN tblOpenSubject os
        ON oc.id = os.tblOpenCourse_id
            INNER JOIN tblBook b
                ON b.id = os.tblBook_id
                    INNER JOIN tblTeacher t
                        ON t.id = os.tblTeacher_id
                            INNER JOIN tblAllotment a
                                ON os.id = a.tblOpenSubject_id
                                    INNER JOIN tblCompletion c
                                        ON oc.id = c.tblOpenCourse_id
                                            INNER JOIN tblGrade g
                                                ON os.id = g.tblOpenSubject_id
                                                    WHERE oc.id = <개설과정번호>
                                                        GROUP BY os.name, os.startDate, os.endDate, b.name, t.name, a.filename 
                                                            ORDER BY 과목기간;



-- 1. 특정 개설 과정을 선택하는 경우 모든 교육생의 출결을 조회 할 수 있다.
SELECT s.name , a.attendancedate, ad.inTime, ad.outTime 
    FROM tblAttendance a
    INNER JOIN tblAttendDetail ad ON ad.tblAttendance_id  = a.id
    INNER JOIN tblStudent s ON s.id = a.tblStudent_id
        WHERE tblOpenCourse_id = 1;
                

-- 2. 출결 현황은 기간별(년,월,일)로 조회 할 수 있다.
SELECT oc.name, s.name, a.attendancedate, ad.inTime, ad.outTime 
    FROM tblAttendance a
    INNER JOIN tblAttendDetail ad ON ad.tblAttendance_id  = a.id
    INNER JOIN tblStudent s ON s.id = a.tblStudent_id
    INNER JOIN tblOpenCourse oc ON oc.id = a.tblOpenCourse_id
        WHERE a.attendancedate = '2023-03-03'; --조회를 원하는 날짜 
                

-- 3. 특정 과정별 출결 현황 조회시 (과정명, 출결날짜, 근태상황, 인원)을 출력 할 수 있다.
SELECT oc.name AS 과정명, a.attendancedate AS 출결날짜, count(*) AS 인원,
    count(CASE 
        WHEN ad.inTime <= '09:00:00' AND ad.outTime >= '18:00:00' THEN 1
    END) AS 정상출석,
    count(CASE
        WHEN ad.inTime > '09:00:00' AND ad.outTime >= '18:00:00' THEN 1
    END) AS 지각,
    count(CASE
        WHEN ad.inTime > '09:00:00' AND  
             ad.outTime < '18:00:00' AND
             (to_number(to_date(ad.outTime, 'hh24:mi:ss') - to_date(ad.inTime, 'hh24:mi:ss')) * 24) >= 4 THEN 1
    END) AS "지각/조퇴",
    count(CASE
        WHEN ad.outTime < '18:00:00' AND ad.inTime <= '09:00:00' THEN 1
    END) AS 조퇴,
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
        - count(CASE
                    WHEN ad.inTime > '09:00:00' AND  
                         ad.outTime < '18:00:00' AND
                         (to_number(to_date(ad.outTime, 'hh24:mi:ss') - to_date(ad.inTime, 'hh24:mi:ss')) * 24) >= 4 THEN 1
                END)) 
    AS 외출,
    count(CASE
        WHEN sr.tblAttendance_id = a.id THEN 1
    END) AS 병가,
    count(CASE
               WHEN ((CASE 
                            WHEN ad.outTime > '18:00:00' THEN to_date('18:00:00', 'hh24:mi:ss') 
                            ELSE to_date(ad.outTime, 'hh24:mi:ss') 
                        END - to_date(ad.inTime, 'hh24:mi:ss')) * 24) < 4
                 THEN 1
                WHEN  ad.id IS NULL AND sr.id IS NULL THEN 1
           END) 
    AS 결석
    FROM tblAttendance a
    FULL OUTER JOIN tblAttendDetail ad ON a.id = ad.tblAttendance_id
    INNER JOIN tblOpenCourse oc ON oc.id = a.tblOpenCourse_id
    FULL OUTER JOIN tblSickRecord sr ON sr.tblAttendance_id = a.id
    WHERE oc.id = 1
        GROUP BY oc.name, a.attendancedate, oc.id
            ORDER BY 출결날짜;

            
            
            
-- 4. 특정 수강생별 개인 출결 현황 조회시 (수강생 이름, 출결날짜, 근태상황)을 출력 할 수 있다.
SELECT s.name AS 수강생명, a.attendancedate AS 출결날짜, 
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
    END AS 근태상황
    FROM tblAttendance a
    FULL OUTER JOIN tblAttendDetail ad ON a.id = ad.tblAttendance_id
    INNER JOIN tblOpenCourse oc ON oc.id = a.tblOpenCourse_id
    FULL OUTER JOIN tblSickRecord sr on sr.tblAttendance_id = a.id
    INNER JOIN tblStudent s ON s.id = a.tblStudent_id
    WHERE s.id = 1;




/*교육생 면접 및 선발 기능*/

--1.생성
INSERT INTO tblResume VALUES (seqResume.nextVal, <지원서이름>, <전화번호>, <지원일자>, <면접일정>, <선발결과>, <과정명번호>, <관리자번호>);

--2. 조회
SELECT
    id AS 지원서번호,
    name AS 지원서이름,
    tel AS 전화번호,
    dueDate AS 지원일자,
    seeDate AS 면접일정,
    pick AS 선발결과,
    tblOpenCourse_id AS 과정명번호,
    tblAdmin_id AS 관리자번호
FROM tblResume;

--3-1. 이름 수정
UPDATE tblResume SET name = <수정할 지원서이름> WHERE id = <수정할 지원서번호>;

--3-2. 전화번호 수정
UPDATE tblResume SET tel = <수정할 전화번호> WHERE id = <수정할 지원서번호>;

--3-3. 지원일자 수정
UPDATE tblResume SET dueDate = <수정할 지원일자> WHERE id = <수정할 지원서번호>;

--3-4. 면접 일정 수정
UPDATE tblResume SET seeDate = <수정할 면접일정> WHERE id = <수정할 지원서번호>;

--3-5. 선발 결과 수정
UPDATE tblResume SET pick = <수정할 선발결과> WHERE id = <수정할 지원서번호>;

--3-6. 과정명 번호 수정
UPDATE tblResume SET tblOpenCourse_id = <수정할 과정명번호> WHERE id = <수정할 지원서번호>;

--3-7. 관리자 번호 수정
UPDATE tblResume SET tblAdmin_id = <수정할 관리자번호> WHERE id = <수정할 지원서번호>;

--4. 삭제
DELETE FROM tblResume WHERE id  = <삭제할 지원서번호>;




/* 상담일지 관리 */

--1.생성
INSERT INTO tblCounsel VALUES (seqCounsel.nextVal, <상담일지내용>, <상담일>, <교육생번호>, <교사번호>);

--2-1. 조회
SELECT
    id AS 상담일지번호,
    content AS 상담일지내용,
    counselDate AS 상담일,
    tblStudent_id AS 교육생번호,
    tblTeacher_id AS 교사번호
FROM tblCounsel;

--2-2. 상담일 최신순 조회
SELECT
    content AS 상담내용,
    counselDate AS 상담일,
    tblStudent_id AS 교육생번호,
    tblTeacher_id AS 교사번호
FROM tblCounsel
ORDER BY counselDate DESC;

--3-1. 상담 내용 수정
UPDATE tblCounsel SET content = <수정할 상담내용> WHERE id = <수정할 상담일지번호>;

--3-2. 상담일 수정
UPDATE tblCounsel SET counselDate = <수정할 상담일> WHERE id = <수정할 상담일지번호>;

--3-3. 교육생 번호 수정
UPDATE tblCounsel SET tblStudent_id = <수정할 교육생번호> WHERE id = <수정할 상담일지번호>;

--3-4. 교사 번호 수정
UPDATE tblCounsel SET tblTeacher_id = <수정할 교사번호> WHERE id = <수정할 상담일지번호>;

--4. 삭제
DELETE FROM tblCounsel WHERE id = <삭제할 상담일지번호>;




-- 과목별교재 관리

-- 생성
INSERT INTO tblSubjectTextbook VALUES(seqSubjectTextbook.nextVal, <과목번호>, <교재번호>);

-- 조회
SELECT id AS 과목명, tblSubject_id AS 과목번호, tblBook_id AS 교재번호 FROM tblSubjectTextbook;

-- 수정
UPDATE tblSubjectTextbook SET tblSubject_id = <수정할 과목번호> WHERE id = <수정할 과목별교재번호>;
UPDATE tblSubjectTextbook SET tblBook_id = <수정할 교재번호> WHERE id = <수정할 과목별교재번호>;

-- 삭제
DELETE FROM tblSubjectTextbook WHERE id = <삭제할 과목별교재번호>;




-- 수료생 취업지원목록 데이터
-- 생성
INSERT INTO tblApplyList VALUES(seqApplyList.nextVal, <합격결과>, <채용공고번호>, <수료정보번호>);

-- 조회
-- 수료생정보(교육생이름, 수료날짜,재취업지원 종료날짜)와 취업현황정보(취업지원수, 취업합격수, 취업상태(취업/미취업)
SELECT
    studentId AS 교육생번호,
    studentName AS 교육생이름,
    completionState AS 수료상태,
    completionCompletiondate || ' - ' || add_months(completionCompletiondate, 3) AS 사후처리가능기간,
    count(applyListTblCompletion_id) AS 지원공고수,
    sum(CASE WHEN applyListPass LIKE '합격' THEN 1 ELSE 0 END) AS 합격공고수,
    CASE WHEN employListState LIKE '취업' THEN '취업' ELSE '미취업' END AS 취업상태
FROM vwStudentEmployInfo vwse
    LEFT OUTER JOIN vwApplyRecruitNoticeInfo vwarn
        ON vwse.completionId = vwarn.applyListTblCompletion_id
            GROUP BY studentId, studentName, completionState, completionCompletiondate, employListState;

-- 수정
UPDATE tblApplyList SET pass= <수정할 합격결과> WHERE id = <취업지원목록 번호>;
UPDATE tblApplyList SET tblRecruitNotice_id = <수정할 채용공고번호> WHERE id = <취업지원목록 번호>;
UPDATE tblApplyList SET tblCompletion_id = <수정할 수료정보번호> WHERE id = <취업지원목록 번호>;

-- 삭제
DELETE FROM tblApplyList WHERE id = <취업지원목록 번호>;



-- 수료생 취업현황 데이터
-- 생성
INSERT INTO tblEmployList VALUES(seqEmployList.nextVal, <취업상태>, <취업날짜>, <수료정보번호>, <취업지원목록번호>);

-- 조회
수료생정보(교육생이름,수료날짜)와 취업현황정보(취업상태(취업/미취업),취업날짜, 기업명, 직무, 연봉,계약형태)를 같이 출력한다
SELECT 
    vwse.studentName AS 교육생이름,
    vwse.completionCompletiondate AS 수료날짜,
    vwse.employListState AS 취업상태,
    vwse.employListHireDate AS 취업날짜,
    vwarn.companyName AS 기업명,
    vwarn.recruitNoticeJob AS 직무,
    vwarn.recruitNoticeSalary AS 연봉,
    vwarn.contractTypeType AS 계약형태,
    vwarn.applyListPass
FROM vwStudentEmployInfo vwse
    INNER JOIN vwApplyRecruitNoticeInfo vwarn
        ON vwse.employListTblApplyList_id = vwarn.applyListId;

-- 수정
취업현황정보(취업상태(재직중/퇴사),취업날짜를 수정할수있다.
UPDATE tblEmployListSET state = <수정할 취업상태> WHERE id = <취업목록번호>;
UPDATE tblEmployList SET hireDate = <수정할 취업날짜> WHERE id = <취업목록번호>;
UPDATE tblEmployList SET tblCompletion_id = <수정할 수료정보번호> WHERE id = <취업목록 번호>;
UPDATE tblEmployList SET tblApplyList_id = <수정할 취업지원목록번호> WHERE id = <취업목록 번호>;

-- 삭제
DELETE FROM tblEmployList WHERE id = <취업목록 번호>;





-- 수료생별 취업현황 
   수료생정보(교육생이름, 수료날짜,재취업지원 종료날짜)와 취업현황정보(취업지원수, 취업합격수, 취업상태(취업/미취업)
SELECT
    s.name AS 교육생이름,
    cp.completionDate AS 수료날짜,
    add_months(completiondate, 3) AS 재취업지원종료날짜,
    count(al.tblCompletion_id) AS 지원공고수,
    sum(CASE WHEN al.pass LIKE '합격' THEN 1 ELSE 0 END) AS 합격공고수
FROM tblStudent s
    INNER JOIN tblCompletion cp
        ON s.id = cp.tblstudent_id
            INNER JOIN tblApplyList al
                ON cp.id = al.tblCompletion_id
                    INNER JOIN tblemploylist el
                        ON cp.id = el.tblCompletion_id
                            GROUP BY s.id, s.name, cp.completionDate;



-- 과정별 신청인원수, 중도탈락인원수, 수료인원수, 취업인원수를 조회
SELECT 
    oc.id AS 과정번호,
    oc.name AS 과정명,
    CASE WHEN sum(CASE WHEN completionState LIKE '수료' THEN 1 ELSE 0 END) = 0 THEN '수강중' ELSE '수료' END AS 수강상태,
    count(completionTblopencourse_id) AS 신청인원수,
    sum(CASE WHEN completionState LIKE '중도탈락' THEN 1 ELSE 0 END) AS 중도탈락인원수,
    sum(CASE WHEN completionState LIKE '수료' THEN 1 ELSE 0 END) AS 수료인원수,
    sum(CASE WHEN  employListState LIKE '취업' THEN 1 ELSE 0 END) AS 취업인원수
FROM vwStudentEmployInfo vwse
    INNER JOIN tblOpenCourse oc
        ON oc.id = vwse.completionTblopencourse_id
            GROUP BY oc.id, oc.name;



요구사항번호 
B-12
작성일 
2024-08-16
요구사항명 
재용기업 및 채용공고 관리
작성자 
김유리
-- 채용기업관리
-- 생성
INSERT INTO tblCompany VALUES(seqCompany.nextVal, <기업명>, <연락처>, <담당자명>, <협력여부>);
 
-- 조회
SELECT name AS 기업명, tel AS 연락처, manager AS 담당자명, cooperation AS 협력여부 FROM tblCompany;
 
-- 수정
UPDATE tblCompany SET name = <수정할 기업명> WHERE id = <채용기업 번호>;
UPDATE tblCompany SET tel = <수정할 연락처> WHERE id = <채용기업 번호>;
UPDATE tblCompany SET manager = <수정할 담당자명> WHERE id = <채용기업 번호>;
UPDATE tblCompany SET cooperation = <수정할 협력여부> WHERE id = <채용기업 번호>;
 
-- 삭제
DELETE FROM tblCompany WHERE id = <채용기업 번호>;
 
 
 
-- 근록계약형태 관리
-- 생성
INSERT INTO tblContractType VALUES(seqContractType.nextVal, <계약형태>);
 
-- 조회
SELECT type AS 계약형태 FROM tblContractType;
 
-- 수정
UPDATE tblContractType SET type = <수정할 계약형태> WHERE id = <근로계약형태 번호>;
 
-- 삭제
DELETE FROM tblContractType WHERE id = <근로계약형태 번호>;
 
 
 
-- 채용공고관리
-- 생성
INSERT INTO tblRecruitNotice VALUES(seqRecruitNotice.nextVal, <채용직무>, <채용시작날짜>, <채용종료날짜>, <연봉>, <채용상태>, <채용기업 번호>, <근로계약형태 번호>);
 
-- 조회
SELECT
	c.name AS 채용기업명,
rn.job AS 채용직무,
ct.type AS 계약형태,
rn.salary AS 연봉,
rn.startdate || ' ~ ' || rn.enddate AS 채용공고기간,
rn.state AS 채용상태
FROM tblRecruitNoticern
	INNER JOIN tblCompany c
on c.id = rn.tblCompany_id
INNER JOIN tblContractTypect
on ct.id = rn.tblcontracttype_id;
 
-- 수정
UPDATE tblRecruitNotice SET job = <채용직무> WHERE id = <채용공고 번호>;
UPDATE tblRecruitNotice SET startDate = <채용시작날짜> WHERE id = <채용공고 번호>;
UPDATE tblRecruitNotice SET endDate = <채용종료날짜> WHERE id = <채용공고 번호>;
UPDATE tblRecruitNotice SET salary = <연봉> WHERE id = <채용공고 번호>;
UPDATE tblRecruitNotice SET state = <채용상태>, <채용기업 번호>, <근로계약형태 번호> WHERE id = <채용공고 번호>;
UPDATE tblRecruitNotice SET tblCompany_id = <채용기업 번호> WHERE id = <채용공고 번호>;
UPDATE tblRecruitNotice SET tblContractType_id = <근로계약형태 번호> WHERE id = <채용공고 번호>;
 
-- 삭제
DELETE FROM tblRecruitNotice WHERE id = <채용공고 번호>;







-- 0. 제약사항
-- 일식은 화요일, 목요일에만 포함한다.
-- 각 메뉴는 날짜로 구분한다.

-- 1. 원하는 날짜의 구내식당 식단표(날짜, 요일, 한식, 일품, PLUS 메뉴)를 조회한다.
SELECT DISTINCT wm.menuDate, to_char(wm.menuDate, 'dy'), km.menu AS 한식, pm.menu AS 일품, plm.menu AS PLUS메뉴
    FROM tblKoreanMenu km
    INNER JOIN tblKoreanList kl ON km.id = kl.tblKoreanMenu_id
    INNER JOIN tblWeeklyMenu wm ON wm.id = kl.tblWeeklyMenu_id
    LEFT OUTER JOIN tblPremiumList pl ON wm.id = pl.tblWeeklyMenu_id
    LEFT OUTER JOIN tblPremiumMenu pm ON pm.id = pl.tblPremiumMenu_id
    INNER JOIN tblPlusList pll ON wm.id = pll.tblWeeklyMenu_id
    INNER JOIN tblPlusMenu plm ON plm.id = pll.tblPlusMenu_id
        WHERE wm.menuDate = '2024-01-04';



-- 2. 구내식당 식단표의 원하는 날짜를 등록한다. 
INSERT INTO tblWeeklyMenu(id, menuDate) VALUES (seqWeeklyMenu.nextVal, '2024-09-01');



-- 3. 해당 날짜의 한식 메뉴를 조회 및 등록한다. (일품, PLUS메뉴 방식 동일)
INSERT INTO tblKoreanMenu(id, menu) VALUES(seqKoreanMenu.nextVal, '삼겹살*쌈장');
INSERT INTO tblKoreanList(id, tblWeeklyMenu_id, tblKoreanMenu_id) VALUES (seqKoreanList.nextVal, 181, 301);
INSERT INTO tblKoreanMenu(id, menu) VALUES(seqKoreanMenu.nextVal, '상추');
INSERT INTO tblKoreanList(id, tblWeeklyMenu_id, tblKoreanMenu_id) VALUES (seqKoreanList.nextVal, 181, 302);
INSERT INTO tblKoreanMenu(id, menu) VALUES(seqKoreanMenu.nextVal, '명이나물');
INSERT INTO tblKoreanList(id, tblWeeklyMenu_id, tblKoreanMenu_id) VALUES (seqKoreanList.nextVal, 181, 303);
INSERT INTO tblKoreanMenu(id, menu) VALUES(seqKoreanMenu.nextVal, '배추김치');
INSERT INTO tblKoreanList(id, tblWeeklyMenu_id, tblKoreanMenu_id) VALUES (seqKoreanList.nextVal, 181, 304);
INSERT INTO tblKoreanMenu(id, menu) VALUES(seqKoreanMenu.nextVal, '현미밥');
INSERT INTO tblKoreanList(id, tblWeeklyMenu_id, tblKoreanMenu_id) VALUES (seqKoreanList.nextVal, 181, 305);




-- 0. 제약사항
-- 대여 물품의 반납 기한은 일주일 이내로 제한한다.
-- 대여 신청 및 반납은 대여 번호를 통해 관리한다. 


-- 1. 대여 물품 등록
-- 대여 물품 정보 입력시 기본 내용은 물품 이름, 물품 수량(tblItemState > insert 개수), 등록일으로한다.

-- 물품 등록
INSERT INTO tblItemList(id, name, regDate) VALUES(seqItemList.nextVal, '손풍기', sysdate);

-- 물품 상태 및 수량 등록
INSERT INTO tblItemState(id, state, tblItemList_id) VALUES(seqItemState.nextVal, default, 21);



-- 2. 대여 물품 조회
-- 대여 가능한 물품의 정보를 출력한다. (물품 이름, 총 수량, 대여가능 수량)
SELECT DISTINCT il.name AS 물품, count(*) AS "총 수량",
count(CASE
    WHEN tis.state = '대여가능' THEN 1
END) AS "대여가능 수량"
    FROM tblItemList il
    INNER JOIN tblItemState tis ON il.id = tis.tblItemList_id
            GROUP BY il.name;


-- 특정 물품을 선택하면 해당 물품들의 상태를 출력한다. 이 때 상태는 대여 가능, 대여중으로 나뉜다.
SELECT il.name, tis.state
    FROM tblItemList il
    INNER JOIN tblItemState tis ON il.id = tis.tblItemList_id
        WHERE il.id = 1;


-- 3. 대여 물품 관리 및 수정
-- 교육생의 대여 신청 및 반납을 통해 물품 수량의 수정사항이 발생 시 물품의 상태(대여가능/대여중)를 수정할 수 있다.

-- 대여
UPDATE tblItemState SET state = '대여중' WHERE id = 3;

-- 반납
UPDATE tblItemState SET state = '대여가능' WHERE id = 3;



-- 4. 대여 서비스 관리
-- 수강생들의 대여 및 반납 현황을 조회하고, 대여 물품의 상태를 변경한다. 
SELECT * FROM tblItemRental;

-- 대여
INSERT INTO tblItemRental(id, rentalDate, returnDate, tblItemState_id, tblStudent_id) VALUES (seqItemRental.nextVal, sysdate, null, 4, 296);
UPDATE tblItemState SET state = '대여중' WHERE id = 4;

-- 반납
UPDATE tblItemRental SET returnDate = sysdate WHERE id = 264;
UPDATE tblItemState SET state = '대여가능' WHERE id = 4;




/* 커리큘럼 관리 */

--1.생성
INSERT INTO tblCuri
VALUES (seqCuri.nextVal, <과목설명>, <난이도>, <개설과정번호>, <개설과목번호>);

--2. 출력
SELECT
    id AS 커리큘럼번호,
    content AS 과목설명,
    levels AS 난이도,
    tblOpenCourse_id AS 개설과정번호,
    tblOpenSubject_id AS 개설과목번호
FROM tblCuri;

--3-1. 과목설명 수정
UPDATE tblCuri SET content  = <수정할 과목설명> WHERE id = <수정할 커리큘럼번호>;

--3-2. 난이도 수정
UPDATE tblCuri SET levels = <수정할 난이도> WHERE id = <수정할 커리큘럼번호>;

--3-3. 개설과정 번호 수정
UPDATE tblCuri SET tblOpenCourse_id = <수정할 개설과정번호> WHERE id = <수정할 커리큘럼번호>;

--3-4. 개설과목 번호 수정
UPDATE tblCuri SET tblOpenSubject_id = <수정할 개설과목번호> WHERE id = <수정할 커리큘럼번호>;

--4. 삭제
DELETE FROM tblCuri WHERE id = <삭제할 커리큘럼번호>;




-- 배점 생성
INSERT INTO tblAllotment VALUES(seqAllotment.nextVal, <출결배점>, <필기배점>, <실기배점>, <시험날짜>, <시험문제파일>, <개설과목번호>); 




-- 성적 생성
INSERT INTO tblAllotment VALUES(seqAllotment.nextVal, <출결배점>, <필기배점>, <실기배점>, <시험날짜>, <시험문제파일>, <개설과목번호>); 




-- 0. 제약사항
-- 본인이 강의한 과정에 대한 출결만 조회할 수 있다.
-- 모든 출결 조회는 근태 상황을 구분할 수 있다. (정상, 지각, 조퇴, 외출, 병가, 기타)


-- 1. 수강생들의 출결 현황을 기간별(년, 월, 일) 조회할 수 있다.
SELECT DISTINCT oc.name, s.name, a.attendancedate, ad.inTime, ad.outTime 
    FROM tblTeacher t 
    INNER JOIN tblOpenSubject os ON t.id = os.tblteacher_id
    INNER JOIN tblOpenCourse oc ON os.tblOpenCourse_id = oc.id
    INNER JOIN tblAttendance a ON a.tblOpenCourse_id = oc.id
    INNER JOIN tblAttendDetail ad ON ad.tblAttendance_id  = a.id
    INNER JOIN tblStudent s ON s.id = a.tblStudent_id
    INNER JOIN tblOpenCourse oc ON oc.id = a.tblOpenCourse_id
        WHERE t.id = 4 AND a.attendancedate BETWEEN '2023-03-01' AND '2023-03-31' --조회를 원하는 날짜
            ORDER BY a.attendancedate;



-- 2. 특정 과정(과정명, 출결날짜, 근태상황, 인원)에 대한 출결 현황을 조회할 수 있다.
SELECT DISTINCT oc.name AS 과정명, a.attendancedate AS 출결날짜, count(*) AS 인원,
    count(CASE WHEN ad.inTime <= '09:00:00' AND ad.outTime >= '18:00:00' THEN 1 END) AS 정상출석,
    count(CASE WHEN ad.inTime > '09:00:00' AND ad.outTime >= '18:00:00' THEN 1 END) AS 지각,
    count(CASE WHEN ad.inTime > '09:00:00' AND  
                    ad.outTime < '18:00:00' AND
                   (to_number(to_date(ad.outTime, 'hh24:mi:ss') - to_date(ad.inTime, 'hh24:mi:ss')) * 24) >= 4 THEN 1
          END) AS "지각/조퇴",
    count(CASE WHEN ad.outTime < '18:00:00' AND ad.inTime <= '09:00:00' THEN 1 END) AS 조퇴,
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
    AS 외출,
    count(CASE WHEN sr.tblAttendance_id = a.id THEN 1 END) AS 병가,
    count(CASE
               WHEN ((CASE 
                            WHEN ad.outTime > '18:00:00' THEN to_date('18:00:00', 'hh24:mi:ss') 
                            ELSE to_date(ad.outTime, 'hh24:mi:ss') 
                        END - to_date(ad.inTime, 'hh24:mi:ss')) * 24) < 4
                 THEN 1
                WHEN  ad.id IS NULL AND sr.id IS NULL THEN 1
           END)  
    AS 결석
    FROM tblTeacher t 
    INNER JOIN tblOpenSubject os ON t.id = os.tblteacher_id
    INNER JOIN tblOpenCourse oc ON os.tblOpenCourse_id = oc.id
    INNER JOIN tblAttendance a ON a.tblOpenCourse_id = oc.id
    FULL OUTER JOIN tblAttendDetail ad ON a.id = ad.tblAttendance_id
    FULL OUTER JOIN tblSickRecord sr ON sr.tblAttendance_id = a.id
    INNER JOIN tblStudent s ON s.id = a.tblStudent_id
        WHERE t.id = 4 AND oc.id = 1
            GROUP BY oc.name, a.attendancedate, oc.id, os.id
            ORDER BY 출결날짜;




-- 3. 특정 교육생(교육생 이름, 출결날짜, 근태상황)에 대한 출결 현황을 조회할 수 있다.
SELECT s.name AS 수강생명, a.attendancedate AS 출결날짜,
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
    END AS 근태상황
    FROM tblTeacher t 
    INNER JOIN tblOpenSubject os ON t.id = os.tblteacher_id
    INNER JOIN tblOpenCourse oc ON os.tblOpenCourse_id = oc.id
    INNER JOIN tblAttendance a ON a.tblOpenCourse_id = oc.id
    FULL OUTER JOIN tblAttendDetail ad ON a.id = ad.tblAttendance_id
    FULL OUTER JOIN tblSickRecord sr ON sr.tblAttendance_id = a.id
    INNER JOIN tblStudent s ON s.id = a.tblStudent_id
        WHERE t.id = 4 AND s.id = 1
            ORDER BY 출결날짜;




-- 이전과정과 현재과정의 교사평가 평균비교
SELECT 
    CASE
        WHEN num = 1 THEN '현재 과정' 
        ELSE '이전 과정'
    END AS 과정,
    courseName AS 과정명,
    evaluationDate AS 평가일,
    difficulty AS 난이도,
    communicationSkills AS 전달력,
    lecturePace AS 강의속도,
    satisfaction AS 종합만족도,
    recommendation AS 추천의사
FROM
    (SELECT * FROM(SELECT rownum AS num, a.* FROM (
        SELECT
            courseName,
            evaluationDate,
            round(avg(difficulty), 2) AS difficulty,
            round(avg(communicationSkills), 2) AS communicationSkills,
            round(avg(lecturePace), 2) AS lecturePace,
            round(avg(satisfaction), 2) AS satisfaction,
            round(avg(recommendation), 2) AS recommendation
        FROM vwEvaluation
            WHERE teacherId = <교사번호>
                GROUP BY courseId, courseName, evaluationDate
                    ORDER BY evaluationDate DESC) a) b
        WHERE num <= 2);




/* 상담일지 작성 및 조회 */

--1.생성
INSERT INTO tblCounsel VALUES (seqCounsel.nextVal, <상담일지내용>, <상담일>, <교육생번호>, <교사번호>);

--2-1. 조회 (1번 교사 조회시)
SELECT
    id AS 상담일지번호,
    content AS 상담일지내용,
    counselDate AS 상담일,
    tblStudent_id AS 교육생번호
FROM tblCounsel
WHERE tblTeacher_id = 1;

--2-2. 최신순 상담일지 조회 (1번 교사 조회시)
SELECT
    id AS 상담일지번호,
    content AS 상담일지내용,
    counselDate AS 상담일,
    tblStudent_id AS 교육생번호
FROM tblCounsel
WHERE tblTeacher_id = <교사번호>
ORDER BY counselDate DESC;

--3-1. 상담일지 내용 수정
UPDATE tblCounsel SET content = <수정할 상담일지내용> WHERE id = <수정할 상담일지번호>;

--3-2. 상담일 수정
UPDATE tblCounsel SET counselDate = <수정할 상담일> WHERE id = <수정할 상담일지번호>;

--3-3. 교육생 번호 수정
UPDATE tblCounsel SET tblStudent_id = <수정할 교육생번호> WHERE id = <수정할 상담일지번호>;

--3-4. 교사 번호 수정
UPDATE tblCounsel SET tblTeacher_id = <수정할 교사번호> WHERE id = <수정할 상담일지번호>;

--4. 삭제
DELETE FROM tblCounsel WHERE id = <삭제할 상담일지번호>;









-- 0. 제약사항
-- 다른 교육생의 현황은 조회할 수 없다.
-- 모든 출결 조회는 근태 상황을 구분할 수 있어야 한다.(정상, 지각, 조퇴, 외출, 병가, 기타) 


-- 1. 매일 출석을 기록해야 한다. 
-- 출근 1회, 퇴근 1회 기록한다.
-- 조퇴(18시 이전 퇴근 기록), 외출(출근, 퇴근 2회씩 기록) 중에 해당되는 사항이 있을 경우 기록한다. 
-- 병가 중에 해당되는 사항이 있을 경우 기록한다.

-- 출결
INSERT INTO tblAttendance(id, attendancedate, tblStudent_id, tblOpenCourse_id) VALUES (seqAttendance.nextVal, sysdate, 351, 16);

-- 출근
INSERT INTO tblAttendDetail(id, inTime, outTime, tblAttendance_id) VALUES (seqAttendDetail.nextVal, '08:31:23', null, 32001);

-- 퇴근
UPDATE tblAttendDetail SET outTime = '18:01:34' WHERE tblAttendance_id = 32001;

-- 병가
INSERT INTO tblAttendance(id, attendancedate, tblStudent_id, tblOpenCourse_id) VALUES (seqAttendance.nextVal, sysdate, 351, 16);
INSERT INTO tblSickRecord(id, tblAttendance_id) VALUES (seqSickRecord.nextVal, 32002);




-- 2. 매일 금일 출석을 조회할 수 있다. 
-- 금일 출석 현황에는 교육생 이름, 과정명, 날짜, 근태 상황이 포함된다.
SELECT s.name, oc.name, a.attendancedate,
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
    END AS 근태상황
        FROM tblAttendance a
        INNER JOIN tblAttendDetail ad on a.id = ad.tblAttendance_id
        INNER JOIN tblStudent s on s.id = a.tblStudent_id
        INNER JOIN tblOpenCourse oc on oc.id = a.tblOpenCourse_id
        FULL OUTER JOIN tblSickRecord sr on sr.tblAttendance_id = a.id
            WHERE to_date(a.attendancedate, 'yyyy-mm-dd') = to_date(sysdate, 'yyyy-mm-dd')
                  AND s.id = 266;


-- 3. 본인의 출결 현황을 기간별(전체, 월, 일) 조회할 수 있다.
SELECT DISTINCT oc.name, s.name, a.attendancedate, ad.inTime, ad.outTime 
    FROM tblOpenCourse oc
    INNER JOIN tblAttendance a ON a.tblOpenCourse_id = oc.id
    INNER JOIN tblAttendDetail ad ON ad.tblAttendance_id  = a.id
    INNER JOIN tblStudent s ON s.id = a.tblStudent_id
    INNER JOIN tblOpenCourse oc ON oc.id = a.tblOpenCourse_id
        WHERE s.id = 24 AND a.attendancedate BETWEEN '2023-03-01' AND '2023-03-31' --조회를 원하는 날짜
            ORDER BY a.attendancedate; 




-- 교사평가 생성
INSERT INTO tblEvaluation VALUES(seqEvaluation.nextVal, sysdate, <난이도>, <전달력>, <강의 속도>, <종합 만족도>, <추천의사>, <교육생번호>, <교사번호>);


/* 상담일지 조회 */

--1. 조회
SELECT
    id AS 상담일지번호,
    content AS 상담일지내용,
    counselDate AS 상담일,
    tblTeacher_id AS 교사번호
FROM tblCounsel;




-- 사후 처리 조회
-- 수료생 개인별 사후처리 정보의 일부(교육생이름,수료과정,사후처리기간)를 조회할 수 있다.
SELECT
    s.name AS 교육생이름,
    oc.name AS 개설과정명
    cp.completiondate || ' ~ ' || add_months(cp.completiondate, 3) AS 사후처리날짜, 
    cp.completiondate AS 수료날짜
FROM tblStudent s
    INNER JOIN tblCompletion cp
        ON s.id = cp.tblStudent_id
             INNER JOIN tblOpenCourse oc
                 ON cp.tblOpenCourse_id = oc.id
                      WHERE s.id = <교육생 번호>;



-- 수료생 개인별 지원공고수, 합격공고수, 취업현황(취업상태,취업날짜)을 조회 할 수 있다.
SELECT
    s.name,
    count(al.tblCompletion_id) AS 지원한공고수,
    count(CASE WHEN al.pass = '합격' THEN 1 END) AS 합격한공고수,
    cp.employstate AS 취업상태,
    cp.hiredate AS 취업날짜
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
                                            GROUP BY s.id, s.name, cp.employstate, cp.hiredate
                                                HAVING s.id = <교육생번호>;






-- 0. 제약사항
-- 대여 물품의 반납 기한은 일주일 이내로 제한한다.
-- 대여 번호는 자동으로 누적해서 입력된다. 


-- 1. 대여 가능한 물품을 조회한다. 
-- 대여 물품 내용에는 물품 이름을 조회할 수 있다.
-- 대여 가능한 물품을 조회할 때
SELECT name FROM tblItemList WHERE name = '우산';

-- 대여가 불가능한 물품을 조회할 때 
SELECT name FROM tblItemList WHERE name = '텀블러';


-- 특정 물품을 선택하여 특정 물품의 상태(대여 가능, 대여중)를 확인 가능하다. 
SELECT il.name, tis.state
    FROM tblItemList il
    INNER JOIN tblItemState tis ON il.id = tis.tblItemList_id
        WHERE name = '우산';




/* 커리큘럼 조회 */

--1. 조회
SELECT
    id AS 커리큘럼번호,
    content AS 과목설명,
    levels AS 난이도,
    tblOpenCourse_id AS 개설과정번호,
    tblOpenSubject_id AS 개설과목번호
FROM tblCuri;





