--.---------------------------------------------
--. utilFunctions.lua (Version:1.0)         --
--. Implement new util functions  --
--.---------------------------------------------

--.--------------------
--. Prefix functions --
--.--------------------
module("utils", package.seeall)

--.-------------------------------------------------------------------
--. utils.FileTest(FileName, For, errorMsg, StopRun) return boolean --
--.-------------------------------------------------------------------
function FileTest(FileName, For, errorMsg, StopRun)

    local file = io.open(FileName, For)
    if file == nil then
		if StopRun then
			error("ERROR:" .. errorMsg)
		else
			return false
		end
    end
    io.close(file)
	
	return true
end
