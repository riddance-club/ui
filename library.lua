local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")

local GUI = Instance.new("ScreenGui")
GUI.ResetOnSpawn = false

local Frame = Instance.new("Frame", GUI)
Frame.Position = UDim2.new(0.35, 0, 0.35, 0)
Frame.Size = UDim2.new(0.5, 0, 0.5, 0)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextScaled = true

local Container = Instance.new("ScrollingFrame", Frame)
Container.Position = UDim2.new(0, 0, 0, 25)
Container.Size = UDim2.new(1, 0, 1, -25)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.CanvasSize = UDim2.new(0, 0, 0, 0)

local GridLayout = Instance.new("UIGridLayout", Container)
GridLayout.CellSize = UDim2.new(0, 110, 0, 30)
GridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
GridLayout.SortOrder = Enum.SortOrder.LayoutOrder

local ResizeCorner = Instance.new("TextButton", Frame)
ResizeCorner.Size = UDim2.new(0, 30, 0, 30)
ResizeCorner.Position = UDim2.new(1, -30, 1, -30)
ResizeCorner.BackgroundTransparency = 1
ResizeCorner.Text = "↘"
ResizeCorner.TextScaled = true
ResizeCorner.ZIndex = 5

local TemplateButton = Instance.new("TextButton")
TemplateButton.TextScaled = true
TemplateButton.RichText = true

local TemplateBox = Instance.new("TextBox")
TemplateBox.ClearTextOnFocus = false
TemplateBox.TextScaled = true

local TemplateLabel = Instance.new("TextLabel")
TemplateLabel.BackgroundTransparency = 1
TemplateLabel.TextScaled = true
TemplateButton.RichText = true

local TemplateImageLabel = Instance.new("ImageLabel")
TemplateImageLabel.BackgroundTransparency = 1

local TemplateImageButton = Instance.new("ImageButton")
TemplateImageButton.BackgroundTransparency = 1

local layoutOrderCounter = 0
local Library = {}
local Window = {
	DraggingState = true
}

