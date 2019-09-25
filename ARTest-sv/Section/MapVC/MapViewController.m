//
//  MapViewController.m
//  ARTest-sv
//
//  Created by 张玺臣 on 2019/9/5.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import "MapViewController.h"
//AMap3D SDK
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "ZXPinAnnotationView.h"
#import "ARSCNViewController.h"

@interface MapViewController ()<MAMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *MapViewContent;
@property (strong, nonatomic)MAMapView *mapView;
@property (strong, nonatomic)UIButton *chatBtn;
//
@property (strong, nonatomic)NSObject *locationManager;
@end

@implementation MapViewController



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //frame 调整
    CGFloat btnHeight = 50;
    CGFloat btnWidth = 150;
    self.chatBtn.frame = CGRectMake((self.view.bounds.size.width - btnWidth)/2 ,
                                    self.view.bounds.size.height - btnHeight - HEIGHT_NAVSTATUS ,
                                    btnWidth,
                                    btnHeight);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    self.title = @"地图";
    
    [self initNavBtnItem];
    [self initMap];
    [self initChatBtn];
    
    
    
    
//    self.locationManager = [[AMapLocationManager alloc] init];
//    self.locationManager.delegate = self;
}

- (void)initNavBtnItem;{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_AR"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
//    rightBarItem.width = -50;
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)onClickedOKbtn;{
    NSLog(@"onClickedOKbtn");
    ARSCNViewController *vc = [[ARSCNViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//    self.prese
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)initMap;{
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    ///初始化地图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     self.view.bounds.size.width,
                                                                     self.view.bounds.size.height -HEIGHT_NAVSTATUS)];
    ///把地图添加至view
    [self.MapViewContent addSubview:mapView];
    //显示用户位置
    mapView.showsUserLocation = NO;
    //在follow用户定位位置模式
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    //缩放级别
    mapView.zoomLevel = 16;
    //现实自定义用户位置精度圈，由于nil 顾而=不现实
    mapView.customizeUserLocationAccuracyCircleRepresentation = NO;
    mapView.delegate = self;
    self.mapView = mapView;
}

- (void)initChatBtn;{
    //添加返回按钮
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectZero;
    [btn setTitle:@"随机创建" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(sendChat:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.chatBtn = btn;
}

- (void)sendChat:(UIButton *)btn;{
    NSLog(@"touch sendChat\n");

    if(self.mapView.userLocation == nil){
            return ;
    }

    //添加标注
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    //self.mapView.userLocation.coordinate;//CLLocationCoordinate2DMake(39.989631, 116.481018);
    pointAnnotation.coordinate = self.mapView.centerCoordinate ;
    pointAnnotation.title = @"title";
    pointAnnotation.subtitle = @"subtitle";
    [self.mapView addAnnotation:pointAnnotation];
}



#pragma -mark MAMapViewDelegate

- (void)mapViewRegionChanged:(MAMapView *)mapView;{
    NSLog(@"zoom level :%f",self.mapView.zoomLevel);
}

//精确圈 -样式
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay;{
    NSLog(@"精度圈:\n");
    NSLog(@" coordinate: (%f,%f)",overlay.coordinate.latitude,overlay.coordinate.longitude);
    
    return nil;
}


/**
 * @brief 地图区域改变完成后会调用此接口
 * @param mapView 地图View
 * @param animated 是否动画
 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated;{
//    NSLog(@"%f,%f,%f,%f",
//          mapView.region.center.latitude,
//          mapView.region.center.longitude,
//          mapView.region.span.latitudeDelta,
//          mapView.region.span.longitudeDelta);
}


//气泡相关
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation;{
//    if([annotation isKindOfClass:[MAUser]])annotation    MAUserLocation *    0x2820feeb0    0x00000002820feeb0
    if([annotation isKindOfClass:[MAUserLocation class]]){
        NSLog(@"self view");
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        NSLog(@"气泡 view");
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        ZXPinAnnotationView *annotationView = (ZXPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        
        if (annotationView == nil){
            annotationView = [[ZXPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
            //设置图标
            annotationView.image = [UIImage imageNamed:@"icon_circular_msg"];
            //根据图标修正偏移量
            annotationView.centerOffset = CGPointMake(0, -30);//中心修正
        }
        
        //设置气泡可以弹出，默认为NO
        annotationView.canShowCallout = NO;
         //设置标注动画显示，默认为NO
        annotationView.animatesDrop = YES;
         //设置标注可以拖动，默认为NO
        annotationView.draggable = YES;
//        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views;{
    NSLog(@"添加了一个Annotation View");
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view;{
    NSLog(@"选中了一个Annotation View");
    if([view isKindOfClass:[ZXPinAnnotationView class]]){
        ZXPinAnnotationView *zxView = (ZXPinAnnotationView *)view;
        [zxView didSelectView];
    }
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view;{
    NSLog(@"取消选中了一个Annotation View");
    if([view isKindOfClass:[ZXPinAnnotationView class]]){
        ZXPinAnnotationView *zxView = (ZXPinAnnotationView *)view;
        [zxView didDeSelectView];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
