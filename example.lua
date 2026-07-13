local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/riddance-club/ui/refs/heads/main/library.lua"))()

Library:SetUIParent(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))

local _, Frame, Title, _, GridLayout, _, TemplateButton, TemplateBox, TemplateLabel = Library:GetRawAll()

local Colors = {Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 255, 255)}

Frame.BackgroundColor3 = Color3.new()
Frame.BorderColor3 = Colors[1]
Frame.BorderSizePixel = 2
Frame.Size = UDim2.new(0, 480, 0, 450)

Title.BackgroundColor3 = Color3.new()
Title.TextColor3 = Colors[2]
Title.Font = Enum.Font.SourceSansBold
Title.BorderColor3 = Colors[1]
Title.BorderSizePixel = 1

GridLayout.CellSize = UDim2.new(0.25, 0, 0.15, 0)
GridLayout.CellPadding = UDim2.new(0, 0, 0, 0)

local function applyColorTheme(ins)
    ins.BackgroundColor3 = Color3.new()
    ins.TextColor3 = Colors[2]
    ins.BorderColor3 = Colors[1]
    ins.BorderSizePixel = 1
    ins.Font = Enum.Font.SourceSansBold
end

applyColorTheme(TemplateButton)
applyColorTheme(TemplateBox)
applyColorTheme(TemplateLabel)

local Window = Library:CreateWindow({
    Title = "riddance's ui library example design"
})

Window:CreateLabel({
    Text = "label"
})

Window:CreateButton({
    Text = "button",
    Callback = function()
        Library:Hint({Text = "clicked button", Duration = 1})
    end
})

Window:CreateToggle({
    Text = "toggle",
    Default = false,
    Callback = function(state)
        Library:Hint({Text = "toggle state is now " .. tostring(state), Duration = 1})
    end
})

Window:CreateKeybind({
    Text = "keybind",
    Default = Enum.KeyCode.Z,
    Callback = function(key)
        Library:Hint({Text = "key is: " .. tostring(key), Duration = 1})
        Window:SetVisible(not Window:GetVisible())
    end
})
