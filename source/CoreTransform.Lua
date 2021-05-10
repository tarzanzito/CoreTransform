--.----------------------------------------------------------------------------------------------
--. CoreTransform.lua (Version: 1.8)  (Note:change variavel version)                           --
--.                                                                                            --
--. Usage:                                                                                     -- 
--. lua.exe CoreTransform.lua -c Input_SQL_file.sql Output_SQL_file.sql HighCore LowCore       --
--. lua.exe CoreTransform.lua -s Input_SQL_file.sql Output_SQL_file.sql rules/Rules_A_To_B.lua --
--.                                                                                            --
--. Look for 'Program Start Here'                                                              --
--.----------------------------------------------------------------------------------------------

--.------------
--. includes --
--.------------
dofile("source/UtilFunctions.lua")
dofile("source/SQLParser.lua")
dofile("source/ruleProcessor.lua")

local version = "1.8"
local rulesFolder = "rules/"
local msg = "\n\nUsage: CoreTransform -c input.sql output.sql HighCore LowCore" ..
            "\n       CoreTransform -s input.sql output.sql rules.lua\n"

--.----------------------------------------------------------------
--. ParametersValidation()                                       --
--. return table with groups of NameInput, NameOutput, NameRules --
--.----------------------------------------------------------------
function ParametersValidation()

    if arg == nil then
        error("ERROR: parameters not found." .. msg)
    end
	
    if table.maxn(arg) ~= 4 and table.maxn(arg) ~= 5 then
        error("Number of parameters wrong." .. msg)
    end
	
	if (arg[1] == "-c") then
		return ParametersValidationForCores()
	end
	
	if (arg[1] == "-s") then
		return ParametersValidationForSingle()
	end
	
    error("First parameter: must be -c or -s" .. msg)
      
   return nil
   
end

--.-----------------------------------------------------------------------
--. ParametersValidationForSingle()                                     --
--. return table with unique item with NameInput, NameOutput, NameRules --
--.-----------------------------------------------------------------------
function ParametersValidationForSingle()
	
    print("")
    print("File Input   : " .. arg[2])
    print("File Output  : " .. arg[3])
	print("Lua Rules    : " .. arg[4])
	print("Action       : SQL Transform.")
		
    local nameInput = arg[2] 
    local nameOutput = arg[3]
	local nameRules = arg[4]
	
	utils.FileTest(nameInput, "r", "Second parameter. File not found." .. msg, true)
	utils.FileTest(nameOutput, "w", "Third parameter. File cannot be create." .. msg, true)
	utils.FileTest(nameRules, "r", "Fourth parameter. File not found." .. msg, true)
	
    local filesName = { }
    filesName[1] = {}
    filesName[1].fileNameInput = nameInput
    filesName[1].fileNameOutput = nameOutput
    filesName[1].fileNameRules = nameRules
      
   return filesName
   
end

--.----------------------------------------------------------------
--. ParametersValidationForCores()                               --
--. return table with groups of NameInput, NameOutput, NameRules --
--.----------------------------------------------------------------
function ParametersValidationForCores()

    print("")
    print("File Input   : " .. arg[2])
    print("File Output  : " .. arg[3])
	print("High Core Num: " .. arg[4])
	print("Low  Core Num: " .. arg[5])
	print("Action       : Cores Transform.")
		
    local nameInput = arg[2]
    local nameOutput = arg[3]
	local highCore = tonumber(arg[4])
	local lowCore = tonumber(arg[5])
	
	utils.FileTest(nameInput, "r", "Second parameter. File not found." .. msg, true)
	utils.FileTest(nameOutput, "w", "Third parameter. File cannot be create." .. msg, true)
	
    if highCore == nil then
        error("Fourth parameter must be a number." .. msg)
    end

    if highCore < 10 or highCore > 99 then
        error("Fourth parameter must be in [10...99]." .. msg)
    end
        
    if lowCore == nil then
        error("Fifth parameter must be a number." .. msg)
    end

    if lowCore < 10 or highCore > 99 then
        error("Fifth parameter must be in [10...99]." .. msg)
    end

    if lowCore >= highCore then
        error("Fifth parameter must greater than fourth parameter." .. msg)
    end

    lowCore = lowCore + 1
    local filesName = { }
    
    for i =  highCore, lowCore, -1 do
        
        local nameRules = rulesFolder .. "Rules_" .. tostring(i) .. "_To_" .. tostring(i - 1) .. ".lua"
        
		utils.FileTest(nameRules, "r", "File rules not found:[" .. nameRules .. "]" .. msg, true)

        local tempInput
        if i == highCore then
            tempInput = nameInput
        else
            tempInput = "temp_" .. tostring(i) .. ".txt"
        end
        
        local tempOutput
        if i == lowCore then
            tempOutput = nameOutput
        else
            tempOutput = "temp_" .. tostring(i - 1) .. ".txt"
        end

        local item = highCore - i + 1
        
        filesName[item] = {}
        filesName[item].fileNameInput = tempInput
        filesName[item].fileNameOutput = tempOutput
        filesName[item].fileNameRules = nameRules
    end
      
   return filesName
   
end

--.-------------------------------------------------
--. function ProcessStatement(Line)               --  
--. return string                                 --
--.-------------------------------------------------
function ProcessStatement(Line)
    
    local result = RuleProcessor.ApplyRules(Line)
    
    return result
    
end

--.-------------------------------------------------------------
--. ProcessFile(FileNameInput, FileNameOutput, FileNameRules) --
--. return none                                               --
--.-------------------------------------------------------------
function ProcessFile(FileNameInput, FileNameOutput, FileNameRules)

    local fileInput = io.open(FileNameInput, "r")
    if fileInput == nil then
        error("File '" .. FileNameInput .. "' error.")
    end    

    local fileOutput = io.open(FileNameOutput, "w")
    if fileOutput == nil then
        error("File '" .. FileNameOutput .. "' error.")
    end    

	--Mount rules file	
    RuleProcessor.InitRules(FileNameRules)

	--Process statements
    for line in fileInput:lines() do
        
        local textInfo = ProcessStatement(line)
        
        if textInfo ~= nil then
            fileOutput:write(textInfo, '\n')
        end
        
    end
    
    io.close(fileOutput)
    io.close(fileInput)
    
end



------------
-- Main() --
------------
function Main()

    local filesName = { }

	--Get array files based on main args and Validate 
    filesName = ParametersValidation()

	--process files
    for name, value in pairs(filesName) do 
        
        print("")
        print("Processing...")
        print("Input :" .. value.fileNameInput)
        print("Output:" .. value.fileNameOutput)
        print("Rules :" .. value.fileNameRules)
        
        ProcessFile(value.fileNameInput, value.fileNameOutput, value.fileNameRules)

    end

	--delete temp files
    print("")
    for name, value in pairs(filesName) do 
        
        if (name ~= 1) then
            print("delete file:" .. value.fileNameInput)
            os.remove(value.fileNameInput)
        end
    end
    print("")
    
end

------------------------
-- Program Start Here --
------------------------
print("CoreTransform (Version: " .. version .. ")")
print("Program Started  at: " .. os.date("%d/%m/%Y %H:%M:%S"))

local status
local message

status, message = pcall(Main) 
if status == false then
    print(message)
    --os.exit(1)
end

print("Program finished at: " .. os.date("%d/%m/%Y %H:%M:%S"))
