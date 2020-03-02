/* 1) Table backup
 *
 *    ER_ARTICLE_AUTHR
 *    ER_ARTICLE_ADRES
 *    ER_ARTICLE_AUTHR_ADRES
 *    ER_ARTICLE
 *
 * */

-- ⓐ 백업을 위한 테이블 생성하고 select 하여 insert하기
CREATE TABLE ER_ARTICLE_AUTHR_160225(
	SOURC_IDNTFC_NO VARCHAR2(20)
	,AUTHR_SEQ NUMBER(4)
	,AUTHR_ABRV VARCHAR2(200)
	,AUTHR_NM VARCHAR2(200)
	,RE_PERNO VARCHAR2(20)
	,RE_DATE DATE
	,RE_USER VARCHAR2(20)
	,MIG_COMPLETED CHAR(1) DEFAULT 'Y'
	,IS_APPROVAL CHAR(1) DEFAULT 'N'
	,ARTICLE_ID NUMBER(11)
	,VA_DATE DATE
	,VA_USER VARCHAR2(20)
	,AUTHR_ORDER NUMBER(11)
	,TPI_DVS_CD VARCHAR2(20)
	,ORCID VARCHAR2(50)
	,RID VARCHAR2(50)
	,KCI_AUTHR_ID VARCHAR2(50)
);

insert into ER_ARTICLE_AUTHR_160225 select * from ER_ARTICLE_AUTHR;


CREATE TABLE ER_ARTICLE_AUTHR_ADRES_160225(
	SOURC_IDNTFC_NO VARCHAR2(20)
	,AUTHR_SEQ NUMBER(4)
	,ADRES_SEQ NUMBER(4)
	,ARTICLE_ID NUMBER(11)
);

insert into ER_ARTICLE_AUTHR_ADRES_160225 select * from ER_ARTICLE_AUTHR_ADRES;

CREATE TABLE ER_ARTICLE_ADRES_160225(
	SOURC_IDNTFC_NO VARCHAR2(20)
	,ADRES_SEQ NUMBER(4)
	,AUTHOR VARCHAR2(4000)
	,ADDRESS CLOB(4000)
	,ADD1 VARCHAR2(1000)
	,ADD2 VARCHAR2(1000)
	,ADD3 VARCHAR2(100)
	,RE_INST VARCHAR2(500)
	,RE_DEPT VARCHAR2(500)
	,RE_COUNTRY VARCHAR2(50)
	,RE_DATE DATE
	,RE_USER VARCHAR2(20)
	,ARTICLE_ID NUMBER(11)
	,VA_USER VARCHAR2(20)
	,VA_DATE DATE
);

insert into ER_ARTICLE_ADRES_160225 select * from ER_ARTICLE_ADRES;

CREATE TABLE ER_ARTICLE_160225(
	SOURC_IDNTFC_NO VARCHAR2(20)
	,PBLCATE_TYPE VARCHAR2(20)
	,ARTICLE_TTL VARCHAR2(500)
	,PLSCMPN_NM VARCHAR2(200)
	,LANG VARCHAR2(20)
	,DOC_TYPE VARCHAR2(100)
	,ADIT_KWRD VARCHAR2(3000)
	,AUTHR_KWRD VARCHAR2(3000)
	,PBLSHR_NM VARCHAR2(100)
	,PBLSHR_CITY VARCHAR2(100)
	,PBLSHR_ADRES VARCHAR2(200)
	,TC NUMBER(11)
	,TC_DATE DATE
	,ISSN VARCHAR2(20)
	,ARTICLE_ABRV VARCHAR2(30)
	,ISO_ARTICLE_ABRV VARCHAR2(200)
	,PBLCATE_DATE VARCHAR2(20)
	,PBLCATE_YEAR VARCHAR2(10)
	,VLM VARCHAR2(20)
	,ISSUE VARCHAR2(20)
	,BEGIN_PAGE VARCHAR2(20)
	,END_PAGE VARCHAR2(20)
	,DOI VARCHAR2(100)
	,SUBJCT_CTGRY VARCHAR2(1000)
	,ARTICLE_DELY_NO VARCHAR2(100)
	,RPNT_ADRES VARCHAR2(500)
	,EMAIL_ADRES VARCHAR2(1000)
	,TR_PC VARCHAR2(50)
	,RE_IF VARCHAR2(10)
	,RE_DATE DATE
	,RE_USER VARCHAR2(20)
	,DPLCT_SOURC_IDNTFC_NO VARCHAR2(20)
	,ARTL_TIMEP VARCHAR2(4)
	,STATUS CHAR(1) DEFAULT 'I'
	,REGDATE DATE
	,MIG_COMPLETED CHAR(1) DEFAULT 'N'
	,MIG_USER VARCHAR2(20)
	,MIG_DATE DATE
	,IS_APPROVAL CHAR(1)
	,TR_PD CHAR(2)
	,ARTICLE_ID NUMBER(11)
	,ABSTRCT CLOB(4000)
	,ISBN VARCHAR2(200)
	,CFRNC_NM VARCHAR2(400)
	,CFRNC_DATE VARCHAR2(400)
	,CFRNC_LOC VARCHAR2(400)
	,CFRNC_CD VARCHAR2(400)
	,RE_PC VARCHAR2(10)
	,RE_LA VARCHAR2(10)
	,SOURC_DVSN_CD VARCHAR2(20)
	,VA_DATE DATE
	,VA_USER VARCHAR2(20)
	,FU VARCHAR2(1000)
	,WOS_CTGRY VARCHAR2(1000)
	,DIFF_LANG_TTL VARCHAR2(500)
);

