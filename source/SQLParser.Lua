--.------------------------------------------------------
--. SQLParser.lua  (Version:1.8)                       --
--. Implement functions for interpreter sql statements --
--.------------------------------------------------------

--.------------
--. includes --
--.------------
dofile("source/stringExtension.lua")

--.--------------------
--. Prefix functions --
--.--------------------
module("SQLParser", package.seeall)

local endStatementChar = ";"


--.----------------------------------------
--. ExposeStatement(Line)                --  
--. return string                        -- 
--.----------------------------------------
function ExposeStatement(Line)

	local object
    local object = SQLParser.GetObject(Line)
	
    if object ~= nil then
	    local objectPK = ""
		local objectName = ""

		if object.PK ~= nil then
			objectPK = object.PK
		end
		if object.Name ~= nil then
			objectName = object.Name
		end
		
        return "ObjectPK=" .. objectPK .. ", ObjectName=" .. objectName .. "\n"
    end
    
    local statement = SQLParser.GetStatementType(Line)
    if statement == nil then
        return nil
    end

    if statement ~= "insert" then 
        return nil
    end
    
    local tableName = SQLParser.GetTableName(Line)
    if tableName == nil then
        error("Error: TableName invalid.")
    end

    local textInfo
    
    textInfo = "Type:" .. statement .. "\n"
    textInfo = textInfo .. "TableName:" .. tableName .. "\n"

    local tableFields = { }
    tableFields = SQLParser.GetFieldsAndValues(Line)

    textInfo = textInfo .. "Fields:" .. "\n"
    if tableNames == nil then
        textInfo = textInfo .. "tableNames nil" .. "\n"
    else
        for col, value in pairs (tableFields.Fields) do
            textInfo = textInfo .. col .. "=" .. value .. "\n"
        end
    end

    textInfo = textInfo .. "***********" .. "\n"
    
    return textInfo

end

--.-----------------------------------------
--. GetObject(Line)                       --
--. return string, string                 -- 
--.-----------------------------------------
function GetObject(Line)

    local line = string.trim(Line)

    if string.len(Line) == 0 then
        return nil
    end
    
    if string.sub(line, 1, 2) ~= "/*" then
        return nil
    end

    line = string.subAndTrim(line, 3, string.len(line) - 2)
        
    local pos  = string.find(line, "[:]")
    if pos == nill then
        return nil
    end

	local object = { }
    object.Name = string.upper(string.subAndTrim(line, 1, pos - 1))
    object.PK = string.subAndTrim(line, pos + 1, string.len(line))
    
    return object

end

--.----------------------------------------------
--. GetStatementType(Line)                     --                        
--. return string 'insert', 'update', 'delete' -- 
--.----------------------------------------------
function GetStatementType(Line)

    local line = string.trim(Line)
    
    if string.len(line) == 0 then
        return nil
    end
    
    local pos  = string.find(line, "[ ]")

    if pos ~= nill then
        local statement = string.sub(line, 1, pos - 1)
        statement = string.lower(statement)

        if statement ~= "insert" and statement ~= "update" and statement ~= "delete" then
            return nil
        else
             return statement
        end
    else
        return nil
    end
    
end

--.----------------------
--. GetTableName(Line) --
--. return string      -- 
--.----------------------
function GetTableName(Line)

    local statementType = SQLParser.GetStatementType(Line)
    if statementType == nil then
        return nil
    end
    
    if statementType == "insert" then
        return SQLParser.GetTableNameFromInsert(Line)

    elseif statementType == "update" then
        return SQLParser.GetTableNameFromUpdate(Line)
        
    elseif statementType == "delete" then

        return SQLParser.GetTableNameFromDelete(Line)
    else

        return nil
    end

end

--.-------------------------------------
--. GetSchemaFromTableName(TableName) --
--. return string                     -- 
--.-------------------------------------
function GetSchemaFromTableName(TableName)

    local pos = string.find(TableName, "[.]")
    if pos == nill then
		return nil
	end

    return string.subAndTrim(TableName, 1, pos - 1)

end

--.----------------------------------------
--. RemoveSchemaFromTableName(TableName) --
--. return string                        -- 
--.----------------------------------------
function RemoveSchemaFromTableName(TableName)

    local pos = string.find(TableName, "[.]")
    if pos == nill then
		return TableName
	end

    return string.subAndTrim(TableName, pos + 1, string.len(TableName))

