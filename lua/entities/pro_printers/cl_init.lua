include("shared.lua")
surface.CreateFont( "Cash", {
	font = "Arial",size = 50,weight = 700,blursize = 0,antialias = true,
} )
surface.CreateFont( "CashBlur", {
	font = "Arial",size = 50,weight = 700,blursize = 2,antialias = true,
} )
surface.CreateFont( "Cash_Small", {
	font = "Arial",size = 15,weight = 700,blursize = 0,antialias = true,
} )
surface.CreateFont( "CashBlur_Small", {
	font = "Arial",size = 15,weight = 700,blursize = 2,antialias = true,
} )
surface.CreateFont( "Cash_Med", {
	font = "Arial",size = 25,weight = 700,blursize = 0,antialias = true,
} )
surface.CreateFont( "CashBlur_Med", {
	font = "Arial",size = 25,weight = 700,blursize = 2,antialias = true,
} )

local Col = {}
Col.Amethyst = Color(146,89,150)
Col.Emerald = Color(31,78,59)
Col.Ruby = Color(224,17,95)
Col.Sapphire = Color(15,82,186)
Col.Topaz = Color(247,127,32)
Col.Plain = Color(55,72,78)


local function formatCurrency( number )
	local output = number
	if number < 1000000 then
		output = string.gsub( number, "^(-?%d+)(%d%d%d)", "%1,%2" ) 
	else
		output = string.gsub( number, "^(-?%d+)(%d%d%d)(%d%d%d)", "%1,%2,%3" )
	end
	output = "$" .. output
	return output
end

function surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness)
	local triarc = {}
	-- local deg2rad = math.pi / 180
	-- Define step
	local roughness = math.max(roughness or 1, 1)
	local step = roughness
	-- Correct start/end ang
	local startang,endang = startang or 0, endang or 360
	if startang > endang then
		step = math.abs(step) * -1
	end
	-- Create the inner circle's points.
	local inner = {}
	local r = radius - thickness
	for deg=startang, endang, step do
		local rad = math.rad(deg)
		-- local rad = deg2rad * deg
		local ox, oy = cx+(math.cos(rad)*r), cy+(-math.sin(rad)*r)
		table.insert(inner, {
			x=ox,
			y=oy,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		})
	end
	-- Create the outer circle's points.
	local outer = {}
	for deg=startang, endang, step do
		local rad = math.rad(deg)
		-- local rad = deg2rad * deg
		local ox, oy = cx+(math.cos(rad)*radius), cy+(-math.sin(rad)*radius)
		table.insert(outer, {
			x=ox,
			y=oy,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		})
	end
	-- Triangulize the points.
	for tri=1,#inner*2 do -- twice as many triangles as there are degrees.
		local p1,p2,p3
		p1 = outer[math.floor(tri/2)+1]
		p3 = inner[math.floor((tri+1)/2)+1]
		if tri%2 == 0 then --if the number is even use outer.
			p2 = outer[math.floor((tri+1)/2)]
		else
			p2 = inner[math.floor((tri+1)/2)]
		end
		table.insert(triarc, {p1,p2,p3})
	end
	-- Return a table of triangles to draw.
	return triarc
end
function surface.DrawArc(arc)
	for k,v in ipairs(arc) do
		draw.NoTexture()
		surface.DrawPoly(v)
	end
end
function draw.Arc(cx,cy,radius,thickness,startang,endang,roughness,color)
	surface.SetDrawColor(color)
	surface.DrawArc(surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness))
end

local PowerIcon = Material("icon16/lightning.png","no-clamp smooth")
local GradDown = Material("gui/gradient_down")

