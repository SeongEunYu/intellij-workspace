-- COMMENT ON TABLE ""  IS '';
-- COMMENT ON COLUMN ""."" IS '';

drop view "RI_CODE";
drop view "DEPT_CLG_MAP";

/* Migration RI_CODE Table */
  -- table
  CREATE TABLE "RI_CODE"
   (
  "ID" NUMBER NOT NULL ENABLE,
    "GUBUN" VARCHAR2(20 BYTE) NOT NULL ENABLE,
  "CODE_VALUE" VARCHAR2(60 BYTE),
  "CODE_DISP" VARCHAR2(400 BYTE) NOT NULL ENABLE,
  "CODE_DISP_ENG" VARCHAR2(250 BYTE),
  "DISP_ORDER" NUMBER(11,0),
  "IS_USED" CHAR(1 BYTE) DEFAULT 'Y',
  "PROPERTY" VARCHAR2(500 BYTE),
   PRIMARY KEY ("ID")
   ) TABLESPACE "RIMS";
  --comment
   COMMENT ON TABLE "RI_CODE"  IS '코드정보';
   COMMENT ON COLUMN "RI_CODE"."ID" IS '관리번호';
   COMMENT ON COLUMN "RI_CODE"."GUBUN" IS '코드구분';
   COMMENT ON COLUMN "RI_CODE"."CODE_VALUE" IS '코드값';
   COMMENT ON COLUMN "RI_CODE"."CODE_DISP" IS '코드명';
   COMMENT ON COLUMN "RI_CODE"."CODE_DISP_ENG" IS '영문코드명';
   COMMENT ON COLUMN "RI_CODE"."DISP_ORDER" IS '정렬순서';
   COMMENT ON COLUMN "RI_CODE"."IS_USED" IS '사용여부';
   COMMENT ON COLUMN "RI_CODE"."PROPERTY" IS '속성값';
  -- index
  CREATE UNIQUE INDEX "PK_RI_CODE" ON "RI_CODE" ("ID") TABLESPACE "RIMS" ;
  CREATE INDEX "IDX_RI_CODE_1" ON "RI_CODE" ("GUBUN", "IS_USED") TABLESPACE "RIMS" ;
  CREATE INDEX "IDX_RI_CODE_2" ON "RI_CODE" (NVL("IS_USED",'Y')) TABLESPACE "RIMS" ;
  CREATE INDEX "IDX_RI_CODE_4" ON "RI_CODE" (NVL("IS_USED",'Y'), "GUBUN", "DISP_ORDER") TABLESPACE "RIMS" ;
  -- sequence
  CREATE SEQUENCE  "SEQ_RI_CODE";
  --insert into RI_CODE from RI_CODE_COMMON or RI_CODE_ORG
  insert into "RI_CODE" ("ID", "GUBUN", "CODE_VALUE", "CODE_DISP", "CODE_DISP_ENG", "DISP_ORDER", "IS_USED", "PROPERTY")
  select SEQ_RI_CODE.nextval, GUBUN, CODE_VALUE, CODE_DISP, CODE_DISP_ENG, DISP_ORDER, IS_USED, PROPERTY
  from (
    select GUBUN, CODE_VALUE, CODE_DISP, CODE_DISP_ENG, DISP_ORDER, IS_USED, PROPERTY from RI_CODE_COMMON
      union all
    select GUBUN, CODE_VALUE, CODE_DISP, CODE_DISP as CODE_DISP_ENG, DISP_ORDER, IS_USED, '' as PROPERTY from RI_CODE_ORG
  );

-- 임시로 사용할 경우 VIEW 생성
/*
 CREATE OR REPLACE FORCE VIEW "RI_CODE" ("GUBUN", "CODE_VALUE", "CODE_DISP", "CODE_DISP_ENG", "DISP_ORDER", "IS_USED", "PROPERTY") AS
  select GUBUN, CODE_VALUE, CODE_DISP, CODE_DISP_ENG, DISP_ORDER, IS_USED, PROPERTY from RI_CODE_COMMON
  union all
 select GUBUN, CODE_VALUE, CODE_DISP, CODE_DISP as CODE_DISP_ENG, DISP_ORDER, IS_USED, '' as PROPERTY from RI_CODE_ORG;
*/

/* Migration DEPT_CLG_MAP Table */
-- table
   CREATE TABLE "DEPT_CLG_MAP"
   ( "CLG_CODE" VARCHAR2(20 BYTE),
  "CLG_NM" VARCHAR2(200 BYTE),
  "DEPT_CODE" VARCHAR2(20 BYTE),
  "DEPT_ENG_NM" VARCHAR2(300 BYTE),
  "DEPT_KOR_NM" VARCHAR2(200 BYTE),
  "DEPT_ENG_ABBR" VARCHAR2(300 BYTE),
  "DEPT_ENG_MOST_ABBR" VARCHAR2(300 BYTE),
  "IS_USED" CHAR(1 BYTE) DEFAULT 'Y',
  "DEPT_CMMT" VARCHAR2(1000 BYTE),
  "DRHF_EMP_ID" VARCHAR2(20 BYTE),
  "SERS_SE" VARCHAR2(10 BYTE)
   ) TABLESPACE "RIMS" ;
