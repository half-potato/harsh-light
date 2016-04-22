require 'entity/Entity'
require 'entity/FlyingEntity'

local entity = ...

local choices = {}
choices["SandHowler"] = Entity
choices["FrostGale"] = FlyingEntity
choices["Crab"] = Entity
choices["Spinefin"] = Entity
choices["Scorpion"] = Entity
choices["Sandwurm"] = Entity
choices["Earthworm"] = Entity
choices["Bluejay"] = FlyingEntity
choices["Hawk"] = FlyingEntity
choices["Crow"] = FlyingEntity
choices["Roadhog"] = Entity
choices["SerBuffalo"] = Entity
choices["Squirrel"] = Entity

en = choices[entity.name]:new(entity)
--print_r(en)
return en
