My solutions for the "advent of code" event for the year 2017.
See <https://adventofcode.com/>.

## Running

All solution files are executable. They take as input the puzzle input and
outputs the solution.

The `makesolution.sh` script facilitates running the solutions with the
advent input. It takes as input the day and number of the challenge, and
pipes the clipboard content into the relevent executable file. `xsel` is
required for that.

For rust solutions, you can compile into a properly placed executable file
using `makerust.sh`.

## Requirements

* `xsel` if you want to use `makesolution.sh`.

* `rustc` for compilling rust files

* The Glorious Glasgow Haskell Compilation System for running the haskell
  files. (ideally with `runghc` installed so the source files can be ran
  directly)

## Schedules

I'll post my solution one day after the challenge is posted. Exceptionally,
if the circumstances offer themselves, I may post them earlier.

## License

Fucking hell, not everything need a license.