-- comment
   COMMENT ON TABLE "DEPT_CLG_MAP"  IS '단과대와 학과코드 맵핑';
   COMMENT ON COLUMN "DEPT_CLG_MAP"."CLG_CODE" IS '단과대학코드';
   COMMENT ON COLUMN "DEPT_CLG_MAP"."CLG_NM" IS '단과대학명';
   COMMENT ON COLUMN "DEPT_CLG_MAP"."DEPT_CODE" IS '학과코드';
   COMMENT ON COLUMN "DEPT_CLG_MAP"."DEPT_ENG_NM" IS '영문학과명';
   COMMENT ON COLUMN "DEPT_CLG_MAP"."DEPT_KOR_NM" IS '한글학과명';
   COMMENT ON COLUMN "DEPT_CLG_MAP"."DEPT_ENG_ABBR" IS '영문학과축약명';
   COMMENT ON COLUMN "DEPT_CLG_MAP"."DEPT_ENG_MOST_ABBR" IS '영무학과최상위축약명';
   COMMENT ON COLUMN "DEPT_CLG_MAP"."IS_USED" IS '사용여부';
   COMMENT ON COLUMN "DEPT_CLG_MAP"."DEPT_CMMT" IS '학과변경사항';
   COMMENT ON COLUMN "DEPT_CLG_MAP"."DRHF_EMP_ID" IS '학과장EMPID';
   COMMENT ON COLUMN "DEPT_CLG_MAP"."SERS_SE" IS '계열구분(인문:SCT,자연:NRT)';
-- insert into DEPT_CLG_MAP from KAIST_CLG_MAP
  insert into "DEPT_CLG_MAP" ("CLG_CODE","CLG_NM", "DEPT_CODE", "DEPT_ENG_NM", "DEPT_KOR_NM", "DEPT_ENG_ABBR", "DEPT_ENG_MOST_ABBR", "IS_USED", "DEPT_CMMT", "SERS_SE" )
  select  CLG_CODE, CLG_NAME as CLG_NM, DEPT_CODE, DEPT_ENG_NM, DEPT_KOR_NM, DEPT_ENG_ABBR, DEPT_ENG_MOST_ABBR, 'Y' as IS_USED, DEPT_CMMT, DECODE(CLG_CODE,'0136','SCT','1269','SCT','NRT') as SERS_SE from KAIST_CLG_MAP;

-- 임시로 조회만 필요한 경우 VIEW 생성
/*
  CREATE OR REPLACE FORCE VIEW "DEPT_CLG_MAP" ("CLG_CODE", "DEPT_CODE", "DEPT_ENG_NM", "DEPT_KOR_NM", "DEPT_ENG_ABBR", "DEPT_ENG_MOST_ABBR", "CLG_NAME") AS
  select  CLG_CODE, DEPT_CODE, DEPT_ENG_NM, DEPT_KOR_NM, DEPT_ENG_ABBR, DEPT_ENG_MOST_ABBR, CLG_NAME
  from KAIST_CLG_MAP;
*/

/* Migration RI_TRACK Table */
--table
    CREATE TABLE "RI_TRACK"
   ( "TRACK_ID" NUMBER,
  "TRACK_NAME" VARCHAR2(1000 BYTE),
  "REG_DATE" DATE,
  "MOD_DATE" DATE,
  "DEL_DVS_CD" CHAR(1 BYTE)
   ) TABLESPACE "RIMS" ;
-- comment
  COMMENT ON TABLE "RI_TRACK"  IS '트랙정보';
  COMMENT ON COLUMN "RI_TRACK"."TRACK_ID" IS '트랙ID';
  COMMENT ON COLUMN "RI_TRACK"."TRACK_NAME" IS '트랙명';
  COMMENT ON COLUMN "RI_TRACK"."REG_DATE" IS '등록일자';
  COMMENT ON COLUMN "RI_TRACK"."MOD_DATE" IS '수정일자';
  COMMENT ON COLUMN "RI_TRACK"."DEL_DVS_CD" IS '삭제여부';
-- index
  CREATE UNIQUE INDEX "PK_RI_TRACK" ON "RI_TRACK" ("TRACK_ID")  TABLESPACE "RIMS" ;
-- sequence
  CREATE SEQUENCE  "SEQ_RI_TRACK" MINVALUE 0 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 121 CACHE 20 NOORDER  NOCYCLE ;
-- insert into RI_TRACK select from TRACK
  insert into "RI_TRACK" ("TRACK_ID", "TRACK_NAME", "REG_DATE", "MOD_DATE", "DEL_DVS_CD") select TRACK_ID, TRACK_NAME, REG_DATE, MOD_DATE, DEL_DVS_CD from TRACK;

/* Migration RI_TRACK Table */
--table
   CREATE TABLE "RI_TRACK_USER"
   (  "ID" NUMBER,
  "TRACK_ID" NUMBER,
  "USER_ID" VARCHAR2(30 BYTE),
  "USER_NAME" VARCHAR2(100 BYTE),
  "GRADE" CHAR(1 BYTE),
  "DEPT" VARCHAR2(100 BYTE),
  "EMAIL" VARCHAR2(200 BYTE),
  "DEL_DVS_CD" CHAR(1 BYTE) DEFAULT 'N',
  "U_ID" VARCHAR2(20 BYTE),
  "REG_DATE" DATE,
  "MOD_DATE" DATE
   ) TABLESPACE "RIMS" ;
--comment
  COMMENT ON TABLE "RI_TRACK_USER"  IS '트랙연구자정보';
  COMMENT ON COLUMN "RI_TRACK_USER"."TRACK_ID" IS '트랙ID';
  COMMENT ON COLUMN "RI_TRACK_USER"."ID" IS '일련번호';
  COMMENT ON COLUMN "RI_TRACK_USER"."USER_ID" IS '연구자ID';
  COMMENT ON COLUMN "RI_TRACK_USER"."USER_NAME" IS '연구자명';
  COMMENT ON COLUMN "RI_TRACK_USER"."GRADE" IS '관리자/일반여부(관리자:M,일반:G)';
  COMMENT ON COLUMN "RI_TRACK_USER"."DEPT" IS '소속학과명';
  COMMENT ON COLUMN "RI_TRACK_USER"."EMAIL" IS '이메일';
  COMMENT ON COLUMN "RI_TRACK_USER"."DEL_DVS_CD" IS '삭제여부';
  COMMENT ON COLUMN "RI_TRACK_USER"."U_ID" IS 'Unique_ID';
  COMMENT ON COLUMN "RI_TRACK_USER"."REG_DATE" IS '등록일자';
  COMMENT ON COLUMN "RI_TRACK_USER"."MOD_DATE" IS '수정일자';
