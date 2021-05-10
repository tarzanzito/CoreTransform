--.---------------------------------------------
--. Rules_MAIN_To_VC.lua  (Version:1.0)       --
--. Applies rules from:                       --
--. all:   GLB_SYS         -> VC_TEST         --
--. table: WORK_DEF_ROLES  -> GLB_RUN         --
--.---------------------------------------------


--.--------------------
--. Prefix functions --
--.--------------------
module("CoreRules", package.seeall)


function InitRules()


    local currentRules = {

			default = {
				insert = {
					qualifiedName = qualifiedNameFunc
				}
				,update = {
					qualifiedName = qualifiedNameFunc
					,whereProcess = whereProcessFunc
				}
				,delete = {
					qualifiedName = qualifiedNameFunc
					,whereProcess = whereProcessFunc
				}
			}
			
			,generic = genericFunc
    }
   
   return currentRules
   
end    

function qualifiedNameFunc(SchemaName, TableName)

	if SchemaName == nil or SchemaName == "" then
		return TableName
	end
                      
	if SchemaName == "GLB_SYS" or SchemaName == "GLB_RUN" then
		return  "VC_TEST" .. "." .. TableName
	end

	return  SchemaName .. "." .. TableName

end

function whereProcessFunc (SchemaName, TableName, Fields, Where)

	if Where == nil or Where == "" then
		return Where
	end

	if SchemaName == nil or SchemaName == "" then
		return Where
	end
                      
	--if 	TableName == "WORK_DEF_ROLES" then
	--
	--	local whereNew = string.gsub(Where, SchemaName .. ".WORK_DEF_ROLES", "GLB_RUN.WORK_DEF_ROLES")
	--	whereNew = string.gsub(whereNew, SchemaName .. ".WORK_DEF", "GLB_SYS.WORK_DEF")
	--	return whereNew
	--end
	
    return string.gsub(Where, SchemaName, "VC_TEST")
end

function genericFunc (Line)
	
	if Line == nil then
		return Line
	end
	
	local lin = string.gsub(Line, "GLB_SYS", "VC_TEST")
	return string.gsub(lin, "GLB_RUN", "VC_TEST")
	
end
