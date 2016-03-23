AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

sound.Add( {
	name = "moneyprinter_idle",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	pitch = 100,
	sound = "ambient/levels/labs/equipment_beep_loop1.wav"
} )

function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox01a.mdl")
    self:SetMaterial("models/debug/debugwhite")
	self:SetColor(Color(50,50,50))

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self.pipe = ents.Create( "prop_dynamic" )
    self.pipe:SetModel( "models/props_junk/propane_tank001a.mdl" )
    self.pipe:SetPos( self:GetPos() + (self:GetAngles():Up() * 5) + (self:GetAngles():Right() * 15))
    self.pipe:SetAngles( self:GetAngles() + Angle(0,-90,90) )
    self.pipe:SetParent( self )
    self.pipe:SetModelScale(0.75,0)
    self.pipe:SetMaterial("models/debug/debugwhite")
	self.pipe:SetColor(Color(50,50,50))
    self.pipe:Spawn( )

	self.bar = ents.Create( "prop_dynamic" )
    self.bar:SetModel( "models/props_c17/playground_teetertoter_stan.mdl" )
    self.bar:SetPos( self:GetPos() + (self:GetAngles():Up() * 5) + (self:GetAngles():Right() * -4))
    self.bar:SetAngles( self:GetAngles() + Angle(0,180,90) )
    self.bar:SetParent( self )
    self.bar:SetModelScale(0.75,0)
    self.bar:SetMaterial("models/debug/debugwhite")
	self.bar:SetColor(Color(50,50,50))
    self.bar:Spawn( )

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then 
		phys:Wake()
	end
	self:EmitSound("moneyprinter_idle")
	self:SetDegrees(0)
	self.LastMoney = 0


end

function ENT:Think()
	--[/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\]
	-- SET THE MONIES IN DOLLAS..EZ
	Payout = 5000
	self:SetPayout(Payout)
	--[/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\]

	--[/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\]
	-- SET THE SPEED OF THE PRINTER / 60
	-- 0.5 = 2min, 1 = 60sec, 2 = 30sec, 4 = 15sec etc
	Speed = 4
	self:SetSpeedVal(Speed)
	--[/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\]
	self:SetDegrees(self:GetDegrees() + Speed)
	if self:GetDegrees() > 360 then 
		self:SetDegrees(0)
		self:SetMoney(self:GetMoney()+self:GetPayout())
	end
	if self:GetMoney() > self.LastMoney then
		self:EmitSound("buttons/combine_button7.wav",75,100,1,0)
	end
	self.LastMoney = self:GetMoney()
end

function ENT:Use(a, c)
	self.money = self:GetMoney()
	self:SetMoney(0)
	if self.money > 0 then
		self:EmitSound("ambient/machines/combine_terminal_idle4.wav",75,100,1,0)
	end
	c:addMoney(self.money)
end


function ENT:OnRemove( )
	self.Entity:StopSound( "moneyprinter_idle" )
end