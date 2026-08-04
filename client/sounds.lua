local _sounds = {}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["pulsar_core"]:RegisterComponent("Sounds", SOUNDS)
end)

RegisterNUICallback("SoundEnd", function(data, cb)
	plsr.Logger:Trace("Sounds", ("^2Stopping Sound %s For ID %s^7"):format(data.file, data.source))
	if _sounds[data.source] ~= nil and _sounds[data.source][data.file] ~= nil then
		_sounds[data.source][data.file] = nil
	end
end)

SOUNDS = {}
SOUNDS.Do = {
	Loop = {
		One = function(self, soundFile, soundVolume)
			plsr.Logger:Trace("Sounds", ("^2Looping Sound %s On Client Only^7"):format(soundFile))
			_sounds[plsr.State.flags.ID] = _sounds[plsr.State.flags.ID] or {}
			_sounds[plsr.State.flags.ID][soundFile] = {
				file = soundFile,
				volume = soundVolume,
				distance = maxDistance,
			}
			SendNUIMessage({
				action = "loopSound",
				source = plsr.State.flags.ID,
				file = soundFile,
				volume = soundVolume,
			})
		end,
		Distance = function(self, playerNetId, maxDistance, soundFile, soundVolume)
			plsr.Logger:Trace(
				"Sounds",
				("^2Looping Sound %s Per Request From %s For Distance %s^7"):format(soundFile, playerNetId, maxDistance)
			)

			local isFromMe = false
			local pPed = PlayerPedId()

			local tPlayer = GetPlayerFromServerId(playerNetId)
			local tPed = GetPlayerPed(tPlayer)

			if playerNetId == plsr.State.flags.ID then
				isFromMe = true
				tPed = PlayerPedId()
			end

			local distIs = #(GetEntityCoords(pPed) - GetEntityCoords(tPed))
			local vol = soundVolume * (1.0 - (distIs / maxDistance))
			if isFromMe then
				vol = soundVolume
			elseif
				(tPed ~= 0 and distIs > maxDistance)
				or tPed == 0
				or not plsr.State.flags.loggedIn
				or (tPlayer == -1)
			then
				vol = 0
			end

			_sounds[playerNetId] = _sounds[playerNetId] or {}
			_sounds[playerNetId][soundFile] = {
				file = soundFile,
				volume = soundVolume,
				distance = maxDistance,
			}
			SendNUIMessage({
				action = "loopSound",
				source = playerNetId,
				file = soundFile,
				volume = vol,
			})

			CreateThread(function()
				while _sounds[playerNetId] ~= nil and _sounds[playerNetId][soundFile] ~= nil do
					tPlayer = GetPlayerFromServerId(playerNetId)
					tPed = GetPlayerPed(tPlayer)

					local distIs = #(GetEntityCoords(pPed) - GetEntityCoords(tPed))
					vol = soundVolume * (1.0 - (distIs / maxDistance))

					if isFromMe then
						vol = soundVolume
					elseif
						(tPed ~= 0 and distIs > maxDistance)
						or tPed == 0
						or not plsr.State.flags.loggedIn
						or (tPlayer == -1)
					then
						vol = 0
					end

					SendNUIMessage({
						action = "updateVol",
						source = playerNetId,
						file = soundFile,
						volume = vol,
					})
					Wait(100)
				end
			end)
		end,
		Location = function(self, playerNetId, location, maxDistance, soundFile, soundVolume)
			plsr.Logger:Trace(
				"Sounds",
				("^2Looping Sound %s Per Request From %s at location %s For Distance %s^7"):format(
					soundFile,
					playerNetId,
					json.encode(location),
					maxDistance
				)
			)
			local distIs = #(GetEntityCoords(PlayerPedId()) - location)
			local vol = soundVolume * (1.0 - (distIs / maxDistance))
			if distIs > maxDistance then
				vol = 0
			end

			_sounds[playerNetId] = _sounds[playerNetId] or {}
			_sounds[playerNetId][soundFile] = {
				file = soundFile,
				volume = soundVolume,
				distance = maxDistance,
			}
			SendNUIMessage({
				action = "loopSound",
				source = playerNetId,
				file = soundFile,
				volume = vol,
			})

			CreateThread(function()
				while _sounds[playerNetId] ~= nil and _sounds[playerNetId][soundFile] ~= nil do
					local distIs = #(GetEntityCoords(PlayerPedId()) - location)
					vol = soundVolume * (1.0 - (distIs / maxDistance))
					if distIs > maxDistance or not plsr.State.flags.loggedIn then
						vol = 0
					end
					SendNUIMessage({
						action = "updateVol",
						source = playerNetId,
						file = soundFile,
						volume = vol,
					})
					Wait(100)
				end
			end)
		end,
	},
	Play = {
		One = function(self, soundFile, soundVolume)
			plsr.Logger:Trace("Sounds", ("^2Playing Sound %s On Client Only^7"):format(soundFile))
			_sounds[plsr.State.flags.ID] = _sounds[plsr.State.flags.ID] or {}
			_sounds[plsr.State.flags.ID][soundFile] = {
				file = soundFile,
				volume = soundVolume,
			}
			SendNUIMessage({
				action = "playSound",
				source = plsr.State.flags.ID,
				file = soundFile,
				volume = soundVolume,
			})
		end,
		Distance = function(self, playerNetId, maxDistance, soundFile, soundVolume)
			playerNetId = tonumber(playerNetId)
			plsr.Logger:Trace(
				"Sounds",
				("^2Playing Sound %s Once Per Request From %s For Distance %s^7"):format(
					soundFile,
					playerNetId,
					maxDistance
				)
			)

			local pPed = PlayerPedId()

			local isFromMe = false

			local tPlayer = GetPlayerFromServerId(playerNetId)
			local tPed = GetPlayerPed(tPlayer)

			if playerNetId == plsr.State.flags.ID then
				isFromMe = true
				tPed = PlayerPedId()
			end

			local distIs = #(GetEntityCoords(pPed) - GetEntityCoords(tPed))
			local vol = soundVolume * (1.0 - (distIs / maxDistance))
			if isFromMe then
				vol = soundVolume
			elseif
				(tPed ~= 0 and distIs > maxDistance)
				or (tPed == 0)
				or not plsr.State.flags.loggedIn
				or (tPlayer == -1)
			then
				vol = 0
			end

			_sounds[playerNetId] = _sounds[playerNetId] or {}
			_sounds[playerNetId][soundFile] = {
				file = soundFile,
				volume = soundVolume,
				distance = maxDistance,
			}
			SendNUIMessage({
				action = "playSound",
				source = playerNetId,
				file = soundFile,
				volume = vol,
			})

			CreateThread(function()
				while _sounds[playerNetId] ~= nil and _sounds[playerNetId][soundFile] ~= nil do
					tPlayer = GetPlayerFromServerId(playerNetId)
					tPed = GetPlayerPed(tPlayer)

					local distIs = #(GetEntityCoords(pPed) - GetEntityCoords(tPed))
					vol = soundVolume * (1.0 - (distIs / maxDistance))

					if isFromMe then
						vol = soundVolume
					elseif
						(tPed ~= 0 and distIs > maxDistance)
						or (tPed == 0)
						or not plsr.State.flags.loggedIn
						or (tPlayer == -1)
					then
						vol = 0
					end

					SendNUIMessage({
						action = "updateVol",
						source = playerNetId,
						file = soundFile,
						volume = vol,
					})
					Wait(100)
				end
			end)
		end,
		Location = function(self, playerNetId, location, maxDistance, soundFile, soundVolume)
			plsr.Logger:Trace(
				"Sounds",
				("^2Playing Sound %s Once Per Request From %s at location %s For Distance %s^7"):format(
					soundFile,
					playerNetId,
					json.encode(location),
					maxDistance
				)
			)
			local distIs = #(
				vector3(plsr.State.flags.position.x, plsr.State.flags.position.y, plsr.State.flags.position.z)
				- vector3(location.x, location.y, location.z)
			)
			local vol = soundVolume * (1.0 - (distIs / maxDistance))
			if distIs > maxDistance then
				vol = 0
			end
			_sounds[playerNetId] = _sounds[playerNetId] or {}
			_sounds[playerNetId][soundFile] = {
				file = soundFile,
				volume = soundVolume,
				distance = maxDistance,
			}
			SendNUIMessage({
				action = "playSound",
				source = playerNetId,
				file = soundFile,
				volume = vol,
			})

			CreateThread(function()
				while _sounds[playerNetId] ~= nil and _sounds[playerNetId][soundFile] ~= nil do
					local distIs = #(
						vector3(plsr.State.flags.position.x, plsr.State.flags.position.y, plsr.State.flags.position.z)
						- vector3(location.x, location.y, location.z)
					)
					vol = soundVolume * (1.0 - (distIs / maxDistance))
					if distIs > maxDistance then
						vol = 0
					end
					SendNUIMessage({
						action = "updateVol",
						source = playerNetId,
						file = soundFile,
						volume = vol,
					})
					Wait(100)
				end
			end)
		end,
	},
	Stop = {
		One = function(self, soundFile)
			plsr.Logger:Trace("Sounds", ("^2Stopping Sound %s On Client^7"):format(soundFile))
			if _sounds[plsr.State.flags.ID] ~= nil and _sounds[plsr.State.flags.ID][soundFile] ~= nil then
				_sounds[plsr.State.flags.ID][soundFile] = nil
				SendNUIMessage({
					action = "stopSound",
					source = plsr.State.flags.ID,
					file = soundFile,
				})
			end
		end,
		Distance = function(self, playerNetId, soundFile)
			plsr.Logger:Trace("Sounds", ("^2Stopping Sound %s Per Request From %s^7"):format(soundFile, playerNetId))
			if _sounds[playerNetId] ~= nil and _sounds[playerNetId][soundFile] ~= nil then
				_sounds[playerNetId][soundFile] = nil
				SendNUIMessage({
					action = "stopSound",
					source = playerNetId,
					file = soundFile,
				})
			end
		end,
	},
	Fade = {
		One = function(self, soundFile)
			plsr.Logger:Trace("Sounds", ("^2Stopping Sound %s On Client^7"):format(soundFile))
			if _sounds[plsr.State.flags.ID] ~= nil and _sounds[plsr.State.flags.ID][soundFile] ~= nil then
				_sounds[plsr.State.flags.ID][soundFile] = nil
				SendNUIMessage({
					action = "fadeSound",
					source = plsr.State.flags.ID,
					file = soundFile,
				})
			end
		end,
	},
}

