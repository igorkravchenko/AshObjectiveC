
#import <Foundation/Foundation.h>

@class WaitForStartView;

@interface WaitForStart : NSObject

@property (nonatomic, strong) WaitForStartView * waitForStart;
@property (nonatomic, assign) BOOL startGame;

- (instancetype)initWithWaitForStart:(WaitForStartView *)waitForStart;

@end