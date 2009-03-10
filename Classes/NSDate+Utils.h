@interface NSDate(ChronologicAdditions) 

- (BOOL)isAfter:(NSDate*)other;
- (BOOL)isBefore:(NSDate*)other;
- (CGFloat)minutesSinceDate:(NSDate*)date;
- (NSDate*)addMinutes:(CGFloat)minutes;
- (CGFloat)hoursSinceDate:(NSDate*)date;
- (NSDate*)dayStart;

@end
