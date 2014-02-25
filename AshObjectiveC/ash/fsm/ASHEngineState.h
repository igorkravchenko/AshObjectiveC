
#import <Foundation/Foundation.h>

@class ASHStateSystemMapping;
@class ASHSystem;
@protocol ASHSystemProvider;

@interface ASHEngineState : NSObject

@property (nonatomic, readonly) NSMutableArray * providers;

- (ASHStateSystemMapping *)addInstance:(ASHSystem *)system;
- (ASHStateSystemMapping *)addSingleton:(Class)aClass;
- (ASHStateSystemMapping *)addMethod:(id)target
                              action:(SEL)action;
- (ASHStateSystemMapping *)addProvider:(id <ASHSystemProvider>)provider;

@end