CREATE TABLE tblCourse (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL
);
CREATE SEQUENCE seqCourse;

CREATE TABLE tblSubject (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL
);
CREATE SEQUENCE seqSubject;

CREATE TABLE tblBook (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(150) NOT NULL,
    author VARCHAR2(50) NOT NULL,
    publish VARCHAR2(100) NOT NULL,
    issueDate DATE NOT NULL
);
CREATE SEQUENCE seqBook;

CREATE TABLE tblSubjectTextbook (
    id NUMBER PRIMARY KEY,
    tblSubject_id NUMBER REFERENCES tblSubject(id) NOT NULL,
    tblBook_id NUMBER REFERENCES tblBook(id) NOT NULL
);
CREATE SEQUENCE seqSubjectTextbook;

CREATE TABLE tblClassroom (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    capacity NUMBER NOT NULL
);
CREATE SEQUENCE seqClassroom;

CREATE TABLE tblAdmin (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    tel VARCHAR2(50) NOT NULL,
    ssn NUMBER DEFAULT 1234567 NOT NULL
);
CREATE SEQUENCE seqAdmin;

CREATE TABLE tblTeacher (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(20) NOT NULL,
    ssn NUMBER NOT NULL,
    tel VARCHAR2(30) NOT NULL
);
CREATE SEQUENCE seqTeacher;

CREATE TABLE tblSubjectList (
    id NUMBER PRIMARY KEY,
    tblSubject_id NUMBER REFERENCES tblSubject(id) NOT NULL,
    tblTeacher_id NUMBER REFERENCES tblTeacher(id) NOT NULL
);
CREATE SEQUENCE seqSubjectList;

CREATE TABLE tblOpenCourse (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    tblCourse_id NUMBER REFERENCES tblCourse(id) NOT NULL,
    tblClassroom_id NUMBER REFERENCES tblClassroom(id) NOT NULL
);
CREATE SEQUENCE seqOpenCourse;

CREATE TABLE tblOpenSubject (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    tblSubject_id NUMBER REFERENCES tblSubject(id) NOT NULL,
    tblBook_id NUMBER REFERENCES tblBook(id) NOT NULL,
    tblTeacher_id NUMBER REFERENCES tblTeacher(id) NOT NULL,
    tblOpenCourse_id NUMBER REFERENCES tblOpenCourse(id) NOT NULL
);
CREATE SEQUENCE seqOpenSubject;

CREATE TABLE tblAllotment (
    id NUMBER PRIMARY KEY,
    attendance NUMBER NOT NULL,
    write NUMBER NOT NULL,
    practice NUMBER NOT NULL,
    examDate DATE NOT NULL,
    filename VARCHAR2(200) NOT NULL,
    tblOpenSubject_id NUMBER REFERENCES tblOpenSubject(id) NOT NULL
);
CREATE SEQUENCE seqAllotment;

CREATE TABLE tblResume (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(30) NOT NULL,
    tel VARCHAR2(30) NOT NULL,
    dueDate DATE NOT NULL,
    seeDate DATE NOT NULL,
    pick VARCHAR2(10) NOT NULL,
    tblOpenCourse_id NUMBER REFERENCES tblOpenCourse(id) NOT NULL,
    tblAdmin_id NUMBER REFERENCES tblAdmin(id) NOT NULL
);
CREATE SEQUENCE seqResume;

CREATE TABLE tblStudent (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    ssn NUMBER NOT NULL,
    tel VARCHAR2(50) NOT NULL,
    regdate DATE DEFAULT SYSDATE NOT NULL
);
CREATE SEQUENCE seqStudent;

CREATE TABLE tblCuri (
    id NUMBER PRIMARY KEY,
    content VARCHAR2(300) NOT NULL,
    levels NUMBER NOT NULL,
    tblOpenCourse_id NUMBER REFERENCES tblOpenCourse(id) NOT NULL,
    tblOpenSubject_id NUMBER REFERENCES tblOpenSubject(id) NOT NULL
);
CREATE SEQUENCE seqCuri;

