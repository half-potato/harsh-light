require 'entity/Entity'
require 'entity/FlyingEntity'

local entitytable = ...

entitytable[1] = Entity.new(entitytable[1])
entitytable[2] = FlyingEntity.new(entitytable[2])
entitytable[3] = Entity.new(entitytable[3])
entitytable[4] = Entity.new(entitytable[4])
entitytable[5] = Entity.new(entitytable[5])
entitytable[6] = Entity.new(entitytable[6])
entitytable[7] = Entity.new(entitytable[7])
entitytable[8] = FlyingEntity.new(entitytable[8])
entitytable[9] = FlyingEntity.new(entitytable[9])
entitytable[10] = FlyingEntity.new(entitytable[10])
entitytable[11] = Entity.new(entitytable[11])
entitytable[12] = Entity.new(entitytable[12])
entitytable[13] = Entity.new(entitytable[13])

return entitytable
