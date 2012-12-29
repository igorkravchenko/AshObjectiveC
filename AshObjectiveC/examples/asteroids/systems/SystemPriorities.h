
#ifndef Ash_SystemPriorities_h
#define Ash_SystemPriorities_h

typedef enum
{
    preUpdate = 1,
    update,
    move,
    resolveCollisions,
    stateMachines,
    animate,
    render
}
SystemPriorities;

#endif
