#import <Flutter/Flutter.h>

@interface NemIdPlugin : NSObject<FlutterPlugin>

@property (nonatomic, copy) NSString *spBackendURL;
@property (nonatomic, copy) NSString *nemIDBackendURL;
@property (nonatomic, copy) NSString *signingEndpoint;
@property (nonatomic, copy) NSString *validationEndpoint;
@property (nonatomic, copy) FlutterResult flutterResult;
@property (assign) BOOL isDev;

- (void)sendResult:(NSString *)response;

@end
