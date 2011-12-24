------------------------------------------------------------------------------------------------------------------------
--
-- RapaNui
--
-- by Ymobe ltd  (http://ymobe.co.uk)
--
-- LICENSE:
--
-- RapaNui uses the Common Public Attribution License Version 1.0 (CPAL) http://www.opensource.org/licenses/cpal_1.0.
-- CPAL is an Open Source Initiative approved
-- license based on the Mozilla Public License, with the added requirement that you attribute
-- Moai (http://getmoai.com/) and  RapaNui in the credits of your program.
------------------------------------------------------------------------------------------------------------------------

local M = {}

local landscape = true
local device = "iPad" 


local sizes = {}
sizes["iPad"] = {1024, 768, 670, 503}
sizes["iPhone"] = {480, 320, 670, 503}

M.PW, M.PH, M.SW, M.SH = sizes[device][1],sizes[device][2], sizes[device][3], sizes[device][4]

if landscape == false then -- flip Widths and Hieghts
	M.PW, M.PH = M.PH, M.PW
	M.SW, M.SH = M.SH, M.SW
end

return M