end

--.----------------------------
--. GetFieldsAndValues(Line) --
--. return table, table      --
--.----------------------------
function GetFieldsAndValues(Line)

    local statementType = SQLParser.GetStatementType(Line)
    if statementType == nil then
        return nil
    end
        
    if statementType == "insert" then
        return SQLParser.GetFieldsAndValuesFromInsert(Line)

    elseif statementType == "update" then
        return SQLParser.GetFieldsAndValuesFromUpdate(Line)
        
    elseif statementType == "delete" then

        return SQLParser.GetFieldsAndValuesFromDelete(Line)
    else

        return nil
    end
		
end

--.----------------------------------------------------
--. IsValidStatement(StatementType, TableFields)     --
--. return boolean                                   --
--.----------------------------------------------------
function IsValidStatement(StatementType, TableFields)

	if StatementType == "insert" then
	    return TableFields.HasColumnNames
	end
	
	return true
	
end

--.------------------
--. GetWhere(Line) --
--. return string  --
--.------------------
function GetWhere(Line)

    local statementType = SQLParser.GetStatementType(Line)
    if statementType == nil then
        return nil
    end
        
    if statementType == "insert" then
        return SQLParser.GetWhereFromInsert(Line)

    elseif statementType == "update" then
        return SQLParser.GetWhereFromUpdate(Line)
        
    elseif statementType == "delete" then

        return SQLParser.GetWhereFromDelete(Line)
    else

        return nil
    end


end


--.------------------------------
--. INSERT Statement functions --
--.------------------------------