--sequence
  CREATE SEQUENCE  "SEQ_RI_TRACK_USER" MINVALUE 0 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 381 CACHE 20 NOORDER  NOCYCLE ;
--index
  CREATE UNIQUE INDEX "PK_RI_TRACK_USER" ON "RI_TRACK_USER" ("ID") TABLESPACE "RIMS" ;
--insert into RI_TRACK_USER select from TRACK_USER
  insert into "RI_TRACK_USER" ("ID","TRACK_ID","USER_ID","USER_NAME","GRADE","DEPT","EMAIL","DEL_DVS_CD","U_ID","REG_DATE","MOD_DATE")
  select ID, TRACK_ID, USER_ID, USER_NAME, GRADE, DEPT, '', DEL_DVS_CD, U_ID, REG_DATE, MOD_DATE from TRACK_USER;

/* Migration RI_CODE_INFO Table */
-- 기존테이블명 변경
  alter table RI_CODE_INFO rename to RI_CODE_INFO_OLD;
--table
  CREATE TABLE "RI_CODE_INFO"
   (  "ID" NUMBER NOT NULL ENABLE,
     "GUBUN" VARCHAR2(20 BYTE) DEFAULT 'Y' NOT NULL ENABLE,
     "GUBUN_DESC" VARCHAR2(300 BYTE),
     PRIMARY KEY ("ID")
   ) TABLESPACE "RIMS" ;
--comment
  COMMENT ON TABLE "RI_CODE_INFO"  IS '코드구분정보';
  COMMENT ON COLUMN "RI_CODE_INFO"."ID" IS '일련번호';
  COMMENT ON COLUMN "RI_CODE_INFO"."GUBUN" IS '구분명';
  COMMENT ON COLUMN "RI_CODE_INFO"."GUBUN_DESC" IS '구분설명';

--insert RI_CODE_INFO select from RI_CODE_INFO_OLD;
insert into "RI_CODE_INFO" ("ID","GUBUN","GUBUN_DESC")
select row_number() over(order by GUBUN ) as ID, GUBUN, GUBUN_DESC
from (select CODE_GUBUN as GUBUN, MAX(CODE_CONT) as GUBUN_DESC from RI_CODE_INFO_OLD group by CODE_GUBUN );

/* 저자정보 테이블 헤더 추가 - 학(부)과 */
insert into RI_CODE_TRANS (GUBUN,CODE_VALUE,CODE_DISP,DISP_ORDER,IS_USED,KRI_DISP,CODE_DISP_ENG) values ('ART','ART_AUTHOR_DEPT','학(부)과',0,'Y',null,'Department');

/* 특허 테이블 컬럼 추가 */
alter table "RI_PATENT" add("IPC" VARCHAR2(500 BYTE));
alter table "RI_PATENT" add("ORG_LANG_APPL_RPST_NM" VARCHAR2(500 BYTE));
alter table "RI_PATENT" add("DIFF_LANG_APPL_RPST_NM" VARCHAR2(500 BYTE));
alter table "RI_PATENT" add("OPEN_NO" VARCHAR2(35 BYTE));
alter table "RI_PATENT" add("OPEN_DATE" VARCHAR2(8 BYTE));
alter table "RI_PATENT" add("WIPSONKEY" VARCHAR2(35 BYTE));
alter table "RI_PATENT" add("PARENT_ID" NUMBER(10) DEFAULT 0);

  COMMENT ON COLUMN "RI_PATENT"."IPC" IS 'IPC값';
  COMMENT ON COLUMN "RI_PATENT"."ORG_LANG_APPL_RPST_NM" IS '';
  COMMENT ON COLUMN "RI_PATENT"."DIFF_LANG_APPL_RPST_NM" IS '';
  COMMENT ON COLUMN "RI_PATENT"."OPEN_NO" IS '공개번호';
  COMMENT ON COLUMN "RI_PATENT"."OPEN_DATE" IS '공개일자';
  COMMENT ON COLUMN "RI_PATENT"."WIPSONKEY" IS 'WIPSON제어번호';
  COMMENT ON COLUMN "RI_PATENT"."PARENT_ID" IS '부모키';


/* 특허 발명자정보 헤더 */
INSERT INTO RI_CODE_TRANS (GUBUN, CODE_VALUE, CODE_DISP, DISP_ORDER, IS_USED, KRI_DISP, CODE_DISP_ENG)
VALUES ('PATN', 'PATN_OPEN_DATE', '공개일자', NULL, 'Y', NULL, 'Open Date');
INSERT INTO RI_CODE_TRANS (GUBUN, CODE_VALUE, CODE_DISP, DISP_ORDER, IS_USED, KRI_DISP, CODE_DISP_ENG)
VALUES ('PATN', 'PATN_OPEN_NO', '공개번호', NULL, 'Y', NULL, 'Open No.');
INSERT INTO RI_CODE_TRANS (GUBUN, CODE_VALUE, CODE_DISP, DISP_ORDER, IS_USED, KRI_DISP, CODE_DISP_ENG)
VALUES ('PATN', 'PATN_ORDER', '번호', NULL, 'Y', NULL, 'No');
INSERT INTO RI_CODE_TRANS (GUBUN, CODE_VALUE, CODE_DISP, DISP_ORDER, IS_USED, KRI_DISP, CODE_DISP_ENG)
VALUES ('PATN', 'PATN_ABBR_NM', '발명자명(ABBR)', NULL, 'Y', NULL, 'Abbr Name');
INSERT INTO RI_CODE_TRANS (GUBUN, CODE_VALUE, CODE_DISP, DISP_ORDER, IS_USED, KRI_DISP, CODE_DISP_ENG)
VALUES ('PATN', 'PATN_USER_ID', '사번', NULL, 'Y', NULL, 'ID (Emp No)');
INSERT INTO RI_CODE_TRANS (GUBUN, CODE_VALUE, CODE_DISP, DISP_ORDER, IS_USED, KRI_DISP, CODE_DISP_ENG)
VALUES ('PATN', 'PATN_BLNG_AGC_NM', '소속기관명', NULL, 'Y', NULL, 'Affiliation');

