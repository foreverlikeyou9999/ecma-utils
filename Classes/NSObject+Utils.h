#import <UIKit/UIKit.h>

void checkNotNil(id value, NSString *message);
void checkNotNull(void *value, NSString *message);
void checkState(BOOL result, NSString *message);
void checkArgument(BOOL result, NSString *message);

@interface NSObject(ArgChecking) 

+ (void)notNull:(id)value message:(NSString*)message;
+ (void)state:(BOOL)result message:(NSString*)message;
+ (void)argument:(BOOL)result message:(NSString*)message;

@end

@interface NSObject (Utils)

-(NSArray*)arrayed;

@end

@interface NSObject (Invocation)

+ (NSInvocation*)invocationForClassMethod:(SEL)selector;
- (NSInvocation*)invocationForMethod:(SEL)selector;

@end

typedef NSObject DebugCheck;
