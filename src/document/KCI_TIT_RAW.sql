/**
 * 1. 반일을 위한 작업테이블 생성
 */
  CREATE TABLE "KCI_TIT_RAW"
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
	 "KCI_WOS_IF" NUMBER(7,3),
	 "KCI_IF" NUMBER(7,3),
	 "SELF_CTS_EXCL_KCI_IF" VARCHAR2(10 BYTE),
	 "CENTER_IDEX_3YRS" VARCHAR2(10 BYTE),
	 "IMDTL_IDEX" VARCHAR2(10 BYTE),
	 "SELF_CTS_RATE_2YRS" VARCHAR2(10 BYTE),
	 "CTS_DOC_2YRS" VARCHAR2(10 BYTE),
	 "WOS_CTS_DOC_2YRS" VARCHAR2(10 BYTE),
	 "JRNL_ID" NUMBER(11,0),
 	 "REGDATE" DATE
   ) TABLESPACE "TS_R2RIMS_YU" ;

   COMMENT ON TABLE "KCI_TIT_RAW"  IS 'KCI 인용지수 반입을 위한 작업테이블';

   CREATE TABLE "KCI_CAT_RANK_RAW"
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

COMMENT ON TABLE "KCI_CAT_RANK_RAW"  IS 'KCI 카테고리별 랭킹 생성을 위한 작업테이블';

/**
 * 2. Import data to 작업테이블 (sqldeveloper 사용)
 */
-- ISSN 값이 정상적인지 확인 필요

delete from KCI_TIT_RAW where PRODYEAR = '2009';

/**
 * 3. CATNAME을 통해 RD_SUBJECT에서 CATEG 코드 값 채워기
 * */

update KCI_TIT_RAW TA
   set CATEG = (
                    select CATCODE
                    from RD_SUBJECT
                    where PRODCODE = 'KCI'
                    and DESCRIPTION = TA.CATNAME
                    and CATCODE like DECODE( TA.UP_CATNAME,
                                               '인문학','A%',
                                               '사회과학','B%',
                                               '자연과학','C%',
                                               '공학','D%',
                                               '의약학','E%',
                                               '농수해양','F%',
                                               '예술체육','G%',
                                               '복합학','H%',
                                               'ZZZZ'          )
                    group by CATCODE
                )
where PRODYEAR = '2009'
;


/**
 * 4. ISSN를 이횽하여 저널마스터에서 JNDL_ID 값 채우기
 * */
MERGE INTO KCI_TIT_RAW TA USING
    (SELECT JRNL_ID,
           ISSN
      FROM RI_JOURNAL_MASTER
    ) TB ON (TA.PRODYEAR='2008' AND TA.ISSN=TB.ISSN )
WHEN MATCHED THEN
       UPDATE
              SET TA.JRNL_ID = TB.JRNL_ID
;

-- Test Select Query
SELECT PRODYEAR,
      TITLE,
      PUBLISHER,
      ISSN,
      'X',
      DECODE(NVL(REGST_AT,'0'),'등재','2','후보','1',null),
      SYSDATE
 FROM KCI_TIT_RAW
WHERE JRNL_ID IS NULL
  AND ISSN is not null
  AND PRODYEAR = '2008'
;

INSERT INTO RI_JOURNAL_MASTER
      (
          JRNL_ID,
          YEAR,
          TITLE,
          PU_KCI,
          ISSN,
          KCI,
          KCI_GUBUN,
          REG_DATE
      )
SELECT SEQ_RI_JOURNAL_MASTER.NEXTVAL,
      PRODYEAR,
      TITLE,
      PUBLISHER,
      ISSN,
      'X',
      DECODE(NVL(REGST_AT,'0'),'등재','2','후보','1',null),
      SYSDATE
 FROM KCI_TIT_RAW
WHERE JRNL_ID IS NULL
  AND ISSN is not null
  AND PRODYEAR = '2008'
;

merge into RI_JOURNAL_MASTER JM
  using (
          select TITLE
                 ,PUBLISHER
                 ,ISSN
                 ,DECODE(NVL(REGST_AT,'0'),'등재','2','후보','1',null) as REGST_AT
           from KCI_TIT
           where PRODYEAR = '2008'
            and ISSN is not null
            and ISSN not in ('1225-9489','1225-9489','1226-1874','1226-301X','1226-8526','1229-0521','1229-9154','1738-1592')
        ) TA on (JM.ISSN = TA.ISSN)
WHEN MATCHED THEN
   UPDATE
      SET  JM.KCI = 'X'
          ,JM.PU_KCI = TA.PUBLISHER
          ,JM.KCI_GUBUN = TA.REGST_AT
;

/**
 * 5. select 하여  KCI_CAT_RANK_RAW에 insert 하기
 * */
