
#import <Foundation/Foundation.h>
#import "ASHSystem.h"

@interface ASHSystemList : NSObject
{
    @package
    __strong ASHSystem * head;
    __strong ASHSystem * tail;
}

@property (nonatomic, strong) ASHSystem * head;
@property (nonatomic, strong) ASHSystem * tail;

- (void)addSystem:(ASHSystem *)system;
- (void)removeSystem:(ASHSystem *)system;
- (void)removeAll;
- (ASHSystem *)getSystem:(Class)type;

@end
