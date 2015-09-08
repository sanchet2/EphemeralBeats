//
//  AppDelegate.m
//  Efemer
//
//  Created by Nikhil Sancheti on 5/31/15.
//  Copyright (c) 2015 Nikhil Sancheti. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "NetworkUtilities.h"
#import <RNSwipeViewController/RNSwipeViewController.h>
#import "SearchBarVC.h"
#import "SearchUsersVC.h"
#import "SongQueueCollectionVC.h"
#import "CurrentSongSwipeVC.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "Constants.h"
#import <AVFoundation/AVFoundation.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "StreamingPlayer.h"
#import "User.h"
@interface AppDelegate ()
@property (strong,nonatomic) UINavigationController *navController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //setup logging
    [self setupCocoaLumberjack];
    [Fabric with:@[CrashlyticsKit]];
    
    //Login Controller
    LoginViewController *loginVC=[[LoginViewController alloc]init];
    self.navController=[[UINavigationController alloc]initWithRootViewController:loginVC];
    self.window.rootViewController =self.navController;
    
    //Setup Core Data
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Efemer.sqlite"];
    //Retrieve User Data and Check if its the right user
//    [User MR_truncateAll];
//    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    NSError* error;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    return YES;
}
-(void)setupCocoaLumberjack
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blackColor] backgroundColor:nil forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:DDLogFlagError];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor yellowColor] backgroundColor:nil forFlag:DDLogFlagWarning];
    
}
- (BOOL)validateUrl:(NSString *)candidate {
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}
- (void)deleteAllEntities:(NSString *)nameEntity
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [[NSManagedObjectContext MR_defaultContext] executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [[NSManagedObjectContext MR_defaultContext] deleteObject:object];
    }
    
    error = nil;
    [[NSManagedObjectContext MR_defaultContext] save:&error];
}


-(void)goToNewViewController{
    
    RNSwipeViewController *swipeVC=[[RNSwipeViewController alloc]init];
    swipeVC.view.backgroundColor=[UIColor clearColor];
    swipeVC.leftVisibleWidth=self.window.frame.size.width;
    swipeVC.rightVisibleWidth=self.window.frame.size.width;
    
    SearchBarVC *searchBar=[[SearchBarVC alloc]init];
    swipeVC.centerViewController=searchBar;
    
    SearchUsersVC *searchUsersVC=[[SearchUsersVC alloc]init];
    swipeVC.leftViewController=searchUsersVC;
    
    SongQueueCollectionVC *playlistVC=[[SongQueueCollectionVC alloc]init];
    swipeVC.rightViewController=playlistVC;
    
    [self.navController presentViewController:swipeVC animated:YES completion:nil];
    
}
-(void)pause{
    if ([[StreamingPlayer sharedManager]isPlaying]) {
        [[StreamingPlayer sharedManager]pause];
    }
    else{
        [[StreamingPlayer sharedManager]resume];
    }
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
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
}


@end
