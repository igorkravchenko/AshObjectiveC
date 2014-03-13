
#import <Foundation/Foundation.h>

@protocol ASHComponentProvider <NSObject>

- (id)getComponent;
- (id)identifier;

@end
