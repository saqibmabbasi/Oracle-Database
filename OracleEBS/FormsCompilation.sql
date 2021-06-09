SELECT 
    '&Form_Name'    Form_Name
    , APP.APPLICATION_ID
    , APP.APPLICATION_SHORT_NAME
    , APP.BASEPATH
    , APP.PRODUCT_CODE
    , ATL.APPLICATION_NAME
    , EC_Top.Value
    , 'source ' || EC_Source.Value     Environment_Source_Path
    , 'frmcmp_batch ' 
        || 'module=' || '&Form_Name' || '.fmb' 
        || ' output_file=' || EC_Top.Value || '/forms/US/' || '&Form_Name' || '.fmx' 
        || ' compile_all=' || 'yes' 
        || ' userid=' || 'apps/' || '&Apps_Password'
        || ' module_type=' || 'form' 
      Compile_Command
FROM   FND_APPLICATION APP
      ,FND_APPLICATION_TL ATL
      ,(SELECT VARIABLE_NAME, VALUE
        FROM   FND_ENV_CONTEXT
        WHERE  VARIABLE_NAME LIKE '%\_TOP' Escape '\'
        AND    CONCURRENT_PROCESS_ID =
               (SELECT MAX(CONCURRENT_PROCESS_ID) FROM FND_ENV_CONTEXT)
        ) EC_Top
      , (SELECT VARIABLE_NAME, Value
         FROM   FND_ENV_CONTEXT   ec
         Where  VARIABLE_NAME = 'MYAPPSORA'
         AND    CONCURRENT_PROCESS_ID = (SELECT MAX(CONCURRENT_PROCESS_ID) FROM FND_ENV_CONTEXT)
        ) EC_Source
WHERE  APP.APPLICATION_ID = ATL.APPLICATION_ID
AND    APP.BASEPATH = EC_Top.VARIABLE_NAME
AND    APP.APPLICATION_SHORT_NAME = '&Application_short_name'
/*
<name="Application_Short_Name" 
                                      hint="Enter Application Short Name"
                                      type="string"
                                      default="PER"
                                      ifempty="%"
                                      list="Select application_short_name From fnd_application a Order By a.application_short_name Asc">;
*/
