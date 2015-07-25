//
//  ViewController.m
//  DSContentScrollerView
//
//  Created by YMY on 15/7/25.
//  Copyright (c) 2015年 dasheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>{
    
    UIScrollView *dsScrollerView;
    UIScrollView *dsScrollerView2;  //子scroller
    
    CGFloat   topBarOrginY;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    dsScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    dsScrollerView.backgroundColor = [UIColor redColor];
    dsScrollerView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*3);
    dsScrollerView.delegate = self;
    [self.view addSubview:dsScrollerView];
    
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageView1 setImage:[UIImage imageNamed:@"anima.jpg"]];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [imageView2 setImage:[UIImage imageNamed:@"anima2.jpg"]];
    
    [dsScrollerView addSubview:imageView1];
    [dsScrollerView addSubview:imageView2];
    
    
    topBarOrginY = self.view.frame.size.height*2;
    UIView *topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, topBarOrginY, self.view.frame.size.width, 80)];
    topBarView.backgroundColor = [UIColor whiteColor];
    [dsScrollerView addSubview:topBarView];
    
    
    //子scroller
    dsScrollerView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarOrginY+topBarView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-80)];
    
    dsScrollerView2.backgroundColor = [UIColor redColor];
    dsScrollerView2.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
    dsScrollerView2.delegate = self;
    [dsScrollerView addSubview:dsScrollerView2];
    
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageView3 setImage:[UIImage imageNamed:@"image3.jpg"]];
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [imageView4 setImage:[UIImage imageNamed:@"image4.jpg"]];
    
    [dsScrollerView2 addSubview:imageView3];
    [dsScrollerView2 addSubview:imageView4];

    
    
    
    //测试contentInset
    UIButton *contentInsetTopButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, 300, 100)];
    contentInsetTopButton.backgroundColor = [UIColor blueColor];
    [contentInsetTopButton addTarget:self action:@selector(insetTopClick) forControlEvents:UIControlEventTouchUpInside];
    [contentInsetTopButton setTitle:@"点击改变顶部contentInset" forState:UIControlStateNormal];
    [self.view addSubview:contentInsetTopButton];
    
    UIButton *contentInsetbottomButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 300, 100)];
    contentInsetbottomButton.backgroundColor = [UIColor blueColor];
    [contentInsetbottomButton addTarget:self action:@selector(insetBottomClick) forControlEvents:UIControlEventTouchUpInside];
    [contentInsetbottomButton setTitle:@"点击改变底部contentInset" forState:UIControlStateNormal];
    [self.view addSubview:contentInsetbottomButton];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)insetTopClick{
    
    dsScrollerView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0); //依次表示为上，左，下，右
}

- (void)insetBottomClick{
    
    dsScrollerView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0); //依次表示为上，左，下，右
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"%f",scrollView.contentOffset.y);  //scrollView.contentOffset.y>0表示向上滚动
    
    if (scrollView == dsScrollerView2) {
        CGPoint currentOffset = scrollView.contentOffset;
        //子scroller已经在顶部，topbar还没到顶部，继续向上滚动
        if (currentOffset.y>0&&dsScrollerView.contentOffset.y<topBarOrginY) {
            scrollView.contentOffset = CGPointMake(0, 0);
            dsScrollerView.contentOffset = CGPointMake(0, dsScrollerView.contentOffset.y+currentOffset.y);
        }
        
        //向下滚动
        if (currentOffset.y<=0&&dsScrollerView.contentOffset.y<=topBarOrginY) {
            scrollView.contentOffset = CGPointMake(0, 0);
            dsScrollerView.contentOffset = CGPointMake(0, dsScrollerView.contentOffset.y + currentOffset.y);
        }
    }
    if (scrollView == dsScrollerView) {
        
        CGPoint currentOffset = scrollView.contentOffset;
        
        //向上滚动
        if (currentOffset.y>=topBarOrginY) {
            scrollView.contentOffset = CGPointMake(0, topBarOrginY);
            //topbar停在顶部，子scroller还可以向上滚动（下面是判断子scroller是否已经滚动到底部）
            if(dsScrollerView2.contentOffset.y+(currentOffset.y-topBarOrginY)<(dsScrollerView2.contentSize.height-dsScrollerView2.frame.size.height)){
                
                dsScrollerView2.contentOffset = CGPointMake(0, dsScrollerView2.contentOffset.y+(currentOffset.y-topBarOrginY));
            }
        }
        
        //向下滚动
        if(currentOffset.y<topBarOrginY&&dsScrollerView2.contentOffset.y>0){
            //topbar停在顶部，子scroller还可以向下滚动
            scrollView.contentOffset = CGPointMake(0, topBarOrginY);
            dsScrollerView2.contentOffset = CGPointMake(0, dsScrollerView2.contentOffset.y - (topBarOrginY-currentOffset.y ));
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
