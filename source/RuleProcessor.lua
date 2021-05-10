--.------------------------------------------------------
--. RuleProcessor.lua  (Version:1.8)                   --
--. Applies rules to statements                        --
--.------------------------------------------------------


--.--------------------
--. Prefix functions --
--.--------------------
module("RuleProcessor", package.seeall)

local currentRules = {}

--.---------------------------------------------------
--. InitRules(RulesFileName)                        -- 
--. Initializes the rule engine from the given file --
--. return none                                     --
--.---------------------------------------------------
function InitRules(RulesFileName)

    dofile(RulesFileName)
    
    currentRules = CoreRules.InitRules()
    
end

--.----------------------------------------------------
--. ShouldProcess(tableName)                         --
--. Indicates if there are rules for the given table --
--. returns true or false                            --
--.----------------------------------------------------
function ShouldProcess(tableName)

	return GetRules(tableName) ~= nil
end

--.-----------------------------
--. GetRules(tableName)       --
--. Get rules for table table --
--. returns rules or nil      --
--.-----------------------------
function GetRules(tableName)

	if tableName == nil then
		return nil
	end
	
	local tableWithoutSchema = SQLParser.RemoveSchemaFromTableName(tableName)
	local rules = currentRules[tableWithoutSchema]
	if rules == nil then
		rules = currentRules["default"]
	end
	
    return rules

end
--.-------------------------------------------
--. ApplyRules(statement)                   --  
--. Applies existing rules to the statement --
--. returns processed statement             -- 
--.-------------------------------------------
function ApplyRules(statement)

    local statementType = SQLParser.GetStatementType(statement)
    if statementType == nil then
		local genericRule = currentRules["generic"]
		if genericRule ~= nil then
			if type(genericRule == "function") then
				return genericRule(statement)
			end
		end
		return statement
    end

    local tableName = SQLParser.GetTableName(statement)
	
    local theRulesTable = GetRules(tableName)
    if theRulesTable == nil then
		return statement
    end
	
	local theRules = theRulesTable[statementType]
    if theRules == nil then
        return statement
    end
	
    local tableFields = { }
    tableFields = SQLParser.GetFieldsAndValues(statement)

	if SQLParser.IsValidStatement(statementType, tableFields) == false then
          error("Statement not valid.")
    end
    
    local fields = { }
    fields = tableFields.Fields

	local where = SQLParser.GetWhere(statement)
	
    if theRules.lineFilter ~= nil and theRules.lineFilter(fields, where) == false then
		return ""
    end

	local reBuildStament = false
	
    for name, value in pairs(fields) do
        
        --remove fields
        if theRules.removeColumns ~= nil and theRules.removeColumns[name] == 1 then
			reBuildStament = true
            fields[name] = nil
        end
        
        --replace field with new value
        if theRules.replaceValue ~= nil and theRules.replaceValue[name] ~= nil then
			reBuildStament = true
            if type(theRules.replaceValue[name]) == "function" then
                 fields[name] = theRules.replaceValue[name](fields)
            else 
                 fields[name] = theRules.replaceValue[value]
            end
        end
        
    end

    --insert new fields
	if theRules.addColumns ~= nil then
		for name, value in pairs (theRules.addColumns) do
			reBuildStament = true
			if type(value) == "function" then
				fields[name] = value(fields)
			else 
				fields[name] = value
			end
			
		end
	end

	local tableWithoutSchema = SQLParser.RemoveSchemaFromTableName(tableName)
	local schemaName = 	SQLParser.GetSchemaFromTableName(tableName)

    --process Where
    if theRules.whereProcess ~= nil and statementType ~= "insert" then
		reBuildStament = true
		where = theRules.whereProcess(schemaName, tableWithoutSchema, fields, where)
    end
	
	--process qualifiedName
   if theRules.qualifiedName ~= nil then
		reBuildStament = true
		if type(theRules.qualifiedName) == "function" then
			tableName = theRules.qualifiedName(schemaName, tableWithoutSchema)
		else 
			tableName = theRules.qualifiedName
		end
    end	

	--No changes, return original
	if not reBuildStament then
		return statement
	end

	--Build sql statement
	local result
	
    if statementType == "insert" then
		result = BuildInsertStatement(tableName, tableFields)
		
	elseif statementType == "update" then
		result = BuildUpdateStatement(tableName, fields, where)

	elseif statementType == "delete" then
		result = BuildDeleteStatement(tableName, where)
	else
		return statement
	end

	if SQLParser.HasEndStatement(statement) then
		result = SQLParser.AddEndStatement(result)
	end
	
    return result
    
end

--.-------------------------------------------
--. BuildInsertStatement(TableName, Fields) --  
--. Build insert sql statement              --
--. returns string                          -- 
--.-------------------------------------------
function BuildInsertStatement(TableName, TableFields)

    local isfirst = true 
    local valuesString = ""
    local fieldsString = ""
    local result = ""

	if (TableFields.HasColumnNames) then

		for idx, name in ipairs(TableFields.Columns) do 
			
			value = TableFields.Fields[name]
		
			if value ~= nil then
				if isfirst then
					isfirst = false
				else
				    fieldsString = fieldsString .. "," --optional ", "
					valuesString = valuesString .. "," --optional ", "
				end

			    fieldsString = fieldsString .. name
				valuesString = valuesString .. value
			end
		end

		result = "insert into " .. TableName .. " (" .. fieldsString .. ") values (" .. valuesString .. ")"
		
	else
		for idx, name in ipairs(TableFields.Columns) do 
			
			value = TableFields.Fields[name]
		
			if value ~= nil then
				if isfirst then
					isfirst = false
				else
					valuesString = valuesString .. "," --optional ", "
				end

				valuesString = valuesString .. value
			end
		end

		result = "insert into " .. TableName .. " values (" .. valuesString .. ")"

	end
	
	return result
	
end

--.--------------------------------------------------
--. BuildUpdateStatement(TableName, Fields, Where) --  
--. Build update sql statement                     --
--. returns string                                 -- 
--.--------------------------------------------------
function BuildUpdateStatement(TableName, Fields, Where)

    local result = "update " .. TableName .. " set "
    local isfirst = true 
    
    for name, value in pairs(Fields) do 
        if isfirst then
            isfirst = false
        else
            result = result .. ", " -- optional  ","
        end
        
        result = result .. name .. "=" .. value --optional " = "
    end
    
	if Where ~= nil and string.len(Where) > 0 then
		result = result .. " where " .. Where
	end

	return result
	
end

--.------------------------------------------
--. BuildDeleteStatement(TableName, Where) --  
--. Build delete sql statement             --
--. returns string                         -- 
--.------------------------------------------
function BuildDeleteStatement(TableName, Where)

    local result = "delete from " .. TableName 
	if Where ~= nil and string.len(Where) > 0 then
		result = result .. " where " .. Where
	end
    
	return result
	
end