insert into ER_ARTICLE_160225 select * from ER_ARTICLE;


select MAX(ARTICLE_ID) from ER_ARTICLE where TO_CHAR(REGDATE,'YYYYMMDD') < TO_CHAR(sysdate,'YYYYMMDD');

/*
 * 2) Migration 대상 확인 및 삭제처리
 *
 * 	  ER_ARTICLE_AUTHR 			2,329
 *    ER_ARTICLE_ADRES  		1,666
 *    ER_ARTICLE_AUTHR_ADRES    2,525
 *
 * */


select *
from ER_ARTICLE_AUTHR
where SOURC_IDNTFC_NO IN (select SOURC_IDNTFC_NO from URP_ARTICLE_RAWDATA_160225 where SEQ >  47252 group by SOURC_IDNTFC_NO)
and ARTICLE_ID > 20364
;
delete from ER_ARTICLE_AUTHR
where SOURC_IDNTFC_NO IN (select SOURC_IDNTFC_NO from URP_ARTICLE_RAWDATA_160225 where SEQ >  47252 group by SOURC_IDNTFC_NO)
and ARTICLE_ID > 20364
;

select *
from ER_ARTICLE_ADRES
where SOURC_IDNTFC_NO IN (select SOURC_IDNTFC_NO from URP_ARTICLE_RAWDATA_160225 where SEQ >  47252 group by SOURC_IDNTFC_NO)
and ARTICLE_ID > 20364
;
delete from ER_ARTICLE_ADRES
where SOURC_IDNTFC_NO IN (select SOURC_IDNTFC_NO from URP_ARTICLE_RAWDATA_160225 where SEQ >  47252 group by SOURC_IDNTFC_NO)
and ARTICLE_ID > 20364
;

select *
from ER_ARTICLE_AUTHR_ADRES
where SOURC_IDNTFC_NO IN (select SOURC_IDNTFC_NO from URP_ARTICLE_RAWDATA_160225 where SEQ >  47252 group by SOURC_IDNTFC_NO)
and ARTICLE_ID > 20364
;
delete from ER_ARTICLE_AUTHR_ADRES
where SOURC_IDNTFC_NO IN (select SOURC_IDNTFC_NO from URP_ARTICLE_RAWDATA_160225 where SEQ >  47252 group by SOURC_IDNTFC_NO)
and ARTICLE_ID > 20364
;


/*
 * 2) 입력할 데이터 생성하기 URP_ARTICLE_RAWDATA_160225 로부터
 *
 * 	  ER_ARTICLE_AUTHR
 *    ER_ARTICLE_ADRES
 *    ER_ARTICLE_AUTHR_ADRES
 *
 * */


select TA.SOURC_IDNTFC_NO
       ,TB.ARTICLE_ID
       ,TA.AUTHR_NM
       ,DECODE(INSTR(TA.PERNO,'GEN'), 0, TA.PERNO, DECODE(TA.RANGE_GUBUN, '교내', '99999999', '') )  as RE_PERNO
       ,row_number()over(partition by TA.Sourc_Idntfc_No order by TA.seq) as AUTHR_SEQ
       ,row_number()over(partition by TA.Sourc_Idntfc_No order by TA.seq) as AUTHR_ORDER
       ,DECODE(TA.DTL_TPI_DVS_CD, '제1저자', '2','교신저자', '3', '공동', '4', '4') as TPI_DVS_CD
from URP_ARTICLE_RAWDATA_160225 TA
    , ER_ARTICLE TB
