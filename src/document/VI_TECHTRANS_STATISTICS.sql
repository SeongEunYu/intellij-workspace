  CREATE OR REPLACE FORCE VIEW "VI_TECHTRANS_STATISTICS" ("TECHTRANS_ID", "TECH_TRANSR_YM", "TRANS_YEAR", "TECH_TRANSR_CD", "RPM_AMT", "APPR_DVS_CD", "APPR_DATE", "SEQ_AUTHOR", "PRTCPNT_ID", "PRTCPNT_NM", "USER_ID", "GUBUN", "KOR_NM", "DEPT_KOR", "HLDOF_YN", "APTM_DATE", "GRADE1", "POSI_NM", "SEX_DVS_CD", "NTNT_CD", "EMP_ID", "GRADE_GUBUN") AS
  SELECT
            TA.TECHTRANS_ID,
            TA.TECH_TRANSR_YM,
            SUBSTR(TA.TECH_TRANSR_YM,0,4) as TRANS_YEAR,
			TA.TECH_TRANSR_CD,
            (select SUM(NVL(RPM_AMT,0)) from RI_TECHTRANS_ROYALTY where NVL(DEL_DVS_CD, 'N') != 'Y' and TECHTRANS_ID = TA.TECHTRANS_ID group by TECHTRANS_ID ) as RPM_AMT,
            TA.APPR_DVS_CD,
            TA.APPR_DATE,
            TB.SEQ_AUTHOR,
            TB.PRTCPNT_ID,
            TB.PRTCPNT_NM,
            TC.USER_ID,
            TC.GUBUN,
            TC.KOR_NM,
            TC.DEPT_KOR,
            TC.HLDOF_YN,
            TC.APTM_DATE,
            TC.GRADE1,
            TC.POSI_NM,
            TC.SEX_DVS_CD,
            TC.NTNT_CD,
	        TC.EMP_ID,
	        DECODE (TC.POSI_NM,
                    '교수', 1,
                    '조교수', 1,
                    '부교수', 1,
                    '학생', 3,
                    2)
               grade_gubun
       FROM RI_TECHTRANS TA, RI_TECHTRANS_PARTI TB, RI_USER TC
      WHERE TA.TECHTRANS_ID = TB.TECHTRANS_ID
            AND TB.PRTCPNT_ID = TC.USER_ID
            AND NVL (TA.DEL_DVS_CD, 'N') != 'Y'
            AND NVL (TB.DEL_DVS_CD, 'N') != 'Y';

