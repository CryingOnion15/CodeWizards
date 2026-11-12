# Resources
- [UUID Generator] ('./id-generator.gd')
- [Pin Rules] ('./pins.md')
- [Parameter Rules] ('./parameters.md)
- [Wand Rules] (./wand.md)


# Entry Panel
Only one of these can exist in a wand and is required for a wand.

## JSON Template
```
{
    "id": "",
    "template": "entry",
    "position": [600, 400],
    "pins": []
}
```

## Action
Once the template is created you need to set and id from the UUIS Generator resource. Then for the pin array you will need to create a variable amount of pins using the Pin Rules resource. We need one Control pin and a pin for each parameter. Wand Rules & Parameter Rules can help guide that.

# Exit Panel
Only one of these can exist in a wand and is required for a wand.

## JSON Template
```
{
    "id": "",
    "template": "exit",
    "position": [1300, 800],
    "pins": []
}
```

## Action
Once the template is created you need to set and id from the UUIS Generator resource. Then for the pin array you will need to create 3 pins using the Pin Rules resource. We need a Control pin, a Number Reciever Pin, and a String Reciever Pin.