where TA.SOURC_IDNTFC_NO = TB.SOURC_IDNTFC_NO
 and TA.SEQ >  47252
 and TB.ARTICLE_ID > 20364
;

insert into ER_ARTICLE_AUTHR (SOURC_IDNTFC_NO, AUTHR_SEQ, AUTHR_ABRV, AUTHR_NM, RE_PERNO, ARTICLE_ID, AUTHR_ORDER, TPI_DVS_CD)
select TA.SOURC_IDNTFC_NO
       ,row_number()over(partition by TA.Sourc_Idntfc_No order by TA.seq) as AUTHR_SEQ
       ,TA.AUTHR_NM
       ,TA.AUTHR_NM
       ,DECODE(INSTR(TA.PERNO,'GEN'), 0, TA.PERNO, DECODE(TA.RANGE_GUBUN, '교내', '99999999', '') )  as RE_PERNO
	   ,TB.ARTICLE_ID
       ,row_number()over(partition by TA.Sourc_Idntfc_No order by TA.seq) as AUTHR_ORDER
       ,DECODE(TA.DTL_TPI_DVS_CD, '제1저자', '2','교신저자', '3', '공동', '4', '4') as TPI_DVS_CD
from URP_ARTICLE_RAWDATA_160225 TA
    , ER_ARTICLE TB
where TA.SOURC_IDNTFC_NO = TB.SOURC_IDNTFC_NO
 and TA.SEQ >  47252
 and TB.ARTICLE_ID > 20364
;

select TA.SOURC_IDNTFC_NO
       ,TB.ARTICLE_ID
       ,TA.AUTHR_NM as AUTHOR
       ,TA.BLNG_ACG_NM as ADDRESS
       ,row_number()over(partition by TA.Sourc_Idntfc_No order by TA.seq) as ADRES_SEQ
       ,TA.PERNO
       ,DECODE(INSTR(TA.PERNO,'GEN'), 0, '영남대학교', TA.BLNG_ACG_NM) as ADD1
       ,TA.EMP_ACG_NM as ADD2
       ,DECODE(INSTR(TA.PERNO,'GEN'), 0, '영남대학교', DECODE(NVL(TA.INTEGRATED_BLNG_ACG_NM,'0'), '0', TA.BLNG_ACG_NM, TA. INTEGRATED_BLNG_ACG_NM) ) as RE_INST
from URP_ARTICLE_RAWDATA_160225 TA
    , ER_ARTICLE TB
where TA.SOURC_IDNTFC_NO = TB.SOURC_IDNTFC_NO
 and TA.SEQ >  47252
 and TB.ARTICLE_ID > 20364
;

insert into ER_ARTICLE_ADRES (SOURC_IDNTFC_NO, ADRES_SEQ, AUTHOR, ADDRESS, ADD1, ADD2, ADD3, RE_INST, ARTICLE_ID)
select TA.SOURC_IDNTFC_NO
       ,row_number()over(partition by TA.Sourc_Idntfc_No order by TA.seq) as ADRES_SEQ
       ,TA.AUTHR_NM as AUTHOR
       ,TA.BLNG_ACG_NM as ADDRESS
       ,DECODE(INSTR(TA.PERNO,'GEN'), 0, '영남대학교', TA.BLNG_ACG_NM) as ADD1
       ,TA.EMP_ACG_NM as ADD2
       ,'' as ADD3
       ,DECODE(INSTR(TA.PERNO,'GEN'), 0, '영남대학교', DECODE(NVL(TA.INTEGRATED_BLNG_ACG_NM,'0'), '0', TA.BLNG_ACG_NM, TA. INTEGRATED_BLNG_ACG_NM) ) as RE_INST
       ,TB.ARTICLE_ID
from URP_ARTICLE_RAWDATA_160225 TA
    , ER_ARTICLE TB
where TA.SOURC_IDNTFC_NO = TB.SOURC_IDNTFC_NO
 and TA.SEQ >  47252
 and TB.ARTICLE_ID > 20364
;

select TA.SOURC_IDNTFC_NO
       ,TB.ARTICLE_ID
       ,row_number()over(partition by TA.Sourc_Idntfc_No order by TA.seq) as AUTHR_SEQ
       ,row_number()over(partition by TA.Sourc_Idntfc_No order by TA.seq) as ADRES_SEQ
from URP_ARTICLE_RAWDATA_160225 TA
    , ER_ARTICLE TB
where TA.SOURC_IDNTFC_NO = TB.SOURC_IDNTFC_NO
 and TA.SEQ >  47252
 and TB.ARTICLE_ID > 20364
