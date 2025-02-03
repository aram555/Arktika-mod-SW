--************************************************************************
--* Вспомогательные функции и константы									 *
--************************************************************************
-- utility variables
-- constants
SCRIPTS_PATH = "scripts/lua/"
dofile(SCRIPTS_PATH.."constants.lua")
-- соответствие объекта спауну
dofile(SCRIPTS_PATH.."spawns.lua")
-- соответстиве объекта резервам
dofile(SCRIPTS_PATH.."reserves.lua")
-- вспомогательные функции
dofile(SCRIPTS_PATH.."tools.lua")
--*****************************************************************************
--* Global map: start event handler											  *
--*****************************************************************************
function mapOnStart()
	dofile(SCRIPTS_PATH.."gm_effects.lua")
end

function showNextMissionObjects(lastMissionName)

	local nextMission = nil
	if not(isValid(lastMissionName)) then
		nextMission = Missions[1]
	else
		local currentMission = getMission(lastMissionName)
	    -- hide current mission map objects
	    if(isValid(currentMission)) then
			for i, spawn in ipairs(currentMission.spawns) do
				game.hideObject(spawn.mapObject)
			end
		 end
		nextMission = getNextMission(lastMissionName)
	end

	if(isValid(nextMission)) then
		-- show next mission map objects
		for i, spawn in ipairs(nextMission.spawns) do
			game.loadObject(spawn.mapObject, spawn.mapObjectPos.x, spawn.mapObjectPos.y)
		end
		-- set camera position
		game.setCameraPos(nextMission.mapCameraPos.x, nextMission.mapCameraPos.y)
	else
		console.log("WARNING::global_map.lua >> mapOnStartMissionSpecific() >> End of Campaign Reached")
	end

end

--*****************************************************************************
--* Global map: start event handler	for last mission						  *
--*****************************************************************************
function mapOnStartMissionSpecific(lastMission)
	showNextMissionObjects(lastMission)
	-- Сохраним глобальную карту после изменений, для возврата на нее с тактической
	game.autoSaveGlobalMap()
end

--*****************************************************************************
--* Global map: mouse left click event handler								  *
--*****************************************************************************
function mapOnMouseLeftUp(missionName)

	if not(isValid(missionName)) then
		console.log("ERROR::global_map.lua >> mapOnMouseLeftUp() >> Wrong argument: ", missionName, ".")
		return
	end
	
	local object_pos = game.getObjectPos(missionName, true)
	
	game.setCameraPos(object_pos.x, object_pos.y)
end

--*****************************************************************************
--* addMissionReserve														  *
--*****************************************************************************
function addMissionReserve(missionName)

	if not(isValid(missionName)) then
		console.log("ERROR::global_map.lua >> addMissionReserve >> Wrong argument: ", missionName, ".")
		return
	end

	local setReserve = Reserves[missionName]
	
	if (isFunction(setReserve)) then
		console.log("**********************************************************************")
		console.log(string.upper(missionName), " >> setting reserve")
		console.log("**********************************************************************")

		setReserve()

	else
		console.log("ERROR::global_map.lua >> addMissionReserve() >> Nonmanaged or Wrong object name:", missionName)
	end

end

--*****************************************************************************
--* Global map briefing window: "OK"-button click event handler				  *
--*****************************************************************************
function mapOnOkButton(missionName)

	if not(isValid(missionName)) then
		console.log("ERROR::global_map.lua >> mapOnOkButton >> Wrong argument: ", missionName, ".")
		return
	end
	
	if (isValid(missionName)) then
		local spawnName = "spawns/"..missionName..".sws"
		console.log("**********************************************************************")
		console.log("loading spawn >> ", spawnName)
		
		game.enterTacticalMap(PLAYER, spawnName)
	else
		-- nonmanaged object_name
		console.log("ERROR::global_map.lua >> mapOnOkButton() >> Nonmanaged or Wrong object name:", missionName)
	end

end

--*****************************************************************************
--* Global map: leave TacticalMap                                             *
--*****************************************************************************
function mapOnLeaveTacticalMap(victory, currentMission)
	
	if not(isValid(victory)) then
		console.log("ERROR::global_map.lua >> mapOnLeaveTacticalMap >> Wrong argument: ", victory, ". ", "Setting to true")
		victory = true
	end
	
	-- Если больше миссий нет
	if (victory) then
		if(getNextMission(currentMission) == nil) then
			game.enterEndVideo()
		else
			-- Если победили, то выполним действия для продвижения по сюжету
			game.returnToGlobalMap()
			mapOnStartMissionSpecific(currentMission);
		end
	else 
		if(getPrevMission(currentMission) == nil) then
			game.enterMainMenu()
		else
			-- Выходим на сохраненную ранее глобальную карту
			game.returnToGlobalMap()
		end
	end
end
