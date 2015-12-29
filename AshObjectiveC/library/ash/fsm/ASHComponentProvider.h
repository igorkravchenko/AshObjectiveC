
#import <Foundation/Foundation.h>

@protocol ASHComponentProvider <NSObject>

- (__nonnull id)getComponent;
- (__nonnull id)identifier;

@end
