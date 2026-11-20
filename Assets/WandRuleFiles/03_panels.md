<panel_rules>
# Resources
- See <wand_rules>.

#Rules to follow
- You can add at most 5 constant panels. Duplicates are okay and value selected can depend on wand creator selected.
- The size of the panels matter. You can only add panels to where all of their size is less than or equal the wand size.
- You can add at most 8 panels to the wand when making selections.

# Entry Panel
Only one of these can exist in a wand and is required for a wand.
## JSON
```
{
	"template": "entry",
	"position": [600, 400],
	"size": 0
}
```
## Action
Once the template is created you can add this entry panel to the array of panels.

# Exit Panel
Only one of these can exist in a wand and is required for a wand.
## JSON
```
{
	"template": "exit",
	"position": [1300, 800],
	"size": 0
}
```
## Action
Once the template is created you can add this exit panel to the array of panels.

# Const 0 Panel
A constant panel that define a constant value of 0.
## JSON
```
{
	"template": "const0",
	"position": [x, y],
	"size": 0
}
```
## Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. This panel cannot be nested.

# Const 1 Panel
A constant panel that define a constant value of 1.
## JSON
```
{
	"template": "const1",
	"position": [x, y],
	"size": 0
}
```
## Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. This panel cannot be nested.

# Const 2 Panel
A constant panel that define a constant value of 2.
## JSON
```
{
	"template": "const2",
	"position": [x, y],
	"size": 0
}
```
## Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. This panel cannot be nested.

# Const 3 Panel
A constant panel that define a constant value of 3.
## JSON
```
{
	"template": "const3",
	"position": [x, y],
	"size": 0
}
```
## Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. This panel cannot be nested.

# Const 4 Panel
A constant panel that define a constant value of 4.
## JSON
```
{
	"template": "const4",
	"position": [x, y],
	"size": 0
}
```
## Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. This panel cannot be nested.

# Const 5 Panel
A constant panel that define a constant value of 5.
## JSON
```
{
	"template": "const5",
	"position": [x, y],
	"size": 0
}
```
## Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. This panel cannot be nested.

# Const 6 Panel
A constant panel that define a constant value of 6.
## JSON
```
{
	"template": "const6",
	"position": [x, y],
	"size": 0
}
```
## Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. This panel cannot be nested.

# Const 7 Panel
A constant panel that define a constant value of 7.
## JSON
```
{
	"template": "const7",
	"position": [x, y],
	"size": 0
}
```
## Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. This panel cannot be nested.

# Const 8 Panel
A constant panel that define a constant value of 8.

## JSON
```
{
	"template": "const8",
	"position": [x, y],
	"size": 0
}
```

## Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. This panel cannot be nested.

# Const 9 Panel
A constant panel that define a constant value of 9.

## JSON
```
{
	"template": "const9",
	"position": [x, y],
	"size": 0
}
```

## Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. This panel cannot be nested.

# Const 10 Panel
A constant panel that define a constant value of 10.

## JSON
```
{
	"template": "const10",
	"position": [x, y],
	"size": 0
}
```

## Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. This panel cannot be nested.

# Const 11 Panel
A constant panel that define a constant value of 11.

## JSON
```
{
	"template": "const11",
	"position": [x, y],
	"size": 0
}
```

## Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. This panel cannot be nested.

# Const 12 Panel
A constant panel that define a constant value of 12.
## JSON
```
{
	"template": "const12",
	"position": [x, y],
	"size": 0
}
```
## Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. This panel cannot be nested.

# Const 13 Panel
A constant panel that define a constant value of 0.
## JSON
```
{
	"template": "const13",
	"position": [x, y],
	"size": 0
}
```
## Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. This panel cannot be nested.

# Loop Panel 
A panel that can loop actions of panels that are nested.
## JSON
```
{
	"template": "test_loop",
	"position": [x, y],
	"size": 2
	"nested_panels": []
}
```
##Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. For the nested panel leave empty when other panels are create they may add their JSON. This panel can have a maximum of 3 nested panels.

# Math Panel
A panel that is a basic math function.
## JSON
```
{
	"template": "test_math",
	"position": [x, y],
	"size": 1
}
```
##Actions
Modify the position to be between the positions of the entry and exit panel. Then add this to the array of panels if this panel is selected. This panel can be nest if desired, but only if there is a another panel in the array that have availble space. If this panel is nested add to the nested_panel array of that panel rather than the wand panel array.
</panel_rules>
