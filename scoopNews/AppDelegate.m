//
//  AppDelegate.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//
#import "settings.h"
#import "AppDelegate.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "YWCViewController.h"
#import "GAI.h"
@interface AppDelegate ()
@property (nonatomic, strong) MSClient *client;
@property (nonatomic, strong) MSTable *table;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self configureAzure];
    YWCViewController *vc = [[YWCViewController alloc]initWithClient:self.client andTable:self.table];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        #ifdef __IPHONE_8_0
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound
                                                                                             |UIUserNotificationTypeBadge
                                                                                             |UIUserNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
        #endif
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    NSString * deviceID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSLog(@"DeviceId : %@", deviceID);
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSCharacterSet * chacracterSet = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    NSString * deviceTokenString = [[(deviceToken.description) stringByTrimmingCharactersInSet:chacracterSet]stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Token Push >>>>>>  %@",deviceTokenString);
    
}

-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"El registro noficaciones ha fallado \n \n %@",error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    UIApplicationState state = application.applicationState;
    if (state == UIApplicationStateActive) {
        NSLog(@"Estado activo de las pushNotications");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotification" object:nil];
    }
}


-(void) addGoogleAnalitycs{
    
//    GAI.sharedInstance().trackUncaughtExceptions = true
//    GAI.sharedInstance().logger.logLevel = GAILogLevel.Verbose
//    GAI.sharedInstance().dispatchInterval = 60
//    GAI.sharedInstance().trackerWithTrackingId(kTrackingId)
//    var tracker = GAI.sharedInstance().defaultTracker

}

-(void)setupAnalytics{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 60;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Iniciamos captura
    [[GAI sharedInstance] trackerWithTrackingId:UA_ANALYTICS];
}



-(void)configureAzure{
    NSURL *urlAzure = [NSURL URLWithString:AZURE_URL];
    self.client = [MSClient clientWithApplicationURL:urlAzure applicationKey:AZURE_KEY];
    self.table = [self.client tableWithName:AZURE_TABLENEWS];
}
@end
