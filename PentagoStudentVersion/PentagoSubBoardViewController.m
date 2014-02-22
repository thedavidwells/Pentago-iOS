//  PENTAGO
//  PROJECT 3
//  CS470 - Spring 2014
//
//  CREATED BY DAVID WELLS
//  Copyright (c) 2014 David Wells. All rights reserved.
//  All code not provided by Professor Kooshesh is the sole work of David Wells for CS470 at Sonoma State University.

#import "PentagoSubBoardViewController.h"
#import "PentagoBrain.h"

const int BORDER_WIDTH = 10;
const int TOP_MARGIN = 50;

@interface PentagoSubBoardViewController () {
    int subsquareNumber;
    int widthOfSubsquare;
    
    CGRect _gridFrame;
}

@property (nonatomic, strong) PentagoBrain *pBrain;
@property (nonatomic, strong) UIImageView *gridImageView;
@property (nonatomic) UIView *gridView;
@property (nonatomic) CALayer *ballLayer;

@property (nonatomic, strong) UITapGestureRecognizer *tapGest;

@property (nonatomic) UISwipeGestureRecognizer *rightSwipe;
@property (nonatomic) UISwipeGestureRecognizer *leftSwipe;

-(void) didTapTheView: (UITapGestureRecognizer *) tapObject;

@end

@implementation PentagoSubBoardViewController

-(UITapGestureRecognizer *) tapGest
{
    if( ! _tapGest ) {
        _tapGest = [[UITapGestureRecognizer alloc]
                    initWithTarget:self action:@selector(didTapTheView:)];
        
        [_tapGest setNumberOfTapsRequired:1];
        [_tapGest setNumberOfTouchesRequired:1];
    }
    return _tapGest;
}

-(UISwipeGestureRecognizer *) rightSwipeGesture
{

    self.rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipeRight:)];
    [self.rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:self.rightSwipe];
    
    return _rightSwipe;
}

-(UISwipeGestureRecognizer *) leftSwipeGesture
{

    self.leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipeLeft:)];
    [self.leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:self.leftSwipe];
    
    return _leftSwipe;
}


-(PentagoBrain *) pBrain
{
    if( ! _pBrain )
        _pBrain = [PentagoBrain sharedInstance];
    return _pBrain;
}

-(UIImageView *) gridImageView
{
    if( ! _gridImageView ) {
        _gridImageView = [[UIImageView alloc] initWithFrame: CGRectZero];
    }
    return _gridImageView;
}

-(id) initWithSubsquare: (int) position
{
    // 0 1
    // 2 3
    if( (self = [super init]) == nil )
        return nil;
    subsquareNumber = position;

    // appFrame is the frame of the entire screen so that appFrame.size.width
    // and appFrame.size.height contain the width and the height of the screen, respectively.
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    widthOfSubsquare = ( appFrame.size.width - 3 * BORDER_WIDTH ) / 2;
    

    return self;
}


-(void) didTapTheView: (UITapGestureRecognizer *) tapObject
{

     // p is the location of the tap in the coordinate system of this view-controller's view (not the view of the
     // the view-controller that includes the subboards.)
     NSLog(@"Did tap the %ld view", (long)[self.view tag] );
     
     CGPoint p = [tapObject locationInView:self.view];
     int squareWidth = widthOfSubsquare / 3;
     // The board is divided into nine equally sized squares and thus width = height.
     UIImageView *iView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redMarble.png"]];
     iView.frame = CGRectMake((int) (p.x / squareWidth) * squareWidth,
     (int) (p.y / squareWidth) * squareWidth,
     squareWidth - BORDER_WIDTH / 3,
     squareWidth - BORDER_WIDTH / 3);
     [self.view addSubview:iView];
  
}



-(void) didSwipeRight: (UISwipeGestureRecognizer *) recongizer
{
    NSLog(@"Did swipe right in the the %ld view", (long)[self.view tag] );
    
    //  animationActive = YES;
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [rotate setFromValue:[NSNumber numberWithDouble:0.0]];
    [rotate setToValue: [NSNumber numberWithDouble: M_PI / 2.0]];
    [rotate setDuration:1.5];
    [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
    [rotate setDelegate:self];
    
    [[self.view layer] addAnimation:rotate forKey:@"clockwise rotation"];
}

-(void) didSwipeLeft: (UISwipeGestureRecognizer *) recongizer
{
    NSLog(@"Did swipe left in the the %ld view", (long)[self.view tag] );
    
    //  animationActive = YES;
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [rotate setFromValue:[NSNumber numberWithDouble:0.0]];
    [rotate setToValue: [NSNumber numberWithDouble: M_PI / -2.0]];
    [rotate setDuration:1.5];
    [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
    [rotate setDelegate:self];
    
    [[self.view layer] addAnimation:rotate forKey:@"counterclockwise rotation"];
    
}

/*
-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    CGPoint p = topLeftImageView.center; // hard-coded for demo only.
    p.y += widthOfSubsquare / 3 * 2;
    topLeftImageView.center = p;
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
    [rotate setToValue: [NSNumber numberWithDouble: 0]];
    [rotate setDuration:1];
    [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
    [[topLeftImageView layer] addAnimation:rotate forKey:@"marble unroates"];
}

*/



-(void)setUpGrid
{
    
    CGRect ivFrame = CGRectMake(0, 0, widthOfSubsquare, widthOfSubsquare);
    self.gridImageView.frame = ivFrame;
    UIImage *image = [UIImage imageNamed:@"grid.png"];
    [self.gridImageView setImage:image];
    [self.view addSubview:self.gridImageView];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    CGRect viewFrame = CGRectMake( (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber % 2) + BORDER_WIDTH,
                                  (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber / 2) + BORDER_WIDTH + TOP_MARGIN,
                                  widthOfSubsquare, widthOfSubsquare);
    self.view.frame = viewFrame;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUpGrid];
  
    [self.view setTag:subsquareNumber];

    
    float x = (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber % 2) + BORDER_WIDTH;
    float y = (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber / 2) + BORDER_WIDTH + TOP_MARGIN;
    NSLog(@"x = %f y = %f", x, y);
/*
    CGRect viewFrame = CGRectMake( (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber % 2) + BORDER_WIDTH,
                                  (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber / 2) + BORDER_WIDTH + TOP_MARGIN,
                                  widthOfSubsquare, widthOfSubsquare);
    self.view.frame = viewFrame;
 */
    
    [self.view addGestureRecognizer: self.tapGest];
    [self.view addGestureRecognizer: self.leftSwipeGesture];
    [self.view addGestureRecognizer: self.rightSwipeGesture];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
