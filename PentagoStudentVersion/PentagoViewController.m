//  PENTAGO
//  PROJECT 3
//  CS470 - Spring 2014
//
//  CREATED BY DAVID WELLS
//  Copyright (c) 2014 David Wells. All rights reserved.
//  All code not provided by Professor Kooshesh is the sole work of David Wells for CS470 at Sonoma State University.

#import "PentagoViewController.h"
#import "PentagoSubBoardViewController.h"
#import "PentagoBrain.h"

@interface PentagoViewController ()
@property (nonatomic, strong) PentagoBrain *pBrain;
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
    

    [self setGameTitleLabel];
    [self currentGameStateLabel];
    
    
    
}

-(void)setGameTitleLabel
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = frame.size.width;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, screenWidth, 50)];
    titleLabel.text = @"PENTAGO!";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];

}


-(void)currentGameStateLabel
{
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = frame.size.width;
    UILabel *gameStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 370, screenWidth, 50)];
    gameStateLabel.text = @"Get 5 in a row to win!";
    gameStateLabel.textColor = [UIColor whiteColor];
    gameStateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:gameStateLabel];
    
}


-(PentagoBrain *) pBrain
{
    if( ! _pBrain )
        _pBrain = [PentagoBrain sharedInstance];
    return _pBrain;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
