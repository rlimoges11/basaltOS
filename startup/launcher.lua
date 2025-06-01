if settings.get("Autorun") ~= nil then
	shell.run(settings.get("Autorun"))
else
	shell.run("main.lua")
end