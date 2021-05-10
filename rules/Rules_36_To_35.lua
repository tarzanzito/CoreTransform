--.------------------------------------------------
--. Rules_36_To_35.lua  (Version:1.0)            --
--. Applies rules from core 36 to core 35        --
--.------------------------------------------------


--.--------------------
--. Prefix functions --
--.--------------------
module("CoreRules", package.seeall)

function rejectAll(Fields, Where)
    return false
end

function replaceVersion (Fields)
    if Fields.NVERSION == "'36'" then
        return "'35'"
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
    
-- EDIT_DEF and  MENU_ITEM -> NVERSION was added in Core 36
            EDIT_DEF = {
				insert = {
					removeColumns = { NVERSION = 1 }
				}
				,update = {
					removeColumns = { NVERSION = 1 }
				}
			}
--  MENU_ITEM assume that all Db and Dll functions still have the old fields filled           
            ,MENU_ITEM = {
				insert = {
					removeColumns = { NVERSION = 1 }
				}
				,update = {
					removeColumns = { NVERSION = 1 }
				}
			}
-- Correct the NVersion Collumn
            ,EXT_DEF = ReplaceNVersion
-- New tables, cannot appear in script            
            ,FUNC_DEF = NewTable
            ,QRY_ACTIONS = NewTable
            ,QRY_ACTIONS = NewTable
    }
   
   return currentRules
   
end    