SOUNDS.Play = {
	One = function(self, soundFile, soundVolume)
		plsr.Sounds.Do.Play:One(soundFile, soundVolume)
	end,
	Distance = function(self, maxDistance, soundFile, soundVolume)
		plsr.Callbacks:ServerCallback("Sounds:Play:Distance", {
			maxDistance = maxDistance,
			soundFile = soundFile,
			soundVolume = soundVolume,
		})
	end,
	Location = function(self, location, maxDistance, soundFile, soundVolume)
		plsr.Callbacks:ServerCallback("Sounds:Play:Location", {
			location = location,
			maxDistance = maxDistance,
			soundFile = soundFile,
			soundVolume = soundVolume,
		})
	end,
}

SOUNDS.Loop = {
	One = function(self, soundFile, soundVolume)
		plsr.Sounds.Do.Loop:One(soundFile, soundVolume)
	end,
	Distance = function(self, maxDistance, soundFile, soundVolume)
		plsr.Callbacks:ServerCallback("Sounds:Loop:Distance", {
			maxDistance = maxDistance,
			soundFile = soundFile,
			soundVolume = soundVolume,
		})
	end,
	Location = function(self, location, maxDistance, soundFile, soundVolume)
		plsr.Callbacks:ServerCallback("Sounds:Loop:Location", {
			location = location,
			maxDistance = maxDistance,
			soundFile = soundFile,
			soundVolume = soundVolume,
		})
	end,
}

