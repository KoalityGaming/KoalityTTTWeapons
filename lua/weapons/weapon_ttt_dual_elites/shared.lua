if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType = "duel"
   

if CLIENT then
   SWEP.PrintName = "Dual Elites"
   SWEP.Slot = 1

   SWEP.Icon = "VGUI/ttt/icon_pistol"
end

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_PISTOL

SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil	= 1.5
SWEP.Primary.Damage = 17
SWEP.Primary.Delay = 0.18
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 20
SWEP.Primary.ClipMax = 60
SWEP.Primary.Ammo = "Pistol"
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"
SWEP.Primary.Sound = Sound( "Weapon_P228.Single" )

SWEP.ViewModel  = "models/weapons/v_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"

SWEP.IronSightsPos = Vector(0.0749, -5.5216, 2.3984)
SWEP.IronSightsAng = Vector(2.5174, -0.0099, 0)