
#import <Foundation/Foundation.h>

@interface Display : NSObject

@property (nonatomic, strong) UIView * displayObject;

- (instancetype)initWithDisplayObject:(UIView *)displayObject;

@end
