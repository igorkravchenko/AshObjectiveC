
#import "NodeListMatcher.h"
#import "ASHNodeList.h"
#import <OCHamcrestIOS/HCDescription.h>

@implementation ASHNodeList (Description)

- (NSString *)description
{
    NSMutableArray * list = [NSMutableArray array];
    
    for (ASHNode * node = self.head; node != nil; node = node.next)
    {
        [list addObject:node];
    }
    
    return [list description];
}
@end

@implementation NodeListMatcher
{
    NSArray * _elementMatchers;
}

+ (HCBaseMatcher *)wrapInEqualToIfNotMatcher:(id)item
{
    return [item isKindOfClass:[HCBaseMatcher class]] ? item : equalTo(item);
;
}

+ (HCBaseMatcher *)nodeList:(id)matcherOrMatchersArray, ...
{
    
    NSMutableArray * matchers = [matcherOrMatchersArray isKindOfClass:[NSArray class]] ?
    [(NSArray *)matcherOrMatchersArray mutableCopy] : [NSMutableArray arrayWithObject:matcherOrMatchersArray];
    
    va_list args;
    va_start(args, matcherOrMatchersArray);
    id matcherItem = nil;
    while((matcherItem = va_arg(args, id)))
    {
        [matchers addObject:matcherItem];
    }
    va_end(args);
    
    NSMutableArray * elementMatchers = [NSMutableArray array];
    
    for (id matcherItem in matchers)
    {
        [elementMatchers addObject:[self wrapInEqualToIfNotMatcher:matcherItem]];
    }
    
    return [[self alloc] initElementMatchers:elementMatchers];
}

- (id)initElementMatchers:(NSArray *)elementMatchers
{
    self = [super init];
    
    if (self != nil)
    {
        _elementMatchers = elementMatchers;
    }
    
    return self;
}

- (BOOL)matches:(id)item
{
    if (![item isKindOfClass:[ASHNodeList class]])
    {
        return NO;
    }
    
    ASHNodeList *  nodes = item;
    NSInteger index = 0;
    for (ASHNode * node = nodes.head; node != nil; node = node.next)
    {
        if (index >= _elementMatchers.count)
        {
            return NO;
        }
        if (![_elementMatchers[index] matches:node])
        {
            return NO;
        }
        ++index;

    }

    return YES;
}



- (void)describeTo:(id<HCDescription>)description
{
    
    [description appendList:_elementMatchers
                      start:@"<(\n\""
                  separator:@"\",\n\""
                        end:@"\"\n)>"];
}

@end
