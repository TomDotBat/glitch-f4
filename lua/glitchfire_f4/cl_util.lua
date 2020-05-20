
function getScaledSize(num, axis)
	if axis == "x" then
		num = ScrW() * (num/1920)
	end


	if axis == "y" or axis == nil then
		num = ScrH() * (num/1080)
	end
	
	return math.Round(num)
end

local function createFont(size, thickness)
	surface.CreateFont(thickness and "GF_F4_"..size.."_"..thickness or "GF_F4_"..size, {
		font = "Roboto",
		extended = false,
		size = getScaledSize(size, "y"),
		weight = thickness and thickness or 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )
end

createFont(22, 10000)
createFont(22, 5000)
createFont(22, 10)
createFont(22)
createFont(30)
createFont(16, 10)
createFont(12, 10)
createFont(16, 30)
createFont(16)
createFont(20, 10)
createFont(20, 30)
createFont(20, 50)
createFont(24, 50)
createFont(22, 30)