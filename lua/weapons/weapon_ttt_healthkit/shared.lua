if (SERVER) then
	AddCSLuaFile( "shared.lua" )
	resource.AddFile("materials/vgui/ttt/icon_gpi_hpkit.vmt")
	--resource.AddFile("particles/models/weapons/v_medkit.mdl")
	resource.AddFile("models/jaanus/weapons/v_medkit.mdl")
end

if ( CLIENT ) then
	SWEP.PrintName			= "Portable Healthkit"			
	SWEP.Author				= "Koalas"
	SWEP.Slot				= 7
	--SWEP.ViewModelFOV		= -10
	SWEP.ViewModelFlip  	= false
end


SWEP.HoldType = "slam" 

-- TTT OPS
SWEP.Kind 					= WEAPON_EQUIP2
SWEP.Icon 					= "vgui/ttt/icon_gpi_hpkit"
SWEP.CanBuy 				= { ROLE_TRAITOR, ROLE_DETECTIVE }
SWEP.LimitedStock 			= false
SWEP.WeaponID 				= AMMO_HPKIT
SWEP.EquipMenuData = {
   type = "Tools",
   desc = "One HP Kit. Either heal yourself (right click) or others (left click)!"
};

SWEP.NoSights				= true
SWEP.CanUseKey 				= true

SWEP.Base					= "weapon_tttbase"

SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
	
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel				= "models/jaanus/weapons/v_medkit.mdl"
SWEP.WorldModel				= "models/items/healthkit.mdl"

SWEP.Primary.Recoil			= 0.1
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= .5
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.NumShots		= 1
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

local ShootSound = Sound ("items/smallmedkit1.wav")
local FailSound = Sound ("items/medshotno1.wav")

function SWEP:Reload()
end

function SWEP.Think()
end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end 

function SWEP:PrimaryAttack()
	if SERVER then
		local trace = self.Owner:GetEyeTrace()
		if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 100 then

			local ent = self.Owner:GetEyeTrace().Entity
		  
			if ( ent:IsValid() and ent:IsPlayer() ) then
				if ent:Health() > 125 then
					self.Owner:ChatPrint("Health of Target is Full or Greater!")
				else
					self.Weapon:EmitSound( ShootSound, 60, 100 )
					ent:SetHealth( ent:Health() + 35 )	
					self.Weapon:Remove()
				end
			end 
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		if self.Owner:Health() > 125 then
			self.Owner:ChatPrint("Your health is Full or Greater!")
		else
			self:EmitSound( ShootSound, 60, 100 )
			self.Owner:SetHealth( self.Owner:Health() + 35 )
			self.Weapon:Remove()
		end
	end
end

if CLIENT then
   local draw = draw
   local util = util

	function SWEP:DrawHUD()
		self.BaseClass.DrawHUD(self)
		draw.SimpleText("Left click to heal others, Right click to heal yourself", "TabLarge", ScrW() / 2, ScrH() / 2 - 50, COLOR_RED, TEXT_ALIGN_CENTER)
    end
end