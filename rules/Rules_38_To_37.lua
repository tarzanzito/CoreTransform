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

-- Kind 8.1 is new in core 38
function rejectLabelFields(Fields, Where)
    if Fields.FK_KIND == "8.1" then
        return false
    end
    return true
end

function replaceVersion (Fields)
    if Fields.NVERSION == "'38'" then
        return "'37'"
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
-- MultiSel    
            EDIT_FIELD = {
				insert = {
					removeColumns = { MULTI_SEL = 1 }
                    ,lineFilter = rejectLabelFields
				}
				,update = {
					removeColumns = { MULTI_SEL = 1 }
                    ,lineFilter = rejectLabelFields
				}
            }
-- TXCOLNAMEPRC
            ,QUERY_DEF = {
            	insert = {
					removeColumns = { TXCOLNAMEPRC = 1 }
				}
				,update = {
					removeColumns = { TXCOLNAMEPRC = 1 }
				}
            }
-- Locked and last login
            ,USERROLE  = {
            	insert = {
					removeColumns = { LG_ISLOCKED = 1, DT_LASTLOGIN = 1 }
				}
				,update = {
					removeColumns = { LG_ISLOCKED = 1, DT_LASTLOGIN = 1 }
				}
            }          
-- Correct the NVersion Collumn
            ,EDIT_DEF = ReplaceNVersion
            ,EXT_DEF = ReplaceNVersion
            ,MENU_ITEM = ReplaceNVersion
-- New Tables            
            ,AUDIT_EVT_KIND_S = NewTable
            ,CACHEOBJECT_S = NewTable
            ,VC_CONTROLABLE_OBJ = NewTable
            ,VC_CONTROLABLE_OBJ = NewTable
            ,VC_CONTROLABLE_OBJ = NewTable
            ,VC_ENV_CTRL_OBJ = NewTable
            ,VC_PACKAGE = NewTable
            ,VC_VERSIONED_ENV = NewTable
            ,VC_VERSIONED_ENV = NewTable
            ,VC_WORKUNIT = NewTable
            ,AUDIT_LOG = NewTable
    }
   
   return currentRules
   
end    



