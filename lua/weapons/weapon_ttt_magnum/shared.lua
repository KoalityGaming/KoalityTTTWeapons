if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddFile("materials/VGUI/ttt/magnum_icon_dark.png")
end
   
SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName			= "Magnum Revolver"

   SWEP.Slot		    = 1
   SWEP.SlotPos			= 1
   
   SWEP.Icon = "VGUI/ttt/magnum_icon_dark.png"
   SWEP.ViewModelFlip = false
   SWEP.ViewModelFOV  = 60
end

SWEP.Base				= "weapon_tttbase"

SWEP.Kind = WEAPON_EQUIP
SWEP.WeaponID = AMMO_DEAGLE

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo       = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage = 50
SWEP.Primary.Delay = 0.9
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 6
SWEP.Primary.ClipMax = 36
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = true

SWEP.HeadshotMultiplier = 20

SWEP.AutoSpawnable      = true

SWEP.AmmoEnt = "item_ammo_revolver_ttt"

SWEP.Primary.Sound 		= Sound("Weapon_357.Single")

SWEP.ViewModel			= "models/weapons/v_357.mdl"
SWEP.WorldModel			= "models/weapons/w_357.mdl"

SWEP.IronSightsPos 		= Vector (-5.6891, -3.925, 4.5776)
SWEP.IronSightsAng 		= Vector (0.214, -0.1767, 0)

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