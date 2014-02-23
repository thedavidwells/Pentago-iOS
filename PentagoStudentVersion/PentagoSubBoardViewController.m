//  PENTAGO
//  PROJECT 3
//  CS470 - Spring 2014
//
//  CREATED BY DAVID WELLS
//  Copyright (c) 2014 David Wells. All rights reserved.
//  All code not provided by Professor Kooshesh is the sole work of David Wells for CS470 at Sonoma State University.

#import "PentagoSubBoardViewController.h"
#import "PentagoBrain.h"
#import "PentagoViewController.h"

const int BORDER_WIDTH = 10;
const int TOP_MARGIN = 50;

@interface PentagoSubBoardViewController () {
    int subsquareNumber;
    int widthOfSubsquare;
    
    CGRect _gridFrame;
}

@property(nonatomic) CALayer *blueLayer;

@property (nonatomic, strong) PentagoBrain *pBrain;
@property(nonatomic) PentagoViewController *pView;
@property (nonatomic, strong) UIImageView *gridImageView;
@property (nonatomic) UIView *gridView;
@property (nonatomic) CALayer *ballLayer;

@property (nonatomic, strong) UITapGestureRecognizer *tapGest;

@property (nonatomic) UISwipeGestureRecognizer *rightSwipe;
@property (nonatomic) UISwipeGestureRecognizer *leftSwipe;

-(void) didTapTheView: (UITapGestureRecognizer *) tapObject;

@end




@implementation PentagoSubBoardViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpGridView];
    [self initPositionArray];
    
    [self.pBrain createGridArray:self.view];
}




-(void)setUpGridView
{
    
    _gridFrame = CGRectMake(0, 0, widthOfSubsquare, widthOfSubsquare);
    self.gridView = [[UIView alloc] initWithFrame: _gridFrame];
    [self.gridView addGestureRecognizer:self.rightSwipe];
    [self.gridView addGestureRecognizer:self.leftSwipe];
    [self.view addSubview: self.gridView];
    
    self.gridImageView.frame = CGRectMake(0, 0, 145, 145);
    
    UIImage *image = [UIImage imageNamed:@"grid.png"];
    [self.gridImageView setImage:image];
    [self.gridView addSubview:self.gridImageView];
    [self.gridView addGestureRecognizer: self.tapGest];
    [self.gridView setBackgroundColor:[UIColor blackColor]];
    
    [self.view setTag:subsquareNumber];
    
    CGRect viewFrame = CGRectMake( (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber % 2) + BORDER_WIDTH,
                                  (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber / 2) + BORDER_WIDTH + TOP_MARGIN,
                                  widthOfSubsquare, widthOfSubsquare);
    self.view.frame = viewFrame;
    
}


-(void)initPositionArray
{
    if (self.positionArray == nil) {
        self.positionArray = [[NSMutableArray alloc] init];
    }
}


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

-(UISwipeGestureRecognizer *) rightSwipe
{

    if( !_rightSwipe ) {
        _rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
        [_rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    }
    return _rightSwipe;
}

-(UISwipeGestureRecognizer *) leftSwipe
{

    if( !_leftSwipe ) {
        _leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
        [_leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    }
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
    
    CGPoint p = [tapObject locationInView:self.gridView];
    int squareWidth = widthOfSubsquare / 3;
    // The board is divided into nine equally sized squares and thus width = height.
    UIImageView *iView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"donut_chocolate.png"]];
    
    if (self.pBrain.currentPlayer == player1) {
        iView.image = [UIImage imageNamed:@"donut_strawberry.png"];
        NSLog(@"Player 1's turn");
    }
    else if (self.pBrain.currentPlayer == player2){
        iView.image = [UIImage imageNamed:@"donut_chocolate.png"];
        NSLog(@"Player 2's turn");
    }

    iView.frame = CGRectMake((int) (p.x / squareWidth) * squareWidth,
                             (int) (p.y / squareWidth) * squareWidth,
                             squareWidth,
                             squareWidth);
    
    NSLog(@"p.x value: %f, p.y value: %f", p.x, p.y);
    
    [self determineArrayPosition:p];
    
    
    self.ballLayer = [CALayer layer];
    [self.ballLayer addSublayer: iView.layer];
    self.ballLayer.frame = CGRectMake(0, 0, widthOfSubsquare, widthOfSubsquare);
    self.ballLayer.affineTransform = CGAffineTransformMakeRotation(0.0);
    [self.gridView.layer addSublayer:self.ballLayer];
    
    [self.pBrain switchPlayers];
    [PentagoViewController changeGameStateLabel];
    
}


-(void)determineArrayPosition: (CGPoint)point
{
    // Column 1
    if (point.x < 49) {
        if ( point.y < 49) {
            NSLog(@"array index 0");
            // [self.positionArray addObject: ]
        }
        else if ( point.y < 96) {
            NSLog(@"array index 3");
        }
        else if ( point.y < 145) {
            NSLog(@"array index 6");
        }
    }
    
    // Column 2
    else if (point.x < 96){
        if ( point.y < 49) {
            NSLog(@"array index 1");
        }
        else if ( point.y < 96) {
            NSLog(@"array index 4");
        }
        else if ( point.y < 145) {
            NSLog(@"array index 7");
        }
    }
    
    // Column 3
    else if (point.x < 145){
        if ( point.y < 49) {
            NSLog(@"array index 2");
        }
        else if ( point.y < 96) {
            NSLog(@"array index 5");
        }
        else if ( point.y < 145) {
            NSLog(@"array index 8");
        }
    }
    
    
}


-(void) didSwipeRight: (UISwipeGestureRecognizer *) recongizer
{
    NSLog(@"Did swipe right in the the %ld view", (long)[self.view tag] );
    
    [self.view bringSubviewToFront:self.gridView];
    
    CGAffineTransform currTransform = self.gridView.layer.affineTransform;
    [UIView animateWithDuration:.15 animations:^ {
        CGAffineTransform newTransform = CGAffineTransformConcat(currTransform, CGAffineTransformMakeRotation(M_PI/2));
        self.gridView.layer.affineTransform = newTransform;
    }];
    

    [self.view addGestureRecognizer:self.rightSwipe];
    
}

-(void) didSwipeLeft: (UISwipeGestureRecognizer *) recongizer
{
    NSLog(@"Did swipe left in the the %ld view", (long)[self.view tag] );
    
    [self.view bringSubviewToFront:self.gridView];
    
    CGAffineTransform currTransform = self.gridView.layer.affineTransform;
    [UIView animateWithDuration:.15 animations:^ {
        CGAffineTransform newTransform = CGAffineTransformConcat(currTransform, CGAffineTransformMakeRotation(M_PI/-2));
        self.gridView.layer.affineTransform = newTransform;
    }];
    

    [self.view addGestureRecognizer:self.leftSwipe];
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
