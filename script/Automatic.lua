-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------Arithmetic Functions-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

---Logistic function, Can be used for juicy UI and smooth easing among other things.
---https://www.desmos.com/calculator/cmmwrjtyit?invertedColors
---@param v number|nil Input number, if nil then it will be a Random number between 0 and 1
---@param max number The Maximum value
---@param steep number How steep the curve is
---@param offset number The horizontal offset of the middle of the curve
---@return number
function AutoLogistic(v, max, steep, offset)
	v = AutoDefault(v, math.random(0, 10000) / 10000)
	return max / (1 + math.exp((v - offset) * steep))
end

---Logistic function followed by a mapping function, guarantees that the return value will be between 0 and 1
---@param v number|nil Random number between 0 and 1
---@param max number The Maximum value
---@param steep number How steep the curve is
---@param offset number The horizontal offset of the middle of the curve
---@param rangemin number Maps this number to 0
---@param rangemax number Maps this numver to 1
---@return number
function AutoLogisticScaled(v, max, steep, offset, rangemin, rangemax)
	v = AutoLogistic(v, max, steep, offset)
	local a = AutoLogistic(rangemin, max, steep, offset)
	local b = AutoLogistic(rangemax, max, steep, offset)
	local mapped = AutoMap(v, a, b, 0, 1)
	return AutoClamp(mapped, 0, 1)
end

---This was a Challenge by @TallTim and @1ssnl to make the smallest rounding function, but I expanded it to make it easier to read and a little more efficent
---@param v number Input number
---@param increment number|nil The lowest increment. A Step of 1 will round the number to 1, A step of 5 will round it to the closest increment of 5, A step of 0.1 will round to the tenth. Default is 1
---@return number
function AutoRound(v, increment)
	increment = AutoDefault(increment, 1)
	if increment == 0 then return v end
	s = 1 / increment
	return math.floor(v * s + 0.5) / s
end

---Maps a value from range a1-a2 to range b1-b2
---@param v number Input number
---@param a1 number Goes from the range of number a1
---@param a2 number To number a2
---@param b1 number To the range of b1
---@param b2 number To number b2
---@return number
function AutoMap(v, a1, a2, b1, b2)
	if a1 == a2 then return b2 end
	return b1 + ((v - a1) * (b2 - b1)) / (a2 - a1)
end

---Limits a value from going below the min and above the max
---@param v number The number to clamp
---@param min number|nil The minimum the number can be, Default is 0
---@param max number|nil The maximum the number can be, Default is 1
---@return number
function AutoClamp(v, min, max)
	min = AutoDefault(min, 0)
	max = AutoDefault(max, 1)
	if v < min then
		return min
	elseif v > max then
		return max
	else
		return v
	end
end

---Wraps a value inbetween a range
---@param v number The number to wrap
---@param min number|nil The minimum range
---@param max number|nil The maximum range
---@return number
function AutoWrap(v, min, max)
	min = AutoDefault(min, 0)
	max = AutoDefault(max, 1)

	AutoMap(v, min, max, 0, 1)
	v = v % 1
	return AutoMap(v, 0, 1, min, max)
end

---Lerp function, Is not clamped meaning it if t is above 1 then it will 'overshoot'
---@param a number Goes from number A
---@param b number To number B
---@param t number Interpolated by T
---@return number
function AutoLerpUnclamped(a, b, t)
	return (1 - t) * a + t * b
end

---Moves a towards b by t
---@param a number Goes from number A
---@param b number To number B
---@param t number Moved by T
---@return number
function AutoMove(a, b, t)
	output = a
	if a == b then
		return a
	elseif a > b then
		output = math.max(a - t, b)
	else
		output = math.min(a + t, b)
	end

	return output
end

---Return the Distance between the numbers a and b
---@param a number
---@param b number
---@return number
function AutoDist(a, b)
	return math.abs(a - b)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------Vector Functions-----------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

---Return a Random Vector
---@param length number
---@param precision number|nil 0.001 by default
---@return table
function AutoRndVec(length, precision)
	precision = AutoDefault(precision, 0.01)
	local m = 1/precision
	local v = VecNormalize(Vec(math.random(-m,m), math.random(-m,m), math.random(-m,m)))
	return VecScale(v, length)	
end

---Return the Distance between Two Vectors
---@param a Vec
---@param b Vec
---@return number
function AutoVecDist(a, b)
	return math.sqrt( (a[1] - b[1])^2 + (a[2] - b[2])^2 + (a[3] - b[3])^2 )
end

---Return a vector that has the magnitude of b, but with the direction of a
---@param a Vec
---@param b number
---@return Vec
function AutoVecRescale(a, b)
	return VecScale(VecNormalize(a), b)
end

---Maps a Vector from range a1-a2 to range b1-b2
---@param v Vec Input Vector
---@param a1 number Goes from the range of number a1
---@param a2 number To number a2
---@param b1 number To the range of b1
---@param b2 number To number b2
---@return Vec
function AutoVecMap(v, a1, a2, b1, b2)
	if a1 == a2 then return AutoVecRescale(v, b2) end
	local out = {
		AutoMap(v[1], a1, a2, b1, b2),
		AutoMap(v[2], a1, a2, b1, b2),
		AutoMap(v[3], a1, a2, b1, b2),
	}
	return out
