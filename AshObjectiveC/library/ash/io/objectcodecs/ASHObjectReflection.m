
#import <objc/runtime.h>
#import "ASHObjectReflection.h"
#import "ASHMacro.h"
#import "ASHTypeAssociations.h"

@implementation ASHObjectReflection
{

}

- (id)initWithComponent:(NSObject *)component
{
    self = [super init];

    if (self)
    {
        _type = NSStringFromClass(component.class);
        u_int count;
        objc_property_t * properties = class_copyPropertyList(component.class, &count);
        NSMutableDictionary * propertyTypes = [NSMutableDictionary dictionary] ;
        for (NSUInteger i = 0; i < count; i++)
        {
            unsigned int numOfAttributes;
            objc_property_attribute_t *propertyAttributes = property_copyAttributeList(properties[i], &numOfAttributes);

            BOOL skip = NO;

            for (unsigned int j = 0; j < numOfAttributes; j++)
            {
                if(propertyAttributes[j].name[0] == 'R') // property is readonly, skip it
                {
                    skip = YES;
                    break;
                }
            }

            free(propertyAttributes);

            if(skip)
            {
                continue;
            }

            const char * propType = property_getTypeString(properties[i]);
            NSString * propertyName = [NSString stringWithCString:property_getName(properties[i])
                                                         encoding:NSUTF8StringEncoding];
            NSString * propertyTypeString;

            id v = [component valueForKey:propertyName];
            if(v)
            {
                propertyTypeString = [[ASHTypeAssociations instance] associationForType:[v class]];
            }
            else
            {
                propertyTypeString =
                [[[NSString stringWithCString:propType
                                     encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\""
                                                                                              withString:@""] stringByReplacingOccurrencesOfString:@"T@"
                                                                                                                                        withString:@""];

            }

            if(propertyTypeString == nil)
            {
                propertyTypeString = NSStringFromClass([NSNull class]);
            }
            else
            {
                if([propertyTypeString isEqual:@"T#"])
                {
                    propertyTypeString = @"ASHClass";
                }
            }

            propertyTypes[propertyName] = propertyTypeString;
        }
        _propertyTypes = propertyTypes;
        free(properties);
    }

    return self;
}


@end