;

insert into ER_ARTICLE_AUTHR_ADRES (SOURC_IDNTFC_NO, AUTHR_SEQ, ADRES_SEQ, ARTICLE_ID)
select TA.SOURC_IDNTFC_NO
       ,row_number()over(partition by TA.Sourc_Idntfc_No order by TA.seq) as AUTHR_SEQ
       ,row_number()over(partition by TA.Sourc_Idntfc_No order by TA.seq) as ADRES_SEQ
       ,TB.ARTICLE_ID
from URP_ARTICLE_RAWDATA_160225 TA
    , ER_ARTICLE TB
where TA.SOURC_IDNTFC_NO = TB.SOURC_IDNTFC_NO
 and TA.SEQ >  47252
 and TB.ARTICLE_ID > 20364
;

/*
 * 3) 저자,주소 정보 Migration 한 ER_ARTICLE 작업완료 처리
 *
 * 	  ER_ARTICLE
 *
 * */

update ER_ARTICLE
 set MIG_COMPLETED = 'Y'
 where Sourc_Idntfc_No in (select Sourc_Idntfc_No from URP_ARTICLE_RAWDATA_160225 where SEQ >  47252 group by Sourc_Idntfc_No)
  and ARTICLE_ID > 20364
;


/*
 * 4) 정상적인 프로세스 진행
 *
 */

-- PBLC_YM 일자 넣기

MERGE INTO ER_ARTICLE TA
   USING (
              select SOURC_IDNTFC_NO
                 ,SUBSTR(MAX(RST_DATE),0,4) as PBLCATE_YEAR
                 ,DECODE( SUBSTR(MAX(RST_DATE),5,2), '01','JAN','02','FEB','03','MAR','04','APR','05','MAY','06','JUN','07','JUL','08','AUG','09','SEP','10','OCT','11','NOV','12','DEC','') ||' '|| TO_NUMBER(SUBSTR(MAX(RST_DATE),7,2)) as PBLCATE_DATE
              from URP_ARTICLE_RAWDATA_160225
              where SEQ > 47252
              group by SOURC_IDNTFC_NO
          ) TB  ON (TA.SOURC_IDNTFC_NO = TB.SOURC_IDNTFC_NO )
WHEN MATCHED THEN
   UPDATE SET
          TA.PBLCATE_YEAR = TB.PBLCATE_YEAR
         ,TA.PBLCATE_DATE = TB.PBLCATE_DATE
;

merge into RI_ARTICLE RA
using (
select IR.RIMS_ID, IR.EXRIMS_ID, TA.PBLCATE_DATE
 from INT_RESULT IR
 left join (
                select ARTICLE_ID
                      , PBLCATE_YEAR
                      || CASE SUBSTR(PBLCATE_DATE, 0,3)
                        WHEN 'JAN' THEN '01'
                        WHEN 'FEB' THEN '02'
                        WHEN 'MAR' THEN '03'
                        WHEN 'APR' THEN '04'
                        WHEN 'MAY' THEN '05'
                        WHEN 'JUN' THEN '06'
                        WHEN 'JUL' THEN '07'
                        WHEN 'AUG' THEN '08'
                        WHEN 'SEP' THEN '09'
                        WHEN 'OCT' THEN '10'
                        WHEN 'NOV' THEN '11'
                        WHEN 'DEC' THEN '12'
                        ELSE ''
                        END
                      || NVL( LPAD(TRIM(SUBSTR(PBLCATE_DATE, 4)),2,'1') , '01') as PBLCATE_DATE
                from ER_ARTICLE
                --where article_id not in (20322,20312,20313)
                where article_id > 20364
                  and PBLCATE_DATE is not null
              ) TA on ( IR.EXRIMS_ID = TA.ARTICLE_ID)
 where TA.PBLCATE_DATE is not null
 group by IR.RIMS_ID, IR.EXRIMS_ID, TA.PBLCATE_DATE
 ) TB on (RA.ARTICLE_ID = TB.RIMS_ID)
 	     WHEN MATCHED THEN
			  UPDATE SET
                PBLC_YM = TB.PBLCATE_DATE

;

-- URP 관리번호 RI_ARTICLE 에 Merge하기

