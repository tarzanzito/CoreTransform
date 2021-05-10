--.------------------------------------------------------
--. SimpleTest.lua                                         --
--. bla bla bla ba                                     --
--.------------------------------------------------------

--.------------
--. includes --
--.------------
--require("SQLParser")  nao percebi!!!!!!!!!!!!!!!!!
dofile("SQLParser.lua")


--.----------------
--. Main Program --
--.----------------
print('Program Started...')


local Line = '      insert   into    Split_Def   (   AUTOOPEN,FK_EXTENSION,FK_PARENT,PK_NAME,PRINT_LANDSCAPE,MAXIMIZED,PK,CALC_ALWAYS,FK_OWNER_OBJ) values (\'0\',288.1,2719.1,\'sp_a\'\'rt\'\'ist\',\'0\',\'0\',2518.1,\'0\',1.1  )   ;     '
--local Line = '      insert   into    Split_Def (\'0\',288.1,2719.1,\'sp_a\'\'rt\'\'ist\',\'0\',\'0\',2518.1,\'0\',1.1  )   ;     '


print("\n" .. "Linha a Processar:\n" .. Line .. "\n")

local statement = SQLParser.GetStatementType(Line)
print("Statement:" .. statement)

local tableName = SQLParser.GetTableName(Line)
print("TableName:" .. tableName)

local tableFields = { }
tableFields = SQLParser.GetFieldsAndValues(Line)

print("Fields: With columns Name=" .. tostring(tableFields.HasColumnNames))
if tableFields == nil then
    print("tableNames nil")
else
    for col, value in pairs (tableFields.Fields) do
        print(col .. "=" .. value)
    end
end


print('Program finished.')