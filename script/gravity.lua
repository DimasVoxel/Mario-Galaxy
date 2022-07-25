function init()
    planets = {}
end

function planetsUpdate()
    local planetShapes = FindShapes('planet',true) 
    for num,planetShape in pairs(planetShapes) do
        local planet = {}
        planet.shape = planetShape
        planet.body = GetShapeBody(planetShape)
        planet.transform = GetBodyTransform(planet.body)
        local min, max = GetShapeBounds(planet.shape)
        planet.center = VecLerp(min,max,0.5)
        planet.mass = tonumber(GetTagValue(planet.body, 'mass'))
        planets[num] = planet 
    end 
end


function gravityUpdate(dt)
    local shapes = FindShapes("",true) 
        for num,shape in pairs(shapes) do
            local body = GetShapeBody(shape)
            local vel = GetBodyVelocity(body)
            vel = VecAdd(Vec(0,10*dt,0),vel)
            if not HasTag(body,"nograv") and IsBodyDynamic(body) == true and not HasTag(body,"player") then
                for i=1,#planets do
                    local planet = planets[i]
                    local min, max = GetShapeBounds(shape)
                    local center = VecLerp(min,max,0.5)
                    local mass = GetBodyMass(body)
                    local dir = VecNormalize(VecSub(planet.center,center))
                    local dist = VecDist(planet.center,center)
                    local coef = 7200/mass
                    local gravConst = 0.00015
                    local strength = dt*(gravConst*planet.mass*((mass*coef)-100) / (dist * dist))
                    vel = VecAdd(vel,VecScale(dir,strength))
                end         
            SetBodyVelocity(body,vel)
        end
    end
end


function update(dt)
    planetsUpdate(dt)
    gravityUpdate(dt)
end

function VecDist(a, b)
	return VecLength(VecSub(a, b))
end
