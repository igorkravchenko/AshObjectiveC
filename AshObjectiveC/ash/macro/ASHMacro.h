
#ifndef AshObjectiveC_ASHMacro_h
#define AshObjectiveC_ASHMacro_h
#import <objc/runtime.h>

static inline const char * property_getTypeString( objc_property_t property )
{
    const char * attrs = property_getAttributes( property );
    if ( attrs == NULL )
        return ( NULL );

    static char buffer[256];
    const char * e = strchr( attrs, ',' );
    if ( e == NULL )
        return ( NULL );

    int len = (int)(e - attrs);
    memcpy( buffer, attrs, len );
    buffer[len] = '\0';

    return ( buffer );
}

#endif
