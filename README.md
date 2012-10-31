BooSpec
=======

Behavioral testing library for Boo (compatible with the Unity Engine).  Modelled after RSpec.
However I chose to use Jasmine-style Expect(<expression>) because that was easier to write. :)

This is VERY much a work-in-progress.  I might change the syntax to be more stylistically 
Python or Boo like.  I might also rework a great deal of the interior.  I am sure I 
missed important things.  This is just to get the ball rolling so I can develop games 
using behavioral testing with the Unity Engine.

Usage
-----
class MyTest(BooSpec):

	def Spec(): // define your spec inside here
		Describe("functional area") do:
			Before() do:
				doSomeSetup()

			Describe("subarea") do:
				Before() do:
					moreSetup()

				It ("tests something") do:
					Expect(myObject.SomeFunction(1,2,3)).ToEqual("hello")
					Expect(myObject.MakeAnArray("foo", "bar")).ToContain("bar")

				It ("tests another thing") do:
					Expect(myObject.Add(2,5)).ToBeGreaterThan(6)

				After() do:
					cleanup()

Once you compile your tests against BooSpec (ideally with BooSpec.dll), you can then run them using booi Exec/BooSpecMain.boo.
If you look at the code there, you can probably figure out how to create custom loggers (which are supported with the command-line
option -f:<formatter_name>).  At the moment 'dots' is the default, and 'detailed' is also included.