end

---Limits the magnitude of a vector to be between min and max
---@param v Vec The Vector to clamp
---@param min number|nil The minimum the magnitude can be, Default is 0
---@param max number|nil The maximum the magnitude can be, Default is 1
---@return Vec
function AutoVecClampMagnitude(v, min, max)
	min, max = AutoDefault(min, 0), AutoDefault(max, 1)
	local l = VecLength(v)
	if l > max then
		return AutoVecRescale(v, max)
	elseif l < min then
		return AutoVecRescale(v, min)
	else
		return v
	end
end

---Limits a vector to be between min and max
---@param v Vec The Vector to clamp
---@param min number|nil The minimum, Default is 0
---@param max number|nil The maximum, Default is 1
---@return Vec
function AutoVecClamp(v, min, max)
	min, max = AutoDefault(min, 0), AutoDefault(max, 1)
	return {
		AutoClamp(v[1], min, max),
		AutoClamp(v[2], min, max),
		AutoClamp(v[3], min, max)
	}
end

---Return Vec(1, 1, 1) scaled by length
---@param length number return the vector of size length, Default is 1
---@return Vec
function AutoVecOne(length)
	return VecScale(Vec(1,1,1), length)
end

---Return Vec a multiplied by Vec b
---@param a Vec
---@param b Vec
---@return Vec
function AutoVecMulti(a, b)
	return {
		a[1] * b[1],
		a[2] * b[2],
		a[3] * b[3],
	}
end

---Equivalent to math.min(unpack(v))
---@param v Vec
---@return number
function AutoVecMin(v)
	return math.min(unpack(v))
end

---Equivalent to math.max(unpack(v))
---@param v Vec
---@return number
function AutoVecMax(v)
	return math.max(unpack(v))
end

---Return Vec v with it's x value replaced by subx
---@param v Vec
---@param subx number
function AutoVecSubsituteX(v, subx)
	return Vec(subx, v[2], v[3])
end

---Return Vec v with it's y value replaced by suby
---@param v Vec
---@param suby number
function AutoVecSubsituteY(v, suby)
	return Vec(v[1], suby, v[3])
end

---Return Vec v with it's z value replaced by subz
---@param v Vec
---@param subz number
function AutoVecSubsituteY(v, subz)
	return Vec(v[1], v[2], subz)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------Bounds Functions-----------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

---Takes two vectors and modifys them so they can be used in other bound functions
---@param aa Vec
---@param bb Vec
---@return Vec
---@return Vec
function AutoBoundsCorrection(aa, bb)
	local min, max = VecCopy(aa), VecCopy(bb)

	if bb[1] < aa[1] then
		min[1] = bb[1]
		max[1] = aa[1]
	end
	if bb[2] < aa[2] then
		min[2] = bb[2]
		max[2] = aa[2]
	end
	if bb[3] < aa[3] then
		min[3] = bb[3]
		max[3] = aa[3]
	end

	return min, max
end

---Get a position inside or on the Input Bounds
---@param aa Vec Minimum Bound Corner
---@param bb Vec Maximum Bound Corner
---@param vec Vec|nil A normalized Vector pointing towards the position that should be retrieved, Default is Vec(0, 0, 0)
---@return Vec
function AutoBoundsGetPos(aa, bb, vec)
	vec = AutoDefault(vec, Vec(0,0,0))

	aa, bb = AutoBoundsCorrection(aa, bb)
	vec = AutoVecMap(vec, -1, 1, 0, 1)
	local sizevec = VecSub(bb, aa)

	local size = VecLength(sizevec)
	local scaled = AutoVecMulti(vec, sizevec)
	return VecAdd(scaled, aa)
end

---Get the center of the faces of the given Bounds, as if it was a cube
---@param aa Vec Minimum Bound Corner
---@param bb Vec Maximum Bound Corner
---@return table
function AutoBoundsGetFaceCenters(aa, bb)
	aa, bb = AutoBoundsCorrection(aa, bb)
	return {
		AutoBoundsGetPos(aa, bb, Vec(0, -1, 0)),
		AutoBoundsGetPos(aa, bb, Vec(0, 1, 0)),
		AutoBoundsGetPos(aa, bb, Vec(-1, 0, 0)),
		AutoBoundsGetPos(aa, bb, Vec(1, 0, 0)),
		AutoBoundsGetPos(aa, bb, Vec(0, 0, -1)),
		AutoBoundsGetPos(aa, bb, Vec(0, 0, 1)),
	}
end

---Get the corners of the given Bounds
---@param aa Vec Minimum Bound Corner
---@param bb Vec Maximum Bound Corner
---@return table
function AutoBoundsGetCorners(aa, bb)
	aa, bb = AutoBoundsCorrection(aa, bb)
	return {
		AutoBoundsGetPos(aa, bb, Vec(-1, -1, -1)),
		AutoBoundsGetPos(aa, bb, Vec(1, -1, -1)),
		AutoBoundsGetPos(aa, bb, Vec(-1, 1, -1)),
		AutoBoundsGetPos(aa, bb, Vec(-1, -1, 1)),
		AutoBoundsGetPos(aa, bb, Vec(-1, 1, 1)),
		AutoBoundsGetPos(aa, bb, Vec(1, -1, 1)),
		AutoBoundsGetPos(aa, bb, Vec(1, 1, -1)),
		AutoBoundsGetPos(aa, bb, Vec(1, 1, 1)),
	}
