CreateThread(function()
	RegisterCallbacks()
end)

SOUNDS = {
	Play = {
		One = function(self, clientNetId, soundFile, soundVolume)
			TriggerClientEvent("Sounds:Client:Play:One", clientNetId, soundFile, soundVolume)
		end,
		Distance = function(self, clientNetId, maxDistance, soundFile, soundVolume)
			TriggerClientEvent("Sounds:Client:Play:Distance", -1, clientNetId, maxDistance, soundFile, soundVolume)
		end,
		Location = function(self, clientNetId, Location, maxDistance, soundFile, soundVolume)
			TriggerClientEvent(
				"Sounds:Client:Play:Location",
				-1,
				clientNetId,
				Location,
				maxDistance,
				soundFile,
				soundVolume
			)
		end,
		All = function(self, clientNetId, soundFile, soundVolume)
			TriggerClientEvent("Sounds:Client:Play:One", -1, clientNetId, soundFile, soundVolume)
		end,
		Job = function(self, clientNetId, soundFile, job, soundVolume)
			for k, v in ipairs(GetPlayers()) do
				local myDuty = plsr.State:Player(tonumber(v)).onDuty
				if myDuty and job[myDuty] then
					TriggerClientEvent(
						"Sounds:Client:Play:One",
						v,
						clientNetId,
						soundFile,
						soundVolume
					)
				end
			end
		end,
	},
	Loop = {
		One = function(self, clientNetId, soundFile, soundVolume)
			TriggerClientEvent("Sounds:Client:Loop:One", clientNetId, soundFile, soundVolume)
		end,
		Distance = function(self, clientNetId, maxDistance, soundFile, soundVolume)
			TriggerClientEvent("Sounds:Client:Loop:Distance", -1, clientNetId, maxDistance, soundFile, soundVolume)
		end,
		Location = function(self, clientNetId, Location, maxDistance, soundFile, soundVolume)
			TriggerClientEvent(
				"Sounds:Client:Loop:Location",
				-1,
				clientNetId,
				Location,
				maxDistance,
				soundFile,
				soundVolume
			)
		end,
	},
	Stop = {
		One = function(self, clientNetId, soundFile)
			TriggerClientEvent("Sounds:Client:Stop:One", clientNetId, soundFile)
		end,
		Distance = function(self, clientNetId, soundFile)
			TriggerClientEvent("Sounds:Client:Stop:Distance", -1, clientNetId, soundFile)
		end,
		Location = function(self, clientNetId, location, soundFile)
			TriggerClientEvent("Sounds:Client:Stop:Distance", -1, clientNetId, soundFile)
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["pulsar_core"]:RegisterComponent("Sounds", SOUNDS)
end)

AddEventHandler("Characters:Server:PlayerLoggedOut", function(source)
	TriggerClientEvent("Sounds:Client:Stop:All", -1, source)
end)
AddEventHandler("Characters:Server:PlayerDropped", function(source)
	TriggerClientEvent("Sounds:Client:Stop:All", -1, source)
end)

function RegisterCallbacks()
	plsr.Callbacks:RegisterServerCallback("Sounds:Play:Distance", function(source, data, cb)
		plsr.Sounds.Play:Distance(source, data.maxDistance, data.soundFile, data.soundVolume)
	end)

	plsr.Callbacks:RegisterServerCallback("Sounds:Play:Location", function(source, data, cb)
		plsr.Sounds.Play:Location(source, data.location, data.maxDistance, data.soundFile, data.soundVolume)
	end)

	plsr.Callbacks:RegisterServerCallback("Sounds:Loop:Distance", function(source, data, cb)
		plsr.Sounds.Loop:Distance(source, data.maxDistance, data.soundFile, data.soundVolume)
	end)

	plsr.Callbacks:RegisterServerCallback("Sounds:Loop:Location", function(source, data, cb)
		plsr.Sounds.Loop:Location(source, data.location, data.maxDistance, data.soundFile, data.soundVolume)
	end)

	plsr.Callbacks:RegisterServerCallback("Sounds:Stop:Distance", function(source, data, cb)
		plsr.Sounds.Stop:Distance(source, data.soundFile)
	end)
end

AddEventHandler("Sounds:Server:Play:One", function(soundFile, soundVolume)
	plsr.Sounds.Play:One(soundFile, soundVolume)
end)

AddEventHandler("Sounds:Server:Play:Distance", function(playerNetId, maxDistance, soundFile, soundVolume)
	plsr.Sounds.Play:Distance(playerNetId, maxDistance, soundFile, soundVolume)
end)

AddEventHandler("Sounds:Server:Play:All", function(playerNetId, soundFile, soundVolume)
	plsr.Sounds.Play:All(playerNetId, soundFile, soundVolume)
end)

AddEventHandler("Sounds:Server:Play:Job", function(playerNetId, soundFile, job, soundVolume)
	plsr.Sounds.Play:Job(playerNetId, soundFile, job, soundVolume)
end)

AddEventHandler("Sounds:Server:Loop:One", function(soundFile, soundVolume)
	plsr.Sounds.Loop:One(soundFile, soundVolume)
end)

AddEventHandler("Sounds:Server:Loop:Distance", function(playerNetId, maxDistance, soundFile, soundVolume)
	plsr.Sounds.Loop:Distance(playerNetId, maxDistance, soundFile, soundVolume)
end)

AddEventHandler("Sounds:Server:Stop:One", function(soundFile)
	plsr.Sounds.Stop:One(soundFile)
end)

AddEventHandler("Sounds:Server:Stop:Distance", function(playerNetId, soundFile)
	plsr.Sounds.Stop:Distance(playerNetId, soundFile)
end)
