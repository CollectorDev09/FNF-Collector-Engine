# Friday Night Funkin - Collector Engine

Hey there! Thanks for checking out this FNF Engine! This is just a little project I'm working on to hopefully improve my programming skills. It's really early in development, so there's going to be MANY changes later on.

Support the base game on the itch.io page: https://ninja-muffin24.itch.io/funkin

## Credits / shoutouts

- [ninjamuffin99 (me!)](https://twitter.com/ninja_muffin99) - Programmer
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) and [Evilsk8r](https://twitter.com/evilsk8r) - Art
- [Kawaisprite](https://twitter.com/kawaisprite) - Musician

This game was made with love to Newgrounds and it's community. Extra love to Tom Fulp.

If you want to figure out how to compile and mod this engine, go <a href="docs\main.md">here.</a>

### Ignored files

I gitignore the API keys for the game, so that no one can nab them and post fake highscores on the leaderboards. But because of that the game
doesn't compile without it.

Just make a file in `/source` and call it `APIStuff.hx`, and copy paste this into it

```haxe
package;

class APIStuff
{
	public static var API:String = "";
	public static var EncKey:String = "";
}

```

and you should be good to go there.

### Additional guides

- [Command line basics](https://ninjamuffin99.newgrounds.com/news/post/1090480)
