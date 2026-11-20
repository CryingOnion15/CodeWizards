<wand_rules>
# Getting Started
Wands consist of Panels and connection to form relationships to one another that result in an output. You will always have to panel in a wand the entry panel and the exit panel in the panel array. These are required and must be generated when creating a wand.

## JSON Template
Follow this template you cannot change the names of the fields and the resources must be followed exactly.

```
{
	"parameters": {},
	"variables": {},
	"size": number,
	"panels": [],
	"connections": [],
}
```
For "parameters" follow Parameter Rules resource.
For "varaibles" follow Variable Rules resource.
For "size" this can be 6,8,10,12, or 16. Not other value should be here.
For "panels" use the wand creator personality and the list of panels to create a array of panel objects. Specifics can be found in the panels.md file.
Ignore connections for now.

## Resources
- See <panel_rules>.
- See <connection_rules>.
- See <pin_rules>.
- See <parameter_rules>.
- See <variable_rules>.
- See <wand_creator_rules>.

# Steps

## Step 1 Start with the JSON template.
## Step 2 Create 0-3 parameter using Parameter Rules. Then modify the the template.
## Step 3 Create 0-3 variables using Variable Rules. Then modify the the template.
## Step 4 Create Entry & Exit Panels based on the panel rules. Then modify the the template.
## Step 5 Select panels (panels.md) based on the chosen wand creator. Then modify the the template.
## Step 8 Output final wand JSON.

## Final Wand JSON EXAMPLE
This example can be follow on what the final result might look like.
```
{
	"parameters": {
		"Param1": 4
		"Param2": 6
		"Type": "Poison"
	},
	"variables": {
		"Var 1": 20
	},
	"size": 10,
	"panels": [
		{
			"template": "entry",
			"position": [600, 400],
			"size": 0
		},
		{
			"template": "exit",
			"position": [600, 400],
			"size": 0
		},
		{
			"template": "const2",
			"position": [602, 780],
			"size": 0
		},
		{
			"template": "test_loop",
			"position": [x, y],
			"size": 2
			"nested_panels": [
				{
					"template": "test_math",
					"position": [x, y],
					"size": 1
				},
			]
		},
	],
	"connections": [],
}
```
</wand_rules>