/* 주제분야코드 컬럼추가 IS_CORE */
alter table "RD_SUBJECT" add("IS_CORE" CHAR(1 BYTE) DEFAULT 'N');

/* Migration RI_ARTICLE Table */
--컬럼사이즈조정
alter table "RI_ARTICLE" MODIFY("KEYWORD" VARCHAR2(2000 BYTE));
--초록 컬럼 Type 변경
alter table "RI_ARTICLE" add("ABST_CNTN_CLOB" CLOB);
update RI_ARTICLE set ABST_CNTN_CLOB = ABST_CNTN;
alter table "RI_ARTICLE" drop column ABST_CNTN;
alter table "RI_ARTICLE" rename column "ABST_CNTN_CLOB" to "ABST_CNTN";
--컬럼추가
alter table "RI_ARTICLE" add("KCI_TC" NUMBER(11,0));
alter table "RI_ARTICLE" add("KCI_TC_DATE" DATE);
alter table "RI_ARTICLE" add("KCI_IF" VARCHAR2(20 BYTE));
alter table "RI_ARTICLE" add("GS_TC" NUMBER(11,0));
alter table "RI_ARTICLE" add("GS_TC_DATE" DATE);
alter table "RI_ARTICLE" add("ATC_AT" CHAR(1) DEFAULT 'A');
alter table "RI_ARTICLE" add("ACK_AT" CHAR(1));
alter table "RI_ARTICLE" add("ACK_CONTENTS" VARCHAR2(4000 BYTE));
alter table "RI_ARTICLE" add("ONLINE_DATE" VARCHAR2(10 BYTE));
alter table "RI_ARTICLE" add("SUB_DATE" VARCHAR2(10 BYTE));
alter table "RI_ARTICLE" add("FIX_DATE" VARCHAR2(10 BYTE));
alter table "RI_ARTICLE" add("MNG_NO" VARCHAR2(20 BYTE));
alter table "RI_ARTICLE" add("DOC_TYPE_CD" VARCHAR2(20 BYTE));
alter table "RI_ARTICLE" add("INSTT_RSLT_AT" CHAR(1));
alter table "RI_ARTICLE" add("SCI_AT" CHAR(1));
alter table "RI_ARTICLE" add("SCOPUS_AT" CHAR(1));
alter table "RI_ARTICLE" add("KCI_AT" CHAR(1));
--comment
COMMENT ON COLUMN "RI_ARTICLE"."KEYWORD" IS '키워드';
COMMENT ON COLUMN "RI_ARTICLE"."ABST_CNTN" IS '초록';
COMMENT ON COLUMN "RI_ARTICLE"."KCI_TC" IS 'KCI피인용횟수';
COMMENT ON COLUMN "RI_ARTICLE"."KCI_TC_DATE" IS 'KCI피인용횟수업데이트일자';
COMMENT ON COLUMN "RI_ARTICLE"."KCI_IF" IS 'KCI Impact Factor값';
COMMENT ON COLUMN "RI_ARTICLE"."GS_TC" IS 'GoogleSchalor피인용횟수';
COMMENT ON COLUMN "RI_ARTICLE"."GS_TC_DATE" IS 'GoogleSchalor피인용횟수업데이트일자';
COMMENT ON COLUMN "RI_ARTICLE"."ATC_AT" IS '?';
COMMENT ON COLUMN "RI_ARTICLE"."ACK_AT" IS '사서표기여부';
COMMENT ON COLUMN "RI_ARTICLE"."ACK_CONTENTS" IS '사서표기';
COMMENT ON COLUMN "RI_ARTICLE"."ONLINE_DATE" IS '온라인게재일';
COMMENT ON COLUMN "RI_ARTICLE"."SUB_DATE" IS '투고일';
COMMENT ON COLUMN "RI_ARTICLE"."FIX_DATE" IS '게재확정일';
COMMENT ON COLUMN "RI_ARTICLE"."MNG_NO" IS '소스원관리번호';
COMMENT ON COLUMN "RI_ARTICLE"."DOC_TYPE_CD" IS 'DocType코드';
COMMENT ON COLUMN "RI_ARTICLE"."INSTT_RSLT_AT" IS '기관성과여부';
COMMENT ON COLUMN "RI_ARTICLE"."SCI_AT" IS 'SCI여부';
COMMENT ON COLUMN "RI_ARTICLE"."SCOPUS_AT" IS 'SCOPUS여부';
COMMENT ON COLUMN "RI_ARTICLE"."KCI_AT" IS 'KCI여부';
-- data update
update RI_ARTICLE set INSTT_RSLT_AT = IS_KAIST, SCI_AT = IS_SCI, SCOPUS_AT = IS_SCOPUS, KCI_AT = IS_KCI;
alter table "RI_ARTICLE" drop column IS_KAIST;
alter table "RI_ARTICLE" drop column IS_SCI;
alter table "RI_ARTICLE" drop column IS_SCOPUS;
alter table "RI_ARTICLE" drop column IS_KCI;
--컬럼명
INSERT INTO "RI_CODE_TRANS" (GUBUN,CODE_VALUE,CODE_DISP,DISP_ORDER,IS_USED,KRI_DISP,CODE_DISP_ENG) VALUES ('ART','ART_DOC_TYPE_CD','DOCTYPE',0,'Y','','DOCTYPE');
INSERT INTO "RI_CODE_TRANS" (GUBUN,CODE_VALUE,CODE_DISP,DISP_ORDER,IS_USED,KRI_DISP,CODE_DISP_ENG) VALUES ('ART','ART_KEYWORD','주제 키워드',0,'Y','','KEYWORDS');
INSERT INTO "RI_CODE_TRANS" (GUBUN,CODE_VALUE,CODE_DISP,DISP_ORDER,IS_USED,KRI_DISP,CODE_DISP_ENG) VALUES ('ART','ART_PUB_DATE','온라인 게재일',0,'Y','','ONLINE PUBLISHED');
INSERT INTO "RI_CODE_TRANS" (GUBUN,CODE_VALUE,CODE_DISP,DISP_ORDER,IS_USED,KRI_DISP,CODE_DISP_ENG) VALUES ('ART','ART_SUB_DATE','투고일',0,'Y','','RECIEVED');
INSERT INTO "RI_CODE_TRANS" (GUBUN,CODE_VALUE,CODE_DISP,DISP_ORDER,IS_USED,KRI_DISP,CODE_DISP_ENG) VALUES ('ART','ART_FIX_DATE','게재확정일',0,'Y','','ACCEPTED');
INSERT INTO "RI_CODE_TRANS" (GUBUN,CODE_VALUE,CODE_DISP,DISP_ORDER,IS_USED,KRI_DISP,CODE_DISP_ENG) VALUES ('ART','ART_ACK_CONT','사사표기',0,'Y','','ACKNOWLEDGEMENT');
INSERT INTO "RI_CODE_TRANS" (GUBUN,CODE_VALUE,CODE_DISP,DISP_ORDER,IS_USED,KRI_DISP,CODE_DISP_ENG) VALUES ('ART','ART_AUTHOR_DEPT','학(부)과',0,'Y','','DEPARTMENT');

