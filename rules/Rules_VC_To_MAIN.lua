--.---------------------------------------------
--. Rules_VC_To_MAIN.lua  (Version:1.0)       --
--. Applies rules from:                       --
--. all:   VC_TEST        -> GLB_SYS          --
--. table: WORK_DEF_ROLES -> GLB_RUN          --
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
			,VC_WORKUNIT = {}
			,generic = genericFunc
    }
   
   return currentRules  
end    

--.-------------------------------
--. Aux functions
--.-------------------------------

-- Tables that are in GOM_GLB_RUN
function isRunTable (TableName)

    if  TableName == "WORK_DEF_ROLES" 
     or TableName == "VC_WORKUNIT" 
     or TableName == "VC_PACKAGE" 
    then
        return true
    end
    return false
end

-- Should the schema be replaced
function shouldReplaceSchema (SchemaName)
    if SchemaName == nil or SchemaName == "" or SchemaName == "GLB_SYS" or SchemaName == "GLB_RUN" then
        return false
    end
    
    return SchemaName == "VC_TEST"
end

--.-------------------------------
--. Processing functions
--.-------------------------------

function qualifiedNameFunc(SchemaName, TableName)

	if SchemaName == nil or SchemaName == "" then
		return TableName
	end
                      
	if shouldReplaceSchema (SchemaName) then
		if isRunTable(TableName) then
			return  "GLB_RUN" .. "." .. TableName
		end
	
		return  "GLB_SYS" .. "." .. TableName
	end

	return  SchemaName .. "." .. TableName
end


function whereProcessFunc (SchemaName, TableName, Fields, Where)

	if Where == nil or Where == "" then
		return Where
	end

    if not shouldReplaceSchema (SchemaName) then
		return Where
	end
                      
    if isRunTable(TableName) then
		local whereNew = string.gsub(Where, SchemaName .. "." .. TableName, "GLB_RUN." .. TableName)
        
        if 	TableName == "WORK_DEF_ROLES" then
            whereNew = string.gsub(whereNew, SchemaName .. ".WORK_DEF", "GLB_SYS.WORK_DEF")
        end
        
		return whereNew
	end
    
    return string.gsub(Where, SchemaName, "GLB_SYS")
end

function genericFunc (Line)
	
	if Line == nil then
		return Line
	end
	
	return string.gsub(Line, "VC_TEST", "GOM_GLB_SYS")
end
