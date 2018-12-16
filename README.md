# taco_party

A hypnotic cascade of images. Good for all occasions.

This began as a quick and dirty contribution to a taco-themed birthday party (hence the name). It's grown a bit since then.

## Upcoming 3.0.0 Featurelist

### Sprite Sets
- Save and load sprite sets with local storage
- Import external sprite set repositories

### Internal Improvements
- Remove sprite set classes
  - The original intent with those was for if I wanted to do some sort of configurable generation.
    However, after this long, `pokemon` is still the only sprite set any kind of generation makes sense for.
    So the plan is to generate that one into a `general`-style JSON file and then remove the `class` field entirely.
  - Keep supporting legacy files tho... for at least a while (it isn't that hard anyway)
- Host the official sprite set repository separately to make changes/additions easier
  - ... just make another GitHub repository and Pages it.

### Crazy Ideas
- Automatically cache sprite set repositories via a ServiceWorker
- Remake with AngularDart

## Possible future goals
- Game modes
  - Bullet hell
  - Space Invaders