SOUNDS.Stop = {
	One = function(self, soundFile)
		plsr.Sounds.Do.Stop:One(soundFile)
	end,
	Distance = function(self, pNet, soundFile)
		plsr.Callbacks:ServerCallback("Sounds:Stop:Distance", {
			soundFile = soundFile,
		})
	end,
	Location = function(self, pNet, soundFile)
		plsr.Callbacks:ServerCallback("Sounds:Stop:Distance", {
			soundFile = soundFile,
		})
	end,
}

SOUNDS.Fade = {
	One = function(self, soundFile)
		plsr.Sounds.Do.Fade:One(soundFile)
	end,
}

RegisterNetEvent("Sounds:Client:Play:One", function(playetNedId, soundFile, soundVolume)
	plsr.Sounds.Do.Play:One(playetNedId, soundFile, soundVolume)
end)

RegisterNetEvent("Sounds:Client:Play:Distance", function(playerNetId, maxDistance, soundFile, soundVolume)
	plsr.Sounds.Do.Play:Distance(playerNetId, maxDistance, soundFile, soundVolume)
end)

RegisterNetEvent("Sounds:Client:Play:Location", function(playerNetId, location, maxDistance, soundFile, soundVolume)
	plsr.Sounds.Do.Play:Location(playerNetId, location, maxDistance, soundFile, soundVolume)
end)

RegisterNetEvent("Sounds:Client:Loop:One", function(soundFile, soundVolume)
	plsr.Sounds.Do.Loop:One(soundFile, soundVolume)
end)

RegisterNetEvent("Sounds:Client:Loop:Distance", function(playerNetId, maxDistance, soundFile, soundVolume)
	plsr.Sounds.Do.Loop:Distance(playerNetId, maxDistance, soundFile, soundVolume)
end)

RegisterNetEvent("Sounds:Client:Loop:Location", function(playerNetId, location, maxDistance, soundFile, soundVolume)
	plsr.Sounds.Do.Loop:Location(playerNetId, location, maxDistance, soundFile, soundVolume)
end)

RegisterNetEvent("Sounds:Client:Stop:One", function(soundFile)
	plsr.Sounds.Do.Stop:One(soundFile)
end)

RegisterNetEvent("Sounds:Client:Stop:Distance", function(playerNetId, soundFile)
	plsr.Sounds.Do.Stop:Distance(playerNetId, soundFile)
end)

RegisterNetEvent("Sounds:Client:Stop:All", function(playerNetId, soundFile)
	if _sounds[playerNetId] ~= nil then
		for k, v in pairs(_sounds[playerNetId]) do
			plsr.Sounds.Do.Stop:One(playerNetId, v)
		end
		_sounds[playerNetId] = nil
	end
end)
