ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Custom Money Printer"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",1,"Degrees")
	self:NetworkVar("Int",2,"Money")
	self:NetworkVar("Int",3,"SpeedVal")
	self:NetworkVar("Int",4,"Payout")
end
