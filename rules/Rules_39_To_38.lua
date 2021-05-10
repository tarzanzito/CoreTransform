--.------------------------------------------------
--. Rules_38_To_37.lua  (Version:1.0)            --
--. Applies rules from core 38 to core 37        --
--.------------------------------------------------


--.--------------------
--. Prefix functions --
--.--------------------
module("CoreRules", package.seeall)

function rejectAll(Fields, Where)
    return false
end

-- Kinds 12.1  and 13.1 are new in core 39 (CBLOB and BLOB)
function rejectLobExts(Fields, Where)
    if Fields.FK_KIND == "12.1"  or Fields.FK_KIND == "13.1"  then
        return false
    end
    return true
end

function replaceVersion (Fields)
    if Fields.NVERSION == "'39'" then
        return "'38'"
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
                    removeColumns = { LOB_COL = 1 }
					,replaceValue = { NVERSION = replaceVersion }
                    ,lineFilter = rejectLobExts
				}
				,update = {
                    removeColumns = { LOB_COL = 1 }
					,replaceValue = { NVERSION = replaceVersion }
                    ,lineFilter = rejectLobExts
				}
            }
-- Correct the NVersion Collumn
            ,EDIT_DEF = ReplaceNVersion
            ,MENU_ITEM = ReplaceNVersion
-- New Tables            
            ,SQL_SCRIPT = NewTable
    }
   
   return currentRules
   
end    



