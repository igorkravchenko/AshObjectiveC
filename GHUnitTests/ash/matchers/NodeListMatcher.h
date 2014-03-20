
@interface NodeListMatcher : HCBaseMatcher

+ (HCBaseMatcher *)nodeList:(id)matcherOrMatchersArray, ... NS_REQUIRES_NIL_TERMINATION;

@end
