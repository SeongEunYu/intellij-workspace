  CREATE OR REPLACE FORCE VIEW "VI_PATENT_AUTHORS" ("PATENT_ID", "AUTHORS", "KOR_AUTHORS", "AUTHORS_INFO") AS
  SELECT PATENT_ID,
    LISTAGG (NAME_DISP, ';') WITHIN GROUP (ORDER BY DISP_ORDER) AS AUTHORS,
    LISTAGG (NAME_DISP, ';') WITHIN GROUP (ORDER BY DISP_ORDER) AS KOR_AUTHORS,
    LISTAGG (AUTHOR_INFO, ';') WITHIN GROUP (ORDER BY DISP_ORDER) AS AUTHORS_INFO
  FROM
    ( SELECT ROWNUM AS CNT,
              A.*,
             DECODE (A.PRTCPNT_FULL_NM, NULL,
                     CASE WHEN  B.FIRST_NAME is null and B.FIRST_NAME is null  THEN  ''
                      ELSE  B.LAST_NAME|| ', '|| B.FIRST_NAME
                      END
                    , A.PRTCPNT_FULL_NM) AS NAME_DISP
            ,B.KOR_NM
            ,B.AUTHOR_INFO
    FROM
      ( SELECT DISTINCT PATENT_ID,
        PRTCPNT_ID            AS USER_ID,
        MAX (PRTCPNT_FULL_NM) AS PRTCPNT_FULL_NM,
        MAX (DISP_ORDER)      AS DISP_ORDER
      FROM RI_PATENT_PARTI
      WHERE PRTCPNT_ID          IS NOT NULL
      AND NVL (DEL_DVS_CD, 'N') != 'Y'
      GROUP BY PATENT_ID, PRTCPNT_ID
      ) A,
      (
        select USER_ID, GUBUN, DEL_DVS_CD, FIRST_NAME, LAST_NAME, KOR_NM, KOR_NM || ',' || USER_ID || ',' || POSI_NM || ',' || DEPT_KOR AS AUTHOR_INFO
         from RI_USER
      )B
    WHERE A.USER_ID              = B.USER_ID(+)
    AND B.GUBUN                 IN ('M', 'U')
    AND NVL (B.DEL_DVS_CD, 'N') <> 'Y'
    AND B.GUBUN                 != 'S'
    )
  GROUP BY PATENT_ID;