function ENT:Draw()

	self:DrawModel()

	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(),90)
	local CamPos = self:GetPos() + self:GetAngles():Up() * 11.25

	local ang2 = self:GetAngles()
	local rot = ang2:RotateAroundAxis(ang2:Forward(),0)
	local rot2 = ang2:RotateAroundAxis(ang2:Right(),-45)
	local rot3 = ang2:RotateAroundAxis(ang2:Up(),90)
	local CamPos2 = self:GetPos() + (self:GetAngles():Up() * 7) + (self:GetAngles():Forward() * 21 )

	cam.Start3D2D(CamPos,ang,0.15)

	draw.RoundedBox(0,-101,-105,204,218,Col.Sapphire)

	local Speed = self:GetSpeedVal()
	local ArcStart = 0
	local ArcEnd = self:GetDegrees()
	local TimeLeft = math.ceil((((360-ArcEnd)/360)*60)/Speed)

	if not self.SmoothArc then self.SmoothArc = 0 end
	self.SmoothArc = Lerp(FrameTime()*7,self.SmoothArc,ArcEnd)

	draw.SimpleText("Sapphire Printer","Cash_Med",0,-85,Color(0,0,0),1,1)
	draw.SimpleText("Sapphire Printer","CashBlur_Med",0,-83,Color(0,0,0,255),1,1)
	draw.SimpleText("Sapphire Printer","Cash_Med",0,-87,Color(255,255,255),1,1)

	draw.SimpleText("+"..formatCurrency(self:GetPayout()).." every "..60/Speed.." seconds","Cash_Small",0,85,Color(0,0,0),1,1)
	draw.SimpleText("+"..formatCurrency(self:GetPayout()).." every "..60/Speed.." seconds","CashBlur_Small",0,87,Color(0,0,0,255),1,1)
	draw.SimpleText("+"..formatCurrency(self:GetPayout()).." every "..60/Speed.." seconds","Cash_Small",0,83,Color(255,255,255),1,1)
	
	draw.SimpleText(TimeLeft,"Cash",0,0,Color(0,0,0),1,1)
	draw.SimpleText(TimeLeft,"CashBlur",0,2,Color(0,0,0,255),1,1)
	draw.SimpleText(TimeLeft,"Cash",0,-2,Color(255,255,255),1,1)

	draw.SimpleText("SECONDS","Cash_Small",0,-25,Color(0,0,0),1,1)
	draw.SimpleText("SECONDS","CashBlur_Small",0,-24,Color(0,0,0),1,1)
	draw.SimpleText("SECONDS","Cash_Small",0,-26,Color(255,255,255),1,1)

	draw.SimpleText("LEFT","Cash_Small",0,25,Color(0,0,0),1,1)
	draw.SimpleText("LEFT","CashBlur_Small",0,26,Color(0,0,0),1,1)
	draw.SimpleText("LEFT","Cash_Small",0,24,Color(255,255,255),1,1)

	-- Changes how much detail the circle has. More detail = less FPS
	local ArcFidelity = 2

	draw.Arc(0,0,64,20,0,360,ArcFidelity,Color(0,0,0,150))
	draw.Arc(0,0,67,3,0,360,ArcFidelity,Color(0,0,0))
	draw.Arc(0,0,45,3,0,360,ArcFidelity,Color(0,0,0))
	draw.Arc(0,0,64,19,ArcStart,self.SmoothArc,ArcFidelity,Color(255,255,255))

	--if ElectricNeeds then
		-- surface.SetDrawColor(255,255,255,255)
		-- surface.SetMaterial(PowerIcon)
		-- surface.DrawTexturedRect(76,82,16,16)
		-- draw.Arc(84,90,16,4,0,360,1,Color(255,255,0))
	--end

	cam.End3D2D()

	cam.Start3D2D(CamPos2,ang2,0.15)

		draw.RoundedBox(0,-101,-40,204,75,Col.Sapphire)

		surface.SetDrawColor(0,0,0,150)
		surface.SetMaterial(GradDown)
		surface.DrawTexturedRect(-101,-40,204,32)

	 	self.Money = self:GetMoney() or 0
	    if not self.Smoothed then self.Smoothed = 0 end
		self.Smoothed = Lerp(FrameTime()*7,self.Smoothed,self.Money)
		
		draw.SimpleText(formatCurrency(math.Max(0, math.Round(self.Smoothed))),"Cash",0,0,Color(0,0,0),1,1)
		draw.SimpleText(formatCurrency(math.Max(0, math.Round(self.Smoothed))),"CashBlur",0,2,Color(0,0,0,255),1,1)
		draw.SimpleText(formatCurrency(math.Max(0, math.Round(self.Smoothed))),"Cash",0,-2,Color(75,150,75),1,1)

	cam.End3D2D()

end