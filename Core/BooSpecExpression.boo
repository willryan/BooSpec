# Class which represents an expression, or really just a value.  It supports
# functions Should and ShouldNot, which evaluate if a condition is met, and
# raises an error if expectations are not met

# TODO - should you be able to pass in a callable as expression, 
# to evaluate only on check?
class BooSpecExpression: 
	protected _expression as object

	def constructor(expression as object):
		_expression = expression
		
	def Should(cond as BooSpecCondition):
		condShould(cond, true)
		
	def ShouldNot(cond as BooSpecCondition):
		condShould(cond, false)
			
	private def condShould(cond as BooSpecCondition, expected as bool):
		if cond.evaluate(_expression) != expected:
			raise cond.failureMessage(_expression, expected)
		