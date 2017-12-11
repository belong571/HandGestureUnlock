//
//  PassWordView.m
//  32.九宫格手势解锁
//
//  Created by zyj on 2017/12/7.
//  Copyright © 2017年 ittest. All rights reserved.
//

#import "PassWordView.h"
#define kButtonCount 9//宫格总数量
@interface PassWordView()
@property(nonatomic,strong) NSMutableArray *btns;// 9个按钮的数组
@property(nonatomic,strong) NSMutableArray *linesBtns;// 所有需要连线的按钮
@property(nonatomic,assign) CGPoint currentPoint;// 当前手指的位置
@end

@implementation PassWordView

-(NSMutableArray *)linesBtns{
    if(_linesBtns==nil){
        _linesBtns=[NSMutableArray array];
    }
    return _linesBtns;
}

-(NSMutableArray *)btns{
    if(_btns==nil)
    {
        _btns=[NSMutableArray array];
        for (int i=0; i<kButtonCount; i++) {
            //创建btn
            UIButton *btn=[[UIButton alloc] init];
            btn.tag=i;
            //禁用btn交互
            btn.userInteractionEnabled=NO;
            // 设置 btn 默认的图片
            [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
            //设置 btn 点击高亮的图片
            [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
            //设置 btn 错误的图片
            [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_error"] forState:UIControlStateDisabled];
            [_btns addObject:btn];
            [self addSubview:btn];
        }
    }
    return _btns;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *t=[touches anyObject];
    CGPoint p=[t locationInView:self];
    
    for(int i=0;i<self.btns.count;i++){
        UIButton *btn= self.btns[i];
        // 如果 btn 的 frame 包含 手指的点
        if(CGRectContainsPoint(btn.frame, p)){
            // 让按钮亮起来
            [btn setSelected:YES];
            // 判断 如果已经加到了数组当中 那么不再去添加
            if(![self.linesBtns containsObject:btn]){
                // 添加到需要画线的数组当中
                [self.linesBtns addObject:btn];
            }
        }
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *t=[touches anyObject];
    CGPoint p=[t locationInView:self];
    //记录移动过程中手指的位置
    self.currentPoint=p;
    for(int i=0;i<self.btns.count;i++){
        UIButton *btn= self.btns[i];
        // 如果 btn 的 frame 包含 手指的点
        if(CGRectContainsPoint(btn.frame, p)){
            // 让按钮亮起来
            [btn setSelected:YES];
            // 判断 如果已经加到了数组当中 那么不再去添加
            if(![self.linesBtns containsObject:btn]){
                // 添加到需要画线的数组当中
                [self.linesBtns addObject:btn];
                            }
        }
    }
    //重绘
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //修正最后手指松开后多画出来的一条线
    self.currentPoint=[[self.linesBtns lastObject] center];
    //重绘
    [self setNeedsDisplay];
    
    //拼接密码
    NSString *password=@"";
    for (int i=0;i<self.linesBtns.count;i++) {
        UIButton *btn= self.linesBtns[i];
        
        password=[password stringByAppendingString:[NSString stringWithFormat:@"%ld",btn.tag]];
    }
    
    //把用户选择的密码传出去
    if(self.passwordBlock){
        if(self.passwordBlock(password)){
            NSLog(@"zhengque");
        }else{
            NSLog(@"cuowu");
            // 所有需要画线的 btn 都变成错误的样式
            for (int i=0;i<self.linesBtns.count;i++) {
                UIButton *btn= self.linesBtns[i];
                [btn setEnabled:NO];
                [btn setSelected:NO];
            }
        }
    }
    
    //禁用按钮交互
    self.userInteractionEnabled=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //清空
        [self clean];
        //恢复按钮交互
        self.userInteractionEnabled=YES;
    });
}

//让按钮恢复到最初始的状态
-(void)clean{
    for (int i=0;i<self.btns.count;i++) {
        UIButton *btn= self.btns[i];
        [btn setEnabled:YES];
        [btn setSelected:NO];
    }
    [self.linesBtns removeAllObjects];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    if(!self.linesBtns.count){
        return;
    }
    // Drawing code
    UIBezierPath *path=[[UIBezierPath alloc] init];
    for(int i=0;i<self.linesBtns.count;i++){
        UIButton *btn= self.linesBtns[i];
        if(i==0){
            [path moveToPoint:btn.center];
        }else{
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:self.currentPoint];
    [path setLineWidth:10];
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    [[UIColor whiteColor] set];
    [path stroke];
}

//计算九宫格
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //计算九宫格位置
    CGFloat w = 74;
    CGFloat h = w;
    int colCount = 3;
    CGFloat margin = (self.frame.size.width - 3 * w) / 4;
    for (int i = 0; i < self.btns.count; i++) {
        CGFloat x = (i % colCount) * (margin + w) + margin;
        CGFloat y = (i / colCount) * (margin + w) + margin;
        [self.btns[i] setFrame:CGRectMake(x, y, w, h)];
    }
}
@end
