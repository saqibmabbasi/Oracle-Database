with data as (
    Select 
        trunc(Sysdate,'MON') date_start
        , last_day(trunc(Sysdate)) date_end
    From dual
)
Select 
    'Week-' || Rownum AS WeekNumber
    , wk.week_start_date
    , wk.week_end_date
From
    (Select Distinct 
         Case 
             When Trunc(the_date, 'iw') <= Period_start_date Then
                 Period_start_date
             Else
                 Trunc(the_date, 'iw')
             End               Week_Start_Date
         ,Case 
              When Trunc(the_date, 'iw') + 6 >= Period_End_Date Then
                  Period_End_Date
              Else
                  Trunc(the_date, 'iw') + 6
              End               Week_End_Date
     From 
         (Select 
              date_start                  Period_start_date
              , date_end                  Period_End_Date
              , date_start + Level - 1    the_date
          From Data
          Where (date_start + Level - 1) <= date_end
          Connect By Level <= date_end - date_start + 7
         )
     Order By 2
    )  wk
