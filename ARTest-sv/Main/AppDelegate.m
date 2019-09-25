//
//  AppDelegate.m
//  ARTest-sv
//
//  Created by 张玺臣 on 2019/9/3.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AVOSCloud/AVOSCloud.h>

#import "ZXNavVC.h"
#import "MapViewController.h"
//#import "ARSCNViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma -mark other
//高德地图初始化
- (void)initAMapServices;{
    [AMapServices sharedServices].apiKey = AMapAPIKey;
}
- (void)initLearnClouds;{
    // 配置 SDK 储存
    [AVOSCloud setServerURLString:@"https://jwrsbhuk.lc-cn-n1-shared.com" forServiceModule:AVServiceModuleAPI];
    // 配置 SDK 推送
    [AVOSCloud setServerURLString:@"https://jwrsbhuk.lc-cn-n1-shared.com" forServiceModule:AVServiceModulePush];
    // 配置 SDK 云引擎（用于访问云函数，使用 API 自定义域名，而非云引擎自定义域名）
    [AVOSCloud setServerURLString:@"https://jwrsbhuk.lc-cn-n1-shared.com" forServiceModule:AVServiceModuleEngine];
    // 配置 SDK 即时通讯
    [AVOSCloud setServerURLString:@"https://jwrsbhuk.lc-cn-n1-shared.com" forServiceModule:AVServiceModuleRTM];
    // 配置 SDK 统计
    [AVOSCloud setServerURLString:@"https://jwrsbhuk.lc-cn-n1-shared.com" forServiceModule:AVServiceModuleStatistics];
    // 初始化应用
    [AVOSCloud setApplicationId:@"jwrsBHUKkoLSJ4IjHgoFx1ny-gzGzoHsz" clientKey:@"LJggSsdA4xS4qtKXuTR8SuNX"];

    
    //注册
    NSString *username = @"zxc_user_name";
    NSString *password = @"zxc_password";
    NSString *email = @"670633205@qq.com";
//    if (username && password && email) {
//        // LeanCloud - 注册
//        // https://leancloud.cn/docs/leanstorage_guide-objc.html#用户名和密码注册
//        AVUser *user = [AVUser user];
//        user.username = username;
//        user.password = password;
//        user.email = email;
//        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
////                [self performSegueWithIdentifier:@"fromSignUpToProducts" sender:nil];
//                NSLog(@"注册成功 %d", succeeded);
//
//            } else {
//                NSLog(@"注册失败 %@", error);
//            }
//        }];
//    }
    
//    //登录
//    NSString *username = self.usernameTextField.text;
//    NSString *password = self.passwordTextField.text;
//    if (username && password) {
//        // LeanCloud - 登录
//        // https://leancloud.cn/docs/leanstorage_guide-objc.html#登录
//        [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
//            if (error) {
//            } else {
//            }
//        }];
//    }
    
    
    //
    
    NSString *title = @"title";
    NSString *description = @"description";
    
    AVUser *currentUser = [AVUser currentUser];
    
    AVObject *product = [AVObject objectWithClassName:@"Product"];
    [product setObject:title forKey:@"title"];
    
    // owner 字段为 Pointer 类型，指向 _User 表
    [product setObject:currentUser forKey:@"owner"];
    [product setObject:description forKey:@"description"];
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
//            [self.indicatorView setHidden:YES];
//            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"保存新物品出错 %@", error);
        }
    }];
    
}

#pragma -mark System
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initAMapServices];
    [self initLearnClouds];
    
    MapViewController *vc = [[MapViewController alloc]init];
    //    ARSCNViewController *vc = [[ARSCNViewController alloc]init];
    ZXNavVC *navVC = [[ZXNavVC alloc]initWithRootViewController:vc];
    
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ARTest_sv"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
