//
//  ZXPinAnnotationView.h
//  ARTest-sv
//
//  Created by 张玺臣 on 2019/9/6.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXPinAnnotationView : MAPinAnnotationView

- (void)didSelectView;
- (void)didDeSelectView;
    
@end



//@interface MAAnnotationView(ZX) //: MAPinAnnotationView
//
////@property (nonatomic, strong) UIImageView *imageView;
//- (void)selectView;
//
//@end

NS_ASSUME_NONNULL_END
