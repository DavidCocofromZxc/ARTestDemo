//
//  ZXPinAnnotationView.m
//  ARTest-sv
//
//  Created by 张玺臣 on 2019/9/6.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import "ZXPinAnnotationView.h"
#import "ChatView.h"
//
@interface ZXPinAnnotationView()
@property (nonatomic, assign) CGRect defultFrame;
@property (nonatomic, strong) UIView *chatView;
@end

@implementation ZXPinAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)didSelectView;{
    self.defultFrame = self.imageView.frame;
    self.image = [UIImage imageNamed:@"icon_square_msg"];
    
    UIImage *image = [UIImage imageNamed:@"icon_square_msg"];
    [self.imageView setImage:image];
    
//    UIImage *backImage = [UIImage imageNamed:@"icon_square_msg"];
//    CGSize size = backImage.size;
//
//    //上 / 左 / 下 / 右
//    UIEdgeInsets insets = UIEdgeInsetsMake(size.height * 0.7, size.width * 0.5, size.height * 0.3, size.width * 0.5);
//
//    backImage = [image resizableImageWithCapInsets:insets];
//
//    UIImageView *chatBackImage = [[UIImageView alloc] initWithImage:backImage];
    
   
    CGFloat width = 300;
    CGFloat height = 150;
    self.imageView.frame = CGRectMake(-1 * (width/2) + 25,
                                      -10 - height + 50,//50是原图的高
                                      width,
                                      height);
    
    
    if(self.chatView == nil){
        ChatView *view = [[ChatView alloc]initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   width,
                                                                   height -8)];
        
        view.layer.cornerRadius = 10;//圆角
        self.chatView = view;
    }
    
    
    [self.imageView addSubview:self.chatView];
    
//    self.centerOffset = CGPointMake( 0,-30);
}

- (void)didDeSelectView;{
    self.image = [UIImage imageNamed:@"icon_circular_msg"];
    self.imageView.frame = self.defultFrame;
    if(self.chatView != nil){
        [self.chatView removeFromSuperview];
    }
    
    NSLog(@"frame : (%f,%f),(%f,%f)",
          self.defultFrame.origin.x,
          self.defultFrame.origin.y,
          self.defultFrame.size.width,
          self.defultFrame.size.height);
}

@end


//@implementation MAAnnotationView(ZX)
//
//- (void)selectView;{
//
//    self.imageView.backgroundColor = [UIColor blueColor];
//    self.imageView.frame = CGRectMake(-75, 0, 200, 45);
//
////    self.image = [UIImage imageNamed:@"icon_circular_msg"];
//    //根据图标修正偏移量
//    self.centerOffset = CGPointMake(0, -30);
//}
//
////-（）
//
//
//@end
