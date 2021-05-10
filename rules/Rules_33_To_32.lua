--.------------------------------------------------
--. Rules_33_To_32.lua  (Version:1.0)            --
--. Applies rules from core 33 to core 32        --
--.------------------------------------------------


--.--------------------
--. Prefix functions --
--.--------------------
module("CoreRules", package.seeall)


function correctKind (Fields)
    if (Fields.FK_KIND == '10.1' and Fields.FK_OWNER_OBJ == '3.1') then
        return '2.1'
    elseif (Fields.FK_KIND == '2.1' and Fields.FK_OWNER_OBJ == '3.1') then
        return '10.1'
    else
        return Fields.FK_KIND
    end
end

function InitRules()


    local currentRules = {
    
            EXT_DEF = {
				insert = {
                    removeColumns = { NVERSION = 1, TMP_EDIT=1 }
                    ,replaceValue = { FK_KIND = correctKind }
				}
				,update = {
                    removeColumns = { NVERSION = 1, TMP_EDIT=1 }
                    ,replaceValue = { FK_KIND = correctKind }
				}
            }
            ,QUERY_FIELD = {
				insert = {
                    removeColumns = { TMP_EDIT = 1 }
				}
				,update = {
                    removeColumns = { TMP_EDIT = 1 }
				}
            }
            ,WORK_DEF = {
				insert = {
                    removeColumns = { VAL_ENTITIES = 1 }
				}
				,update = {
                    removeColumns = { VAL_ENTITIES = 1 }
				}
            }
    } 
   
   return currentRules
   
end    