/*Migration VI_ARTICLE_AUTHORS */

  CREATE OR REPLACE FORCE VIEW "VI_ARTICLE_AUTHORS" ("ARTICLE_ID", "AUTHORS", "AUTHORS_INFO") AS
  SELECT ARTICLE_ID,
    LISTAGG (NAME_DISP, ';') WITHIN GROUP (ORDER BY DISP_ORDER) AS AUTHORS,
    LISTAGG (AUTHOR_INFO, ';') WITHIN GROUP (ORDER BY DISP_ORDER) AS AUTHORS_INFO
  FROM
    ( SELECT ROWNUM AS CNT,
              A.*,
             DECODE (A.PRTCPNT_FULL_NM, NULL,
                     CASE WHEN  B.FIRST_NAME is null and B.FIRST_NAME is null  THEN  ''
                      ELSE  B.LAST_NAME|| ', '|| B.FIRST_NAME
                      END
                    , A.PRTCPNT_FULL_NM) AS NAME_DISP
            ,B.AUTHOR_INFO || ','  || A.TPI_DVS_CD as  AUTHOR_INFO
    FROM
      ( SELECT DISTINCT ARTICLE_ID,
        PRTCPNT_ID            AS USER_ID,
        MAX (PRTCPNT_FULL_NM) AS PRTCPNT_FULL_NM,
        MAX (DISP_ORDER)      AS DISP_ORDER,
        MAX (TPI_DVS_CD)      AS TPI_DVS_CD
      FROM RI_ARTICLE_PARTI
      WHERE PRTCPNT_ID          IS NOT NULL
      AND NVL (DEL_DVS_CD, 'N') != 'Y'
      GROUP BY ARTICLE_ID,
        PRTCPNT_ID
      ) A,
      (
        select USER_ID, GUBUN, DEL_DVS_CD, FIRST_NAME, LAST_NAME, KOR_NM || ',' || USER_ID || ',' || POSI_NM || ',' || DEPT_KOR AS AUTHOR_INFO
         from RI_USER
      )B
    WHERE A.USER_ID              = B.USER_ID
    AND B.GUBUN                 IN ('M', 'U')
    AND NVL (B.DEL_DVS_CD, 'N') <> 'Y'
    AND B.GUBUN                 != 'S'
    )
  GROUP BY ARTICLE_ID;


/* Migration RI_MESSAGE */
alter table "RI_MESSAGE" add("REG_USER_ID" VARCHAR2(20 Byte));
 COMMENT ON COLUMN "RI_MESSAGE"."REG_USER_ID" IS '등록자ID';


/* Migration RA_ANALS_EXCL_TRGET */
  CREATE TABLE "RA_ANALS_EXCL_TRGET"
   ( "SN" NUMBER NOT NULL ENABLE,
  "GROUP_TY" VARCHAR2(30 BYTE),
  "TRGET_IDNTFR" VARCHAR2(100 BYTE),
  "REG_USER_ID" VARCHAR2(30 BYTE),
  "REG_DATE" DATE NOT NULL ENABLE
   ) TABLESPACE "RIMS" ;


   COMMENT ON TABLE "RA_ANALS_EXCL_TRGET"  IS '분석_제외_대상';

/* DEPT_CLG_MAP update is_used by RI_USER gubun = 'M'(전임) and HLDOF_YN = '1'(재직) */
update DEPT_CLG_MAP set IS_USED = 'N';
update DEPT_CLG_MAP set IS_USED = 'Y'  where DEPT_KOR_NM IN (select GROUP_DEPT from RI_USER where GUBUN = 'M' and HLDOF_YN = '1' group by GROUP_DEPT);


