//
//  WritingStyleViewController.m
//
//  Copyright (c) 2017 Adonit. All rights reserved.
//

#import "WritingStyleViewController.h"
#import "WritingStyleSelectionView.h"
#import <AdonitSDK/AdonitSDK.h>

@interface WritingStyleViewController ()
@property (weak) WritingStyleSelectionView *selectedView;
@property (nonatomic, weak) IBOutlet WritingStyleSelectionView *leftAverageSelectionView;
@property (nonatomic, weak) IBOutlet WritingStyleSelectionView *leftHorizontalSelectionView;
@property (nonatomic, weak) IBOutlet WritingStyleSelectionView *leftVerticalSelectionView;
@property (nonatomic, weak) IBOutlet WritingStyleSelectionView *rightAverageSelectionView;
@property (nonatomic, weak) IBOutlet WritingStyleSelectionView *rightHorizontalSelectionView;
@property (nonatomic, weak) IBOutlet WritingStyleSelectionView *rightVerticalSelectionView;

@property (nonatomic) CALayer *separatorContainerView;
@property (nonatomic) CALayer *verticalSeparatorView;
@property (nonatomic) CALayer *topHorizontalSeparatorView;
@property (nonatomic) CALayer *bottomHorizontalSeparatorView;
@end

const static CGFloat SeperatorInsetPercentage = 0.04;

@implementation WritingStyleViewController

- (void)viewDidLoad
{
    [self setupSeparatorViews];
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Writing Style", @"Writing Style View Controller Title");
    NSLog(@"[JotStylusManager sharedInstance].writingStyle == %lu",(unsigned long)[JotStylusManager sharedInstance].writingStyle);
    switch ([JotStylusManager sharedInstance].writingStyle) {
        case JotWritingStyleLeftAverage:
            self.selectedView = self.leftAverageSelectionView;
            break;
        case JotWritingStyleLeftHorizontal:
            self.selectedView = self.leftHorizontalSelectionView;
            break;
        case JotWritingStyleLeftVertical:
            self.selectedView = self.leftVerticalSelectionView;
            break;
        case JotWritingStyleRightAverage:
            self.selectedView = self.rightAverageSelectionView;
            break;
        case JotWritingStyleRightHorizontal:
            self.selectedView = self.rightHorizontalSelectionView;
            break;
        case JotWritingStyleRightVertical:
            self.selectedView = self.rightVerticalSelectionView;
            break;
    }
    NSLog(@"self.selectedView == %@",self.selectedView);
    self.selectedView.selected = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateViewWithAppearanceSettings];
    [self updateSeparatorFrames];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updateSeparatorFrames];
}

-(NSBundle *)getResourcesBundle
{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"AdonitSDK" withExtension:@"bundle"]];
    return bundle;
}

