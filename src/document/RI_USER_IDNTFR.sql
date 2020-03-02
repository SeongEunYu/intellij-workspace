/*
 * 저자전거(식별자) 테이블
 *  RI_USER_IDNTFR
 * 
 *  - 도메인
 *     일련번호     SN
 *     유저ID      USER_ID
 *     식별자타입    IDNTFR_SE
 *     식별자       IDNTFR
 *     상태        STATUS 
 *     등록일자      REG_DATE   
 *     등록자ID     REG_USER_ID
 *     수정일자      MOD_DATE
 *     수정자ID     MOD_USER_ID
 * 
 */

  CREATE TABLE "RI_USER_IDNTFR"
   (
    "SN" NUMBER(11,0) not null,
   	"USER_ID" VARCHAR2(20 BYTE),
	"IDNTFR_SE" VARCHAR2(20 BYTE),
	"IDNTFR" VARCHAR2(200 BYTE),
	"STATUS" VARCHAR2(10 BYTE),
	"REG_DATE" DATE,
   	"REG_USER_ID" VARCHAR2(20 BYTE),
	"MOD_DATE" DATE,
   	"MOD_USER_ID" VARCHAR2(20 BYTE)
   )TABLESPACE "RIMS";
   
/*
 *  IDNTFR_SE
 * 
RSCHR_REG_NO    KRI		KRI 연구자등록번호
RGATEID		    RGT 	ResearchGate
ORCID           ORC		ORCID
RID_SCP         SCP		Scopus Author ID
RID_WOS         RID		ResearcherID(WOS)
GRD_ID          GRD		Google
KCI             KCI		KCI OpenAPI

 - 코드 등록
 * 
 */   
   

   
-- DB Migration Query   
select ROW_NUMBER()OVER(ORDER BY TA.USER_ID ASC) as SN
     ,TA.*
 from 
( 
select RU.USER_ID
      ,'KRI' as IDNTFR_SE
      ,RU.RSCHR_REG_NO as IDNTFR
      ,sysdate as REG_DATE
      ,'SYTEM' as REG_USER_ID      
      ,sysdate as MOD_DATE
      ,'SYTEM' as MOD_USER_ID      
from RI_USER RU where RU.RSCHR_REG_NO is not null
UNION ALL
select RU.USER_ID
      ,'RID' as IDNTFR_SE
      ,RU.RID_WOS as IDNTFR
      ,sysdate as REG_DATE
      ,'SYTEM' as REG_USER_ID      
      ,sysdate as MOD_DATE
      ,'SYTEM' as MOD_USER_ID      
from RI_USER RU where RU.RID_WOS is not null
UNION ALL
select RU.USER_ID
      ,'RGT' as IDNTFR_SE
      ,RU.RGATEID as IDNTFR
      ,sysdate as REG_DATE
      ,'SYTEM' as REG_USER_ID      
      ,sysdate as MOD_DATE
      ,'SYTEM' as MOD_USER_ID      
from RI_USER RU where RU.RGATEID is not null
UNION ALL
select RU.USER_ID
      ,'ORC' as IDNTFR_SE
      ,RU.ORCID as IDNTFR
      ,sysdate as REG_DATE
      ,'SYTEM' as REG_USER_ID      
      ,sysdate as MOD_DATE
      ,'SYTEM' as MOD_USER_ID      
from RI_USER RU where RU.ORCID is not null
UNION ALL
select RU.USER_ID
      ,'SCP' as IDNTFR_SE
      ,RU.RID_SCP as IDNTFR
      ,sysdate as REG_DATE
      ,'SYTEM' as REG_USER_ID      
      ,sysdate as MOD_DATE
      ,'SYTEM' as MOD_USER_ID      
from RI_USER RU where RU.RID_SCP is not null
UNION ALL
select RU.USER_ID
      ,'GRD' as IDNTFR_SE
      ,RU.GRD_ID as IDNTFR
      ,sysdate as REG_DATE
      ,'SYTEM' as REG_USER_ID      
      ,sysdate as MOD_DATE
      ,'SYTEM' as MOD_USER_ID      
from RI_USER RU where RU.GRD_ID is not null
) TA   