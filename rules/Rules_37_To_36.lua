--.------------------------------------------------
--. Rules_37_To_36.lua  (Version:1.0)            --
--. Applies rules from core 37 to core 36        --
--.------------------------------------------------


--.--------------------
--. Prefix functions --
--.--------------------
module("CoreRules", package.seeall)

function rejectAll(Fields, Where)
    return false
end

function replaceVersion (Fields)
    if Fields.NVERSION == "'37'" then
        return "'36'"
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
    
-- OBJ_DEF -> Single Edit was added in Core 37   
-- This is usually "Not Export" but we make sure 
            OBJ_DEF = {
				insert = {
					removeColumns = { SINGLE_EDIT = 1 }
				}
				,update = {
					removeColumns = { SINGLE_EDIT = 1 }
				}
			}
-- Correct the NVersion Collumn
            ,EDIT_DEF = ReplaceNVersion
            ,EXT_DEF = ReplaceNVersion
            ,MENU_ITEM = ReplaceNVersion
-- New tables, cannot appear in script            
            ,OPTRIGGERS = NewTable
            ,VCCHECKOUT = NewTable
            ,VCPLUGIN = NewTable
            ,VCPLUGIN = NewTable
            ,VCOBJDETAILS = NewTable
            ,VCOBJDETAILS = NewTable
            ,VCOBJDETAILS = NewTable
    }
   
   return currentRules
   
end    



