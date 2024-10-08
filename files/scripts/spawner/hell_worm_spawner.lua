
local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

local comp = EntityGetFirstComponentIncludingDisabled(entity_id,"DamageModelComponent")
local hp = ComponentGetValue2(comp,"max_hp")
local worm_count = EntityGetInRadiusWithTag(x,y,800,"boss") or {}

if (y > 40000 or y < -30000) and #worm_count < 2 then
    local eid = EntityLoad("data/entities/animals/worm_hell_big/worm_end_big_apotheosis.xml",x,y)
    local dcomp = EntityGetFirstComponentIncludingDisabled(eid,"DamageModelComponent")
    ComponentSetValue2(dcomp,"max_hp",hp)
    ComponentSetValue2(dcomp,"hp",hp)
end
EntityKill(entity_id)
