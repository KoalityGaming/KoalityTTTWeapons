-- traitor equipment: c4 bomb

if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddFile("sound/jihad/big_explosion.wav")
   resource.AddFile("materials/vgui/entities/weapon_jihadbomb.vtf")
   resource.AddFile("materials/vgui/entities/weapon_jihadbomb.vmt")
   resource.AddFile("sound/jihad/wreckingball.mp3")
   resource.AddFile("sound/jihad/murica.mp3")
   resource.AddFile("sound/jihad/letsdothis2.mp3")
   resource.AddFile("materials/vgui/ttt/jihad_icon_dark.png")
end
 
SWEP.HoldType                   = "slam"
 
if CLIENT then
   SWEP.PrintName                       = "Jihad bomb"
   SWEP.Slot                            = 6
 
   SWEP.EquipMenuData = {
      --type  = "item_weapon",
	  type  = "Equipment",
      name  = "Jihad bomb",
      desc  = "Sacrifice yourself for Allah.\nLeft Click to make yourself EXPLODE.\nRight click to taunt."
   };
 
   SWEP.Icon = "materials/vgui/ttt/jihad_icon_dark.png"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.WeaponID = AMMO_C4

SWEP.ViewModel  = Model("models/weapons/v_c4.mdl")
SWEP.WorldModel = Model("models/weapons/w_c4.mdl")

SWEP.DrawCrosshair      = false
SWEP.ViewModelFlip      = false
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo       = "none"
SWEP.Primary.Delay = 5.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo     = "none"

SWEP.NoSights = true

local noBlow = true

----------------------
--  Weapon its self --
----------------------

-- Reload does nothing
function SWEP:Reload()
end   

function SWEP:Initialize()
    util.PrecacheSound("jihad/big_explosion.wav")
	util.PrecacheSound("jihad/murica.mp3")
	util.PrecacheSound("jihad/wreckingball.mp3")
	util.PrecacheSound("jihad/letsdothis.mp3")
end


-- Think does nothing
function SWEP:Think()	
end


-- PrimaryAttack
function SWEP:PrimaryAttack()
self.Weapon:SetNextPrimaryFire(CurTime() + 3)
	noBlow = false
	
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Owner:GetPos() )
		effectdata:SetNormal( self.Owner:GetPos() )
		effectdata:SetMagnitude( 8 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 20 )
	util.Effect( "Sparks", effectdata )
	self.BaseClass.ShootEffects( self )
	
	--local sounds = {"siege/jihad.wav", "wreckingball.mp3"}
	local sounds = {"jihad/wreckingball.mp3", "jihad/murica.mp3"}
	--local times = {2, 2.7}
	local times = {2.7, 2}
	-- The rest is only done on the server
	if (SERVER) then
		local i = math.random(#sounds)
		timer.Simple(times[i], function() self:Asplode() end )
		self.Owner:EmitSound( sounds[i] )

	end

end

-- The asplode function
 function SWEP:Asplode()
	if noBlow then return end
 local k, v
            
  local ent = ents.Create( "env_explosion" )
  ent:SetPos( self.Owner:GetPos() )
  ent:SetOwner( self.Owner )
  ent:SetKeyValue( "iMagnitude", "250" )
  ent:Spawn()
  ent:Fire( "Explode", 0, 0 )
  ent:EmitSound( "siege/big_explosion.wav", 500, 500 )
  self:Remove()
end


-- SecondaryAttack
function SWEP:SecondaryAttack()	
	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
	--local TauntSound = Sound( "vo/npc/male01/overhere01.wav" )
	local TauntSound = Sound( "jihad/letsdothis2.mp3" )
	self.Weapon:EmitSound( TauntSound )

	-- The rest is only done on the server
	if (!SERVER) then return end
	self.Weapon:EmitSound( TauntSound )
end

function SWEP:PreDrop()
    noBlow = true
end

-- Bewm
function SWEP:WorldBoom()
	surface.EmitSound( "siege/big_expolsion.wav" )

end