-(UIImage *)loadImageFromResourceBundle:(NSString *)imageName
{
    NSBundle *bundle = [self getResourcesBundle];
    NSString *imageFileName = [NSString stringWithFormat:@"%@.png",imageName];
    UIImage *image = [UIImage imageNamed:imageFileName inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}
#pragma mark - IBAction

- (IBAction)writingStyleTapped:(UITapGestureRecognizer *)recognizer
{
    WritingStyleSelectionView *tappedView = (WritingStyleSelectionView *)recognizer.view;
    self.selectedView.selected = NO;
    tappedView.selected = YES;
    self.selectedView = tappedView;
    JotStylusManager *stylusManager = [JotStylusManager sharedInstance];
    
    if (self.selectedView == self.leftAverageSelectionView) {
        stylusManager.writingStyle = JotWritingStyleLeftAverage;
    } else if (self.selectedView == self.leftHorizontalSelectionView) {
        stylusManager.writingStyle = JotWritingStyleLeftHorizontal;
    } else if (self.selectedView == self.leftVerticalSelectionView) {
        stylusManager.writingStyle = JotWritingStyleLeftVertical;
    } else if (self.selectedView == self.rightAverageSelectionView) {
        stylusManager.writingStyle = JotWritingStyleRightAverage;
    } else if (self.selectedView == self.rightHorizontalSelectionView) {
        stylusManager.writingStyle = JotWritingStyleRightHorizontal;
    } else if (self.selectedView == self.rightVerticalSelectionView) {
        stylusManager.writingStyle = JotWritingStyleRightVertical;
    }
}

#pragma mark - Separators

- (void)setupSeparatorViews
{
    self.separatorContainerView = [[CALayer alloc]init];
    [self.view.layer addSublayer:self.separatorContainerView];
    
    self.verticalSeparatorView = [[CALayer alloc]init];
    [self.separatorContainerView addSublayer:self.verticalSeparatorView];
    
    self.topHorizontalSeparatorView = [[CALayer alloc]init];
    [self.separatorContainerView addSublayer:self.topHorizontalSeparatorView];
    
    self.bottomHorizontalSeparatorView = [[CALayer alloc]init];
    [self.separatorContainerView addSublayer:self.bottomHorizontalSeparatorView];
}

- (void)updateSeparatorFrames
{
    self.separatorContainerView.frame = self.view.bounds;
    self.verticalSeparatorView.frame = CGRectMake(self.separatorContainerView.bounds.size.width / 2.0, 0, 1.0, self.separatorContainerView.bounds.size.height);
    self.topHorizontalSeparatorView.frame = CGRectMake(0, (self.separatorContainerView.bounds.size.height / 3.0), self.separatorContainerView.bounds.size.width, 1.0);
    self.bottomHorizontalSeparatorView.frame = CGRectMake(0, (self.separatorContainerView.bounds.size.height / 3.0) * 2.0, self.separatorContainerView.bounds.size.width, 1.0);
    
    CGFloat horizontalInsetAmount = self.topHorizontalSeparatorView.bounds.size.width * SeperatorInsetPercentage;
    CGFloat verticalInsetAmount = self.verticalSeparatorView.bounds.size.height * SeperatorInsetPercentage;
    CGFloat insetAmount = MAX(horizontalInsetAmount, verticalInsetAmount);
    
    self.verticalSeparatorView.frame = CGRectInset(self.verticalSeparatorView.frame, 0, insetAmount);
    self.topHorizontalSeparatorView.frame = CGRectInset(self.topHorizontalSeparatorView.frame, insetAmount, 0);
    self.bottomHorizontalSeparatorView.frame = CGRectInset(self.bottomHorizontalSeparatorView.frame, insetAmount, 0);
}

#pragma mark - Selection Views

- (NSArray *)arrayOfSelectionViews
{
    if (self.leftHorizontalSelectionView && self.leftAverageSelectionView && self.leftVerticalSelectionView && self.rightHorizontalSelectionView && self.rightAverageSelectionView && self.rightVerticalSelectionView) {
        return @[self.leftHorizontalSelectionView, self.leftAverageSelectionView, self.leftVerticalSelectionView, self.rightHorizontalSelectionView, self.rightAverageSelectionView, self.rightVerticalSelectionView];
    } else {
        return nil;
    }
}

- (void)updateViewWithAppearanceSettings
{
    
    self.view.backgroundColor = [UIColor jotSecondaryColor];
   
    [self setLineSeparatorColor:[UIColor jotSeparatorColor]];
    [self setSelectionViewsUnSelectedColor:[UIColor jotSeparatorColor]];
    [self setSelectionViewsSelectedColor:[UIColor jotPrimaryColor]];
}

- (void)setSelectionViewsSelectedColor:(UIColor *)selectedColor
{
    for (WritingStyleSelectionView *selectionView in [self arrayOfSelectionViews]) {
        selectionView.selectedColor = selectedColor;
    }
}

- (void)setSelectionViewsUnSelectedColor:(UIColor *)unSelectedColor
{
    for (WritingStyleSelectionView *selectionView in [self arrayOfSelectionViews]) {
        selectionView.unSelectedColor = unSelectedColor;
    }
}

- (void)setLineSeparatorColor:(UIColor *)seperatorColor
{
    self.verticalSeparatorView.backgroundColor = seperatorColor.CGColor;
    self.topHorizontalSeparatorView.backgroundColor = seperatorColor.CGColor;
    self.bottomHorizontalSeparatorView.backgroundColor = seperatorColor.CGColor;
}

@end
