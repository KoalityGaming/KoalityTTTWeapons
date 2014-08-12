---- Example TTT custom weapon

-- First some standard GMod stuff
if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddFile("materials/VGUI/ttt/ak47_icon_dark.png")
   resource.AddFile("sound/weapons/ak47/boomak.mp3")
end

if CLIENT then
   SWEP.PrintName = "AK47"
   SWEP.Slot      = 6 -- add 1 to get the slot number key

   SWEP.ViewModelFOV  = 72
   SWEP.ViewModelFlip = true
   
		SWEP.EquipMenuData = {
      --type = "item_weapon",
	  type  = "Weapons",
      desc = "Koala Brand AK47. Powerful and Efficient"
   };
   SWEP.Icon = "VGUI/ttt/ak47_icon_dark.png"
   
   --Boom Ak sound
   sound.Add({
		name = 			"BOOMAK",
		channel = 		CHAN_ITEM,
		volume = 		1.0,
		sound = 			"weapons/ak47/boomak.mp3"
	})
end

-- Always derive from weapon_tttbase.
SWEP.Base				= "weapon_tttbase"

--- Standard GMod values

SWEP.HoldType			= "ar2"

SWEP.Primary.Delay       = 0.08
SWEP.Primary.Recoil      = 1--1.9
SWEP.Primary.Automatic   = true
SWEP.Primary.Damage      = 25--15
SWEP.Primary.Cone        = 0.025
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.ClipSize    = 45
SWEP.Primary.ClipMax     = 1
SWEP.Primary.DefaultClip = 45
SWEP.HeadshotMultiplier = 1.2
SWEP.Primary.Sound       = Sound( "Weapon_AK47.Single" )
SWEP.NextSong = CurTime()
SWEP.Block = false

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.LimitedStock = true -- only buyable once
--SWEP.WeaponID = AMMO_Ak47

SWEP.IronSightsPos = Vector( 6.05, -5, 4.4 )
SWEP.IronSightsAng = Vector( 2.2, -0.1, 0 )

SWEP.ViewModel  = "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"


--- TTT config values

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_EQUIP2

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
-- be spawned as a random weapon. Of course this AK is special equipment so it won't,
-- but for the sake of example this is explicitly set to false anyway.
SWEP.AutoSpawnable = true

-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

-- If IsSilent is true, victims will not scream upon death.
SWEP.IsSilent = false

-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = false



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

function SWEP:BoomAK()
	if ( self.Owner:IsPlayer() && self.Owner:KeyDown( IN_ATTACK ) ) then
		local length = 1.7
		if self.NextSong > CurTime() then return end
		self.Owner:EmitSound( "BOOMAK" )
		self.NextSong = CurTime() + length
		timer.Simple(length, function() self:BoomAK() end )
		
	else
		
	end
end
	

function SWEP:Think()
	if ( self.Owner:IsPlayer() && self.Owner:KeyDown( IN_ATTACK ) ) then
		--self:BoomAK()	
		local length = 1.7
		if self.NextSong > CurTime() then return end
		self.Owner:EmitSound( "BOOMAK" )
		self.NextSong = CurTime() + length
	else
		
	end
end