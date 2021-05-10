--.------------------------------------------------
--. Rules_35_To_34.lua  (Version:1.0)            --
--. Applies rules from core 35 to core 34        --
--.------------------------------------------------


--.--------------------
--. Prefix functions --
--.--------------------
module("CoreRules", package.seeall)

function replaceVersion (Fields)
    if Fields.NVERSION == "'35'" then
        return "'34'"
    else
        return Fields.NVERSION
    end
end

function InitRules()

    local currentRules = {
    
-- EXT_DEF -> NOT_EXPORT added in core 35, Correct the NVersion Collumn
            EXT_DEF = {
				insert = {
                    removeColumns = { NOT_EXPORT = 1 }
					,replaceValue = { NVERSION = replaceVersion }
				}
				,update = {
                    removeColumns = { NOT_EXPORT = 1 }
					,replaceValue = { NVERSION = replaceVersion }
				}
            }
    }
   
   return currentRules
   
end    



