# SubtitleTimeShifter

Many times we download a film and later find out that the audio is a language other than english.

No need to despair, you say to yourself. You google a bit for the subtitles file of the film. You soon find it but hit another hiccup.

You soon notice that the audio and the subtitle are not in sync. You pay attention to when a sentence is spoken by a character and when the subtitle text for that sentence appears.

You find out it is seven seconds out of sync. Aaaah! Too bad you can't modify the subtitle file "times" for the entire film.

That's where this program comes in. It can shift the "times" in a subtitle file by a specified number of seconds and generates a new subtitle file with the new times.

### How to run
```terminal
mix deps.get
mix compile
iex -S mix
SubtitleTimeShifter.shift_time
```