--.----------------------------------------------------
--. GetTableNameFromInsert(Line)                     --
--. return string                                    --
--. Note: It's safer to call from GetTableName(Line) --
--.----------------------------------------------------
function GetTableNameFromInsert(Line)

    local line = string.trim(Line) 
	
    local pos  = string.find(line, "[ ]")

    if pos == nill then
        return nil
    end
    
    line = string.subAndTrim(line, pos, string.len(line))
    
    pos  = string.find(line, "[ ]")
    if pos == nill then
        return nil
    end
     
    line = string.subAndTrim(line, pos, string.len(line))
    line = string.trim(line)
    
    pos  = string.find(line, "[( ]") -- space or (
    if pos == nill then
        return nil
    end
    
	return string.subAndTrim(line, 1, pos - 1)

end

--.----------------------------------------------------------
--. GetFieldsAndValuesFromInsert(Line)                     --
--. return table                                           --
--. Note: It's safer to call from GetFieldsAndValues(Line) --
--.----------------------------------------------------------
function GetFieldsAndValuesFromInsert(Line)

    --get string between first "(" and last ")"
    local line = string.trim(Line)
    local pos = string.find(line, "[(]")
    if (pos == nil) then
        return nil
    end

    line = string.subAndTrim(line, pos + 1, string.len(line))

    pos = string.findLast(line, "[)]")
    if (pos == nil) then
        return nil
    end

    line = string.subAndTrim(line, 1, pos)

    if (string.len(line) == 0) then
        return nil
    end
    
    --split to array elements
    local elements = { }
    local elementsCount = 1
    local temp = ""
    local isInQuotes = false
    local hasValuePart = false
	local isInNamesPart = true
	local writeElem = false
        
  	for idx = 1, string.len(line), 1 do

        local chr = string.sub(line, idx, idx)

		--is between "'" ignore
        if (chr == "'") then
            isInQuotes = not isInQuotes
        end

        if (not isInQuotes) then

			if (isInNamesPart) then
				--if end of names part (write last name)
				if (chr == ')') then
					writeElem = true
				elseif (chr == "(") then
				--if begin of values part 
					isInNamesPart = false
					hasValuePart = true
					writeElem = true
				end  
			end

			
			--if field or value sparator
            if (chr == ",") then
				writeElem = true
			end
			
			if (writeElem) then
                elements[elementsCount] = string.trim(temp)
                elementsCount = elementsCount + 1
                temp = ""
                chr = ""
				writeElem = false
            end
			
        end

        temp = temp .. chr

	end
    
    elements[elementsCount] = string.trim(temp)
 
    --add elements to table pair Name, Value
    local tableFields = { }
    local fields = { }
	local columns = {}
 
    if hasValuePart then
        tableFields.HasColumnNames = true
        elementsCount = math.floor(table.maxn(elements) / 2)
   	    for idx = 1, elementsCount, 1 do
   	        fields[elements[idx]] = elements[idx + elementsCount + 1]
			columns[idx] = elements[idx]
			
        end
	else
        tableFields.HasColumnNames = false
        fields = elements
        elementsCount = math.floor(table.maxn(elements))
   	    for idx = 1, elementsCount, 1 do
			local fld = "Field" .. tostring(idx)
   	        fields[fld] = elements[idx]
			columns[idx] = fld
        end
    end
    
    tableFields.Fields = fields
    tableFields.Columns = columns
       
    return tableFields
    
end

--.------------------------------------------------
--. GetWhereFromInsert                           --
--. return string                                --
--. Note: It's safer to call from GetWhere(Line) --
--.------------------------------------------------
function GetWhereFromInsert(Line)

	return nil
	
end

--.------------------------------
--. UPDATE Statement functions --
--.------------------------------

--.----------------------------------------------------
--. GetTableNameFromUpdate(Line)                     -- 
--. return string                                    --
--. Note: It's safer to call from GetTableName(Line) --
--.----------------------------------------------------
function GetTableNameFromUpdate(Line)
	
    local line = string.trim(Line) 

	--jump to the end of "update" word
    local pos  = string.find(line, "[ ]")
    if pos == nill then
        return nil
    end
    
    line = string.subAndTrim(line, pos, string.len(line))
    
	--jump to the end of tableName word
    pos  = string.find(line, "[ ]")
    if pos == nill then
        return nil
    end
     
    return string.subAndTrim(line, 1, pos - 1)

end

--.----------------------------------------------------------
--. GetFieldsAndValuesFromUpdate(Line)                     --
--. return table                                           --
--. Note: It's safer to call from GetFieldsAndValues(Line) --
--.----------------------------------------------------------
function GetFieldsAndValuesFromUpdate(Line)

	--remove the end statement ";"
    local line = string.trim(Line) 
	if string.sub(line, string.len(line), string.len(line)) == ";" then
		line = line.subAndTrim(line, 1, string.len(line) - 1) 
	end

	--jump to the end of "update" word
    local pos = string.find(line, "[ ]")
    if (pos == nil) then
        return nil
    end

    line = string.subAndTrim(line, pos, string.len(line))

	--jump to the end of tableName word
    pos = string.find(line, "[ ]")
    if (pos == nil) then
        return nil
    end
	
    line = string.subAndTrim(line, pos, string.len(line))

	--jump to the end of "set" word
    pos = string.find(line, "[ ]")
    if (pos == nil) then
        return nil
    end
	
    line = string.subAndTrim(line, pos, string.len(line))

    --split to array elements
    local elements = { }
    local elementsCount = 0

	pos = GetNextEndPosition(line)
	
	while pos ~= nil do
	
	    local temp = string.subAndTrim(line, 1, pos - 1)
		if string.upper(temp) == "WHERE" then
			pos = nil
		else
			if temp ~= "" then
				elementsCount = elementsCount + 1
				elements[elementsCount] = temp
			end
			
			line = string.subAndTrim(line, pos + 1, string.len(line))
			pos = GetNextEndPosition(line)
			if pos == string.len(line) then
				pos = nil
			end
		end

	end
    
    --add elements to table pair Name, Value
    local tableFields = { }
    local fields = { }
    local columns = { } 
	
    tableFields.HasColumnNames = true
    for idx = 1, elementsCount, 2 do
        fields[elements[idx]] = elements[idx + 1]
		columns[idx] = elements[idx]
    end
    
    tableFields.Fields = fields
	tableFields.Columns = columns
	
	return tableFields

end

--.------------------------------------------------
--. GetWhereFromUpdate                           --
--. return string                                --
--. Note: It's safer to call from GetWhere(Line) --
--.------------------------------------------------
function GetWhereFromUpdate(Line)

	--remove the end statement ";"
    local line = string.trim(Line) 
	if string.sub(line, string.len(line), string.len(line)) == ";" then
		line = line.subAndTrim(line, 1, string.len(line) - 1) 
	end

	--jump to the end of "update" word
    local pos = string.find(line, "[ ]")
    if (pos == nil) then
        return nil
    end

    line = string.subAndTrim(line, pos, string.len(line))

	--jump to the end of tableName word
    pos = string.find(line, "[ ]")
    if (pos == nil) then
        return nil
    end
	
    line = string.subAndTrim(line, pos, string.len(line))

	--jump to the end of "set" word
    pos = string.find(line, "[ ]")
    if (pos == nil) then
        return nil
    end
	
    line = string.subAndTrim(line, pos, string.len(line))

    --split elements
	pos = GetNextEndPosition(line)
	
	while pos ~= nil do
		local temp = string.subAndTrim(line, 1, pos - 1)
		
		line = string.subAndTrim(line, pos + 1, string.len(line))

		if string.upper(temp) == "WHERE" then
			pos = nil
		else
			pos = GetNextEndPosition(line)
			if pos == string.len(line) then
				pos = nil
			end
		end

	end

	if line == "" then
		return nil
	end

	return line

end

--.-------------------------------------
--. function GetNextEndPosition(Line) --
--. return int                        --
--.-------------------------------------
function GetNextEndPosition(Line)

    local isInQuotes = false

  	for idx = 1, string.len(Line), 1 do

        local chr = string.sub(Line, idx, idx)

        if (chr == "'") then
            isInQuotes = not isInQuotes
        end

        if (not isInQuotes) then

			if chr == "," or chr == "=" or chr == " " then
                return idx
            end
            
        end

	end
	
	return string.len(Line)

end

--.------------------------------
--. DELETE Statement functions --
--.------------------------------

--.----------------------------------------------------
--. GetTableNameFromDelete(Line)                     --
--. return string                                    --
--. Note: It's safer to call from GetTableName(Line) --
--.----------------------------------------------------
function GetTableNameFromDelete(Line)
    
    local line = string.trim(Line) 
	
	--jump to the end of "delete" word
    local pos  = string.find(line, "[ ]")
    if pos == nill then
        return nil
    end
    
    line = string.subAndTrim(line, pos, string.len(line))
    
	--jump to the end of "from" word
    pos  = string.find(line, "[ ]")
    if pos == nill then
        return nil
    end
    
    line = string.subAndTrim(line, pos, string.len(line))
    
	--jump to the end of tableName word
    pos  = string.find(line, "[ ]")
    if pos == nill then
        return nil
    end
    
    return string.subAndTrim(line, 1, pos - 1)

end

--.----------------------------------------------------------
--. GetFieldsAndValuesFromDelete(Line)                     --
--. return table                                           --
--. Note: It's safer to call from GetFieldsAndValues(Line) --
--.----------------------------------------------------------
function GetFieldsAndValuesFromDelete(Line)

    --delete statement don't have Fields
    local tableFields = { }
    local fields = { }
	
    tableFields.HasColumnNames = true
    tableFields.Fields = fields

    return tableFields

end

--.------------------------------------------------
--. GetWhereFromDelete                           --
--. return string                                --
--. Note: It's safer to call from GetWhere(Line) --
--.------------------------------------------------
function GetWhereFromDelete(Line)

	--remove the end statement ";"
    local line = string.trim(Line) 
	if string.sub(line, string.len(line), string.len(line)) == ";" then
		line = line.subAndTrim(line, 1, string.len(line) - 1) 
	end
	
	--jump to the end of "delete" word
    local pos  = string.find(line, "[ ]")
    if pos == nill then
        return nil
    end
    
    line = string.subAndTrim(line, pos, string.len(line))
    
	--jump to the end of "from" word
    pos  = string.find(line, "[ ]")
    if pos == nill then
        return nil
    end
    
    line = string.subAndTrim(line, pos, string.len(line))
    
	--jump to the end of tableName word
    pos  = string.find(line, "[ ]")
    if pos == nill then
        return nil
    end

    line = string.subAndTrim(line, pos, string.len(line))
	
	if line == "" then
		return nil
	end

	--jump to the end of "where" word
    pos  = string.find(line, "[ ]")
    if pos == nill then
        return nil
    end
	
    line = string.subAndTrim(line, pos, string.len(line))

	return line
	
end

--.-------------------
--. HasEndStatement --
--. return true     --
--.-------------------
function HasEndStatement(Line)

    local line = string.trim(Line) 
	
	return string.sub(line, string.len(line), string.len(line)) == endStatementChar 
		
end

--.-------------------
--. HasEndStatement --
--. return true     --
--.-------------------
function AddEndStatement(Line)

    local line = string.trim(Line) 
	
	return line .. endStatementChar 
		
end
