//
//  AppDelegate.m
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "AppDelegate.h"
#import "YNCLoginViewController.h"
#import "YNCListViewController.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface AppDelegate ()<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  NSLog(@"Hello World");
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  
  // Initialize Parse.
  [Parse setApplicationId:@"G6ytzz5MuXyjrQVNvXuRBr6Xe0eyDrpBL8rjaPgn"
                clientKey:@"JVpCvikLi7GQv33RTxTysRhRbyrGvIZUVYVwHz9r"];
  [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];

  
  if (![PFUser currentUser]) { // No user logged in
    YNCLoginViewController *logInViewController = [[YNCLoginViewController alloc] init];
    logInViewController.fields = PFLogInFieldsFacebook;
    logInViewController.facebookPermissions = @[@"user_friends", @"public_profile"];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    self.window.rootViewController = logInViewController;
  } else {
    [self postLoginLaunch];
  }
  
  self.window.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
  [self.window makeKeyAndVisible];
  
  
  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                  didFinishLaunchingWithOptions:launchOptions];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
  //  [logInController dismissViewControllerAnimated:YES completion:nil];
  [self postLoginLaunch];
}

- (void)postLoginLaunch {
  YNCListViewController *listView = [[YNCListViewController alloc] init];
  UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:listView];
  self.window.rootViewController = navVC;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                        openURL:url
                                              sourceApplication:sourceApplication
                                                     annotation:annotation
          ];
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

@end
