# Wire Tools

Adds tools for managing wires:

- *Power grid isolator*: Marks power poles and isolates their power grid by disconnecting all copper wires between poles in the selected area and poles outside of the selected area. Does not disconnect wires connected to power switches. Does not disconnect circuit wires. Default hotkey: *Shift + G*
- *Circuit wire connector*: Marks power poles and connects red circuit wires along their copper wires. Reverse selection (Right-click drag) disconnects circuit wires. Alternative selection (hold Shift) (dis)connects green circuit wires. Default hotkey: *Shift + C*

These tools are also available as shortcuts (the buttons to the right of the quickbar).

**NOTE:** There is no undo for connecting/disconnecting wires, so be careful!

The circuit wire connector tool uses "Reverse select" for disconnecting wires, which by default is bound to Right-click. If you've bound Right-click to something else, you need to bind "Reverse select" to something other than Right-click, for example: Alt + Left-click. Similarly, you need to bind "Alternative reverse select" to something else, like Shift + Alt + Left-click.
