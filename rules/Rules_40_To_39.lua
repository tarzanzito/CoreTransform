--.------------------------------------------------
--. Rules_40_To_39.lua  (Version:1.0)            --
--. Applies rules from core 40 to core 39        --
--.------------------------------------------------


--.--------------------
--. Prefix functions --
--.--------------------
module("CoreRules", package.seeall)

function rejectAll(Fields, Where)
    return false
end

-- Kind 14.1 is new in core 40 (External typedef)
function rejectExts(Fields, Where)
    if Fields.FK_KIND == "14.1" then
        return false
    end
    return true
end

function replaceVersion (Fields)
    if Fields.NVERSION == "'40'" then
        return "'39'"
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
            EXT_DEF = {
				insert = {
                    removeColumns = { VALID_TIME = 1, LAST_REFRESH_COL = 1, FORCE_REFRESH = 1, CACHE_RESULT = 1 }
					,replaceValue = { NVERSION = replaceVersion }
                    ,lineFilter = rejectExts
				}
				,update = {
                    removeColumns = { VALID_TIME = 1, LAST_REFRESH_COL = 1, FORCE_REFRESH = 1, CACHE_RESULT = 1 }
					,replaceValue = { NVERSION = replaceVersion }
                    ,lineFilter = rejectExts
				}
            }
            ,TYPE_DEF = {
				insert = {
                    removeColumns = { VISIBLE_CX = 1, VISIBLE_CY = 1 }
				}
				,update = {
                    removeColumns = { VISIBLE_CX = 1, VISIBLE_CY = 1 }
				}
            }
-- Correct the NVersion Collumn
            ,EDIT_DEF = ReplaceNVersion
            ,MENU_ITEM = ReplaceNVersion            
-- New Tables            
            ,WS_CONNECTION = NewTable
            ,WSLOCATION = NewTable
            ,PARAM_WS_FUNC = NewTable
            ,WS_FUNCTION = NewTable
    }
   
   return currentRules
   
end    



