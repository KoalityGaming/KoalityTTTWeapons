if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddFile("materials/VGUI/ttt/det_pistol_icon_dark.png")
end
   
SWEP.HoldType = "pistol"
   

if CLIENT then
   SWEP.PrintName = "Detective Pistol" 
   SWEP.Slot = 1
   
      SWEP.EquipMenuData = {
      type  = "Guns",
      name  = "Detective Pistol",
      desc  = "A pistol made for you."
   };
   
   SWEP.ViewModelFlip = false
   SWEP.ViewModelFOV  = 60
   SWEP.Icon = "VGUI/ttt/det_pistol_icon_dark.png"
end

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_PISTOL

SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil	= 1.5
SWEP.Primary.Damage = 25
SWEP.Primary.Delay = 0.1
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 18
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 18
SWEP.Primary.ClipMax = 60
SWEP.Primary.Ammo = "Pistol"
SWEP.AutoSpawnable = false
SWEP.Primary.Automatic = false
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.ViewModel  = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.CanBuy = {ROLE_DETECTIVE} -- only detectives can buy
SWEP.LimitedStock = true -- only buyable once

SWEP.Primary.Sound 		= Sound("Weapon_Pistol.Single")

SWEP.IronSightsPos 		= Vector (-6.0266, -1.0035, 5.9003)
SWEP.IronSightsAng 		= Vector (0.5281, -1.3165, 0.8108)
SWEP.RunArmOffset 		= Vector (0.041, 0, 5.6778)
SWEP.RunArmAngle 		= Vector (-17.6901, 0.321, 0)

function SWEP:SetZoom(state)
   if CLIENT then return end
   if state then
      self.Owner:SetFOV(35, 0.5)
   else
      self.Owner:SetFOV(0, 0.2)
   end
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self.Weapon:GetNextSecondaryFire() > CurTime() then return end

   bIronsights = not self:GetIronsights()

   self:SetIronsights( bIronsights )

   if SERVER then
      self:SetZoom(bIronsights)
   end

   self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
end

function SWEP:PreDrop()
   self:SetZoom(false)
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
   self.Weapon:DefaultReload( ACT_VM_RELOAD );
   self:SetIronsights( false )
   self:SetZoom(false)
end


function SWEP:Holster()
   self:SetIronsights(false)
   self:SetZoom(false)
   return true
end

function SWEP:Reload()
	if !( ( self.Weapon:Clip1() ) < ( self.Primary.ClipSize ) ) then return end
	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	self:EmitSound( "Weapon_Pistol.Reload" )
end
-- Backup reloading sounds
-- Weapon_Pistol.Reload
-- weapons/pistol/pistol_reload1.wav