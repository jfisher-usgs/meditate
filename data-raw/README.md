# Internal Dataset

Audio recordings of (1) a Tibetan singing bowl struck once with a wooden mallet, and (2) a calling bell in Daitokuji temple, Kyoto.

## Usage

`meditate:::sounds`

## Format

A list object with components of class `audio::audioSample`.

## Source

*bowl-struck.wav* file accessed on December 2, 2019 at https://freesound.org/s/2166/ and released under the Creative Commons [Sampling Plus 1.0](https://creativecommons.org/licenses/sampling+/1.0/) license.

*bell-kyoto.wav* file accessed on December 3, 2019 at https://freesound.org/s/131348/ and released under the Creative Commons [CC0 1.0 Universal](https://creativecommons.org/licenses/by-nc/3.0/) license.

## Examples

```r
audio::play(meditate:::sounds[["bowl struck"]])
audio::play(meditate:::sounds[["bell kyoto"]])
```
