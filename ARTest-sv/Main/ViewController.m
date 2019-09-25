//
//  ViewController.m
//  ARTest-sv
//
//  Created by 张玺臣 on 2019/9/3.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import "ViewController.h"
#import "ARSCNViewController.h"
#import "MapViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)touchARAction:(id)sender {
    ARSCNViewController *vc = [[ARSCNViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)touchMapAction:(id)sender {
    MapViewController *vc = [[MapViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
