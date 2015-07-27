
#import <Foundation/Foundation.h>

@interface Position : NSObject

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) float rotation;

- (instancetype)initWithX:(float)x
                        y:(float)y
                 rotation:(float)rotation;


@end
