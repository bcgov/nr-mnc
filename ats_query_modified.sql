SELECT 
    avgprtime.AUTHORIZATION_INSTRUMENT_ID,
    avgprtime.PROJECT_ID,
    avgprtime.PROJECT_NAME,
    REPLACE(REPLACE(prj.LOCATION, CHR(10), NULL), CHR(13), NULL) AS project_location,
    avgprtime.AUTHORIZATION_ID,
    avgprtime.AUTHORIZATION_TYPE,
    avgprtime.BUSINESS_AREA,
    avgprtime.AUTHORIZATION_STATUS,
    avgprtime.REGION_NAME,
    avgprtime.SUBREGIONAL_OFFICE_NAME,
    avgprtime.SECONDARY_OFFICE_NAME,
    avgprtime.APPLICATION_RECEIVED_DATE,
    avgprtime.APPLICATION_ACCEPTED_DATE,
    avgprtime.APPLICATION_REJECTED_DATE,
    avgprtime.ADJUDICATION_DATE,
    avgprtime.NET_PROCESSING_TIME,
    avgprtime.FILE_NUMBER,
    code.PROJECT_TYPE_CODE,
    REPLACE(REPLACE(code.DESCRIPTION, CHR(10), NULL), CHR(13), NULL) AS project_type_code_description
      
FROM 
    ATS.ATS_AVG_PROCESSING_TIME_VW avgprtime
JOIN 
    ats.ATS_PROJECTS prj ON avgprtime.PROJECT_ID = prj.PROJECT_ID
LEFT JOIN 
    ats.ATS_PROJ_PROJ_TYPE_CODE_XREF refx ON avgprtime.PROJECT_ID = refx.PROJECT_ID
LEFT JOIN 
    ats.ATS_PROJECT_TYPE_CODES code ON refx.PROJECT_TYPE_CODE = code.PROJECT_TYPE_CODE
WHERE 
    avgprtime.BUSINESS_AREA IN ('Parks', 'Water', 'Lands', 'Fish and Wildlife') AND 
    avgprtime.AUTHORIZATION_STATUS IN ('Active', 'Closed', 'On Hold') AND 
    avgprtime.AUTHORIZATION_TYPE NOT IN ('Notification', 'DMA Approval', 'Assignments', 'Replacements', 'Premature Replacement') AND 
    avgprtime.AUTHORIZATION_TYPE NOT LIKE '%Ownership Change%' AND 
    avgprtime.AUTHORIZATION_TYPE NOT LIKE 'Sponsorship Letter%' AND 
    avgprtime.APPLICATION_RECEIVED_DATE > TO_DATE('2016-04-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS') AND 
    avgprtime.NET_PROCESSING_TIME >= 0
  ORDER BY 2