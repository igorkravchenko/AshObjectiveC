
#import "ASHSignalBase.h"

@interface ASHSignalAny : ASHSignalBase

- (void)dispatchWithObjects:(id)object, ... NS_REQUIRES_NIL_TERMINATION;

@end
