--Appending/changing vanilla boss/creature data
dofile("data/scripts/lib/utilities.lua")
local nxml = dofile_once("mods/Apotheosis/lib/nxml.lua")

--Pitboss can shoot blackholes if she fails a line of sight check too many times in a row, prevents tablet cheese
local content = ModTextFileGetContent("data/entities/animals/boss_pit/boss_pit.xml")
local xml = nxml.parse(content)
xml:add_child(nxml.parse([[
    <LuaComponent
    script_source_file="data/entities/animals/boss_pit/boss_pit_apotheosis_blackhole_check.lua"
    execute_times="-1"
    execute_every_n_frame="300"
    remove_after_executed="0"
    >
    </LuaComponent>
]]))
xml:add_child(nxml.parse([[
    <VariableStorageComponent
        name="apotheosis_blackhole_count"
        value_int="0"
        >
    </VariableStorageComponent>
]]))
xml:add_child(nxml.parse([[
    <LuaComponent
    script_damage_received="data/entities/animals/boss_pit/boss_pit_apotheosis_proj_failsafe.lua"
    script_death="data/entities/animals/boss_pit/boss_pit_apotheosis_proj_failsafe.lua"
    execute_times="-1"
    execute_every_n_frame="-1"
    remove_after_executed="0"
    >
    </LuaComponent>
]]))
ModTextFileSetContent("data/entities/animals/boss_pit/boss_pit.xml", tostring(xml))

--Adds tag to wandstone so perk creation altar can detect it.. technically you can throw it into the sun because of this but, eh, nobody would ever do that.. right? I just wanna save on tags whenever possible
--Let Wand Stone enable tinkering regardless of if you have it held or not
local content = ModTextFileGetContent("data/entities/items/pickup/wandstone.xml")
local xml = nxml.parse(content)
xml.attr.tags = xml.attr.tags .. ",poopstone"
local attrs = xml:first_of("GameEffectComponent").attr
attrs._tags = attrs._tags .. ",enabled_in_inventory"
ModTextFileSetContent("data/entities/items/pickup/wandstone.xml", tostring(xml))

--Adds tag to beamstone so perk creation altar can detect it.. technically you can throw it into the sun because of this but, eh, nobody would ever do that.. right? I just wanna save on tags whenever possible
local content = ModTextFileGetContent("data/entities/items/pickup/beamstone.xml")
local xml = nxml.parse(content)
xml.attr.tags = xml.attr.tags .. ",poopstone"
ModTextFileSetContent("data/entities/items/pickup/beamstone.xml", tostring(xml))

--Adds Vulnerability immunity check to Master of Vulnerability's attack
local content = ModTextFileGetContent("data/entities/misc/effect_weaken.xml")
local xml = nxml.parse(content)
xml:add_child(nxml.parse([[
	<LuaComponent
		script_source_file="mods/Apotheosis/files/scripts/status_effects/weaken_immunity_check.lua"
		execute_every_n_frame="2"
		>
	</LuaComponent>
]]))
ModTextFileSetContent("data/entities/misc/effect_weaken.xml", tostring(xml))

do -- Fix Spatial Awareness friendcave position(s)
    local path = "data/scripts/perks/map.lua"
    local content = ModTextFileGetContent(path)
    content = content:gsub("local fspots = { { 249, 153 }, { 261, 201 }, { 153, 141 }, { 87, 135 }, { 81, 219 }, { 153, 237 } }", "local fspots = { { 309, 153 }, { 260, 201 }, { 153, 141 }, { 87, 135 }, { 81, 219 }, { 153, 237 } }")
    ModTextFileSetContent(path, content)
end

--Fix Weakening Curses not showing remaining time
do
  local curses = {"electricity","explosion","melee","projectile"}
  for k=1, #curses
  do local v = curses[k];
    local content = ModTextFileGetContent("data/entities/misc/curse_wither_" .. v .. ".xml")
    local xml = nxml.parse(content)
    xml:first_of("UIIconComponent").attr.display_in_hud = "1"
    xml:first_of("UIIconComponent").attr.is_perk = "0"
    ModTextFileSetContent("data/entities/misc/curse_wither_" .. v .. ".xml", tostring(xml))
  end
end

do -- Remove some pixelscenes as they're being turned into biomes to recur infinitely with world width (essence eaters use pixelscenes that don't line up with the new world width)
  local path = "data/biome/_pixel_scenes.xml"
  local content = ModTextFileGetContent(path)
  content = content:gsub("data/biome_impl/overworld/essence_altar_visual.png", "")
  content = content:gsub("data/biome_impl/overworld/essence_altar_desert_visual.png", "")
  content = content:gsub("data/biome_impl/overworld/essence_altar.png", "")
  content = content:gsub("data/biome_impl/overworld/essence_altar_desert.png", "")
  content = content:gsub("data/entities/buildings/essence_eater.xml", "")
  ModTextFileSetContent(path, content)
end

do -- Increase Giga Death Cross's Damage
  local path = "data/entities/projectiles/deck/death_cross_big_laser.xml"
  local content = ModTextFileGetContent(path)
  content = content:gsub("0.38", "1.20")
  content = content:gsub("1.15", "1.35")
  ModTextFileSetContent(path, content)
