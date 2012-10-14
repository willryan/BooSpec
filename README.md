BooSpec
=======

Behavioral testing library for Boo (compatible with the Unity Engine).  Modelled after RSpec.

This is VERY much a work-in-progress.  I might change the syntax to be more stylistically 
Python or Boo like.  I might also rework a great deal of the interior.  I am sure I 
missed important things.  This is just to get the ball rolling so I can develop games 
using behavioral testing with the Unity Engine.

Usage
-----
Note that you MUST use semicolons between lines in callable blocks.

class MyTest(BooSpec):

	def Spec(): // define your spec inside here
		Describe("functional area", {
			Before() {
				doSomeSetup();
				useSemicolonsBetween("Lines");
			}); # don't forget this semicolon
			Describe("subarea", {
				Before() {
					moreSetup();
				});
				It ("tests something", {
					Expr(myObject.SomeFunction(1,2,3)).Should(Equal("hello"));
					Expr(myObject.MakeAnArray("foo", "bar")).Should(Contain("bar"));
				});
				It ("tests another thing", {
					Expr(myObject.Add(2,5)).Should(BeGreaterThan(6))
				});
				After() {
					cleanup();	
				});
			});
		});