end

---Get data about the size of the given Bounds
---@param aa Vec Minimum Bound Corner
---@param bb Vec Maximum Bound Corner
---@return Vector representing the size of the Bounds
---@return the smallest edge size of the Bounds
---@return the longest edge size of the Bounds
function AutoBoundsSize(aa, bb)
	aa, bb = AutoBoundsCorrection(aa, bb)
	local size = VecSub(bb, aa)
	local minval = math.max(unpack(size))
	local maxval = math.min(unpack(size))

	return size, minval, maxval
end

---Draws the world space bounds between the given bounds
---@param aa Vec Minimum Bound Corner
---@param bb Vec Maximum Bound Corner
---@param rgbcolors boolean|nil If the Minimum and Maximum corners are colorcoded representing the xyz axis colors, Default is false
---@param hue number|nil 0 to 1 representing the hue of the lines, Default is 0
---@param saturation number|nil 0 to 1 representing the saturation of the lines, Default is 0
---@param value number|nil 0 to 1 representing the value of the lines, Default is 0
---@param alpha number|nil the alpha of the lines, Default is 1
---@param draw boolean|nil weather to use DebugLine or DrawLine, Default is false (DebugLine)
function AutoDrawBounds(aa, bb, rgbcolors, hue, saturation, value, alpha, draw)
	aa, bb = AutoBoundsCorrection(aa, bb)
	rgbcolors = AutoDefault(rgbcolors, false)

	hue = AutoDefault(hue, 0)
	saturation = AutoDefault(saturation, 0)
	value = AutoDefault(value, 0)
	alpha = AutoDefault(alpha, 1)
	
	draw = AutoDefault(draw, false)

	local color = AutoHSVToRGB(hue, saturation, value)

	min, max = {
		[1] = Vec(aa[1], aa[2], aa[3]),
		[2] = Vec(bb[1], aa[2], aa[3]),
		[3] = Vec(bb[1], aa[2], bb[3]),
		[4] = Vec(aa[1], aa[2], bb[3]),
	}, {
		[1] = Vec(aa[1], bb[2], aa[3]),
		[2] = Vec(bb[1], bb[2], aa[3]),
		[3] = Vec(bb[1], bb[2], bb[3]),
		[4] = Vec(aa[1], bb[2], bb[3]),
	}

	-- This code made me want to give up
	local lines = {
		{ min[2], min[3], color[1], color[2], color[3], alpha },
		{ min[3], min[4], color[1], color[2], color[3], alpha },
		{ max[1], max[2], color[1], color[2], color[3], alpha },
		{ max[4], max[1], color[1], color[2], color[3], alpha },
		{ min[2], max[2], color[1], color[2], color[3], alpha },
		{ min[4], max[4], color[1], color[2], color[3], alpha },

		{ min[1], min[2], rgbcolors and 1 or color[1], rgbcolors and 0 or color[2], rgbcolors and 0 or color[3], alpha },
		{ max[2], max[3], rgbcolors and 0 or color[1], rgbcolors and 1 or color[2], rgbcolors and 0 or color[3], alpha },
		{ max[3], max[4], rgbcolors and 1 or color[1], rgbcolors and 0 or color[2], rgbcolors and 0 or color[3], alpha },
		{ min[1], max[1], rgbcolors and 0 or color[1], rgbcolors and 0 or color[2], rgbcolors and 1 or rgbcolors and 0 or color[3], alpha },
		{ min[3], max[3], rgbcolors and 0 or color[1], rgbcolors and 0 or color[2], rgbcolors and 1 or rgbcolors and 0 or color[3], alpha },
		{ min[4], min[1], rgbcolors and 0 or color[1], rgbcolors and 1 or color[2], rgbcolors and 0 or color[3], alpha },
	}

	for i, v in ipairs(lines) do
		if draw then
			DrawLine(unpack(v))
		else
			DebugLine(unpack(v))
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------Table Functions------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

---Returns the amount of elements in the given list.
---@param t table
---@return integer
function AutoTableCount(t)
	local c = 0
	for i in pairs(t) do
		c = c + 1
	end

	return c
end

---Returns true and the index if the v is in t, otherwise returns false and nil
---@param t table
---@param v any
---@return boolean, unknown
function AutoTableContains(t, v)
	for i, v2 in ipairs(t) do
		if v == v2 then
			return true, i
		end
	end
	return false, nil
end

---Returns the Last item of a given list
---@param t any
---@return unknown
function AutoTableLast(t)
	return t[AutoTableCount(t)]
end

