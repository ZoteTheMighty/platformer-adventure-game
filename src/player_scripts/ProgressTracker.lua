local ProgressTracker = {}

-- TODO: Track various values like the track the player is on
-- Display them on the screen using Roact
ProgressTracker.track = 0

function ProgressTracker:UpdateTrack(newTrack)
	self.track = newTrack
end

return ProgressTracker