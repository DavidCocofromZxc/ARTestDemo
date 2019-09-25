//
//  ARSCNViewController.m
//  ARTest-sv
//
//  Created by 张玺臣 on 2019/9/3.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import "ARSCNViewController.h"

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>


@interface ARSCNViewController ()<ARSCNViewDelegate,ARSessionDelegate>
//AR视图：展示3D界面
@property(nonatomic,strong)ARSCNView *arSCNView;
//AR会话，负责管理相机追踪配置及3D相机坐标
@property(nonatomic,strong)ARSession *arSession;
//会话追踪配置：负责追踪相机的运动
@property(nonatomic,strong)ARConfiguration *arSessionConfiguration;
//飞机3D模型(本小节加载多个模型)
@property(nonatomic,strong)SCNNode *planeNode;
@end


@implementation ARSCNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated;{
    [super viewDidAppear:animated];
    //1.将AR视图添加到当前视图
    [self.view addSubview:self.arSCNView];
    //2.开启AR会话（此时相机开始工作）//
    [self.arSession runWithConfiguration:self.arSessionConfiguration];
    //3
    self.arSCNView.delegate = self;
    self.arSession.delegate = self;
    
    [self initBackBtn];
}


- (void)initBackBtn;{
    //添加返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    //    btn.frame = CGRectMake(self.view.bounds.size.width/2-50,
    //                           self.view.bounds.size.height-100,
    //                           100,
    //                           50);
    btn.frame = CGRectMake(10,10,100,50);
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


- (void)back:(UIButton *)btn;{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark- 点击屏幕添加飞机
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;{
// 1使用场景加载scn文件（scn格式文件是一个基于3D建模的文件，使用3DMax软件可以创建，这里系统有一个默认的3D飞机）--------在右侧我添加了许多3D模型，只需要替换文件名即可

        //飞机
//    NSLog(@"点击屏幕");
//    SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/ship.scn"];
//    //2.获取飞机节点（一个场景会有多个节点，此处我们只写，飞机节点则默认是场景子节点的第一个）
//    //所有的场景有且只有一个根节点，其他所有节点都是根节点的子节点
//    SCNNode *shipNode = scene.rootNode.childNodes[0];
//    shipNode.position = SCNVector3Make(0,0,-3);
//
//    //3.将飞机节点添加到当前屏幕中
//    [self.arSCNView.scene.rootNode addChildNode:shipNode];
    
//    SCNLight *light = [SCNLight light];
//    light.type = SCNLightTypeOmni;
//    light.color = [UIColor redColor];
//    light.temperature = 6500;
//    self.arSCNView.scene.rootNode.light = light;


    
    
    
    
    
    
    SCNCone *cylinder = [SCNCone coneWithTopRadius:0.2 bottomRadius:0 height:0.4];
    SCNNode *geoNode = [SCNNode nodeWithGeometry:cylinder];
//    geoNode.position = SCNVector3Make(0, 0, -5);
    geoNode.position = SCNVector3Make(0, 0, -1);

    
    [self.arSCNView.scene.rootNode addChildNode:geoNode];
    

    
    
    
    CGFloat textFont = 1.0;//文字尺寸
    NSString *scnText = @"中国好";
//    scnText
    NSLog(@"字数：%ld",scnText.length);
    SCNText *text = [SCNText textWithString:scnText extrusionDepth:0.1 * textFont];
    text.font = [UIFont systemFontOfSize:textFont];
    SCNNode *textNode = [SCNNode nodeWithGeometry:text];
    textNode.position = SCNVector3Make(-1 * (textFont/2) ,
                                       -1 * 0.5,
                                       -1);
    [self.arSCNView.scene.rootNode addChildNode:textNode];
//    [geoNode addChildNode:textNode];
    
//    [text setWrapped:true];
//    text.containerFrame = CGRectMake(0, 0, 6, 1);
    
    
    
//    CAKeyframeAnimation *moonAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
//    NSValue *value0 = [NSNumber numberWithFloat:0.3];
//    NSValue *value1 = [NSNumber numberWithFloat:-0.3];
//
//    moonAnimation.values = [NSArray arrayWithObjects:value0,value1, nil];
//    moonAnimation.beginTime = 0;
//    moonAnimation.duration = 1;
//
//    moonAnimation.repeatCount = FLT_MAX;
//    moonAnimation.autoreverses = YES;
//
//    [geoNode addAnimation:moonAnimation forKey:@"moon rotation around earth"];
    
}


#pragma mark -- ARSCNViewDelegate

//添加节点时候调用（当开启平地捕捉模式之后，如果捕捉到平地，ARKit会自动添加一个平地节点）
- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor;{
    
    //
//    if(self.arType != ARTypePlane) {
        return;
//    }
    
    //第一步是捕捉平地
    //第二步是添加目标平地
    //第三步是在目标平地添加飞机模型
    if ([anchor isMemberOfClass:[ARPlaneAnchor class]]) {
        NSLog(@"捕捉到平地");
        
        //添加一个3D平面模型，ARKit只有捕捉能力，锚点只是一个空间位置，要想更加清楚看到这个空间，我们需要给空间添加一个平地的3D模型来渲染他
        
        //1.获取捕捉到的平地锚点
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        //2.创建一个3D物体模型    （系统捕捉到的平地是一个不规则大小的长方形，这里笔者将其变成一个长方形，并且是否对平地做了一个缩放效果）
        //参数分别是长宽高和圆角
        SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x*0.3 height:0 length:planeAnchor.extent.x*0.3 chamferRadius:0];
        //3.使用Material渲染3D模型（默认模型是白色的，这里笔者改成红色）
        plane.firstMaterial.diffuse.contents = [UIColor redColor];
        
        //4.创建一个基于3D物体模型的节点
        SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
        //5.设置节点的位置为捕捉到的平地的锚点的中心位置  SceneKit框架中节点的位置position是一个基于3D坐标系的矢量坐标SCNVector3Make
        planeNode.position =SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        
        //self.planeNode = planeNode;
        [node addChildNode:planeNode];
        
        
        //2.当捕捉到平地时，2s之后开始在平地上添加一个3D模型
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //1.创建一个花瓶场景
//            SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/vase/vase.scn"];//
            //暂时只有飞机资源
            SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/ship.scn"];
            //2.获取花瓶节点（一个场景会有多个节点，此处我们只写，花瓶节点则默认是场景子节点的第一个）
            //所有的场景有且只有一个根节点，其他所有节点都是根节点的子节点
            SCNNode *vaseNode = scene.rootNode.childNodes[0];
            
            //4.设置花瓶节点的位置为捕捉到的平地的位置，如果不设置，则默认为原点位置，也就是相机位置
            vaseNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
            
            //5.将花瓶节点添加到当前屏幕中
            //!!!此处一定要注意：花瓶节点是添加到代理捕捉到的节点中，而不是AR试图的根节点。因为捕捉到的平地锚点是一个本地坐标系，而不是世界坐标系
            [node addChildNode:vaseNode];
        });
    }
}

