//
//  ChatView.m
//  ARTest-sv
//
//  Created by 张玺臣 on 2019/9/9.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import "ChatView.h"

@implementation ChatView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"ChatView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}

@end
