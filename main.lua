local run_service,tween_service,user_input_service = game:GetService("RunService"),game:GetService("TweenService"),game:GetService("UserInputService")
local plr = game:GetService("Players").LocalPlayer
local swait do
    local stack = 0
    local step = run_service["RenderStepped"]:wait()

    function swait(times)
        if times then
            local total = 0
            stack = stack + times

            while stack >= step do
                step = run_service["RenderStepped"]:wait()
                
                stack = stack - step
                total = total + step
            end
        else
            return run_service["RenderStepped"]:wait()
        end
    end
end
local function play(id)
    local animation = game:GetObjects("rbxassetid://" .. tostring(id))[1]
    local char = plr.Character

    local motors = {}
    
    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("Motor6D") then motors[#motors+1] = v end
    end

    if playing then
        playing = false
        wait(.1)
    end

    playing = true
    while wait() and playing do
        for _,frame in pairs(animation:GetKeyframes()) do
            for _,v in pairs(frame:GetDescendants()) do
                local current_motor do
                    for i=1,#motors do
                        if motors[i].Part1.Name ~= v.Name then continue end
    
                        current_motor = motors[i]
    
                        break
                    end
                end
    
                if not current_motor then continue end
    
                local a,b = string.split(tostring(v.EasingStyle),"."),string.split(tostring(v.EasingDirection),".")
                local style = a[#a]
                if style == "Constant" then style = "Linear" end
                local dir = b[#b]
                local tween_info = TweenInfo.new(
                    0.03,
                    Enum.EasingStyle[style],
                    Enum.EasingDirection[dir],
                    0,false,0
                )
    
                tween_service:Create(
                    current_motor,
                    tween_info,
                    {Transform = v.CFrame}
                ):Play()
                  
                if not playing then break end
            end
        
            if not playing then break end

            swait(0.03)
        end
    end
end

play(5159955624)