merge into RI_ARTICLE TC
 using (
			select Ta.ARTICLE_ID, Tb.Sourc_Idntfc_No, TB.MNG_NO
			from (
					select ARTICLE_ID
					      , DECODE( NVL(RA.ID_SCI,'NONE'), 'NONE', DECODE( NVL(RA.ID_SCOPUS,'NONE'), 'NONE', RA.ID_KCI, RA.ID_SCOPUS), RA.ID_SCI) as Sourc_Idntfc_No
					from RI_ARTICLE RA
					where ARTICLE_ID > 11665
				  ) TA,
				  (
					select Sourc_Idntfc_No, MAX(RST_NO) as MNG_NO from URP_ARTICLE_RAWDATA group by Sourc_Idntfc_No
				   ) TB
			where TA.Sourc_Idntfc_No = TB.Sourc_Idntfc_No
) TD on (TC.ARTICLE_ID = TD.ARTICLE_ID)
	WHEN MATCHED THEN
		  UPDATE SET
      TC.MNG_NO = TD.MNG_NO
;

-- KCI 등재여부 Merge 하기
merge into RI_ARTICLE RA
using (
        select UT as ID_KCI, DECODE(MIN(krfYn), '등재', '1', '2') as KRF_REG_PBLC_YN
        from (
            select UT, extract(xmltype(RAWDATA), '/record/journalInfo/kci-registration/text()').getStringVal() as krfYn
            from RD_IMP_HISTORY
            where DB_TYPE = 'KCI'
             )
        group by UT
) TB on (RA.ID_KCI = TB.ID_KCI)
	WHEN MATCHED THEN
		  UPDATE SET
		  KRF_REG_PBLC_YN = TB.KRF_REG_PBLC_YN


-- URP 비전임 교원, 학생 추가
insert into RI_USER (USER_ID, EMP_ID, KOR_NM, DEPT_KOR, POSI_NM, GRADE1, GUBUN, DEPT_CODE )
select TA.*
     ,(select DEPT_CODE from DEPT_CLG_MAP where DEPT_KOR_NM = TA.DEPT_KOR) as DEPT_CODE
from (
select PERNO as UER_ID
     , PERNO as EMP_ID
     , MAX(AUTHR_NM) as KOR_NM
     , MAX(TRIM(BLNG_ACG_NM)) as DEPT_KOR
     , MAX(POSI_NM)
     , MAX(POSI_NM) as GRADE1
     , case when MAX(POSI_NM) like '%과정' then 'S'
         else case when MAX(POSI_NM) like '%학생%' then 'S'
           else case when MAX(POSI_NM) like '%석사%' then 'S'
              else case when MAX(POSI_NM) like '%박사%' then 'S'
                else case when MAX(POSI_NM) like '%학사%' then 'S'
                else 'U'
                end
              end
            end
         end
     end
     as GUBUN
from URP_ARTICLE_RAWDATA_160225 TA
where SEQ > 47252
 and PERNO not in (select user_id from RI_USER)
 and PERNO not like 'GEN%'
group by PERNO
) TA


merge into RI_USER TA
using (
select USER_ID, DEPT_CODE
from (
select USER_ID
      ,gubun
      ,KOR_NM
      ,DEPT_KOR
      ,(
         select dept_code from dept_clg_map
         where TRIM(Dept_kor_nm) = TRIM(RU.DEPT_KOR)
          and DEPT_CODE not in ('C094100','C094300')
       ) as DEPT_CODE
from RI_USER RU
where gubun = 'U'
 and DEPT_CODE is null
)
where DEPT_CODE is not null
) TB on (TA.USER_ID = TB.USER_ID)
    WHEN MATCHED THEN
		  UPDATE SET TA.DEPT_CODE = TB.DEPT_CODE
;


merge into RI_USER TA
using (
select USER_ID, GUBUN
from (
select USER_ID
      ,POSI_NM
      ,KOR_NM
      , case when POSI_NM like '%과정' then 'S'
         else case when POSI_NM like '%학생%' then 'S'
           else case when POSI_NM like '%석사%' then 'S'
              else case when POSI_NM like '%박사%' then 'S'
                else case when POSI_NM like '%학사%' then 'S'
                else 'U'
                end
              end
            end
         end
     end
     as GUBUN
from RI_USER RU
where gubun = 'U'
)
) TB on (TA.USER_ID = TB.USER_ID)
    WHEN MATCHED THEN
		  UPDATE SET TA.GUBUN = TB.GUBUN
;

merge into RI_USER TA
using (
select PERNO as USER_ID, MAX(POSI_NM) as POSI_NM
from URP_ARTICLE_RAWDATA_160225
where PERNO not like 'GEN%'
 and PERNO not in (select user_id from RI_USER where gubun = 'M')
group by PERNO
) TB on (TA.USER_ID = TB.USER_ID)
    WHEN MATCHED THEN
		  UPDATE SET TA.POSI_NM = TB.POSI_NM
;