end

--Can't gsub anything with a string? [[]] doesn't work?
--do -- Fix Darkcave not spawning in properly, because it just doesn't if I don't do this...? weird
--  local path = "data/scripts/biomes/watercave.lua"
--  local content = ModTextFileGetContent(path)
--  content = content:gsub([[function random_layout( x, y )]], [[function init( x, y )]])
--  content = content:gsub([[LoadPixelScene( "data/biome_impl/watercave_layout_"..r..".png", "", x, y, "", true )]], [[LoadPixelScene( "data/biome_impl/watercave_layout_"..r..".png", "", x, y + 3, "", true )]])
--  ModTextFileSetContent(path, content)
--end

--Bubble Spark Bounce no longer does self-damage
local content = ModTextFileGetContent("data/entities/projectiles/deck/bounce_spark_friendly_fire.xml")
local xml = nxml.parse(content)
xml:first_of("Base"):first_of("ProjectileComponent").attr.friendly_fire = "0"
ModTextFileSetContent("data/entities/projectiles/deck/bounce_spark_friendly_fire.xml", tostring(xml))

local content = ModTextFileGetContent("data/entities/projectiles/deck/bounce_spark_friendly_fire_silent.xml")
local xml = nxml.parse(content)
xml:first_of("ProjectileComponent").attr.friendly_fire = "0"
ModTextFileSetContent("data/entities/projectiles/deck/bounce_spark_friendly_fire_silent.xml", tostring(xml))


--Maybe only do this for an optional "hardmode? Unsure"
--Goal is for the mod to be accessible to anyone but it gets so freakin boring 1 shotting everything

dofile_once("mods/apotheosis/lib/apotheosis/apotheosis_utils.lua")

do --Boosts Health of various creatures
  local multiplier = 2.0
  local enemy_list = {
    "acidshooter",
    "barfer",
    "crystal_physics",
    "enlightened_alchemist",
    --"failed_alchemist",
    "maggot",
    "necromancer",
    "phantom_a",
    "phantom_b",
    "skullfly",
    "skullrat",
    "tentacler",
    "tentacler_small",
    "thundermage",
    "wizard_dark",
    "wizard_neutral",
    "wizard_poly",
    "wizard_returner",
    "wizard_tele",
    "worm",
    "worm_skull",
    --Modded Enemies below
    "devourer_ghost",
    "devourer_magic",
    "hideous_mass",
    "hideous_mass_red",
    "tentacler_big",
    "triangle_gem",
    "wizard_firemage_greater",
  }

  MultiplyHP("data/entities/animals/crypt/",enemy_list,multiplier,true)
end



do --Boosts Health of various creatures (THE_END)
  local multiplier = 10.0
  local enemy_list = {
    "bloodcrystal_physics",
    "gazer",
    "skycrystal_physics",
    "skygazer",
    "spearbot",
    "spitmonster",
    "worm_end",
    "worm_skull",
    --Modded Enemies below
    "blindgazer",
    "fairy_big_discord",
    "forsaken_eye",
    "gazer_cold_apotheosis",
    "gazer_greater",
    "gazer_greater_cold",
    "gazer_greater_sky",
    "ghost_bow",
    "musical_being",
    "sentry",
    "slime_leaker_weak",
    "star_child",
    "wizard_firemage_greater",
    "wraith_returner_apotheosis",
  }

  MultiplyHP("data/entities/animals/the_end/",enemy_list,multiplier,true)
end

do --Boosts Health of various creatures (THE_END)
  local multiplier = 10.0
  local enemy_list = {
    "poring_holy",
    "poring_devil",
  }

  MultiplyHP("data/entities/animals/",enemy_list,multiplier,true)

end

do
  --Triple health of Evil Temple Masters
  multiplier = 3.0
  enemy_list = {
    "wizard_corrupt_ambrosia",
    "wizard_corrupt_hearty",
    "wizard_corrupt_manaeater",
    "wizard_corrupt_neutral",
    "wizard_corrupt_swapper",
    "wizard_wands",
  }

  MultiplyHP("data/entities/animals/",enemy_list,multiplier,true)
end


do -- Add some new magical liquids to the Ancient Laboratory
  local path = "data/biome/liquidcave.xml"
  local content = ModTextFileGetContent(path)
  content = content:gsub("FFF86868,FF7FCEEA,FFA3569F,FFC23055,FF0BFFE5", "FFF86868,FF7FCEEA,FFA3569F,FFC23055,FF0BFFE5,FF59FDD9,FFF6CBAE,FFF6F7FD")
  ModTextFileSetContent(path, content)
end