//刷新时调用
- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor;{
    NSLog(@"刷新中");
}

//更新节点时调用
- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor;{
    NSLog(@"节点更新");
}

//移除节点时调用
- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor;{
    NSLog(@"节点移除");
}

#pragma mark -ARSessionDelegate

//会话位置更新（监听相机的移动），此代理方法会调用非常频繁，只要相机移动就会调用，如果相机移动过快，会有一定的误差，具体的需要强大的算法去优化，笔者这里就不深入了
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame;{
//    NSLog(@"相机移动");
}

- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor*>*)anchors;{
    NSLog(@"添加锚点");
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors;{
    NSLog(@"刷新锚点");
}

- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors;{
    NSLog(@"移除锚点");
}
#pragma mark -搭建ARKit环境
#pragma -mark Lazy
////懒加载会话追踪配置
- (ARConfiguration *)arSessionConfiguration {
    if (_arSessionConfiguration != nil) {
        return _arSessionConfiguration;
    }
    //1.创建世界追踪会话配置（使用ARWorldTrackingSessionConfiguration效果更加好），需要A9芯片支持
    ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc] init];
    //2.设置追踪方向（追踪平面，后面会用到）
    configuration.planeDetection = ARPlaneDetectionHorizontal;//ARPlaneDetectionVertical //ARPlaneDetectionHorizontal
    _arSessionConfiguration = configuration;
    //3.自适应灯光（相机从暗到强光快速过渡效果会平缓一些）
    _arSessionConfiguration.lightEstimationEnabled = YES;
    return _arSessionConfiguration;
}

//懒加载拍摄会话
- (ARSession *)arSession {
    if(_arSession != nil) {
        return _arSession;
    }
    //1.创建会话
    _arSession = [[ARSession alloc] init];
    //2返回会话
    return _arSession;
}

//创建AR视图
- (ARSCNView *)arSCNView {
    if (_arSCNView != nil) {
        return _arSCNView;
    }
    //1.创建AR视图
    _arSCNView = [[ARSCNView alloc] initWithFrame:self.view.bounds];//self.view.bounds//CGRectMake(0,100,    self.view.bounds.size.width,    self.view.bounds.size.height - 100)
    //2.设置视图会话
    _arSCNView.session = self.arSession;
    //3.自动刷新灯光（3D游戏用到，此处可忽略）
    _arSCNView.automaticallyUpdatesLighting = YES;
    
    return _arSCNView;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
