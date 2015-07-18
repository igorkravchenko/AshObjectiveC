
#import <Foundation/Foundation.h>

@interface ASHListenerNode : NSObject
{
    @package
    __weak ASHListenerNode * previous;
    __strong ASHListenerNode * next;
    SEL listener;
    __weak id target;
    BOOL once;
}

@end
