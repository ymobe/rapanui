Lunatest is an xUnit-style, Lua-based unit testing framework with
additional support for randomized testing (a la QuickCheck).

It's largely upwardly compatible from [lunit][], with the following changes:

* Where lunit uses assert(), lunatest uses assert_true(). lunatest does
  not change any functions from the standard library.
* If running tests in only one file, no module declaration is necessary.
* For multiple suites, register them with lunatest.suite("file").
  This uses require to load the suite, and uses the same methods to
  match filenames with modules.
* It doesn't have any dependencies except Lua, though if present, it
  will use lhf's [lrandom][] module (for consistent pseudorandom numbers
  across operating systems) and [luasocket][]'s gettime() for timestamps).

The main (or only) test file should end in lunatest.run(), and can be
run as a normal lua script. The following command-line arguments are
supported:

* -v: verbose mode, which lists every test's name, result, and runtime.
* -s / --suite *pattern*: Only run suite(s) with names matching the pattern.
* -t / --test *pattern*: Only run test(s) with names matching the pattern.

[lunit]: http://www.nessie.de/mroth/lunit/
[lrandom]: http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/#lrandom
[luasocket]: http://luaforge.net/projects/luasocket/

For further examples, see the API documentation and included test suite.
