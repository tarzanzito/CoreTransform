--.------------------------------------------------
--. Rules_41_To_40.lua  (Version:1.0)            --
--. Applies rules from core 41 to core 40        --
--.------------------------------------------------


--.--------------------
--. Prefix functions --
--.--------------------
module("CoreRules", package.seeall)

function rejectAll(Fields, Where)
    return false
end

function replaceVersion (Fields)
    if Fields.NVERSION == "'41'" then
        return "'40'"
    else
        return Fields.NVERSION
    end
end

function InitRules()

    local NewTable = {
				insert = {
					lineFilter = rejectAll 
				}
				,update = {
					lineFilter = rejectAll
				}
				,delete = {
					lineFilter = rejectAll 
				}
            }
            
    local ReplaceNVersion = {
				insert = {
					replaceValue = { NVERSION = replaceVersion }
				}
				,update = {
					replaceValue = { NVERSION = replaceVersion }
				}
            }

    local currentRules = {
            T__WORK_DEF_S = {
				insert = {
                    removeColumns = { USE_AUDIT = 1, LAST_USED_BY=1, LAST_USED_ON=1 }
				}
				,update = {
                    removeColumns = { USE_AUDIT = 1, LAST_USED_BY=1, LAST_USED_ON=1 }
				}
            }
-- Correct the NVersion Collumn
            ,T__EDIT_DEF_S = ReplaceNVersion
            ,T__MENU_ITEM_S = ReplaceNVersion    
            ,T__EXT_DEF_S = ReplaceNVersion
-- These tables did not appear in core scripts
            ,T__SCREENRULEVAL_S = NewTable
            ,T__SCREENELEMRULE_S = NewTable
            ,T__SCREENRULE_S = NewTable
    }
   
   return currentRules
   
end    



