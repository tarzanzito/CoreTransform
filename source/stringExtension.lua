--.---------------------------------------------
--. stringExtension.lua (Version:1.0)         --
--. Implement new functions in string package --
--.---------------------------------------------

--.--------------------
--. Prefix functions --
--.--------------------
module("string", package.seeall)

--.----------------------------------
--. string.trim(str) return string --
--.----------------------------------
function trim(str)
	-- Function by Colandus
	return (string.gsub(str, "^%s*(.-)%s*$", "%1"))
end

--.-----------------------------------------------
--. string.subAndTrim (str, i, j) return string --
--.-----------------------------------------------
function subAndTrim (str, i, j)

    local stmp = string.sub(str, i, j)
    stmp = string.trim(stmp)
    
    return stmp
end

--.--------------------------------------------
--. string.findLast(str, pattern) return int --
--.--------------------------------------------
function findLast(str, pattern)

    if string.len(str) == 0 then
        return nil
    end

    if string.len(pattern) < 3 then
        return nil
    end

    if string.sub(pattern, 1, 1) ~= "[" or string.sub(pattern, string.len(pattern), string.len(pattern)) ~= "]" then
        return nil
    end

    local ptmp = string.sub(pattern, 2, string.len(pattern) - 1)
    ptmp = string.reverse(ptmp)
    ptmp = "[" .. ptmp .. "]"

    local stmp = string.reverse(str)
    local pos  = string.find(stmp, ptmp)
    
    if pos == nil then
        return nill
    end
    
    pos = string.len(str) - pos

	return pos
end