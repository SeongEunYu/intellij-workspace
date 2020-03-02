/*

KCI_TIT

일련번호		  ID				NUMBER(11,0)
기준년도		  PRODYEAR			CHAR(4 BYTE)
학술지명		  TITLE				VARCHAR2(500 BYTE)
구분			  GUBUN				CHAR(1 BYTE)
발행기관		  PUBLISHER			VARCHAR2(250 BYTE)
주제 대분류명		  UP_CATNAME			VARCHAR2(300 BYTE)
주제 중분류 코드	  CATEG				VARCHAR2(20 BYTE)
주제 중분류		  CATNAME			VARCHAR2(300 BYTE)
등재정보		  REGST_AT			CHAR(1 BYTE)
KCI + WoS 통합 IF (2년)	  KCI_WOS_IF			VARCHAR2(10 BYTE)
KCI IF (2년)		  KCI_IF			VARCHAR2(10 BYTE)
(자기인용제외) KCI IF (2년)  SELF_CTS_EXCL_KCI_IF	VARCHAR2(10 BYTE)
중심성 지수(3년)	  CENTER_IDEX_3YRS		VARCHAR2(10 BYTE)
즉시성지수		  IMDTL_IDEX			VARCHAR2(10 BYTE)
자기인용 비율(2년)	  SELF_CTS_RATE_2YRS		VARCHAR2(10 BYTE)
논문수(2년)	 -	  TOTAL_DOCS			NUMBER(11,0)
피인용횟수(2년)		  CTS_DOC_2YRS			VARCHAR2(10 BYTE)
WOS 피인용횟수(2년)	  WOS_CTS_DOC_2YRS		VARCHAR2(10 BYTE)
ISSN번호		  ISSN				VARCHAR2(10 BYTE)
등록일자		  REGDATE			DATE
저널ID			  JRNL_ID			NUMBER(11,0)

KCI_CAT_RANK

일련번호		ID		NUMBER(11,0)
주제분류코드		CATEG		VARCHAR2(20 BYTE)
주제분류명		CATNAME		VARCHAR2(300 BYTE)
주제분류 순서		CATORDER	NUMBER(10,0)
주제분류별 논문수	CNT		NUMBER(5,0)
ISSN번호		ISSN		VARCHAR2(10 BYTE)
기준년도		PRODYEAR	CHAR(4 BYTE)
랭킹			RANK		NUMBER(11,0)
비율			RATIO		NUMBER(6,2)
KCI IF			KCI_IF		VARCHAR2(10 BYTE)
학술지명		TITLE		VARCHAR2(500 BYTE)

*/

  CREATE TABLE "KCI_TIT"
   ( "ID" NUMBER(11,0) NOT NULL ENABLE,
	 "PRODYEAR" CHAR(4 BYTE) NOT NULL ENABLE,
	 "ISSN" VARCHAR2(10 BYTE),
	 "TOTAL_DOCS" NUMBER(11,0),
	 "TITLE" VARCHAR2(1000 BYTE),
	 "PUBLISHER" VARCHAR2(250 BYTE),
	 "GUBUN" CHAR(1 BYTE),
	 "REGST_AT" VARCHAR2(10 BYTE),
	 "CATEG" VARCHAR2(200 BYTE),
	 "CATNAME" VARCHAR2(500 BYTE),
	 "UP_CATNAME" VARCHAR2(300 BYTE),
	 "KCI_WOS_IF" VARCHAR2(20 BYTE),
	 "KCI_IF" VARCHAR2(20 BYTE),
	 "SELF_CTS_EXCL_KCI_IF" VARCHAR2(10 BYTE),
	 "CENTER_IDEX_3YRS" VARCHAR2(10 BYTE),
	 "IMDTL_IDEX" VARCHAR2(10 BYTE),
	 "SELF_CTS_RATE_2YRS" VARCHAR2(10 BYTE),
	 "CTS_DOC_2YRS" VARCHAR2(10 BYTE),
	 "WOS_CTS_DOC_2YRS" VARCHAR2(10 BYTE),
	 "JRNL_ID" NUMBER(11,0),
 	 "REGDATE" DATE
   ) TABLESPACE "TS_R2RIMS_YU" ;

COMMENT ON TABLE "KCI_TIT"  IS 'KCI 인용지수';

ALTER TABLE "KCI_TIT" ADD CONSTRAINT "PK_KCI_TIT" PRIMARY KEY ("ID") ENABLE;
CREATE INDEX  "IDX_KCI_TIT_1" ON "KCI_TIT" ("PRODYEAR","ISSN") TABLESPACE "TS_R2RIMS_YU" ;
CREATE INDEX  "IDX_KCI_TIT_2" ON "KCI_TIT" ("ISSN") TABLESPACE "TS_R2RIMS_YU" ;

