# CoreTransform
Transform sql statements based on 'lua' table rules.

Example:
On Database 'Xpto' the 'table1' (V1) was changed to (V2):  
Column3 was removed
columnNew1, columnNew2 are new 

TABLE1 - V1 (input file)

INSERT INTO table1 VALUES (column1, column2, column3) VALUES ('value1a', 'value2a', 'value3a');  
INSERT INTO table1 VALUES (column1, column2, column3) VALUES ('value1a', 'value2a', 'value3a');  

TABLE1 - V2 (output file)

INSERT INTO table1 VALUES (column1, column3, columnNew1, columnNew2) VALUES ('value1a', 'value3a', 'valueNew1A', 'valueNew2A');  
INSERT INTO table1 VALUES (column1, column3, columnNew1, columnNew2) VALUES ('value1a', 'value3a', 'valueNew1B', 'valueNew2B');  

 

Example:
Rules/Files.lua

function InitRules()

    local currentRules = {
			default = {
				insert = {
					qualifiedName = qualifiedNameFunc <---- all inserts call this function
				}
				,update = {
					qualifiedName = qualifiedNameFunc  <---- all updates call this function
					,whereProcess = whereProcessFunc   <--- and call this function to change WHERE
				}
				,delete = {
					qualifiedName = qualifiedNameFunc  <---- all deletes call this function
					,whereProcess = whereProcessFunc   <--- and call this function to change WHERE
				}
			}
			,generic = genericFunc <-- After call this func to all statements
    }
   
   return currentRules
   
end  

