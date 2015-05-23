//
//  ViewController.m
//  Painter
//
//  Created by Karl Stiefvater on 5/2/15.
//  Copyright (c) 2015 Karl Stiefvater. All rights reserved.
//

#import "ViewController.h"
#import "PainterView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PainterView* painterView = [[PainterView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:painterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
