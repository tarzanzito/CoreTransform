--.------------------------------------------------
--. Rules_34_To_33.lua  (Version:1.0)            --
--. Applies rules from core 34 to core 33        --
--.------------------------------------------------


--.--------------------
--. Prefix functions --
--.--------------------
module("CoreRules", package.seeall)

function replaceVersion (Fields)
    if Fields.NVERSION == "'34'" then
        return "'33'"
    else
        return Fields.NVERSION
    end
end

function correctFkExtension (Fields)
    --if (Fields.FK_EXTENSION == '674.1' and Fields.FK_OWNER_OBJ == '3.1')
     --       or Fields.FK_EXTENSION == '18250.1' then
	 if (Fields.FK_EXTENSION == '18250.1') then
        return '6.1'
    else
        return Fields.FK_EXTENSION
    end
end

function InitRules()

    local currentRules = {
    
            EXT_DEF = {
				insert = {
                    removeColumns = { FK_SELECTED_BY = 1, FK_PARENT_OBJ = 1, FK_FATHER_UNION = 1 }
					,replaceValue = { NVERSION = replaceVersion
                                    ,FK_EXTENSION = correctFkExtension }
				}
				,update = {
                    removeColumns = { FK_SELECTED_BY = 1, FK_PARENT_OBJ = 1, FK_FATHER_UNION = 1 }
					,replaceValue = { NVERSION = replaceVersion
                                    ,FK_EXTENSION = correctFkExtension }
				}
            }
            ,EDIT_SHEET = {
				insert = {
                    removeColumns = { READ_ONLY = 1, ON_NEW_READ_ONLY = 1, ENV_OLD_RO = 1, ENV_NEW_RO = 1 }
				}
				,update = {
                    removeColumns = { READ_ONLY = 1, ON_NEW_READ_ONLY = 1, ENV_OLD_RO = 1, ENV_NEW_RO = 1 }
				}
            }
    }
   
   return currentRules
   
end    



