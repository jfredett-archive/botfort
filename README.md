#botfort
## a cheap clone of dwarf fortress, with a unique-ish interface

The primary interface to botfort is the commandline. A simple RPN (FORTH-like) 
language allows you to control many bots in the world. These bots can perform 
various tasks, which you may designate -- also through the language.

The intent is for the aspiring player to learn a meta-language and issue commands
to Botfort through it -- perhaps even writing a DSL which 'compiles' to the 
Botfort language. 

## rules (for development)

- Each commit must run the `rake` command clean -- all passing. Starting at the v0.0.0 tag onward.
  (that is, all commits except this one must pass `rake` clean)

- Each commit must add tests for new features

- Only comment if something is confusing

- Think like an object

- It's "Red, Green, Refactor" -- not "Red, Green, I'll do it later"

- Excepting the first, occasionally break the rules if it would be funny to do so.


### obsolete rules

- Each commit must represent the addition of exactly one feature with (at least)
  exactly one corresponding test.

Turns out this is pretty hard. When I started this experiment, it was easy to
isolate the small chunks of functionality. However, as you start extracting
concerns that operate on multiple levels (like Agent/Action) of the class
heirarchy, it gets hard to only add a few tests at a time. Notably, some commits
are refactoring commits, others only add tests, some only remove tests. 

I also started committing pending tests in feature branches -- this was a
descision not lightly made. In particular, I decided the rule should be "no
pending tests in origin/master." Keeping unimplemented tests helps to direct my
efforts to the final objective.

