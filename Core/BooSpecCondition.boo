# Represents a condition which an expression either 
# meets or does not meet 
#
# It should be created with a hash containing at least keys:
# - eval: the block of code to evaluate to determine whether
#         the expression matches, takes the expression's value as input
#         (NOT the BooSpecExpression)
# - valueText: a string representing the value meaning of this condition, 
#               for example 'equals 3' for a condition that checks for
#               equality with 3.
# Alternatively, instead of 'valueText' you can supply:
# - failure: code to run on failure to derive a failure message,
#            takes the expression's value and the result (true = pass,
#            false = fail) as inputs.  Defaults to 
#            EXPRESSION should (not) VALUETEXT, where the not is
#            dependent on the result
class BooSpecCondition: 
	protected _eval as callable;
	protected _valueText as string;
	protected _failure as callable;
	
	def constructor(info as Hash):
		_eval = info['eval']
		_valueText = info['valueText'] as string
		if info['failure']:
			_failure = info['failure']
		else: 
			_failure = { expr, expected |
			notStr = ("" if expected else " not");
			return "$(expr) should$(notStr) $(_valueText)"
		}
		
	def evaluate(expr as object) as bool:
		return _eval(expr)	
		
	def failureMessage(expr as object, expected as bool) as string:
		return _failure(expr, expected)
