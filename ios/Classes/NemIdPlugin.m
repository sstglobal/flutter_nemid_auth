#import "NemIdPlugin.h"
#import "NemIDViewController.h"
#import "ValidationFetcher.h"
#import "NetworkUtilities.h"
#import "ClientDimensions.h"
#import "Constants.h"

@implementation NemIdPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"nemid_auth" binaryMessenger:[registrar messenger]];
    NemIdPlugin* instance = [[NemIdPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (UIViewController *)viewController:(UIWindow *)window {
    UIWindow *windowToUse = window;
    if (windowToUse == nil) {
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if(window.isKeyWindow){
                windowToUse = window;
                break;
            }
        }
    }
    UIViewController *topController = windowToUse.rootViewController;
    while(topController.presentingViewController)
        topController = topController.presentingViewController;
    return topController;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    self.flutterResult = result;

    if ([@"setNemIdEndpoints" isEqualToString:call.method]) {
        self.signingEndpoint = call.arguments[@"signing"];
        self.validationEndpoint = call.arguments[@"validation"];
        self.isDev = call.arguments[@"isDev"];
        result(@"ok");
    } else if ([@"authWithNemID" isEqualToString:call.method]) {
      NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"nemid_bundle" ofType:@"bundle"];
      NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];

      self.spBackendURL = @"https://applet.danid.dk";
      self.nemIDBackendURL = @"https://applet.danid.dk";

       [self parameterResponse:@"RequestTypeTwoFactorLoginLongTerm+" success:^(NSString *parameters) {
           //Pass parameters to next view, and go to view
           if (parameters) {
               NemIDViewController *nemIDViewController;
        
               nemIDViewController = [[UIStoryboard storyboardWithName:@"NemID" bundle:bundle] instantiateViewControllerWithIdentifier:@"NemIDViewController"];

               ClientDimensions *clientDimensions = [self getClientDimensions];

               // Set relevant parameters for NemIDViewController
               nemIDViewController.parameters = parameters;
               NSString *launcherUrl = self.isDev ? @"https://appletk.danid.dk/launcher/lmt" : @"https://applet.danid.dk/launcher/lmt";
               nemIDViewController.nemIDJavascriptURL = launcherUrl;
               nemIDViewController.width = clientDimensions.width;
               nemIDViewController.height = clientDimensions.height;
               nemIDViewController.controller = self;
               nemIDViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;

               [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nemIDViewController animated:YES completion:nil];
           }
           else {
               NSLog(@"Error in parameter response from %@", GenerateParameterURL);
           }
      } error:^(NSInteger errorCode, NSString *errorMessage) {
          NSLog(@"Error while starting flow. ErrorCode was: %lu. ErrorMessage was: %@", (long)errorCode, errorMessage);
      }];
  } else {
    result(FlutterMethodNotImplemented);
  }
}


- (void) sendResult:(NSString*)response {
    self.flutterResult(response);
}

- (ClientDimensions *)getClientDimensions {
    ClientDimensions *clientDimensions = [ClientDimensions new];
    clientDimensions.width = @"320";
    clientDimensions.height = @"460";

    return clientDimensions;
}

- (void)parameterResponse:(NSString *)requestType
                  success:(ParameterFetcherSuccessBlock)successBlock
                    error:(ParameterFetcherErrorBlock)errorBlock {
    NSString *samlProviderUrl = self.signingEndpoint;

    NSLog(@"Starting RequestTypeTwoFactorLoginLongTerm");
    [ParameterFetcher fetchParameters:[NSURL URLWithString:samlProviderUrl]
                                                   success:successBlock
                                                     error:errorBlock];
}



@end
