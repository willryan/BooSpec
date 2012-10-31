namespace BooSpec

class SpecMatchers:

  _matchers as Hash

  static _singleton as SpecMatchers

  static def Singleton() as SpecMatchers:
    if _singleton == null:
      _singleton = SpecMatchers()
    return _singleton

  static def Get(matcherName as string) as SpecMatcher:
    return Singleton().GetMatcher(matcherName)

  static def Set(matcherName as string, matcher as SpecMatcher):
    Singleton().SetMatcher(matcherName, matcher)

  def GetMatcher(matcherName as string) as SpecMatcher:
    return _matchers[matcherName] as SpecMatcher

  def SetMatcher(matcherName as string, matcher as SpecMatcher):
    _matchers[matcherName] = matcher

  def constructor():
    _matchers = {}
    SetDefaultMatchers()

  def SetDefaultMatchers():
    SetMatcher("Equal", SpecMatcher({'eval': { check, expectedValue | 
        return check == expectedValue;
        }, 'valueText': "equal"}))
      
    SetMatcher("BeGreaterThan", SpecMatcher({'eval': { check, expectedValue |
        return check cast double > expectedValue cast double;
      }, 'valueText': "greater than"}))	
      
    SetMatcher("BeGreaterThanOrEqualTo", SpecMatcher({'eval': { check, expectedValue |
        return check cast double >= expectedValue cast double;
      }, 'valueText': "greater than or equal to"}))
      
    SetMatcher("BeLessThan", SpecMatcher({'eval': { check, expectedValue |
        return check cast double < expectedValue cast double;
      }, 'valueText': "less than"}))
      
    SetMatcher("BeLessThanOrEqualTo", SpecMatcher({'eval': { check, expectedValue |
        return check cast double <= expectedValue cast double;
      }, 'valueText': "less than or equal to"}))
      
    SetMatcher("Contain", SpecMatcher({'eval': { check, expectedValue |
        arr = check as List;
        return arr.Contains(expectedValue);
      }, 'valueText': "contain"}))

    SetMatcher("BeTrue", SpecMatcher({'eval': { check, expectedValue |
        return check cast bool;
      }, 'valueText': 'be true'}))

    SetMatcher("BeFalse", SpecMatcher({'eval': { check, expectedValue |
        return (not check) cast bool;
      }, 'valueText': 'be false'}))
