
#import "PCLockLabel.h"
#import "PCCircleViewConst.h"

@implementation PCLockLabel


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        //视图初始化
        [self viewPrepare];
    }
    
    return self;
}



- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self=[super initWithCoder:aDecoder];
    
    if(self){
        
        //视图初始化
        [self viewPrepare];
    }
    
    return self;
}


/*
 *  视图初始化
 */
- (void)viewPrepare{
    
    float fontSize = 14.0f;
    if(DEVICE_SCREEN_INCH_IPAD)
        fontSize = 22.4f;
    
    [self setFont:[UIFont systemFontOfSize:fontSize]];
    [self setTextAlignment:NSTextAlignmentCenter];
}


/*
 *  普通提示信息
 */
- (void)showNormalMsg:(NSString *)msg{
    
    [self setText:msg];
    [self setTextColor:textColorNormalState];
}

/*
 *  警示信息
 */
- (void)showWarnMsg:(NSString *)msg{
    
    [self setText:msg];
    [self setTextColor:textColorWarningState];
}

/*
 *  警示信息(shake)
 */
- (void)showWarnMsgAndShake:(NSString *)msg{
    
    [self setText:msg];
    [self setTextColor:textColorWarningState];
    
    //添加一个shake动画
    [self.layer shake];
}


@end
