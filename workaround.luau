-- ts just disconnects logservice and neuters the linoria ui asset detection that works 1/10 times😭😭😭

while not getactors()[1] do
    task.wait(0.1)
end

run_on_actor(getactors()[1], [==[
    local done = false

    repeat
        for _,v in getgc() do
            if typeof(v) == "function" and islclosure(v) and not isexecutorclosure(v) then
                if pcall(debug.getupvalue, v, 38) and not pcall(debug.getupvalue, v, 39) then
                    local ok, ops = pcall(debug.getupvalue, v, 10)

                    if ok and type(ops) == "table" and not table.isfrozen(ops) and type(rawget(ops, 1)) == "number" then
                        local n = rawlen(ops)
                        if n == 840 or n == 65 then
                            ops[1] = 49

                            if n == 840 then
                                done = true
                            end
                        end
                    end
                end
            end
        end

        if not done then task.wait(0.1) end
    until done

    for _,c in getconnections(game:GetService("LogService").MessageOut) do
        if c.Connected and c.Function and not isexecutorclosure(c.Function) then
            pcall(c.Disconnect, c)
        end
    end
]==])