CREATE TABLE tblAttendance (
    id NUMBER PRIMARY KEY,
    attendanceDate DATE NOT NULL,
    tblStudent_id NUMBER REFERENCES tblStudent(id) NOT NULL,
    tblOpenCourse_id NUMBER REFERENCES tblOpenCourse(id) NOT NULL
);
CREATE SEQUENCE seqAttendance;

CREATE TABLE tblAttendDetail (
    id NUMBER PRIMARY KEY,
    inTime VARCHAR2(10) NOT NULL,
    outTime VARCHAR2(10) NOT NULL,
    tblAttendance_id NUMBER REFERENCES tblAttendance(id) NOT NULL
);
CREATE SEQUENCE seqAttendDetail;

CREATE TABLE tblSickRecord (
    id NUMBER PRIMARY KEY,
    tblAttendance_id NUMBER REFERENCES tblAttendance(id) NOT NULL
);
CREATE SEQUENCE seqSickRecord;

CREATE TABLE tblHoliday (
    id NUMBER PRIMARY KEY,
    holidayDate DATE NOT NULL,
    holiday VARCHAR2(30) NOT NULL
);
CREATE SEQUENCE seqHoliday;

CREATE TABLE tblGrade (
    id NUMBER PRIMARY KEY,
    write NUMBER NOT NULL,
    practice NUMBER NOT NULL,
    tblOpenSubject_id NUMBER REFERENCES tblOpenSubject(id) NOT NULL,
    tblStudent_id NUMBER REFERENCES tblStudent(id) NOT NULL
);
CREATE SEQUENCE seqGrade;

CREATE TABLE tblEvaluation (
    id NUMBER PRIMARY KEY,
    evaluationDate DATE DEFAULT SYSDATE NOT NULL,
    difficulty NUMBER NOT NULL,
    communicationSkills NUMBER NOT NULL,
    lecturePace NUMBER NOT NULL,
    satisfaction NUMBER NOT NULL,
    recommendation NUMBER NOT NULL,
    tblStudent_id NUMBER REFERENCES tblStudent(id) NOT NULL,
    tblTeacher_id NUMBER REFERENCES tblTeacher(id) NOT NULL
);
CREATE SEQUENCE seqEvaluation;

CREATE TABLE tblCounsel (
    id NUMBER PRIMARY KEY,
    content VARCHAR2(900) NOT NULL,
    counselDate DATE NOT NULL,
    tblStudent_id NUMBER REFERENCES tblStudent(id) NOT NULL,
    tblTeacher_id NUMBER REFERENCES tblTeacher(id) NOT NULL
);
CREATE SEQUENCE seqCounsel;

CREATE TABLE tblQuestion (
    id NUMBER PRIMARY KEY,
    title VARCHAR2(100) NOT NULL,
    content VARCHAR2(2000) NOT NULL,
    creation_time DATE NOT NULL,
    tblStudent_id NUMBER REFERENCES tblStudent(id) NOT NULL
);
CREATE SEQUENCE seqQuestion;

CREATE TABLE tblAnswer (
    id NUMBER PRIMARY KEY,
    title VARCHAR2(100) NOT NULL,
    content VARCHAR2(2000) NOT NULL,
    creation_time DATE NOT NULL,
    tblTeacher_id NUMBER REFERENCES tblTeacher(id) NOT NULL
);
CREATE SEQUENCE seqAnswer;

CREATE TABLE tblQnABoard (
    id NUMBER PRIMARY KEY,
    tblQuestion_id NUMBER REFERENCES tblQuestion(id) NOT NULL,
    tblAnswer_id NUMBER REFERENCES tblAnswer(id) NULL
);
CREATE SEQUENCE seqQnABoard;

CREATE TABLE tblCompletion (
    id NUMBER PRIMARY KEY,
    state VARCHAR2(50) NOT NULL,
    completionDate DATE NULL,
    tblStudent_id NUMBER REFERENCES tblStudent(id) NOT NULL,
    tblOpenCourse_id NUMBER REFERENCES tblOpenCourse(id) NOT NULL
);
CREATE SEQUENCE seqCompletion;

CREATE TABLE tblCompany (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    tel VARCHAR2(50) NOT NULL,
    manager VARCHAR2(50) NOT NULL,
    cooperation VARCHAR2(50) NOT NULL
);
CREATE SEQUENCE seqCompany;