function Library:CreateWindow(tbl)
	if not tbl then
		error("You forgot to specify settings for CreateWindow.")
	end

	local windowTitle = tbl.Title or "Window"
	Title.Text = windowTitle

	if tbl.DraggingState ~= nil then
		Window.DraggingState = not not tbl.DraggingState
	else
		Window.DraggingState = true
	end

	for k, v in pairs(tbl) do
		if k == "Rounded" and v then
			Instance.new("UICorner", Frame)
		elseif k == "CornerRadius" then
			local corner = Frame:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", Frame)
			corner.CornerRadius = v
		elseif k ~= "Title" and k ~= "DraggingState" then
			pcall(function()
				Frame[k] = v
			end)
		end
	end

	local dragging, dragInput, dragStart, startPos
	Title.InputBegan:Connect(function(input)
		if not Window.DraggingState then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	Title.InputChanged:Connect(function(input)
		if not Window.DraggingState then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not Window.DraggingState then
			dragging = false
			return
		end
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	local resizing, resizeStartPos, resizeStartSize
	ResizeCorner.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			resizeStartPos = input.Position
			resizeStartSize = Frame.AbsoluteSize
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					resizing = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - resizeStartPos
			local newX = resizeStartSize.X + delta.X
			local newY = resizeStartSize.Y + delta.Y
			newX = math.max(newX, 150)
			newY = math.max(newY, 100)
			Frame.Size = UDim2.new(0, newX, 0, newY)
		end
	end)

	return Window
end

function Library:SetUIParent(parent)
	GUI.Parent = parent
end

function Library:Notification(tbl)
	StarterGui:SetCore("SendNotification", tbl)
end

function Library:Message(tbl)
	tbl = tbl or {}
	local Message = Instance.new("Message", workspace)
	Message.Text = tbl.Text or "Message"
	Debris:AddItem(Message, tbl.Duration or 3)
end

function Library:Hint(tbl)
	tbl = tbl or {}
	local Hint = Instance.new("Hint", workspace)
	Hint.Text = tbl.Text or "Hint"
	Debris:AddItem(Hint, tbl.Duration or 3)
end

function Library:GetRawAll()
	return GUI, Frame, Title, Container, GridLayout, ResizeCorner, TemplateButton, TemplateBox, TemplateLabel, TemplateImageLabel, TemplateImageButton
end

function Window:GetRaw()
	return Frame
end

function Window:SetProperty(property, data)
	Frame[property] = data
end

function Window:GetProperty(property)
	return Frame[property]
end

function Window:SetCellSize(cellSize)
	GridLayout.CellSize = cellSize
end

function Window:SetCellPadding(cellPadding)
	GridLayout.CellPadding = cellPadding
end

function Window:SetTitle(text)
	Title.Text = text
end

function Window:GetTitle()
	return Title.Text
end

function Window:SetDraggingState(state)
	self.DraggingState = not not state
end

function Window:GetDraggingState()
	return self.DraggingState
end

function Window:EditResizeCorner(tbl)
	tbl = tbl or {}
	if tbl.Symbol then
		ResizeCorner.Text = tbl.Symbol
	end
	if tbl.Size then
		if typeof(tbl.Size) == "number" then
			ResizeCorner.Size = UDim2.new(0, tbl.Size, 0, tbl.Size)
			ResizeCorner.Position = UDim2.new(1, -tbl.Size, 1, -tbl.Size)
		elseif typeof(tbl.Size) == "UDim2" then
			ResizeCorner.Size = tbl.Size
		end
	end
	for k, v in pairs(tbl) do
		if k ~= "Symbol" and k ~= "Size" then
			pcall(function()
				ResizeCorner[k] = v
			end)
		end
	end
end

function Window:CreateLabel(tbl)
	tbl = tbl or {}
	local lblObj = {}
	local lbl = TemplateLabel:Clone()

	layoutOrderCounter = layoutOrderCounter + 1
	lbl.LayoutOrder = layoutOrderCounter
	lbl.Text = tbl.Text or "Label"

	for k, v in pairs(tbl) do
		if k == "Rounded" and v then
			Instance.new("UICorner", lbl)
		elseif k == "CornerRadius" then
			local corner = lbl:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", lbl)
			corner.CornerRadius = v
		elseif k ~= "Position" and k ~= "Size" and k ~= "Text" then
			pcall(function()
				lbl[k] = v
			end)
		end
	end

	lbl.Parent = Container

	function lblObj:GetRaw()
		return lbl
	end

	function lblObj:SetText(text)
		lbl.Text = text
	end

	function lblObj:GetText()
		return lbl.Text
	end

	function lblObj:SetVisible(visible)
		lbl.Visible = visible
	end

	return lblObj
end

function Window:CreateButton(tbl)
	tbl = tbl or {}
	local btnObj = {}
	local btn = TemplateButton:Clone()

	layoutOrderCounter = layoutOrderCounter + 1
	btn.LayoutOrder = layoutOrderCounter
	btn.Text = tbl.Text or "Button"

	for k, v in pairs(tbl) do
		if k == "Rounded" and v then
			Instance.new("UICorner", btn)
		elseif k == "CornerRadius" then
			local corner = btn:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", btn)
			corner.CornerRadius = v
		elseif k ~= "Position" and k ~= "Size" and k ~= "Text" and k ~= "Callback" then
			pcall(function()
				btn[k] = v
			end)
		end
	end

	if tbl.Callback then
		btnObj.Connection = btn.MouseButton1Click:Connect(tbl.Callback)
	end

	btn.Parent = Container

	function btnObj:GetRaw()
		return btn
	end

	function btnObj:SetText(text)
		btn.Text = text
	end

	function btnObj:GetText()
		return btn.Text
	end

	function btnObj:SetVisible(visible)
		btn.Visible = visible
	end

	function btnObj:SetCallback(callback)
		if self.Connection then
			self.Connection:Disconnect()
		end
		self.Connection = btn.MouseButton1Click:Connect(callback)
	end

	return btnObj
end

function Window:CreateToggle(tbl)
	tbl = tbl or {}
	local tglObj = {}
	local tgl = TemplateButton:Clone()

	local baseText = tbl.Text or "Toggle"
	local state = tbl.Default or false
	local onColor = tbl.OnColor or Color3.fromRGB(0, 255, 0)
	local offColor = tbl.OffColor or Color3.fromRGB(255, 0, 0)

	local function updateText()
		local colorHex = state and onColor:ToHex() or offColor:ToHex()
		local stateText = state and "ON" or "OFF"
		tgl.Text = baseText .. ": <font color=\"#" .. colorHex .. "\">" .. stateText .. "</font>"
	end

	layoutOrderCounter = layoutOrderCounter + 1
	tgl.LayoutOrder = layoutOrderCounter
	updateText()

	for k, v in pairs(tbl) do
		if k == "Rounded" and v then
			Instance.new("UICorner", tgl)
		elseif k == "CornerRadius" then
			local corner = tgl:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", tgl)
			corner.CornerRadius = v
		elseif k ~= "Position" and k ~= "Size" and k ~= "Text" and k ~= "Callback" and k ~= "Default" and k ~= "OnColor" and k ~= "OffColor" then
			pcall(function()
				tgl[k] = v
			end)
		end
	end

	tgl.MouseButton1Click:Connect(function()
		state = not state
		updateText()
		if tbl.Callback then
			tbl.Callback(state)
		end
	end)

	tgl.Parent = Container

	function tglObj:GetRaw()
		return tgl
	end

	function tglObj:SetState(newState)
		state = newState
		updateText()
	end

	function tglObj:GetState()
		return state
	end

	function tglObj:SetText(newText)
		baseText = newText
		updateText()
	end

	function tglObj:SetVisible(visible)
		tgl.Visible = visible
	end

	return tglObj
end

function Window:CreateKeybind(tbl)
	tbl = tbl or {}
	local kbObj = {}
	local btn = TemplateButton:Clone()

	local baseText = tbl.Text or "Keybind"
	local currentKey = tbl.Default
	local binding = false

	local function updateText()
		local keyName = currentKey and currentKey.Name or "None"
		btn.Text = baseText .. ": " .. keyName
	end

	layoutOrderCounter = layoutOrderCounter + 1
	btn.LayoutOrder = layoutOrderCounter
	updateText()

	for k, v in pairs(tbl) do
		if k == "Rounded" and v then
			Instance.new("UICorner", btn)
		elseif k == "CornerRadius" then
			local corner = btn:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", btn)
			corner.CornerRadius = v
		elseif k ~= "Position" and k ~= "Size" and k ~= "Text" and k ~= "Callback" and k ~= "Default" then
			pcall(function()
				btn[k] = v
			end)
		end
	end

	btn.MouseButton1Click:Connect(function()
		binding = true
		btn.Text = baseText .. ": ..."
	end)

	UserInputService.InputBegan:Connect(function(input, processed)
		if binding then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				currentKey = input.KeyCode
				binding = false
				updateText()
			end
		elseif currentKey and input.KeyCode == currentKey and not processed then
			if tbl.Callback then
				tbl.Callback(currentKey)
			end
		end
	end)

	btn.Parent = Container

	function kbObj:GetRaw()
		return btn
	end

	function kbObj:SetKey(keyCode)
		currentKey = keyCode
		updateText()
	end

	function kbObj:GetKey()
		return currentKey
	end

	function kbObj:SetText(text)
		baseText = text
		updateText()
	end

	function kbObj:SetVisible(visible)
		btn.Visible = visible
	end

	return kbObj
end

function Window:CreateTextBox(tbl)
	tbl = tbl or {}
	local txtObj = {}
	local txt = TemplateBox:Clone()

	layoutOrderCounter = layoutOrderCounter + 1
	txt.LayoutOrder = layoutOrderCounter
	txt.PlaceholderText = tbl.Placeholder or ""
	txt.Text = tbl.Default or ""

	for k, v in pairs(tbl) do
		if k == "Rounded" and v then
			Instance.new("UICorner", txt)
		elseif k == "CornerRadius" then
			local corner = txt:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", txt)
			corner.CornerRadius = v
		elseif k ~= "Position" and k ~= "Size" and k ~= "Text" and k ~= "Callback" and k ~= "Default" then
			pcall(function()
				txt[k] = v
			end)
		end
	end

	if tbl.Callback then
		txt.FocusLost:Connect(function(enterPressed)
			tbl.Callback(txt.Text, enterPressed)
		end)
	end

	txt.Parent = Container

	function txtObj:GetRaw()
		return txt
	end

	function txtObj:SetText(text)
		txt.Text = text
	end

	function txtObj:GetText()
		return txt.Text
	end

	function txtObj:Clear()
		txt.Text = ""
	end

	function txtObj:SetVisible(visible)
		txt.Visible = visible
	end

	return txtObj
end

function Window:CreateImageLabel(tbl)
	tbl = tbl or {}
	local imgLblObj = {}
	local imgLbl = TemplateImageLabel:Clone()

	layoutOrderCounter = layoutOrderCounter + 1
	imgLbl.LayoutOrder = layoutOrderCounter
	imgLbl.Image = tbl.Image or ""

	for k, v in pairs(tbl) do
		if k == "Rounded" and v then
			Instance.new("UICorner", imgLbl)
		elseif k == "CornerRadius" then
			local corner = imgLbl:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", imgLbl)
			corner.CornerRadius = v
		elseif k ~= "Position" and k ~= "Size" and k ~= "Image" then
			pcall(function()
				imgLbl[k] = v
			end)
		end
	end

	imgLbl.Parent = Container

	function imgLblObj:GetRaw()
		return imgLbl
	end

	function imgLblObj:SetImage(image)
		imgLbl.Image = image
	end

	function imgLblObj:GetImage()
		return imgLbl.Image
	end

	function imgLblObj:SetVisible(visible)
		imgLbl.Visible = visible
	end

	return imgLblObj
end

function Window:CreateImageButton(tbl)
	tbl = tbl or {}
	local imgBtnObj = {}
	local imgBtn = TemplateImageButton:Clone()

	layoutOrderCounter = layoutOrderCounter + 1
	imgBtn.LayoutOrder = layoutOrderCounter
	imgBtn.Image = tbl.Image or ""

	for k, v in pairs(tbl) do
		if k == "Rounded" and v then
			Instance.new("UICorner", imgBtn)
		elseif k == "CornerRadius" then
			local corner = imgBtn:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", imgBtn)
			corner.CornerRadius = v
		elseif k ~= "Position" and k ~= "Size" and k ~= "Image" and k ~= "Callback" then
			pcall(function()
				imgBtn[k] = v
			end)
		end
	end

	if tbl.Callback then
		imgBtnObj.Connection = imgBtn.MouseButton1Click:Connect(tbl.Callback)
	end

	imgBtn.Parent = Container

	function imgBtnObj:GetRaw()
		return imgBtn
	end

	function imgBtnObj:SetImage(image)
		imgBtn.Image = image
	end

	function imgBtnObj:GetImage()
		return imgBtn.Image
	end

	function imgBtnObj:SetVisible(visible)
		imgBtn.Visible = visible
	end

	function imgBtnObj:SetCallback(callback)
		if self.Connection then
			self.Connection:Disconnect()
		end
		self.Connection = imgBtn.MouseButton1Click:Connect(callback)
	end

	return imgBtnObj
end

function Window:Destroy()
	GUI:Destroy()
end

function Window:SetVisible(visible)
	Frame.Visible = visible
end

function Window:GetVisible()
	return Frame.Visible
end

return Library
