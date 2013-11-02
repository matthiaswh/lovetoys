CollisionManager = class("CollisionDetectSystem", System)

function CollisionManager:__init()
    self.conditions = {}
end

function CollisionManager:addCollisionAction(component1, component2, object)
    if not self.conditions[component1] then self.conditions[component1] = {} end
    self.conditions[component1][component2] = object
end

function CollisionManager:fireEvent(event)
    -- If an Event is fired, the entities are given to the specific collisions. Entities are passed in Reihenfolge^^.
    local e1 = event.a:getUserData()
    local e2 = event.b:getUserData()

    for k, v in pairs(e1:getComponents()) do
        for k2, val in pairs(e2:getComponents()) do 
            if self.conditions[k] then
                if self.conditions[k]["Everything"] then 
                    self.conditions[k][k2]:action({entity1=e1, entity2=e2}) 
                    return
                end
            elseif self.conditions[k2] then
                if self.conditions[k2]["Everything"] then 
                    self.conditions[k2][k]:action({entity1=e2, entity2=e1}) 
                    return
                end
            end
        end
    end
    -- Iteration of all Components of both Entities to search for a matching constellation of components.
    for k,v in pairs(e1:getComponents()) do
        for k2,val in pairs(e2:getComponents()) do
            if self.conditions[k] then
                if self.conditions[k][k2] then self.conditions[k][k2]:action({entity1=e1, entity2=e2}) end
            elseif self.conditions[k2] then
                if self.conditions[k2][k] then self.conditions[k2][k]:action({entity1=e2, entity2=e1}) end
            end
        end
    end
end