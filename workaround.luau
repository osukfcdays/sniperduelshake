-- deepseeks finest

if getgenv().workaround then
    return
end

local actor = getactors()[1]

while not actor do
    task.wait(0.05)
    actor = getactors()[1]
end

for _,v in getgc() do
    if typeof(v) == "function" and islclosure(v) and not isexecutorclosure(v) then
        if pcall(debug.getupvalue, v, 36) and not pcall(debug.getupvalue, v, 37) then
            local ok, ops = pcall(debug.getupvalue, v, 10)

            if ok and type(ops) == "table" and not table.isfrozen(ops) and type(rawget(ops, 1)) == "number" then
                local n = rawlen(ops)

                if n == 123 or n == 67 or n == 328 or n == 15 or n == 43 then
                    ops[1] = 111
                end
            end
        end
    end
end

local id, channel = create_comm_channel()

run_on_actor(actor, [==[
    local id = ...
    local found1 = false
    local found2 = false

    local targets = {
        [840] = true,
        [65]  = true,
        [75]  = true,
        [56]  = true,
        [49]  = true,
        [132] = true,
        [18]  = true,
        [95]  = true,
        [31]  = true,
        [34]  = true,
        [11]  = true,
        [14]  = true,
        [123] = true,
        [322] = true,
        [129] = true,
        [26]  = true,
        [388] = true,
        [391] = true,
        [90]  = true,
        [16]  = true,
        [384] = true,
    }

    local dummyanim = {Play = function() end}
    local dummyanimator = {LoadAnimation = function() return dummyanim end}
    local dummyhumanoid = {Health = 100}

    repeat
        for _,v in getgc() do
            if typeof(v) == "function" and islclosure(v) and not isexecutorclosure(v) then
                if pcall(debug.getupvalue, v, 38) and not pcall(debug.getupvalue, v, 39) then
                    local ok1, ops = pcall(debug.getupvalue, v, 10)
                    local ok2, ups = pcall(debug.getupvalue, v, 26)

                    if ok1 and type(ops) == "table" and not table.isfrozen(ops) and type(rawget(ops, 1)) == "number" then
                        local n = rawlen(ops)

                        if targets[n] then
                            ops[1] = 49
                            if n == 840 then found1 = true end
                            if n == 65 then found2 = true end
                        elseif n == 25 and ok2 and type(ups) == "table" and rawlen(ups) == 3 then
                            ops[1] = 49

                            if type(ups[3]) == "table" then
                                ups[3][1] = nil
                                ups[3] = {}
                            end
                        elseif n == 63 and ok2 and type(ups) == "table" and rawlen(ups) == 6 then
                            ups[3] = { Character = true }
                            ups[4] = function(_, name)
                                return name == "Humanoid" and dummyhumanoid or dummyanimator
                            end
                            ups[6] = {Instance = {new = function() return {} end}}
                        end
                    end
                end
            end
        end

        if not (found1 and found2) then
            task.wait(0.05)
        end
    until found1 and found2

    for _,c in getconnections(game:GetService("LogService").MessageOut) do
        if c.Connected and c.Function and not isexecutorclosure(c.Function) then
            pcall(c.Disconnect, c)
        end
    end

    print("ok")
    
    get_comm_channel(id):Fire()
]==], id)

channel.Event:Wait()

getgenv().workaround = true