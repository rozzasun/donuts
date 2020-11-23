# Donuts

Word search game written in Swift.

### Features
#### Randomized grid
- word generator fetches words via an async GET request, and generates `n` words in the specified range
- words are placed in random positions and directions in a 2D array
<img src="https://github.com/rozzasun/donuts/blob/master/img/randomGrid.gif" width="200" />

#### Drag Select Generates Closest Linear Line
- the algorithm is optmized to check a maximum of 3/8 directions, and uses the pythagorean theorem on each to determine the line closest to the drag position
<img src="https://github.com/rozzasun/donuts/blob/master/img/select.gif" width="200" />

#### Status Bar
- status bar tracks the number of words found and the current selection, achieved using SwiftUI states
<img src="https://github.com/rozzasun/donuts/blob/master/img/win.gif" width="200" />
