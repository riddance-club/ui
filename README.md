riddance's shitty ui library, base was made quickly in like 1 day for fun with the help of slop code. it is extremely customisable due to it being extremely simple ui and letting you edit the raw properties themselves. you can use this in your games if you want to make a menu for admin or similiar.

simple quick documentation of current api:
# Library
```lua
function Library:CreateWindow(tbl) 
({ 
  Title = "Main Control Panel",
  DraggingState = true, 
  Rounded = true, 
  CornerRadius = UDim.new(0, 8),
  BackgroundColor3 = Color3.fromRGB(35, 35, 35), 
  BorderSizePixel = 0, 
  Position = UDim2.new(0.35, 0, 0.35, 0), 
  Size = UDim2.new(0.5, 0, 0.5, 0) 
}) -> Window

function Library:SetUIParent(parent) (game:GetService("StarterGui")) -> nil

function Library:Notification(tbl) ({ Title = "Status", Text = "Succeeded." }) -> nil
function Library:Message(tbl) ({ Text = "Shutting down...", Duration = 5 }) -> nil
function Library:Hint(tbl) ({ Text = "Hold shift to sprint.", Duration = 4 }) -> nil

function Library:GetRawAll() () -> ScreenGui, Frame, TextLabel, ...
```
# Window
```lua
function Window:GetRaw() () -> Frame

function Window:SetProperty(property, data) ("BackgroundColor3", Color3.fromRGB(45, 45, 45)) -> nil
function Window:GetProperty(property) ("BackgroundColor3") -> any

function Window:SetCellSize(cellSize) (UDim2.new(0, 110, 0, 30)) -> nil
function Window:SetCellPadding(cellPadding) (UDim2.new(0, 5, 0, 5)) -> nil

function Window:SetTitle(text) ("Updated Control Console") -> nil
function Window:GetTitle() () -> string
function Window:SetDraggingState(state) (false) -> nil
function Window:GetDraggingState() () -> boolean
function Window:EditResizeCorner(tbl) ({ Symbol = "⤡", Size = UDim2.new(0, 25, 0, 25) }) -> nil

function Window:CreateLabel(tbl) ({ Text = "Stats", Rounded = true }) -> Label Element
function Window:CreateButton(tbl) ({ Text = "Teleport", Callback = function() end }) -> Button Element
function Window:CreateToggle(tbl) ({ Text = "Toggle", Callback = function(state) end }) -> Toggle Element
function Window:CreateKeybind(tbl) ({ Text = "Bind", Default = Enum.KeyCode.RightShift }) -> Keybind Element
function Window:CreateTextBox(tbl) ({ Placeholder = "Value...", Default = "16" }) -> TextBox Element
function Window:CreateImageLabel(tbl) ({ Image = "rbxassetid://..." }) -> ImageLabel Element
function Window:CreateImageButton(tbl) ({ Image = "rbxassetid://...", Callback = function() end }) -> ImageButton Element

function Window:Destroy() () -> nil
function Window:SetVisible(visible) (false) -> nil
function Window:GetVisible() () -> boolean
```
# Label
```lua
function LabelElement:GetRaw() () -> TextLabel
function LabelElement:SetText(text) ("New text") -> nil
function LabelElement:GetText() () -> string
function LabelElement:SetVisible(visible) (false) -> nil
```
# Button
```lua
function ButtonElement:GetRaw() () -> TextButton
function ButtonElement:SetText(text) ("Click here") -> nil
function ButtonElement:GetText() () -> string
function ButtonElement:SetVisible(visible) (true) -> nil
function ButtonElement:SetCallback(callback) (function() end) -> nil
```
# Toggle
```lua
function ToggleElement:GetRaw() () -> TextButton
function ToggleElement:SetState(newState) (true) -> nil
function ToggleElement:GetState() () -> boolean
function ToggleElement:SetText(newText) ("Label") -> nil
function ToggleElement:SetVisible(visible) (false) -> nil
```
# Keybind
```lua
function KeybindElement:GetRaw() () -> TextButton
function KeybindElement:SetKey(keyCode) (Enum.KeyCode.Q) -> nil
function KeybindElement:GetKey() () -> Enum.KeyCode
function KeybindElement:SetText(text) ("Bind Label") -> nil
function KeybindElement:SetVisible(visible) (true) -> nil
```
# TextBox
```lua
function TextBoxElement:GetRaw() () -> TextBox
function TextBoxElement:SetText(text) ("New value") -> nil
function TextBoxElement:GetText() () -> string
function TextBoxElement:Clear() () -> nil
function TextBoxElement:SetVisible(visible) (false) -> nil
```
# Images
```lua
function ImageLabelElement:GetRaw() () -> ImageLabel
function ImageLabelElement:SetImage(image) ("rbxassetid://...") -> nil
function ImageLabelElement:GetImage() () -> string
function ImageLabelElement:SetVisible(visible) (true) -> nil

function ImageButtonElement:GetRaw() () -> ImageButton
function ImageButtonElement:SetImage(image) ("rbxassetid://...") -> nil
function ImageButtonElement:GetImage() () -> string
function ImageButtonElement:SetVisible(visible) (false) -> nil
function ImageButtonElement:SetCallback(callback) (function() end) -> nil
```
