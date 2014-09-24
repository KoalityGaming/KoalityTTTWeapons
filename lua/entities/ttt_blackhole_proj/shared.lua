
if SERVER then
   AddCSLuaFile("shared.lua")
end

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_fraggrenade.mdl")

local function PushPullRadius(pos, pusher)
   local radius = 600
   local phys_force = 2500
   local push_force = -6000

   -- pull physics objects and push players
   for k, target in pairs(ents.FindInSphere(pos, radius)) do
      if IsValid(target) then
         local dir = (target:GetPos() - pos):GetNormal()
         local phys = target:GetPhysicsObject()

         if target:IsPlayer() and (not target:IsFrozen()) and ((not target.was_pulled) or target.was_pulled.t != CurTime()) then
            local push = dir * push_force

            -- try to prevent excessive upwards force
            local vel = target:GetVelocity() + push
            vel.z = math.max(vel.z, push_force)

            target:SetVelocity(vel)

            target.was_pushed = {att=pusher, t=CurTime()}

         elseif IsValid(phys) then
            phys:ApplyForceCenter(dir * -1 * phys_force)
         end
      end
   end
end

local zapsound = Sound("npc/assassin/ball_zap1.wav")
function ENT:Explode(tr)
   if SERVER then
	  AddToDamageLog({DMG_LOG.BLACK_HOLE, self:GetThrower():Nick(), self:GetThrower():GetRoleString()})
      self.Entity:SetNoDraw(true)
      self.Entity:SetSolid(SOLID_NONE)

      -- pull out of the surface
      if tr.Fraction != 1.0 then
         self.Entity:SetPos(tr.HitPos + tr.HitNormal * 0.6)
      end

      local pos = self.Entity:GetPos()

      -- make sure we are removed, even if errors occur later
      self:Remove()

      PushPullRadius(pos, self:GetThrower())

      local effect = EffectData()
      effect:SetStart(pos)
      effect:SetOrigin(pos)

      if tr.Fraction != 1.0 then
         effect:SetNormal(tr.HitNormal)
      end
      
      util.Effect("Explosion", effect, true, true)
      util.Effect("cball_explode", effect, true, true)

      WorldSound(zapsound, pos, 100, 100)
   else
      local spos = self.Entity:GetPos()
      local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
      util.Decal("SmallScorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)      

      self:SetDetonateExact(0)
   end
end
