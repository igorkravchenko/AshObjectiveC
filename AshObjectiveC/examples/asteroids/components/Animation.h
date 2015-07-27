
#import <Foundation/Foundation.h>
#import "Animatable.h"

@interface Animation : NSObject

@property (nonatomic, strong) id <Animatable> animation;

- (instancetype)initWithAnimation:(id <Animatable>)animation;


@end
