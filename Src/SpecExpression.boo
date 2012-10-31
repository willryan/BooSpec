namespace BooSpec

# Class which represents an expression, or really just a value.  It supports
# functions To<matcherName> and NotTo<matcherName>, which evaluate if a condition is met, and
# raises an error if expectations are not met

# TODO - should you be able to pass in a callable as expression, 
# to evaluate only on check?
class SpecExpression(IQuackFu): 
	protected _expression as object

	def QuackInvoke(name as string, params as (object)) as object:
    r = /^(?<notCond>Not)?To(?<matcher>\w+)$/.Match(name)
    matcherString = r.Groups["matcher"].Value
    expected = (r.Groups["notCond"].Value == "")
    if matcherString != null:
      matcher = SpecMatchers.Get(matcherString)
      if matcher != null:
        param = null
        if params.Length > 0:
          param = params[0]
        checkMatch(matcher, param, expected)
        return
    raise "matcher $(name) not recognized"

	def QuackGet(name as string, params as (object)) as object:
		pass
		
	def QuackSet(name as string, params as (object), obj) as object:
		pass

	def constructor(expression as object):
		_expression = expression
			
	private def checkMatch(matcher as SpecMatcher, expectedValue as object, expectedResult as bool):
		if matcher.evaluate(_expression, expectedValue) != expectedResult:
			raise matcher.failureMessage(_expression, expectedValue, expectedResult)
		
