#import "KeyboardAvoider.h"
#import "UIApplication+Utils.h"

@implementation KeyboardAvoider

-(void)privateInit{
	NSNotificationCenter *notifications = [NSNotificationCenter defaultCenter];
	[notifications addObserver:self selector:@selector(kbdWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[notifications addObserver:self selector:@selector(editingStarted:) name:UITextFieldTextDidBeginEditingNotification object:nil];
	[notifications addObserver:self selector:@selector(editingFinished:) name:UITextFieldTextDidEndEditingNotification object:nil];		
}

-(void)awakeFromNib{
	[super awakeFromNib];
	[self privateInit];
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self privateInit];
    }
    return self;
}


- (void)dealloc {
	NSNotificationCenter *notifications = [NSNotificationCenter defaultCenter];
	[notifications removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[notifications removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
	[notifications removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];	
	
    [super dealloc];
}

#pragma mark private

-(void)resetScroll{
	[self setContentOffset:CGPointZero animated: YES];	
}

-(void)scrollToField: (UIView*)focusedTextField{
	if(![focusedTextField isDescendantOfView:self])
		return;
	
	UIView* main = [UIApplication mainView];
	
	CGRect scrollRectAbsolute = [self.superview convertRect:self.frame toView:main];
	float freeAreaTop = CGRectGetMinY(scrollRectAbsolute);
	float freeAreaBottom = CGRectGetMinY(keyboardFrame);
	float freeAreaCenter = (freeAreaTop + freeAreaBottom)/2;
	CGRect fieldRectAbsolute = [[UIApplication mainView] convertRect: focusedTextField.bounds fromView: focusedTextField];
	float delta = freeAreaCenter - CGRectGetMidY(fieldRectAbsolute);
	float offset = self.contentOffset.y - delta;		
	
	[self setContentOffset: CGPointMake(0, offset) animated:YES];
}

-(CGRect)extractKeyboardFrameFromNotification: (NSNotification*)notification{
	NSDictionary *userInfo = notification.userInfo;
	NSValue *kbdBoundsValue = [userInfo objectForKey:UIKeyboardBoundsUserInfoKey];
	CGRect kbdBounds;
	[kbdBoundsValue getValue:&kbdBounds];
	NSValue *kbdEndCenterValue = [userInfo objectForKey:UIKeyboardCenterEndUserInfoKey];
	CGPoint kbdCenter;
	[kbdEndCenterValue getValue:&kbdCenter];
	
	CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
	if(![UIApplication sharedApplication].statusBarHidden) {
		if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)){
			kbdCenter = CGPointMake(kbdCenter.x, kbdCenter.y - CGRectGetHeight(statusBarFrame));
		} else {
			kbdCenter = CGPointMake(kbdCenter.x, kbdCenter.y - CGRectGetWidth(statusBarFrame));
		}
	}
	
	CGRect kbdAppFrame = CGRectOffset(kbdBounds, kbdCenter.x - kbdBounds.size.width/2, kbdCenter.y - kbdBounds.size.height/2 );
	
	return kbdAppFrame;
}

- (void) cancelCurrentAnimations {
	id animator = objc_getClass("UIAnimator");
	id sharedAnimator = [animator performSelector: @selector(sharedAnimator)];
	[sharedAnimator performSelector: @selector(removeAnimationsForTarget:) withObject: self];
	
}

#pragma mark keyboard & text fields notification handlers

- (void)kbdWillShow:(NSNotification*)notification {
	[self cancelCurrentAnimations];	
    keyboardFrame = [self extractKeyboardFrameFromNotification:notification]; 	
}

- (void)kbdWillHide:(NSNotification*)notification {
}

- (void)editingStarted:(NSNotification*)notification {
	UIView* focusedTextField = (UIView*)[notification object];
	[self scrollToField: focusedTextField];
}

- (void)editingFinished:(NSNotification*)notification {
	[self resetScroll];
}


@end