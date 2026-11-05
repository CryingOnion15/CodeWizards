# Resources
- [UUID Generator] ('./id-generator.gd')
- [Connection Rules] ('./connections.md')
- [Panel Rules] ('./panels.md')
- [Parameter Rules] ('./parameters.md)
- [Wand Rules] (./wand.md)

# JSON Output
For pin this is the JSON template

```
{
    "id": string,
    "connections": Array,
    "connectedTo": string,
    "value": string,
    "isHardcoded": boolean,
    "defaultValue": default_value,
    "isLocked": boolean,
    "isNested": boolean,
}
```

# Rules

## Pin Types
Pins can be one of two pin types.
- Connector: Where they can make connections to other pins.
- Reciever: Where they can be connected to from other pins.

## Data Types
Pins can be one of three data types.
- Control: Type of pins used the function/next step controls. It is how panels know which order to execute.
- Number: Type of the pin that either outputs or inputs a number value. (Base on Pin Type)
- String: Type of pin that either outputs or inputs a string value. (Based on Pin Type)


# Actions
- For ID use the UUID Generator resources to set a unique id.
- Connections is an array of connection data which can be found in the Connection Rules resource. Connections can only be made from type to type so also look to the Panel Rules resource to see what panels has which pins. (Only used when a pin is a Connector type.)
- connectionTo is a id reference to the Pin that this connection is made to. (Only used when a pin is a Reciever Type)
- value is a string with a specific structure. This is use to call a function on an id for a value later. The required format is id:function_name_to_call. ID will either be a pin id or a code panel id. Specific on the pin value can be found on the panel definitions. Only Connector pins have a true value string Reciever pins if they are connected use the pin they are connected to value so it can be left empty.
- Default value can be used for Reciever pins to have a value when a connection is not made. They do not require a value, but can have one. For Integers the value can be 0-13 and for string has to be be and output type. Control pins never have a default value.
- isHardcoded is for pins that are not able to be set to a new value. For control pins the use case would be if there is a forced connection that cannot be broken. For number and string value pins it requires them to have a default value or a hardcoded connection.
- isLocked is for pins that cannot have their connections change because they are affected by something else. Currently that is only applies to pins that apart of a panel that nests or panels that get nested. Those connections are fixed and are managed by the panel rather than the user. Probably don't need to worry about this one the nesting process should handle it.
- isNested for when a pin is nested internally in a panel. This will be specified in the Panel Rules and only apply to panels that allow panels to be nested inside themselves. default is false unless specified by a panel.