namespace BooSpec
# Represents a match condition which an expression either 
# meets or does not meet 
#
# It should be created with a hash containing at least keys:
# - eval: the block of code to evaluate to determine whether
#         the expression matches, takes the expression's value as input
#         (NOT the SpecExpression)
# - valueText: a string representing the value meaning of this condition, 
#               for example 'equals 3' for a condition that checks for
#               equality with 3.
# Alternatively, instead of 'valueText' you can supply:
# - failure: code to run on failure to derive a failure message,
#            takes the expression's value and the result (true = pass,
#            false = fail) as inputs.  Defaults to 
#            EXPRESSION should (not) VALUETEXT, where the not is
#            dependent on the result
class SpecMatcher: 
	protected _eval as callable;
	protected _valueText as string;
	protected _failure as callable;
	
	def constructor(info as Hash):
		_eval = info['eval']
		_valueText = info['valueText'] as string
		if info['failure']:
			_failure = info['failure']
		else: 
			_failure = { expr, expectedValue, expectedResult |
			notStr = ("" if expectedResult else " not");
			return "$(expr) should$(notStr) $(_valueText) $(expectedValue)"
		}
		
	def evaluate(expr as object, expectedValue) as bool:
		return _eval(expr, expectedValue)	
		
	def failureMessage(expr as object, expectedValue as object, expectedResult as bool) as string:
		return _failure(expr, expectedValue, expectedResult)
