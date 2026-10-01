-- since some executors (assium) have crappy console redirection ts just bricks your console so nothing can error/print in it 

game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F9, false, game)
task.wait(0.1)
game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F9, false, game)
task.wait(0.1)

for _,con in getconnections(game:GetService("LogService").MessageOut) do
    con:Disconnect()
end

for _,con in getconnections( game:GetService("ScriptContext").Error) do
    con:Disconnect()
end

task.wait(0.1)
game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F9, false, game)
task.wait(0.1)
game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F9, false, game)