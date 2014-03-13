
#import <Foundation/Foundation.h>

@interface MockRectangle : NSObject

@property (nonatomic, readwrite) CGFloat x;
@property (nonatomic, readwrite) CGFloat y;
@property (nonatomic, readwrite) CGFloat width;
@property (nonatomic, readwrite) CGFloat height;

- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

+ (instancetype)rectangleWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;


@end