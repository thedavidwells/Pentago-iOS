//
//  PentagoViewController.m
//  PentagoStudentVersion
//
//  Created by AAK on 2/17/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import "PentagoViewController.h"
#import "PentagoSubBoardViewController.h"

@interface PentagoViewController ()
@property (nonatomic, strong) NSMutableArray *subViewControllers;
@end

@implementation PentagoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSMutableArray *) subViewControllers
{
    if( ! _subViewControllers )
        _subViewControllers = [[NSMutableArray alloc] initWithCapacity:4];
    return _subViewControllers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    [self.view setFrame:frame];
    
    // This is our root view-controller. Each of the quadrants of the game is
    // represented by a different view-controller. We create them here and add their views to the
    // view of the root view-controller.
    for (int i = 0; i < 4; i++) {
        PentagoSubBoardViewController *p = [[PentagoSubBoardViewController alloc] initWithSubsquare:i];
        [p.view setBackgroundColor:[UIColor blackColor]];
        [self.subViewControllers addObject: p];
        [self.view addSubview: p.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
