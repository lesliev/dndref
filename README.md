# Dndref

For lack of a better name, this is Dndref, a reference for the 5th edition
Dungeons and Dragons rules, written in Ruby!

### Why do this?

1. The official rules are in English, which is ambiguous and verbose, Ruby is unambiguous and concise.
2. The official rules refer to other rules which refer to other rules, which make them slow to consult
  during gameplay. Ruby methods also refer to other methods but are very quick to traverse if you have a
  decent editor like RubyMine.
3. The 5th edition player's handbook doesn't have an index and information is spread over many locations,
  text search on a computer is instant.

Mostly this is about speed, which is vital if you want your game to flow, particularly when everyone
is first learning the game. Sure, you need to understand Ruby but if you don't, Ruby is easy to learn
and you only need to understand a small subset of the language.


### Why bother with syntax?

Since this is written in Ruby to be read by Humans, why bother with making it actually executable?

If the code doesn't actually run, it can quickly become ambiguous again, since syntax errors have no
well defined meaning. So for this to be as useful as it can be, I want it to actually work as a program.


### This code can be optimised!

Yes, probably, but I am trying to make this as easy for Humans to understand as possible, since
unlike most programs, this code is meant to be executed in people's heads. There's a little meta-programming
but hopefully it's extremely obvious what it's doing. In fact I may remove it because I want Rubymine
to be able to navigate this code without any trouble.


### You've not implemented all the rules!

Indeed it would be a large task to implement all the rules, and I'd rather leave things out than make
them too complicated to be immediately understood - until I find a good way to express them. Also, there
are a lot of spells, I am implementing them as players in my games need them, and I don't have a lot of
time to play.

Please, add rules yourself and send me pull requests, I'd be really grateful! If you don't know
how, just ask and I'll be happy to help.