---Copy a Table Recursivly Stolen from http://lua-users.org/wiki/CopyTable
---@param orig table
---@param copies table
---@return table
function AutoTableDeepCopy(orig, copies)
	copies = copies or {}
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		if copies[orig] then
			copy = copies[orig]
		else
			copy = {}
			copies[orig] = copy
			for orig_key, orig_value in next, orig, nil do
				copy[AutoTableDeepCopy(orig_key, copies)] = AutoTableDeepCopy(orig_value, copies)
			end
			setmetatable(copy, AutoTableDeepCopy(getmetatable(orig), copies))
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------Utility Functions------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

---If val is nil, return default instead
---@param v any
---@param default any
---@return any
function AutoDefault(v, default)
	if v == nil then return default else return v end
end

---Returns a Vector for easy use when put into a parameter for xml
---@param vec any
---@return string
function AutoVecToXML(vec)
	return vec[1] .. ' ' .. vec[2] .. ' ' .. vec[3]
end

---A workaround to making a table readonly, don't use, it most likely is bugged in someway
---@param t table
---@return table
function AutoSetReadOnly(t)
	return setmetatable({}, {
		__index = t,
		__newindex = function(t, key, value)
			error("attempting to change constant " .. tostring(key) .. " to " .. tostring(value), 2)
		end
	})
end

---Code donatated from @Dr. HypnoTox - Thankyou! Turns a Table into a string
---@param object any
---@return string
function AutoToString(object)
	if object == nil then
		return 'nil'
	end

	if (type(object) == 'number') or (type(object) == 'string') or (type(object) == 'boolean') then
		return tostring(object)
	end

	local toDump = '{'

	for k, v in pairs(object) do
		if (type(k) == 'number') then
			toDump = toDump .. '[' .. AutoRound(k, 0.00001) .. '] = '
		elseif (type(k) == 'string') then
			toDump = toDump .. k .. '= '
		end

		if (type(v) == 'number') then
			toDump = toDump .. AutoRound(v, 0.00001) .. ','
		elseif (type(v) == 'string') then
			toDump = toDump .. '\'' .. v .. '\', '
		else
			toDump = toDump .. AutoToString(v) .. ', '
		end
	end

	toDump = toDump .. '}'

	return toDump
end

---Splits a string by a separator
---@param inputstr string
---@param sep string
---@return table
function AutoSplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

---Create a Vector in RGB color space from HSV color values
---@param hue number|nil The hue, Default is 0
---@param sat number|nil The saturation, Default is 1
---@param val number|nil The value, Default is 1
---@return Vec
function AutoHSVToRGB(hue, sat, val)
	hue = AutoDefault(hue, 0)
	sat = AutoDefault(sat, 1)
	val = AutoDefault(val, 1)
	
	local huer = hue + 0
	local hueg = hue - 1/3
	local hueb = hue + 1/3
	
	local r = AutoClamp((3 * math.abs(AutoWrap(huer, 0, 2) - 1) - 1))
	local g = AutoClamp((3 * math.abs(AutoWrap(hueg, 0, 2) - 1) - 1))
	local b = AutoClamp((3 * math.abs(AutoWrap(hueb, 0, 2) - 1) - 1))

	local vec = Vec(r, g, b)
	
	local out = AutoVecMap(vec, 0, AutoVecMax(vec), 0, val)
	out = VecLerp(out, AutoVecOne(val), 1 - sat)
	out = AutoVecClamp(out)
	return out
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------Game Functions-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

---Checks if a point is in the view using a transform acting as the "Camera"
---@param point Vec
---@param fromtrans Transfrom|nil The Transform acting as the camera, Default is the Player's Camera
---@param angle number|nil The Angle at which the point can be seen from, Default is the Player's FOV set in the options menu
---@param raycastcheck boolean|nil Check to make sure that the point is not obscured, Default is true
---@return boolean seen If the point is in View
---@return number angle The Angle the point is away from the center of the looking direction
function AutoPointInView(point, fromtrans, angle, raycastcheck)
	fromtrans = AutoDefault(fromtrans, GetCameraTransform())
	angle = AutoDefault(angle, GetInt('options.gfx.fov'))
	raycastcheck = AutoDefault(raycastcheck, true)

	local fromtopointdir = VecNormalize(VecSub(point, fromtrans.pos))
	local fromdir = TransformToParentVec(fromtrans, Vec(0, 0, -1))

	local dot = VecDot(fromtopointdir, fromdir)
	local dotangle = math.deg(math.acos(dot))
	local seen = dotangle < angle/2

	if raycastcheck then
		local hit = QueryRaycast(fromtrans.pos, fromtopointdir, AutoVecDist(fromtrans.pos, point), 0, true)
		if hit then return false end
	end

	return seen, dotangle
end

