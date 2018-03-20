local LevelTrackManager = {}

local arrowMap = {}
local spawnMap = {} -- If I add enemies/danger, there can be a spawn per track
local currentTrack = 0

function LevelTrackManager.AddAdvanceArrow(trackId, arrow)
	arrowMap[trackId] = arrow
end

function LevelTrackManager.GetArrow(trackId)
	return arrowMap[trackId]
end

function LevelTrackManager.AdvanceTrack()
	currentTrack = currentTrack + 1
end

return LevelTrackManager