--.------------------------------------------------
--. rules3837.lua  (Version:1.0)                 --
--. Applies rules from core 38 to core 37        --
--.------------------------------------------------


--.--------------------
--. Prefix functions --
--.--------------------
module("CoreRules", package.seeall)

function InitRules()

    local currentRules = {
    
            SPLIT_DEF = {
				insert = {
					lineFilter = filter1 
					,removeColumns = { PRINT_LANDSCAPE = 1 }
					,addColumns = { NEW_COL1 = "'ola'", NEW_COL2 = calculate1 }
					,replaceValue = { PK_NAME = calculate2 }
				}
				,update = {
					lineFilter = filter2
					,removeColumns = { PRINT_LANDSCAPE = 1 }
					,addColumns = { NEW_COL1 = "'ola'", NEW_COL2 = calculate1 }
					,replaceValue = { PK_NAME = calculate2 }
					,whereProcess = whereFunc2
				}
				,delete = {
					lineFilter = filter3 
					,whereProcess = whereFunc3
				}
				
			}
    }
   
   return currentRules
   
end    

function calculate1(Fields)
    return "'novo campo directo'"
end

function calculate2(Fields)
    return "'replace calculado'"
end

function filter1(Fields, Where)
    return false
end

function filter2(Fields, Where)
    return true
end

function filter3(Fields, Where)
    return false
end

function whereFunc2(Fields, Where)
    return "new where string"
end

function whereFunc3(Fields, Where)
    return "new where string"
end
