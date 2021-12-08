SELECT
    IX_RESULT_NO,
    CREATED_TIMESTAMP,
    REPORT_DATETIME,
    PAT_ID,
    PATIENT_NAME,
    date_of_birth,
    TEST_CODE,
    RECEIVING_DR_NAME,
    referring_dr_name,
    STATUS,
    IS_DELETED,
    Review_Status ,
    DATE_TIME_REVIEWED
from (
SELECT
    irv.IX_RESULT_NO,
    irv.CREATED_TIMESTAMP,
    irv.REPORT_DATETIME,
    irv.PAT_ID,
    irv.PATIENT_NAME,
    irv.date_of_birth,
    irv.TEST_CODE,
    irv.RECEIVING_DR_NAME,
    irv.referring_dr_name,
    case
    when (irv.RESULT_NORMAL = 'F') then 'Abnormal'
    when (irv.RESULT_NORMAL = 'T') then 'Normal'
    else null
    end as STATUS,
    irv.IS_DELETED,
    case
    when (irv.PAT_ID is not null) and
      (irv.DATE_TIME_REVIEWED IS NULL)
      then 'Unreviewed'
    when (irv.PAT_ID is not null) and
      (irv.DATE_TIME_REVIEWED IS NOT NULL)
      then 'Reviewed'
    when (irv.PAT_ID is null)
      then 'Unmatched'
    end as Review_Status ,
    irv.DATE_TIME_REVIEWED
FROM IX_RESULT_VIEW irv
JOIN (  SELECT pl.DOH_PROVIDER_NO
        FROM PROVIDER_LINK pl
        WHERE pl.ENC_PLACE_NO IN (SELECT ENC_PLACE_NO
        			  FROM GET_ENC_PLACE_AND_DESCENDANTS(@IN_ENC_PLACE_NO))
        GROUP BY pl.DOH_PROVIDER_NO
        ) dpn
  ON dpn.DOH_PROVIDER_NO = irv.RECEIVING_DOH_PROV_NO
  UNION ALL
  SELECT
    irv.IX_RESULT_NO,
    irv.CREATED_TIMESTAMP,
    irv.REPORT_DATETIME,
    irv.PAT_ID,
    irv.PATIENT_NAME,
    irv.date_of_birth,
    irv.TEST_CODE,
    irv.RECEIVING_DR_NAME,
    irv.referring_dr_name,
    case
    when (irv.RESULT_NORMAL = 'F') then 'Abnormal'
    when (irv.RESULT_NORMAL = 'T') then 'Normal'
    else null
    end as STATUS,
    irv.IS_DELETED,
    case
    when (irv.PAT_ID is not null) and
      (irv.DATE_TIME_REVIEWED IS NULL)
      then 'Unreviewed'
    when (irv.PAT_ID is not null) and
      (irv.DATE_TIME_REVIEWED IS NOT NULL)
      then 'Reviewed'
    when (irv.PAT_ID is null)
      then 'Unmatched'
    end as Review_Status ,
    irv.DATE_TIME_REVIEWED
FROM IX_RESULT_VIEW irv
WHERE (irv.RECEIVING_DOH_PROV_NO NOT IN (SELECT DISTINCT DOH_PROVIDER_NO
                                        FROM PROVIDER_LINK)
     OR irv.RECEIVING_DOH_PROV_NO IS NULL)
)
where
  is_deleted = 'F'              --Not deleted
  and date_time_reviewed is null   --unreviewed
  and created_timestamp > cast('2000-04-02' as date)
  and created_timestamp < cast('2021-09-29' as date)