do -- Rework Vulnerability Curses.. hmm..
  local path = "data/scripts/projectiles/curse_wither_start.lua"
  local path_2 = "data/scripts/projectiles/curse_wither_end.lua"
  local content = ModTextFileGetContent(path)
  content = content:gsub([[	comp = EntityGetFirstComponent( root_id, "DamageModelComponent" )
	
	if ( comp ~= nil ) then]], [[	comp = EntityGetFirstComponent( root_id, "DamageModelComponent" )
	
    if ( comp ~= nil )and ComponentObjectGetValue2( comp, "damage_multipliers", name ) > 0 then]])
  content = content:gsub("mult = mult + 0.25", "mult = mult * 2")
  ModTextFileSetContent(path, content)

  local content = ModTextFileGetContent(path_2)
  content = content:gsub([[	comp = EntityGetFirstComponent( root_id, "DamageModelComponent" )
	
	if ( comp ~= nil ) then]], [[	comp = EntityGetFirstComponent( root_id, "DamageModelComponent" )
	
    if ( comp ~= nil ) and ComponentObjectGetValue2( comp, "damage_multipliers", name ) > 0 then]])
  content = content:gsub("mult = mult - 0.25", "mult = mult * 0.5")
  ModTextFileSetContent(path, content)
end


do -- Add projectile tag to pit boss wands so they can be cleaned up too
  local path = "data/entities/animals/boss_pit/wand.xml"
  local content = ModTextFileGetContent(path)
  content = content:gsub([[name="$projectile_default"]], [[name="$projectile_default" tags="projectile"]])
  ModTextFileSetContent(path, content)
end

do -- Add secret path check to portal entity
  local path = "data/entities/buildings/teleport_liquid_powered.xml"
  local content = ModTextFileGetContent(path)
  local xml = nxml.parse(content)
  attrpath = xml:first_of("LuaComponent").attr
  attrpath.script_portal_teleport_used = "mods/apotheosis/files/scripts/buildings/teleporter_secret_check_fail.lua"
  ModTextFileSetContent(path, tostring(xml))
end

do -- Fixes Leviathan Portal to Coral Chest
  local path = "data/entities/buildings/teleport_teleroom_6.xml"
  local content = ModTextFileGetContent(path)
  content = content:gsub("7480", "7060")
  content = content:gsub("-12288", "-12209")
  ModTextFileSetContent(path, content)
end

do
  --Prevents Worm launcher from eating through indestructible terrain
  local path = "data/entities/projectiles/deck/worm_shot.xml"
  local content = ModTextFileGetContent(path)
  local xml = nxml.parse(content)
  attrpath = xml:first_of("CellEaterComponent").attr
  attrpath.ignored_material_tag = "[indestructible]"
  ModTextFileSetContent(path, tostring(xml))
end

do -- Add a 1% chance for potions to be replaced with a potion from the rare pool
  local path = "data/entities/items/pickup/potion.xml"
  local content = ModTextFileGetContent(path)
  local xml = nxml.parse(content)
  xml:add_child(nxml.parse([[
    <LuaComponent 
    execute_on_added="1"
    remove_after_executed="1"
    call_init_function="1"
    script_source_file="mods/apotheosis/files/scripts/potions/potion_rare_spawninjector.lua" 
  ></LuaComponent>
  ]]))
  ModTextFileSetContent(path, tostring(xml))
end

do -- Add lua script to vulnerability effect which applies "vulnerable" tag to afflicted creature (allows for lua scripts to detect for vulnerability)
  local path = "data/entities/misc/effect_weaken.xml"
  local content = ModTextFileGetContent(path)
  local xml = nxml.parse(content)
  xml:add_child(nxml.parse([[
    <LuaComponent
    script_source_file="mods/apotheosis/files/scripts/status_effects/vulnerability_tag_start.lua"
    execute_every_n_frame="4"
    remove_after_executed="1"
    >
    </LuaComponent>
  ]]))
  xml:add_child(nxml.parse([[
    <LuaComponent
    script_source_file="mods/apotheosis/files/scripts/status_effects/vulnerability_tag_end.lua"
    execute_every_n_frame="-1"
    execute_on_removed="1"
    >
    </LuaComponent>
  ]]))
  ModTextFileSetContent(path, tostring(xml))
end

do -- Add lua script to Waterstone, allowing you to charm watermages
  local path = "data/entities/items/pickup/waterstone.xml"
  local content = ModTextFileGetContent(path)
  local xml = nxml.parse(content)
  xml:add_child(nxml.parse([[
    <LuaComponent
    _enabled="0"
		_tags="enabled_in_hand"
    script_source_file="mods/apotheosis/files/scripts/items/waterstone_charm.lua"
    execute_every_n_frame="30"
    remove_after_executed="0"
    >
    </LuaComponent>
  ]]))
  ModTextFileSetContent(path, tostring(xml))
end

do -- Fix Swapper Projectiles stretching weirdly (only horizontal instead of all directions)
  local path = "data/entities/projectiles/deck/swapper.xml"
  local content = ModTextFileGetContent(path)
  content = content:gsub([[update_transform_rotation="0"]], [[update_transform_rotation="1"]])
  ModTextFileSetContent(path, content)
end

   -- Not working, not sure why
do -- Limit enemies to dropping 250k gold at any given time, prevents lag in NG+ runs
  local path = "data/scripts/items/drop_money.lua"
  local content = ModTextFileGetContent(path)
  content = content:gsub("local x, y = EntityGetTransform( entity )", "if money > 250000 then money = 250000 end local x, y = EntityGetTransform( entity )")
  ModTextFileSetContent(path, content)
end