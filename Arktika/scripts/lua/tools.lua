function isValid(object)
	return ((object ~= nil) and (object ~= ""))
end
function isFunction(object)
	return ((isValid(object)) and (type(object) == "function"))
end

function getMission( missionName )
    for index, mission in ipairs(Missions) do
    	for i, spawn in ipairs(mission.spawns) do
			if (spawn.name == missionName) then
				return Missions[index]
			end
		end
    end
	return nil
end

function getNextMission(missionName)
	for index, mission in ipairs(Missions) do
    	for i, spawn in ipairs(mission.spawns) do
			if (spawn.name == missionName) then
				return Missions[index + 1]
			end
		end
    end
	
	return nil
end
function getPrevMission(missionName)

    for index, mission in ipairs(Missions) do
    	for i, spawn in ipairs(mission.spawns) do
			if (spawn.name == missionName) then
				return Missions[index - 1]
			end
		end
    end
	
	return nil
end
-- базовая функция-обертка для добавления юнитов в резерв
-- используется типовыми функциями-обертками
-- добавляет юнит uid типа utype в количестве unum
-- unum можно не указывать - будет считаться равным 1
function addUnit(utype, uid, unum)

	if ((unum == nil) or (unum < 1)) then
		unum = 1
	end

	for count = 1, unum, 1 do
		
		if (utype == TANK) then
			game.addTankReserve(uid)
			console.log("SET RESERVE >> Tank added >> ", uid)
		elseif (utype == SQUAD) then
			game.addSquadReserve(uid)
			console.log("SET RESERVE >> Squad added >> ", uid)
		elseif (utype == CAR) then
			game.addCarReserve(uid)
			console.log("SET RESERVE >> Car added >> ", uid)
		elseif (utype == HELI) then
			game.addHeliReserve(uid)
			console.log("SET RESERVE >> Heli added >> ", uid)
		else
			--nonmanaged or wrong unit type
			console.log("ERROR::tools.lua >> addUnit >> Nonmanaged or Wrong unit type: ", utype, ".")
		end
	end
end

-- типовая функция-обертка для добавления такнов в резерв
function addTank(uid, unum)
	addUnit(TANK, uid, unum)
end

-- типовая функция-обертка для добавления машинок в резерв
function addCar(uid, unum)
	addUnit(CAR, uid, unum)
end

-- типовая функция-обертка для добавления вертолетов в резерв
function addHeli(uid, unum)
	addUnit(HELI, uid, unum)
end

-- типовая функция-обертка для добавления людей в резерв
function addSquad(uid, unum)
	addUnit(SQUAD, uid, unum)
end

function win()
	game.win()
end

function lose()
	game.lose()
end
