-- =====================================================
-- 1. BUILDING THE DATABASE
-- =====================================================

-- 1.2 DDL
CREATE DATABASE IF NOT EXISTS college
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE college;

CREATE TABLE STUDENT (
    Rollno      VARCHAR(8)  NOT NULL,
    Name        VARCHAR(40) NOT NULL,
    Dateofbirth DATE,
    CONSTRAINT pk_student PRIMARY KEY (Rollno)
);

CREATE TABLE COURSE (
    SID             VARCHAR(6)  NOT NULL,
    Cname           VARCHAR(40) NOT NULL,
    TotalSeats      INT         NOT NULL,
    Duration        INT,
    Coursetype      VARCHAR(10) NOT NULL,
    TeacherInCharge VARCHAR(40),
    CONSTRAINT pk_course    PRIMARY KEY (SID),
    CONSTRAINT uq_cname     UNIQUE (Cname),
    CONSTRAINT chk_seats    CHECK (TotalSeats > 0),
    CONSTRAINT chk_duration CHECK (Duration BETWEEN 1 AND 6),
    CONSTRAINT chk_ctype    CHECK (Coursetype IN ('Fulltime','Parttime'))
);

CREATE TABLE SOCIETY (
    SocID      VARCHAR(6)  NOT NULL,
    Socname    VARCHAR(40) NOT NULL,
    Mentor     VARCHAR(40),
    TotalSeats INT         NOT NULL,
    CONSTRAINT pk_society    PRIMARY KEY (SocID),
    CONSTRAINT uq_socname    UNIQUE (Socname),
    CONSTRAINT chk_socseats  CHECK (TotalSeats > 0)
);

CREATE TABLE ADMISSION (
    Rollno          VARCHAR(8) NOT NULL,
    SID             VARCHAR(6) NOT NULL,
    Dateofadmission DATE       NOT NULL,
    CONSTRAINT pk_admission PRIMARY KEY (Rollno, SID),
    CONSTRAINT fk_adm_student FOREIGN KEY (Rollno)
        REFERENCES STUDENT(Rollno) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_adm_course FOREIGN KEY (SID)
        REFERENCES COURSE(SID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ENROLLMENT (
    Rollno           VARCHAR(8) NOT NULL,
    SocID            VARCHAR(6) NOT NULL,
    Dateofenrollment DATE       NOT NULL,
    CONSTRAINT pk_enrollment PRIMARY KEY (Rollno, SocID),
    CONSTRAINT fk_enr_student FOREIGN KEY (Rollno)
        REFERENCES STUDENT(Rollno) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_enr_society FOREIGN KEY (SocID)
        REFERENCES SOCIETY(SocID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- =====================================================
-- 1.3 SAMPLE DATA
-- =====================================================

INSERT INTO STUDENT (Rollno, Name, Dateofbirth) VALUES
('X2001','Ankit Sharma','2001-03-14'), ('X2002','Riya Verma','2002-05-11'),
('Z2003','Sana Iqbal','2001-11-02'),   ('Z2004','Arjun Nair','2003-01-25'),
('X2005','Aditi Rao','2001-07-09'),    ('Y2006','Rahul Gupta','2000-09-30'),
('X2007','Neha Joshi','2002-02-18'),   ('Z2008','Vikram Singh','2001-12-05'),
('Y2009','Pooja Mehta','2003-04-22'),  ('X2010','Amit Kapoor','2001-08-17');

INSERT INTO COURSE (SID, Cname, TotalSeats, Duration, Coursetype, TeacherInCharge) VALUES
('CS01','BSc(P)CS',        60,3,'Fulltime','R. K. Gupta'),
('CS02','Computer Science',45,3,'Fulltime','S. Gupta'),
('CH01','Chemistry',       40,3,'Fulltime','S. Menon'),
('MA02','Mathematics',     50,3,'Parttime','A. Gupta'),
('EN03','English',         40,3,'Parttime','P. Das'),
('PH01','Physics',         35,3,'Fulltime','V. Rao');

INSERT INTO SOCIETY (SocID, Socname, Mentor, TotalSeats) VALUES
('S01','Debating','Dr. A. Sharma',30), ('S02','Music','Dr. B. Verma',25),
('S03','Dramatics','Dr. C. Nair',20),  ('S04','Photography','Dr. D. Rao',15),
('S05','Literary','Dr. E. Das',22);

INSERT INTO ADMISSION (Rollno, SID, Dateofadmission) VALUES
('X2001','CS01','2019-07-15'), ('X2001','MA02','2019-08-01'),
('X2002','CS01','2019-07-16'), ('Z2003','CH01','2019-07-18'),
('Z2003','EN03','2019-08-05'), ('X2005','MA02','2019-07-20'),
('Y2006','CS01','2019-07-17'), ('X2007','CS02','2019-07-19'),
('Z2008','CS01','2019-07-21'), ('Y2009','EN03','2019-08-02'),
('X2010','MA02','2019-07-22'), ('X2010','CS02','2019-07-23');
-- Note: Z2004 (Arjun Nair) has NO admission, and PH01 (Physics) has NO students.
-- These deliberate gaps make the LEFT JOIN and NOT EXISTS queries meaningful.

INSERT INTO ENROLLMENT (Rollno, SocID, Dateofenrollment) VALUES
('X2001','S01','2019-08-10'), ('X2001','S02','2019-08-12'),
('X2002','S01','2019-08-11'), ('Z2003','S03','2019-08-15'),
('X2005','S01','2019-08-13'), ('Y2006','S02','2019-08-14'),
('X2007','S01','2019-08-16'), ('Z2008','S04','2019-08-18'),
('Y2009','S01','2019-08-19'), ('X2010','S03','2019-08-20');
-- Note: S05 (Literary) has NO members.
