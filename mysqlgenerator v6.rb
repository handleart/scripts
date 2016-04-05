
ground = -0.51;
add = 0.001;
roundValue = 3;
# number of loops for the for statement
textVal = "(amt1 - amt2) / amt1";
maxVal = 1001;
#textVal = "(amt1 - amt2)";
numberFormat = "%";
textTable = "smud_prep_p3.phase3_accountbillimpact_final_filter"

puts "#query to create histogram
SET @run_name := 'charge 1 - charge 2';     
SET @add := 0.002;
SET @ground := 0.001;
SET @i := 10;   
SET @trun := 1;"



puts "select n.alt2_alt1_delta_grp_pct, if(z.num is null, 0, z.num) as num
from"

#create the unionn table to make sure all CASE values show up 

puts "(select "


for i in 0..maxVal do 
    if i == 0
        tmp0 = "\"" + i.to_s.rjust(3, "0") + ": < " + ((ground + 1*add) *100).round(roundValue).to_s +  numberFormat + "\" as alt2_alt1_delta_grp_pct"
    elsif i == maxVal
        tmp0 = "union select  \"" + (i).to_s.rjust(3, "0") + ": > " + ((ground + (i)*add) *100).round(roundValue).to_s +  numberFormat + "\""
    else
        tmp0 = "union select  \"" + i.to_s.rjust(3, "0") + ": > " + ((ground + i*add) *100).round(roundValue).to_s +  numberFormat + " to "  
        tmp0 = tmp0 + "< " + ((ground + (i +1 )*add) *100).round(roundValue).to_s + numberFormat + "\""
    end

    puts tmp0

   # 

end

puts ") n"

#here we do the actual calculation and query the database from the tables

puts"left join 
    (SELECT 
    t.nme,
    t.alt2_alt1_delta_grp_pct,
    RIGHT(t.alt2_alt1_delta_grp_pct, CHAR_LENGTH(t.alt2_alt1_delta_grp_pct) - 5) as rule,
    COUNT(contract_id) as num"




puts "from 
    (SELECT 
        nme,
            contract_id,"


	puts "CASE"




for i in 0..maxVal do 

    if i == 0
        tmp = "when " + textVal + " <= " 
        tmp = tmp + (ground + 1*add).round(roundValue).to_s 
        tmp = tmp + " then \"" + i.to_s.rjust(3, "0") + ": < " + ((ground + (i+1)*add) *100).round(roundValue).to_s +  numberFormat + "\""
    elsif i == maxVal
        tmp = "else " + "\"" + (i).to_s.rjust(3, "0") + ": > " + ((ground + (i)*add) *100).round(roundValue).to_s +  numberFormat + "\""
    else
    	tmp = tmp = "when " + textVal + " > " 
    	tmp = tmp + (ground + i*add).round(roundValue).to_s
    	tmp = tmp + " and " + textVal + " <="
    	tmp = tmp + (ground + (i + 1) *add).round(roundValue).to_s
    	tmp = tmp + " then \"" + i.to_s.rjust(3, "0") + ": > " + ((ground + i*add) *100).round(roundValue).to_s +  numberFormat + " to "  
    	tmp = tmp + "< " + ((ground + (i +1 )*add) *100).round(roundValue).to_s + numberFormat + "\""
    end

	puts tmp

   # 

end 

	

	#puts tmp

puts "END AS alt2_alt1_delta_grp_pct"

puts "    FROM
        (SELECT 
        @run_name AS nme,
            contract_id,
            amt2 AS amt2,
            amt1 AS amt1
    FROM " + textTable + "
    #WHERE
    #    bill_start_date >= 20140101
    #        AND bill_end_date < 20150101
    #        AND meter_ids != ''
    #        AND ABS(usage_gap) <= 2
            ) a) t
GROUP BY t.alt2_alt1_delta_grp_pct) z on z.alt2_alt1_delta_grp_pct = n.alt2_alt1_delta_grp_pct;"