CREATE TABLE tblContractType (
    id NUMBER PRIMARY KEY,
    type VARCHAR2(50) NOT NULL
);
CREATE SEQUENCE seqContractType;

CREATE TABLE tblRecruitNotice (
    id NUMBER PRIMARY KEY,
    job VARCHAR2(50) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    salary NUMBER NOT NULL,
    state VARCHAR2(50) NOT NULL,
    tblCompany_id NUMBER REFERENCES tblCompany(id) NOT NULL,
    tblContractType_id NUMBER REFERENCES tblContractType(id) NOT NULL
);
CREATE SEQUENCE seqRecruitNotice;

CREATE TABLE tblApplyList (
    id NUMBER PRIMARY KEY,
    pass VARCHAR2(50) NULL,
    tblRecruitNotice_id NUMBER REFERENCES tblRecruitNotice(id) NOT NULL,
    tblCompletion_id NUMBER REFERENCES tblCompletion(id) NOT NULL
);
CREATE SEQUENCE seqApplyList;

CREATE TABLE tblEmployList (
    id NUMBER PRIMARY KEY,
    state VARCHAR2(50) NOT NULL,
    hireDate DATE NOT NULL,
    tblCompletion_id NUMBER REFERENCES tblCompletion(id) NOT NULL,
    tblApplyList_id NUMBER REFERENCES tblApplyList(id) NOT NULL
);
CREATE SEQUENCE seqEmployList;

CREATE TABLE tblItemList (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(30) NOT NULL,
    regDate DATE NOT NULL
);
CREATE SEQUENCE seqItemList;

CREATE TABLE tblItemState (
    id NUMBER PRIMARY KEY,
    state VARCHAR2(15) DEFAULT '대여가능' NOT NULL,
    tblItemList_id NUMBER REFERENCES tblItemList(id) NOT NULL
);
CREATE SEQUENCE seqItemState;

CREATE TABLE tblItemRental (
    id NUMBER PRIMARY KEY,
    rentalDate DATE NOT NULL,
    returnDate DATE NULL,
    tblItemState_id NUMBER REFERENCES tblItemState(id) NOT NULL,
    tblStudent_id NUMBER REFERENCES tblStudent(id) NOT NULL
);
CREATE SEQUENCE seqItemRental;

CREATE TABLE tblWeeklyMenu (
    id NUMBER PRIMARY KEY,
    menuDate DATE NOT NULL UNIQUE
);
CREATE SEQUENCE seqWeeklyMenu;

CREATE TABLE tblKoreanMenu (
    id NUMBER PRIMARY KEY,
    menu VARCHAR2(50) NOT NULL
);
CREATE SEQUENCE seqKoreanMenu;

CREATE TABLE tblKoreanList (
    id NUMBER PRIMARY KEY,
    tblWeeklyMenu_id NUMBER REFERENCES tblWeeklyMenu(id) NOT NULL,
    tblKoreanMenu_id NUMBER REFERENCES tblKoreanMenu(id) NOT NULL
);
CREATE SEQUENCE seqKoreanList;

CREATE TABLE tblPremiumMenu (
    id NUMBER PRIMARY KEY,
    menu VARCHAR2(50) NOT NULL
);
CREATE SEQUENCE seqPremiumMenu;

CREATE TABLE tblPremiumList (
    id NUMBER PRIMARY KEY,
    tblWeeklyMenu_id NUMBER REFERENCES tblWeeklyMenu(id) NOT NULL,
    tblPremiumMenu_id NUMBER REFERENCES tblPremiumMenu(id) NOT NULL
);
CREATE SEQUENCE seqPremiumList;

CREATE TABLE tblPlusMenu (
    id NUMBER PRIMARY KEY,
    menu VARCHAR2(50) NOT NULL
);
CREATE SEQUENCE seqPlusMenu;

CREATE TABLE tblPlusList (
    id NUMBER PRIMARY KEY,
    tblWeeklyMenu_id NUMBER REFERENCES tblWeeklyMenu(id) NOT NULL,
    tblPlusMenu_id NUMBER REFERENCES tblPlusMenu(id) NOT NULL
);
CREATE SEQUENCE seqPlusList;
