//
//  AppDelegate.h
//  ARTest-sv
//
//  Created by 张玺臣 on 2019/9/3.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

