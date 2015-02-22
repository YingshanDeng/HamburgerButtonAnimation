//
//  ViewController.m
//  HamburgerButtonAnimation
//
//  Created by YingshanDeng on 15/2/19.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "ViewController.h"

#import "HamburgerButtonOne.h"
#import "HamburgerButtonTwo.h"

@interface ViewController ()

@property (nonatomic, strong) HamburgerButtonOne *btnOne;

@property (nonatomic, strong) HamburgerButtonTwo *btnTwo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:58.0 / 255.0 green:120.0 / 255.0 blue:238.0 / 255.0 alpha:1.0f];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    self.btnOne = [[HamburgerButtonOne alloc] initWithFrame:CGRectZero];
    self.btnOne.transform = CGAffineTransformMakeScale(4.0, 4.0);
    self.btnOne.center = CGPointMake(screenRect.size.width / 2, screenRect.size.height / 2 - 100);
    [self.btnOne addTarget:self action:@selector(btnOntPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnOne];
    
    
    self.btnTwo = [[HamburgerButtonTwo alloc] initWithFrame:CGRectZero];
    self.btnTwo.transform = CGAffineTransformMakeScale(2.0, 2.0);
    self.btnTwo.center = CGPointMake(screenRect.size.width / 2, screenRect.size.height / 2 + 100);
    [self.btnTwo addTarget:self action:@selector(btnTowPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnTwo];
    

}


- (void)btnOntPressed:(id)sender
{
    self.btnOne.showMenu = !self.btnOne.showMenu;
}

- (void)btnTowPressed:(id)sender
{
    self.btnTwo.showMenu = !self.btnTwo.showMenu;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
