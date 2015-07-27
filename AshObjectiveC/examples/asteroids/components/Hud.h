
#import <Foundation/Foundation.h>

@class HudView;

@interface Hud : NSObject

@property (nonatomic, strong) HudView * view;

- (instancetype)initWithView:(HudView *)view;


@end