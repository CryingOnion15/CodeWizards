# Resources
- [UUID Generator] ('./id-generator.gd')
- [Pin Rules] ('./pins.md')

# JSON Output
JSON Template for Pin Connections.

```
{
    "owner": string,
    "connector": string,
    "hardcoded": boolean
}
```

# Actions
A pin connection is just a connection relation ship between two pins. A control pin can never have more than one connections, but number and string can have many where it makes sense. A connections always goes from a Connector Pin the "owner" (string UUID) to the Reciever Pin the "connector" (string UUID). If a connection is made between two hardcoded pins than this connection is hardcoded.