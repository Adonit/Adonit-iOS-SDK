
void trace(NSString *format, ...);
NSString *getRandomString(uint len);

@interface NSString (utilities)
+(NSString *)stringWithConsoleInputWithCharacterLimit:(uint) maxLen;
@end

@interface NSObject (PerformBlockAfterDelay)
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
- (void)fireBlockAfterDelay:(void (^)(void))block;
@end


typedef NSObject * (^MapFunctionBlock)(NSObject *);

@interface NSArray (map)
- (NSMutableArray *)mapWithBlock:(MapFunctionBlock)lambda;
@end




NSString * VTPG_DDToStringFromTypeAndValue(const char * typeCode, void * value);

#define $(_X_) do{\
__typeof__(_X_) _Y_ = _X_;\
const char * _TYPE_CODE_ = @encode(__typeof__(_X_));\
NSString *_STR_ = VTPG_DDToStringFromTypeAndValue(_TYPE_CODE_,(void *)&_Y_);\
if(_STR_) { \
trace(@"###   %s = %@", #_X_, _STR_);\
} else { \
trace(@"###   Unknown _TYPE_CODE_: %s for expression %s in function %s, file %s, line %d", _TYPE_CODE_, #_X_, __func__, __FILE__, __LINE__);\
}}while(0)



#define _(_X_) ^__typeof__(_X_){\
__typeof__(_X_) _Y_ = _X_;\
const char * _TYPE_CODE_ = @encode(__typeof__(_X_));\
NSString *_STR_ = VTPG_DDToStringFromTypeAndValue(_TYPE_CODE_,(void *) &_Y_);\
if(_STR_) { \
trace(@"###   %s = %@", #_X_, _STR_);\
} else { \
trace(@"###   Unknown _TYPE_CODE_: %s for expression %s in function %s, file %s, line %d", _TYPE_CODE_, #_X_, __func__, __FILE__, __LINE__);\
}\
return _Y_;\
}()

#define fff trace(@"###   %s @ %u",__PRETTY_FUNCTION__,__LINE__)

#define appTime (uint)[[NSProcessInfo processInfo] systemUptime] * 1000
#define initTimer static uint __timerStartTime__
#define startTimer __timerStartTime__ = (uint)[[NSProcessInfo processInfo] systemUptime] * 1000
#define endTimer trace(@" %u ",((uint)[[NSProcessInfo processInfo] systemUptime] * 1000)- __timerStartTime__)