---Get the last Path Query as a path of points
---@param precision number The Accuracy
---@return table
---@return Vec "Last Point"
function AutoRetrievePath(precision)
	precision = AutoDefault(precision, 0.2)

	local path = {}
	local length = GetPathLength()
	local l = 0
	while l < length do
		path[#path + 1] = GetPathPoint(l)
		l = l + precision
	end

	return path, path[#path]
end

---Reject a table of bodies for the next Query
---@param bodies table
function AutoQueryRejectBodies(bodies)
	for i in pairs(bodies) do
		QueryRejectBody(bodies[i])
	end
end

---Set the collision filter for the shapes owned by a body
---@param body number
---@param layer number
---@param masknummber number bitmask
function AutoSetBodyCollisionFilter(body, layer, masknummber)
	local shapes = GetBodyShapes(body)
	for i in pairs(shapes) do
		SetShapeCollisionFilter(shapes[i], layer, masknummber)
	end
end

---Get the Center of Mass of a body in World space
---@param body any
---@return table
function AutoWorldCenterOfMass(body)
	local trans = GetBodyTransform(body)
	local pos = TransformToParentPoint(trans, GetBodyCenterOfMass(body))
	return pos
end

---Get the Total Speed of a body
---@param body number
---@return number
function AutoSpeed(body)
	return VecLength(GetBodyVelocity(body)) + VecLength(GetBodyAngularVelocity(body))
end

---Attempt to predict the position of a body in time
---@param body number
---@param time number
---@param raycast boolean|nil Check and Halt on Collision, Default is false
---@return table log
---@return table vel
---@return table normal
function AutoPredictPosition(body, time, raycast)
	raycast = AutoDefault(raycast, false)
	local pos = AutoWorldCenterOfMass(body)
	local vel = GetBodyVelocity(body)
	local log = { VecCopy(pos) }
	local normal = Vec(0, 1, 0)

	for steps = 0, time, GetTimeStep() do
		vel = VecAdd(vel, VecScale(Vec(0, -10, 0), GetTimeStep()))
		log[#log + 1] = VecAdd(log[#log], VecScale(vel, GetTimeStep()))

		if raycast then
			local last = log[#log - 1]
			local cur = log[#log]
			local hit, dist, norm = QueryRaycast(last, QuatLookAt(last, cur), VecLength(VecSub(cur, last)))
			if hit then normal = norm break end
		end
	end

	return log, vel, normal
end

---Attempt to predict the position of the player in time
---@param time number
---@param raycast boolean|nil Check and Halt on Collision, Default is false
---@return table log
---@return table vel
---@return table normal
function AutoPredictPlayerPosition(time, raycast)
	raycast = AutoDefault(raycast, false)
	local player = GetPlayerTransform(true)
	local pos = player.pos
	local vel = GetPlayerVelocity()
	local log = { VecCopy(pos) }
	local normal = Vec(0, 1, 0)

	for steps = 0, time, GetTimeStep() do
		vel = VecAdd(vel, VecScale(Vec(0, -10, 0), GetTimeStep()))
		log[#log + 1] = VecAdd(log[#log], VecScale(vel, GetTimeStep()))

		if raycast then
			local last = log[#log - 1]
			local cur = log[#log]
			local hit, dist, norm = QueryRaycast(last, QuatLookAt(last, cur), VecLength(VecSub(cur, last)))
			normal = norm
			
			if hit then break end
		end
	end

	return log, vel, normal
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------Showing Debug-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

---A Alternative to DebugPrint that uses AutoToString(), works with tables. Returns the Input
---@param ... any
---@return unknown Arguments
function AutoPrint(...)
	arg.n = nil
	DebugPrint(AutoToString(arg))
	return unpack(arg)
end

---Prints 24 blank lines to quote on quote, "clear the console"
function AutoClearConsole()
	for i = 1, 24 do DebugPrint('') end
end

---Draws a table of 
---@param points any
---@param huescale number|nil A multipler to the hue change, Default is 1
---@param draw boolean|nil weather to use DebugLine or DrawLine, Default is false (DebugLine)
function AutoDrawLines(points, huescale, draw)
	huescale = AutoDefault(huescale, 1)
	draw = AutoDefault(draw, false)
	
	local lines = {}
	local dist = 0
	for i = 1, #points - 1 do
		local color = AutoHSVToRGB(dist / 10 * huescale, 0.5, 1)
		table.insert(lines, { points[i], points[i + 1], color[1], color[2], color[3], 1 })

		dist = dist + AutoVecDist(points[i], points[i + 1])
	end

	for i, v in ipairs(lines) do
		if draw then
			DrawLine(unpack(v))
		else
			DebugLine(unpack(v))
		end
	end
end

---Draws a Transform
---@param transform Transform
---@param size number the size in meters, Default is 0.5
---@param alpha number Default is 1
---@param draw boolean|nil weather to use DebugLine or DrawLine, Default is false (DebugLine)
function AutoDrawTransform(transform, size, alpha, draw)
	transform.rot = AutoDefault(transform.rot, QuatEuler(0, 0, 0))
	size = AutoDefault(size, 0.5)
	alpha = AutoDefault(alpha, 1)
	draw = AutoDefault(draw, false)

	local right = TransformToParentPoint(transform, Vec(size, 0, 0))
	local up = TransformToParentPoint(transform, Vec(0, size, 0))
	local forward = TransformToParentPoint(transform, Vec(0, 0, size))

	local lines = {
		{ transform.pos, right, 1, 0, 0, alpha },
		{ transform.pos, up, 0, 1, 0, alpha },
		{ transform.pos, forward, 0, 0, 1, alpha },
	}

	for i, v in ipairs(lines) do
		if draw then
			DrawLine(unpack(v))
		else
			DebugLine(unpack(v))
		end
	end
end

---Draws some Debug information about a body
---@param body number
---@param size number
function AutoDrawBodyDebug(body, size)
	local trans = GetBodyTransform(body)
	AutoDrawTransform(trans, size)

	local vel = GetBodyVelocity(body)
	local worldvel = VecAdd(vel, trans.pos)
	DebugLine(trans.pos, worldvel)
	AutoTooltip(AutoRound(AutoSpeed(body), 0.001), trans.pos, 16, 0.35)
end

---Draws some text at a world position.
---@param text string
---@param position Vec
---@param fontsize number
---@param alpha number
---@param bold boolean
function AutoTooltip(text, position, fontsize, alpha, bold)
	text = AutoDefault(text or "nil")
	fontsize = AutoDefault(fontsize or 24)
	alpha = AutoDefault(alpha or 0.75)
	bold = AutoDefault(bold or false)

	if not AutoPointInView(position, nil, nil, false) then return end

	UiPush()
		UiAlign('center middle')
		local x, y = UiWorldToPixel(position)
		UiTranslate(x, y)
		UiWordWrap(UiMiddle())

		UiFont(bold and "bold.ttf" or "regular.ttf", fontsize)
		UiColor(0, 0, 0, 0)
		local rw, rh = UiText(text)

		UiColorFilter(1, 1, 1, alpha)
		UiColor(unpack(AutoSecondaryColor))
		UiRect(rw, rh)

		UiColor(unpack(AutoPrimaryColor))
		UiText(text)
	UiPop()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------Registry-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

function AutoKeyDefaultInt(path, default)
	if path == nil then error("path nil") end
	if HasKey(path) then
		return GetInt(path)
	else
		SetInt(path, default)
		return default
	end
end

function AutoKeyDefaultFloat(path, default)
	if path == nil then error("path nil") end
	if HasKey(path) then
		return GetFloat(path)
	else
		SetFloat(path, default)
		return default
	end
end

function AutoKeyDefaultString(path, default)
	if path == nil then error("path nil") end
	if HasKey(path) then
		return GetString(path)
	else
		SetString(path, default)
		return default
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------User Interface-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

AutoPad = {none = 0, atom = 4, micro = 6, thin = 12, thick = 24, heavy = 48, beefy = 128}
setmetatable(AutoPad, { __call = function (t, padding) UiTranslate(padding, padding) end})

AutoPrimaryColor = {0.95, 0.95, 0.95, 1}
AutoSpecialColor = {1, 1, 0.55, 1}
AutoSecondaryColor = {0, 0, 0, 0.55}
AutoFont = 'regular.ttf'
local Stack = {}

---Takes an alignment and returns a Vector representation.
---@param alignment string
---@return table
function AutoAlignmentToPos(alignment)
	v, y = 0, 0
	if string.find(alignment, 'left') then v = -1 end
	if string.find(alignment, 'center') then v = 0 end
	if string.find(alignment, 'right') then v = 1 end
	if string.find(alignment, 'bottom') then y = -1 end
	if string.find(alignment, 'middle') then y = 0 end
	if string.find(alignment, 'top') then y = 1 end
	return {x = v, y = y}
end

---UiTranslate and UiAlign to the Center
function AutoCenter()
	UiTranslate(UiCenter(), UiMiddle())
	UiAlign('center middle')
end

---The next Auto Ui functions will be spread Down until AutoSpreadEnd() is called
---@param padding number|nil The amount of padding that will be used, Default is AutoPad.thin
function AutoSpreadDown(padding)
	table.insert(Stack, {type = 'spread', direction = 'down', padding = AutoDefault(padding, AutoPad.thin)})
	UiPush()
end

---The next Auto Ui functions will be spread Up until AutoSpreadEnd() is called
---@param padding number|nil The amount of padding that will be used, Default is AutoPad.thin
function AutoSpreadUp(padding)
	table.insert(Stack, {type = 'spread', direction = 'up', padding = AutoDefault(padding, AutoPad.thin)})
	UiPush()
end

---The next Auto Ui functions will be spread Right until AutoSpreadEnd() is called
---@param padding number|nil The amount of padding that will be used, Default is AutoPad.thin
function AutoSpreadRight(padding)
	table.insert(Stack, {type = 'spread', direction = 'right', padding = AutoDefault(padding, AutoPad.thin)})
	UiPush()
end

---The next Auto Ui functions will be spread Left until AutoSpreadEnd() is called
---@param padding number|nil The amount of padding that will be used, Default is AutoPad.thin
function AutoSpreadLeft(padding)
	table.insert(Stack, {type = 'spread', direction = 'left', padding = AutoDefault(padding, AutoPad.thin)})
	UiPush()
end

---The next Auto Ui functions will be spread Verticlely across the Height of the Bounds until AutoSpreadEnd() is called
---@param count number|nil The amount of Auto Ui functions until AutoSpreadEnd()
function AutoSpreadVerticle(count)
	table.insert(Stack, {type = 'spread', direction = 'verticle', length = UiHeight(), count = count})
	UiPush()
end

---The next Auto Ui functions will be spread Horizontally across the Width of the Bounds until AutoSpreadEnd() is called
---@param count number|nil The amount of Auto Ui functions until AutoSpreadEnd()
function AutoSpreadHorizontal(count)
	table.insert(Stack, { type = 'spread', direction = 'horizontal', length = UiWidth(), count = count })
	UiPush()
end

function AutoGetSpread(l)
	l = AutoDefault(l, 1)
	_l = 0
	local count = AutoTableCount(Stack)
	for i = count, 1, -1 do
		if Stack[i].type == 'spread' then
			_l = _l + 1
			if _l >= 1 then
				return Stack[i]
			end
		end
	end
	return nil
end

function AutoSetSpread(Spread)
	local count = AutoTableCount(Stack)
	for i = count, 1, -1 do
		if Stack[i].type == 'spread' then
			v = Stack[i]
		end
	end

	v = Spread
end

---Stop the last known Spread
---@return table a table with information about the transformations used
function AutoSpreadEnd()
	local unitdata = {comb = { w = 0, h = 0 }, max = { w = 0, h = 0 }}
	local Spread = AutoGetSpread()
	local LastSpread = AutoGetSpread(2)
	
	while true do
		local count = AutoTableCount(Stack)
		
		if Stack[count].type ~= 'spread' then
			if Stack[count].data.rect then
				local rect = Stack[count].data.rect
				unitdata.comb.w, unitdata.comb.h = unitdata.comb.w + rect.w, unitdata.comb.h + rect.h
				unitdata.max.w, unitdata.max.h = math.max(unitdata.max.w, rect.w), math.max(unitdata.max.h, rect.h)
			end

			table.remove(Stack, count)
		else
			UiPop()
			table.remove(Stack, count)

			return unitdata
		end
		if count <= 1 then return unitdata end
	end
end

function HandleSpread(gs, data, type, spreadpad)
	spreadpad = AutoDefault(spreadpad, false)

	if gs ~= nil then
		if not spreadpad then pad = 0 else pad = gs.padding end
		if gs.direction == 'down' then
			UiTranslate(0, data.rect.h + pad)
		elseif gs.direction == 'up' then
			UiTranslate(0, -(data.rect.h + pad))
		elseif gs.direction == 'right' then
			UiTranslate(data.rect.w + pad, 0)
		elseif gs.direction == 'left' then
			UiTranslate(-(data.rect.w + pad), 0)
		elseif gs.direction == 'verticle' then
			UiTranslate(0, gs.length / gs.count * 1.5 + gs.length / gs.count)
		elseif gs.direction == 'horizontal' then
			UiTranslate(gs.length / gs.count, 0)
		end
	end

	if type ~= nil then
		table.insert(Stack, { type = type, data = data })
	end
end
-------------------------------------------------------------------------------------------------------------------------------------------------------
----------------User Interface Creation Functions-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

---Create a Container with new bounds
---@param width number
---@param height number
---@param padding number|nil The Amount of padding against sides of the container, Default is AutoPad.micro
---@param clip boolean|nil Weather to clip stuff outside of the container, Default is false
---@param draw boolean|nil Draws the container's backgorund, otherwise it will be invisible, Defualt is true
---@return table containerdata
function AutoContainer(width, height, padding, clip, draw)
	width = AutoDefault(width, 300)
	height = AutoDefault(height, 400)
	padding = math.max(AutoDefault(padding, AutoPad.micro), 0)
	clip = AutoDefault(clip, false)
	draw = AutoDefault(draw, true)
	spreadpad = AutoDefault(spreadpad, true)

	local paddingwidth = math.max(width - padding * 2, padding * 2)
	local paddingheight = math.max(height - padding * 2, padding * 2)
	
	UiWindow(width, height, clip)

	UiAlign('left top')
	if draw then
		UiPush()
			UiColor(unpack(AutoSecondaryColor))
			UiImageBox("ui/common/box-solid-10.png", UiWidth(), UiHeight(), 10, 10)
		UiPop()
	end

	hover = UiIsMouseInRect(UiWidth(), UiHeight())
	
	UiTranslate(padding, padding)
	UiWindow(paddingwidth, paddingheight, false)

	local offset = { x = 0, y = 0 }

	UiTranslate(offset.x, offset.y)
	
	return { rect = { w = paddingwidth, h = paddingheight }, hover = hover }
end

---Creates a Button
---@param name string
---@param fontsize number
---@param paddingwidth Amount of padding used Horizontally
---@param paddingheight Amount of padding used Vertically
---@param draw boolean Draws the Button
---@param spreadpad boolean Adds padding when used with AutoSpread...()
---@return boolean Pressed
---@return table ButtonData
function AutoButton(name, fontsize, paddingwidth, paddingheight, draw, spreadpad)
	fontsize = AutoDefault(fontsize, 28)
	paddingwidth = AutoDefault(paddingwidth, AutoPad.thick)
	paddingheight = AutoDefault(paddingheight, AutoPad.thin)
	draw = AutoDefault(draw, true)
	spreadpad = AutoDefault(spreadpad, true)

	UiPush()
		UiWordWrap(UiWidth() - AutoPad.thick)
		UiFont(AutoFont, fontsize)
		UiButtonHoverColor(unpack(AutoSpecialColor))
		UiButtonPressColor(0.75, 0.75, 0.75, 1)
		UiButtonPressDist(0.25)

		UiColor(0, 0, 0, 0)
		local rw, rh = UiText(name)
		local padrw, padrh = rw + paddingwidth * 2, rh + paddingheight * 2
		
		if draw then
			hover = UiIsMouseInRect(padrw, padrh)
			UiColor(unpack(AutoPrimaryColor))
			
			UiButtonImageBox('ui/common/box-outline-6.png', 6, 6, unpack(AutoPrimaryColor))
			pressed = UiTextButton(name, padrw, padrh)
		end
	UiPop()

	local data = { pressed = pressed, hover = hover, rect = { w = padrw, h = padrh } }
	if draw then HandleSpread(AutoGetSpread(), data, 'draw', spreadpad) end

	return pressed, data
end

---Draws some Text
---@param name string
---@param fontsize number
---@param draw boolean Draws the Text
---@param spreadpad boolean Adds padding when used with AutoSpread...()
---@return table TextData
function AutoText(name, fontsize, draw, spreadpad)
	fontsize = AutoDefault(fontsize, 28)
	draw = AutoDefault(draw, true)
	spreadpad = AutoDefault(spreadpad, true)

	UiPush()
		UiWordWrap(UiWidth() - AutoPad.thick)
		UiFont(AutoFont, fontsize)

		UiColor(0, 0, 0, 0)
		local rw, rh = UiText(name)

		if draw then
			UiPush()
				UiWindow(rw, rh)
				AutoCenter()
				
				UiColor(unpack(AutoPrimaryColor))
				UiText(name)
			UiPop()
		end
	UiPop()

	local data = { rect = { w = rw, h = rh} }
	if draw then HandleSpread(AutoGetSpread(), data, 'draw', spreadpad) end

	return data
end

---Creates a Slider
---@param set number The Current Value
---@param min number The Minimum
---@param max number The Maximum
---@param lockincrement number The increment
---@param paddingwidth Amount of padding used Horizontally
---@param paddingheight Amount of padding used Vertically
---@param spreadpad boolean Adds padding when used with AutoSpread...()
---@return number NewValue
---@return table SliderData
function AutoSlider(set, min, max, lockincrement, paddingwidth, paddingheight, spreadpad)
	min = AutoDefault(min, 0)
	max = AutoDefault(max, 1)
	set = AutoDefault(set, min)
	lockincrement = AutoDefault(lockincrement, 0)
	paddingwidth = AutoDefault(paddingwidth, AutoPad.thick)
	paddingheight = AutoDefault(paddingheight, AutoPad.micro)
	spreadpad = AutoDefault(spreadpad, true)

	local width = UiWidth() - paddingwidth * 2
	local dotwidth, dotheight = UiGetImageSize("ui/common/dot.png")

	local screen = AutoMap(set, min, max, 0, width)

	UiPush()
		UiTranslate(paddingwidth, paddingheight)
		UiColor(unpack(AutoSpecialColor))
	
		UiPush()
			UiTranslate(0, dotheight / 2)
			UiRect(width, 2)
		UiPop()
			
		UiTranslate(-dotwidth / 2, 0)

		screen, released = UiSlider('ui/common/dot.png', "x", screen, 0, width)
		screen = AutoMap(screen, 0, width, min, max)
		screen = AutoRound(screen, lockincrement)
		screen = AutoClamp(screen, min, max)
		set = screen
	UiPop()

	local data = { value = set, released = released, rect = {w = width, h = paddingheight * 2 + dotheight} }
	HandleSpread(AutoGetSpread(), data, 'draw', spreadpad)
	
	return set, data
end

---Draws an Image
---@param path string
---@param width number
---@param height number
---@param alpha number
---@param draw boolean Draws the Image
---@param spreadpad boolean Adds padding when used with AutoSpread...()
---@return table ImageData
function AutoImage(path, width, height, alpha, draw, spreadpad)
	local w, h = UiGetImageSize(path)
	width = AutoDefault(width, (height == nil and UiWidth() or (height * (w / h))))
	height = AutoDefault(height, width * (h / w))
	alpha = AutoDefault(alpha, 1)
	draw = AutoDefault(draw, true)
	spreadpad = AutoDefault(spreadpad, true)
	
	if draw then
		UiPush()
			UiColor(1, 1, 1, alpha)
			UiImageBox(path, width, height)
		UiPop()
	end

	local hover = UiIsMouseInRect(width, height)
	
	local data = {hover = hover, rect = {w = width, h = height}}
	if draw then HandleSpread(AutoGetSpread(), data, 'draw', spreadpad) end
	
	return data
end

---Creates a handy little marker, doesnt effect anything, purely visual
---@param size number, Default is 1
function AutoMarker(size)
	size = AutoDefault(size, 1) / 2
	UiPush()
		UiAlign('center middle')
		UiScale(size, size)
		UiColor(unpack(AutoSpecialColor))
		UiImage('ui/common/dot.png')
	UiPop()
end