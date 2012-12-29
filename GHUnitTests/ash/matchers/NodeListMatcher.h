
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
@interface NodeListMatcher : HCBaseMatcher

+ (HCBaseMatcher *)nodeList:(id)matcherOrMatchersArray, ... NS_REQUIRES_NIL_TERMINATION;

@end