--select MAX(ID) from COM_ORG_ALIAS;
--sequence (start with 3318)
  CREATE SEQUENCE  "SEQ_COM_ORG_ALIAS" MINVALUE 0 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 3318 CACHE 20 NOORDER  NOCYCLE ;
  alter table "COM_ORG_ALIAS" add("REG_USER_ID" VARCHAR2(20 BYTE));
  alter table "COM_ORG_ALIAS" rename column "REGDATE" to "REG_DATE";
  alter table "COM_ORG_ALIAS" add("MOD_USER_ID" VARCHAR2(20 BYTE));
  alter table "COM_ORG_ALIAS" rename column "CHGDATE" to "MOD_DATE";


  /* code trans update */
  update RI_CODE_TRANS  SET  CODE_DISP = 'NO'  where GUBUN = 'ART'  and CODE_VALUE = 'ART_ORDER';

  --CREATE INDEX "IDX_RI_ARTICLE_1" ON "RI_ARTICLE" ("ID_SCI") TABLESPACE "RIMS" ;
  --CREATE INDEX "IDX_RI_ARTICLE_2" ON "RI_ARTICLE" ("ID_SCOPUS") TABLESPACE "RIMS" ;
  CREATE INDEX "IDX_RI_ARTICLE_9" ON "RI_ARTICLE" ("DEL_DVS_CD") TABLESPACE "RIMS" ;
  CREATE INDEX "IDX_RI_ARTICLE_10" ON "RI_ARTICLE" ("PBLC_YM") TABLESPACE "RIMS" ;
  CREATE INDEX "IDX_RI_ARTICLE_11" ON "RI_ARTICLE" (SUBSTR("PBLC_YM",1,4)) TABLESPACE "RIMS" ;
  CREATE INDEX "IDX_RI_ARTICLE_12" ON "RI_ARTICLE" ("ARTICLE_ID", "ISSN_NO") TABLESPACE "RIMS" ;
  CREATE INDEX "IDX_RI_ARTICLE_13" ON "RI_ARTICLE" (NVL("DEL_DVS_CD",'N')) TABLESPACE "RIMS" ;
  CREATE INDEX "IDX_RI_ARTICLE_14" ON "RI_ARTICLE" (SUBSTR("PBLC_YM",0,4)) TABLESPACE "RIMS" ;
  CREATE INDEX "IDX_RI_ARTICLE_15" ON "RI_ARTICLE" ("ARTICLE_ID", NVL("DEL_DVS_CD",'N')) TABLESPACE "RIMS" ;
  CREATE INDEX "IDX_RI_ARTICLE_16" ON "RI_ARTICLE" ("ARTICLE_ID", NVL("DEL_DVS_CD",'N'), NVL("IMPCT_FCTR",'0'), NVL("SJR",'0')) TABLESPACE "RIMS" ;
  CREATE INDEX "IDX_RI_ARTICLE_17" ON "RI_ARTICLE" ("ARTICLE_ID", "APPR_DVS_CD", "SCJNL_DVS_CD", NVL("DEL_DVS_CD",'N'), SUBSTR("PBLC_YM",0,4)) TABLESPACE "RIMS" ;
  CREATE INDEX "IDX_RI_ARTICLE_18" ON "RI_ARTICLE" ("ARTICLE_ID", "APPR_DVS_CD", NVL("DEL_DVS_CD",'N'), SUBSTR("PBLC_YM",0,4)) TABLESPACE "RIMS" ;
  CREATE INDEX "IDX_RI_ARTICLE_19" ON "RI_ARTICLE" ("APPR_DVS_CD", NVL("DEL_DVS_CD",'N'), SUBSTR("PBLC_YM",0,4)) TABLESPACE "RIMS" ;

/* RI_ARTICLE 출처구분  */
alter table "RI_ARTICLE" add("ORIGIN_SE" VARCHAR2(100));

create table JCR_APPLC_YEAR (
  SN      NUMBER(11) not null,
  JCR_YEAR    varchar2(10 Byte),
  BEGIN_DE    varchar2(8 Byte),
  END_DE    varchar2(8 Byte),
  RGS_DE    DATE,
  REGISTER_ID     varchar2(20 Byte)
);


insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(1, '1992', null,'19921231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(2, '1993', '19930101','19931231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(3, '1994', '19940101','19941231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(4, '1995', '19950101','19951231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(5, '1996', '19960101','19961231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(6, '1997', '19970101','19971231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(7, '1998', '19980101','19981231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(8, '1999', '19990101','19991231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(9, '2000', '20000101','20001231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(10, '2001', '20010101','20011231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(11, '2002', '20020101','20021231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(11, '2003', '20030101','20031231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(13, '2004', '20040101','20041231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(14, '2005', '20050101','20051231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(15, '2006', '20060101','20061231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(16, '2007', '20070101','20071231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(17, '2008', '20080101','20081231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(18, '2009', '20090101','20091231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(19, '2010', '20100101','20101231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(20, '2011', '20110101','20111231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(21, '2012', '20120101','20121231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(22, '2013', '20130101','20131231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(23, '2014', '20140101', '20141231',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(24, '2015', '20150101', null,sysdate,'system');

/* kci import menu */
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG,IS_USED) values ('menu.kci','메뉴명 - KCI','KCI','Y');
insert into RI_I18N_DETAIL (CODE,LANG,MSG) values ('menu.kci','ko','KCI');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG,IS_USED) values ('menu.kci.import','메뉴명 - KCI 데이터 반입','Import Data','Y');
insert into RI_I18N_DETAIL (CODE,LANG,MSG) values ('menu.kci.import','KO','데이터 반입');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG,IS_USED) values ('menu.kci.identify','메뉴명 - KCI 저자식별','Researcher Identify','Y');
insert into RI_I18N_DETAIL (CODE,LANG,MSG) values ('menu.kci.identify','KO','저자식별');

/* track menu 2016.02.05 */
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED) values('menu.track','메뉴명 - Track관리','Track Manage','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG) values('menu.track', 'ko', 'Track 관리');

/* org-alias menu */
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED) values('menu.orgalias','메뉴명 - 기관전거관리','ORG-Alias Manage','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG) values('menu.orgalias', 'ko', '기관명전거관리');

commit;

 CREATE TABLE RI_ARTICLE_AUTHORS (
  ARTICLE_ID number(10) DEFAULT NULL ,
  AUTHORS clob DEFAULT NULL ,
  AUTHORS_INFO clob DEFAULT NULL ,
  PRTCPNTS clob DEFAULT NULL ,
  PRIMARY KEY (ARTICLE_ID)
) TABLESPACE "RIMS" ;

COMMENT ON TABLE "RI_ARTICLE_AUTHORS"  IS '논문저자정보';
COMMENT ON COLUMN "RI_ARTICLE_AUTHORS"."ARTICLE_ID" IS '논문ID';
COMMENT ON COLUMN "RI_ARTICLE_AUTHORS"."AUTHORS" IS '논문저자명';
COMMENT ON COLUMN "RI_ARTICLE_AUTHORS"."AUTHORS_INFO" IS '논문저자정보';
COMMENT ON COLUMN "RI_ARTICLE_AUTHORS"."PRTCPNTS" IS '저자테이블저자명';


insert into RI_ARTICLE_AUTHORS (ARTICLE_ID, AUTHORS, AUTHORS_INFO)
select ARTICLE_ID
     , AUTHORS
     , AUTHORS_INFO
from VI_ARTICLE_AUTHORS TA;

commit;


insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.overview','메뉴명 - About Overview','Overview','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.overview', 'ko', '요약');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.latest','메뉴명 - About Latest SCI Articles','Latest SCI Articles','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.latest', 'ko', '최근게재논문');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.trend','메뉴명 - About SCI Trends by year','SCI Trends by year','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.trend', 'ko', '연도별 논문건수');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.sbuject','메뉴명 - About Subject Trends by year','Subject Trends by year','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.sbuject', 'ko', '연도별 최다 논문 게재<br/> 연구분야 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.ranking','메뉴명 - About IF Ranking by Cat.','IF Ranking by Cat.','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.ranking', 'ko', '학술지 분야별 IF');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.journal','메뉴명 - About Journal by Dept.','Journal by Dept.','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.journal', 'ko', '연도별 최다 논문 게재<br/> 학술지 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.coauthor','메뉴명 - About 공동연구 네트워크','공동연구 네트워크','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.coauthor', 'ko', '공동연구 네트워크');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.sbuject.page','메뉴명 - About Subject Trends by year','Subject Trends by year','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.sbuject.page', 'ko', '연도별 최다 논문 게재 연구분야 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.journal.page','메뉴명 - About Journal by Dept.','Journal by Dept.','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.journal.page', 'ko', '연도별 최다 논문 게재 학술지 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.overview.scilatest','메뉴명 - About 최근SCI논문','최근SCI논문','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.overview.scilatest', 'ko', '최근SCI논문');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.overview.kcilatest','메뉴명 - About 최근KCI논문','최근KCI논문','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.overview.kcilatest', 'ko', '최근KCI논문');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.overview.scplatest','메뉴명 - About 최근 SCOPUS논문','최근 SCOPUS논문','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.overview.scplatest', 'ko', '최근 SCOPUS논문');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.overview.scitrend','메뉴명 - About 연도별 SCI 논문수','연도별 SCI 논문수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.overview.scitrend', 'ko', '연도별 SCI 논문수');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.overview.kcitrend','메뉴명 - About 연도별 KCI 논문수','연도별 KCI 논문수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.overview.kcitrend', 'ko', '연도별 KCI 논문수');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.overview.scptrend','메뉴명 - About 연도별 SCOPUS 논문수','연도별 SCOPUS 논문수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.overview.scptrend', 'ko', '연도별 SCOPUS 논문수');



/* researcher menu */
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.artco','메뉴명 - Researcher 논문건수 분석','연도별 논문건수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.artco', 'ko', '연도별 논문건수');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.overview','메뉴명 - Researcher Overview','Overview','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.overview', 'ko', '요약');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.profile','메뉴명 - Researcher Overview','Profile','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.profile', 'ko', '프로파일');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.hindex','메뉴명 - Researcher H-index','H-index','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.hindex', 'ko', 'H-index');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.cited','메뉴명 - Researcher Cited vs Uncited','Cited vs Uncited','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.cited', 'ko', '논문 피인용 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.coauthor','메뉴명 - Researcher Co-Author Networks','Co-Author Networks','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.coauthor', 'ko', '공동연구자 네트워크');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.similar','메뉴명 - Researcher Similar Experts','Similar Experts','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.similar', 'ko', '유사 연구자 조회');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.journal','메뉴명 - Researcher Published Journal','Published Journal','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.journal', 'ko', '연도별 최다 논문 게재<br/>학술지 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.patent','메뉴명 - Researcher Trend Patent','특허건수 분석','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.patent', 'ko', '특허건수 분석');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.techtrans','메뉴명 - Researcher Tech-Trans','기술이전','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.techtrans', 'ko', '기술이전');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.journal.page','메뉴명 - Researcher Published Journal','Published Journal','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.journal.page', 'ko', '연도별 최다 논문 게재 학술지 현황');

