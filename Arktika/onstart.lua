spawns = {}
spawns[1] = "first_mission.sws"

spawn_name = "first_mission.sws"
global_map = "sa"
minZoom = 200
maxZoom = 400
console.setvar("game.autostart", true)
console.setvar("game.firstMission", "first_mission.sws")
game.enterGlobalMap()
