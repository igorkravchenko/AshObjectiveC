
#import <Foundation/Foundation.h>

@interface GameState : NSObject

@property (nonatomic, assign) NSInteger lives;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger hits;
@property (nonatomic, assign) BOOL playing;

- (void)setForStart;

@end