CREATE TABLE "KCI_CAT_RANK"
   ( "ID" NUMBER(11,0) NOT NULL ENABLE,
	 "PRODYEAR" CHAR(4 BYTE) NOT NULL ENABLE,
	 "CATEG" VARCHAR2(20 BYTE),
	 "CATNAME" VARCHAR2(300 BYTE),
	 "CATORDER" NUMBER(10,0),
	 "RANK" NUMBER(11,0),
	 "KCI_IF" NUMBER(7,3),
	 "ISSN" VARCHAR2(10 BYTE),
	 "RATIO" NUMBER(6,2),
	 "TITLE" VARCHAR2(1000 BYTE),
	 "CNT" NUMBER
   ) TABLESPACE "TS_R2RIMS_YU" ;

COMMENT ON TABLE "KCI_CAT_RANK"  IS 'KCI 카테고리별 랭킹';

ALTER TABLE "KCI_CAT_RANK" ADD CONSTRAINT "PK_KCI_CAT_RANK" PRIMARY KEY ("ID") ENABLE;
CREATE INDEX "IDX_KCI_CAT_RANK_1" ON "KCI_CAT_RANK" ("PRODYEAR", "ISSN") TABLESPACE "TS_R2RIMS_YU" ;

CREATE SEQUENCE "SEQ_KCI_TIT";
CREATE SEQUENCE "SEQ_KCI_CAT_RANK";

SELECT MAX(ID)+1 FROM RD_SUBJECT;

CREATE SEQUENCE  "SEQ_RD_SUBJECT"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 611 CACHE 20 NOORDER  NOCYCLE ;

insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A00', '인문학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A01', '사전학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A02', '역사학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A03', '철학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A04', '종교학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A05', '기독교신학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A06', '가톨릭신학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A07', '유교학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A08', '불교학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A09', '언어학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A10', '문학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A11', '한국어와문학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A12', '중국어와문학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A13', '일본어와문학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A14', '기타동양어문학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A15', '영어와문학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A16', '프랑스어와문학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A17', '독일어와문학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A18', '스페인어와문학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A19', '러시아어와문학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A20', '서양고전어와문학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A21', '기타서양어문학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A22', '통역번역학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'A99', '기타인문학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B00', '사회과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B01', '사회과학일반');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B02', '정치외교학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B03', '경제학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B04', '농업경제학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B05', '경영학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B06', '회계학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B07', '무역학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B08', '사회학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B09', '사회복지학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B10', '지역학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B11', '인류학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B12', '교육학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B13', '법학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B14', '행정학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B15', '정책학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B16', '지리학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B17', '지역개발');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B18', '관광학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B19', '신문방송학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B20', '군사학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B21', '심리과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'B99', '기타사회과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'C99', '기타자연과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'C10', '대기과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'C04', '물리학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'C07', '생물학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'C12', '생활과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'C02', '수학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'C00', '자연과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'C01', '자연과학일반');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'C08', '지구과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'C09', '지질학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'C05', '천문학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'C03', '통계학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'C11', '해양학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'C06', '화학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D00', '공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D01', '공학일반');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D02', '기계공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D03', '자동차공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D04', '항공우주공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D05', '화학공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D06', '고분자공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D07', '생물공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D08', '제어계측공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D09', '전기공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D10', '재료공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D11', '환경공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D12', '전자/정보통신공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D13', '컴퓨터학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D14', '토목공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D15', '건축공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D16', '산업공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D17', '안전공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D18', '원자력공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D19', '조선공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D20', '해양공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D21', '섬유공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D22', '자원공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D23', '금속공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D24', '교통공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D25', '의공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D26', '농공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D27', '산림공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'D99', '기타공학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E00', '의약학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E01', '의학일반');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E02', '해부학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E03', '생리학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E04', '생화학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E05', '병리학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E06', '약리학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E07', '미생물학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E08', '기생충학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E09', '예방의학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E10', '면역학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E11', '내과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E12', '일반외과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E13', '소아과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E14', '산부인과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E15', '정신과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E16', '정형외과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E17', '신경외과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E18', '흉부외과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E19', '성형외과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E20', '안과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E21', '임상안광학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E22', '이비인후과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E23', '피부과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E24', '비뇨기과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E25', '방사선과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E26', '마취과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E27', '재활의학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E28', '물리치료학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E29', '작업치료학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E30', '신경과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E31', '임상병리학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E32', '가정의학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E33', '응급의학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E34', '치의학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E35', '수의학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E36', '간호학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E37', '한의학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E38', '약학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'E99', '기타의약학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'F00', '농수해양');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'F01', '농학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'F02', '임학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'F03', '조경학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'F04', '축산학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'F05', '수산학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'F06', '해상운송학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'F07', '식품과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'G00', '예술체육');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'G01', '예술일반');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'G02', '음악학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'G03', '미술');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'G04', '디자인');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'G05', '의상');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'G06', '사진');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'G07', '미용');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'G08', '연극');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'G09', '영화');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'G10', '체육');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'G11', '무용');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'G99', '기타예술체육');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'H00', '복합학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'H01', '과학기술학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'H02', '기술정책');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'H03', '문헌정보학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'H04', '심리과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'H05', '여성학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'H06', '인지과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'H07', '뇌과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'H08', '감성과학');
insert into RD_SUBJECT (ID, PRODCODE, CATCODE, DESCRIPTION) values (SEQ_RD_SUBJECT.nextval, 'KCI', 'H99', '학제간연구');