insert into KCI_CAT_RANK_RAW (  ID, PRODYEAR, CATEG, CATNAME, KCI_IF, ISSN, TITLE ) select ROWNUM, PRODYEAR, CATEG, CATNAME, KCI_IF, ISSN, TITLE from KCI_TIT_RAW where PRODYEAR = '2008'
;

MERGE INTO KCI_CAT_RANK_RAW TA USING
    (SELECT PRODYEAR, CATEG, COUNT(*) C
      FROM KCI_CAT_RANK_RAW
     WHERE PRODYEAR = '2008'
     GROUP BY CATEG, PRODYEAR
    ) TB ON ( TA.PRODYEAR = '2008' AND TA.PRODYEAR = TB.PRODYEAR AND TA.CATEG = TB.CATEG)
WHEN MATCHED THEN  UPDATE SET TA.CNT = TB.C
;

UPDATE KCI_CAT_RANK_RAW TA
       SET TA.RANK=
       (SELECT COUNT(*)+1
         FROM KCI_CAT_RANK_RAW TB
        WHERE TA.PRODYEAR=TB.PRODYEAR
              AND TB.CATEG=TA.CATEG
              AND TO_NUMBER(NVL(TB.KCI_IF,0))>TO_NUMBER(NVL(TA.KCI_IF,0))
       )
 WHERE TA.PRODYEAR = '2008'
;

UPDATE KCI_CAT_RANK_RAW
       SET RATIO=TO_NUMBER((RANK/CNT)*100)
 WHERE PRODYEAR = '2008'
;

/**
 * 6. select 하여 KCI_TIT 에 inset 하기
 * */
INSERT INTO KCI_TIT
(
ID,
PRODYEAR,
ISSN,
TOTAL_DOCS,
TITLE,
PUBLISHER,
REGST_AT,
GUBUN,
CATEG,
CATNAME,
UP_CATNAME,
KCI_WOS_IF,
KCI_IF,
SELF_CTS_EXCL_KCI_IF,
CENTER_IDEX_3YRS,
IMDTL_IDEX,
SELF_CTS_RATE_2YRS,
CTS_DOC_2YRS,
WOS_CTS_DOC_2YRS,
JRNL_ID,
REGDATE
)
select
SEQ_KCI_TIT.nextval,
PRODYEAR,
ISSN,
TOTAL_DOCS,
TITLE,
PUBLISHER,
REGST_AT,
GUBUN,
CATEG,
CATNAME,
UP_CATNAME,
KCI_WOS_IF,
KCI_IF,
SELF_CTS_EXCL_KCI_IF,
CENTER_IDEX_3YRS,
IMDTL_IDEX,
SELF_CTS_RATE_2YRS,
CTS_DOC_2YRS,
WOS_CTS_DOC_2YRS,
JRNL_ID,
SYSDATE
from KCI_TIT_RAW
where PRODYEAR = '2008'
;

insert into KCI_CAT_RANK
(
ID,
PRODYEAR,
CATEG,
CATNAME,
CATORDER,
RANK,
KCI_IF,
ISSN,
RATIO,
TITLE,
CNT
)
select
SEQ_KCI_CAT_RANK.nextval,
PRODYEAR,
CATEG,
CATNAME,
CATORDER,
RANK,
KCI_IF,
ISSN,
RATIO,
TITLE,
CNT
from KCI_CAT_RANK_RAW
where PRODYEAR = '2008'
;


 update RI_ARTICLE TA
   set
      TA.KCI_IF = (select MAX(KCI_IF) from KCI_TIT where ISSN = TA.ISSN_NO and PRODYEAR = '2010')
where SUBSTR(TA.PBLC_YM, 0, 4) IN ('2010','2011');

 update RI_ARTICLE TA
   set
      TA.KCI_IF = (select MAX(KCI_IF) from KCI_TIT where ISSN = TA.ISSN_NO and PRODYEAR = '2011')
where SUBSTR(TA.PBLC_YM, 0, 4) IN ('2011','2012');

 update RI_ARTICLE TA
   set
      TA.KCI_IF = (select MAX(KCI_IF) from KCI_TIT where ISSN = TA.ISSN_NO and PRODYEAR = '2012')
where SUBSTR(TA.PBLC_YM, 0, 4) IN ('2012','2013');

 update RI_ARTICLE TA
   set
      TA.KCI_IF = (select MAX(KCI_IF) from KCI_TIT where ISSN = TA.ISSN_NO and PRODYEAR = '2013')
where SUBSTR(TA.PBLC_YM, 0, 4) IN ('2013','2014');

 update RI_ARTICLE TA
   set
      TA.KCI_IF = (select MAX(KCI_IF) from KCI_TIT where ISSN = TA.ISSN_NO and PRODYEAR = '2014')
where SUBSTR(TA.PBLC_YM, 0, 4) IN ('2014','2015');