/* department menu */
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.overview','메뉴명 - Department Overview','요약','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.overview', 'ko', '요약');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.latest','메뉴명 - Department Latest Articles','최근게재논문','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.latest', 'ko', '최근게재논문');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.artco','메뉴명 - Department 논문건수 분석','연도별 논문건수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.artco', 'ko', '연도별 논문건수');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.avgif','메뉴명 - Department 평균IF 분석','평균 IF 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.avgif', 'ko', '평균 IF 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.cited','메뉴명 - Department Citation 분석','논문 피인용 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.cited', 'ko', '논문 피인용 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.hindex','메뉴명 - Department H-index','H-index','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.hindex', 'ko', 'H-index');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.sbuject','메뉴명 - Department 저널 주제별 연구동향','연도별 최다 논문 게재<br/>연구분야 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.sbuject', 'ko', '연도별 최다 논문 게재<br/>연구분야 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.journal','메뉴명 - Department 학과별 투고 저널','연도별 최다 논문 게재<br/>학술지 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.journal', 'ko', '연도별 최다 논문 게재<br/>학술지 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.patent','메뉴명 - Researcher Trend Patent','특허건수 분석','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.patent', 'ko', '특허건수 분석');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.techtrans','메뉴명 - Researcher Tech-Trans','기술이전','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.techtrans', 'ko', '기술이전');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.sbuject.page','메뉴명 - Department 저널 주제별 연구동향','연도별 최다 논문 게재 연구분야 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.sbuject.page', 'ko', '연도별 최다 논문 게재 연구분야 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.journal.page','메뉴명 - Department 학과별 투고 저널','연도별 최다 논문 게재 학술지 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.journal.page', 'ko', '연도별 최다 논문 게재 학술지 현황');

/* college menu */
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.overview','메뉴명 - College Overview','요약','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.overview', 'ko', '요약');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.latest','메뉴명 - College Latest Articles','최근게재논문','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.latest', 'ko', '최근게재논문');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.artco','메뉴명 - College 학과별 논문 건수','학과별 논문 건수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.artco', 'ko', '학과별 논문 건수');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.avgif','메뉴명 - College 평균IF','학과별 평균 IF 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.avgif', 'ko', '학과별 평균 IF 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.cited','메뉴명 - College 학과별 평균 피인용횟수','학과별 평균 논문 피인용현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.cited', 'ko', '학과별 평균 논문 피인용현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.coauthor','메뉴명 - College 학과별 공동연구','학과별 공동연구 네트워크','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.coauthor', 'ko', '학과별 공동연구 네트워크');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.patent','메뉴명 - College Trend Patent','특허건수 분석','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.patent', 'ko', '특허건수 분석');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.techtrans','메뉴명 - College Tech-Trans','기술이전','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.techtrans', 'ko', '기술이전');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.hindex','메뉴명 - College H-index','H-index','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.hindex', 'ko', 'H-index');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.cited.page','메뉴명 - College 학과별 평균 피인용현황 페이지','학과별 평균 논문 피인용현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.cited.page', 'ko', '학과별 평균 논문 피인용현황');

/* Institution menu */
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.hindex','메뉴명 - Institution H-index by Researcher','H-index','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.hindex', 'ko', 'H-index');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.pub','메뉴명 - Institution Researcher by Pub.','연구자별 논문수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.pub', 'ko', '연구자별 논문수');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.artCited','메뉴명 - Institution Article by Citation','논문별 피인용수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.artCited', 'ko', '논문별 피인용수');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.artco','메뉴명 - Institution 학과별 논문 건수','논문 건수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.artco', 'ko', '논문 건수');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.avgif','메뉴명 - Institution 평균IF','평균 IF 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.avgif', 'ko', '평균 IF 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.cited','메뉴명 - Institution 학과별 평균 피인용횟수','평균 논문 피인용현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.cited', 'ko', '평균 논문 피인용현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.coauthor','메뉴명 - Institution 학과별 공동연구','공동연구 네트워크','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.coauthor', 'ko', '공동연구 네트워크');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.patent','메뉴명 - Researcher Trend Patent','특허건수 분석','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.patent', 'ko', '특허건수 분석');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.techtrans','메뉴명 - Researcher Tech-Trans','기술이전','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.techtrans', 'ko', '기술이전');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.logByMenu','메뉴명 - Institution 로그분석 by menu','로그분석 by menu','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.logByMenu', 'ko', '로그분석 by menu');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.logByDate','메뉴명 - Institution 로그분석 by date','로그분석 by date','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.logByDate', 'ko', '기술이전');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.connUser','메뉴명 - Institution 시스템 접속자','시스템 접속자','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.connUser', 'ko', '시스템 접속자');


insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst','메뉴명 - Institution','Institution','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst', 'ko', 'Institution');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg','메뉴명 - College','College','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg', 'ko', 'College');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept','메뉴명 - Department','Department','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept', 'ko', 'Department');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch','메뉴명 - Researcher','Researcher','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch', 'ko', 'Researcher');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about','메뉴명 - About SCI','About KAIST SCI','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about', 'ko', 'About KAIST SCI');

select `` from RI_ARTICLE_PARTI where ARTICLE_ID = TA.ARTICLE_ID and NVL(DEL_DVS_CD, 'N') != 'Y';


update RI_JOURNAL_MASTER
  set
       SCIE = DECODE(SCIE, 'X', '1', null)
      ,SCI = DECODE(SCI, 'X', '1', null)
      ,SSCI = DECODE(SSCI, 'X', '1', null)
      ,AHCI = DECODE(AHCI, 'X', '1', null)
      ,SCOPUS = DECODE(SCOPUS, 'X', '1', null)
      ,KCI = DECODE(KCI, 'X', '1', null)
;     



