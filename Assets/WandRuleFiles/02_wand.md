# Getting Started
Wands consist of Panels and connection to form relationships to one another that result in an output. You will always have to panel in a wand the entry panel and the exit panel. These are required and must be generated when creating a wand.

## JSON Template
Follow this template you cannot change the names of the fields and the resources must be followed exactly.

```
{
    "id": id,
    "parameters": {},
    "variables": {},
    "entry_panel": {},
    "exit_panel": {},
    "panels": [],
}
```

An "id" can be generated with the UUID Generator Resource. "entry_panel" and "exit_panel" are a json object for an entry and exit panel. And "panels" is an array of any other panels in that are in the wand. Panel Rules should be use for the JSON templates for panels.

For "parameters" follow Parameter Rules resource.
For "varaibles" follow Variable Rules resource.

## Resources
- [UUID Generator] ('./id-generator.md')
- [Panel Rules] ('./panels.md')
- [Connection Rules] (./connections.md)
- [Pin Rules] ('./pins.md')
- [Parameter Rules] ('./parameters.md')
- [Variable Rules] ('./variables.md')
- [Wand Creator Outlines] ('./wand-creator.md')

# Steps

## Step 1 Start with the JSON template.
## Step 2 Generate an ID.
## Step 3 Create 0-3 parameter using Parameter Rules.
## Step 4 Create 0-3 variables using Variable Rules.
## Step 5 Create Entry & Exit Panels.
## Step 6 Create Additional Panels based on the chosen wand creator.
## Step 7 Create Connections between all panels in the wand using Connection Rules.
## Step 8 Output final wand JSON.