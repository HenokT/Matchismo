//
//  SetCardVew.m
//  Matchismo
//
//  Created by Henok T on 9/7/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "SetCardVew.h"

@interface SetCardVew()
@property (strong, nonatomic) NSDictionary *colors;
@property (strong, nonatomic) NSDictionary *alphas;
@property (strong, nonatomic) UIImage *selectedCardBackgroundImage;
@end

@implementation SetCardVew

-(NSDictionary *)colors
{
    if(!_colors) _colors=@{@"red":[UIColor redColor], @"green":[UIColor greenColor], @"purple":[UIColor purpleColor]};
    return _colors;
}

-(NSDictionary *)alphas
{
    if(!_alphas) _alphas=@{@"solid":@(0), @"striped":@(0.3), @"open":@(1)};
    return _alphas;
}

#define CORNER_RADIUS 12.0

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	// Drawing code
	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
	[roundedRect addClip];
    
    if([self faceUp]){
        [[[UIColor grayColor] colorWithAlphaComponent:0.3] setFill];
    }
    else{
        [[UIColor whiteColor] setFill];
    }
	[roundedRect fill];
    
    [self drawSymbols];
   
}

-(void) drawSymbols
{
    UIColor *strokeColor=self.colors[self.color];
    [strokeColor setStroke];
    [[strokeColor colorWithAlphaComponent:[self.alphas[self.shading] floatValue] ]  setFill];
    
    CGSize cardSize=self.bounds.size;
    
    CGFloat symbolRectWidth = cardSize.width * 0.5;
    CGSize symbolRectSize = CGSizeMake(symbolRectWidth, symbolRectWidth/2);
    CGFloat symbolRectGap = symbolRectSize.height * 0.4;
    CGPoint symbolRectOrigin = CGPointMake((cardSize.width - symbolRectSize.width)/2, (cardSize.height - self.number * symbolRectSize.height - (self.number -1) * symbolRectGap)/2);
    
    for(int i=0; i < self.number; i++){
        if([self.symbol isEqualToString:@"oval"]){
            [self drawOvalInRectWithOrigin:symbolRectOrigin andSize:symbolRectSize];
        }
        else if([self.symbol isEqualToString:@"diamond"]){
            [self drawDiamondInRectWithOrigin:symbolRectOrigin andSize:symbolRectSize];
        }
        else{
            [self drawSquiggleInRectWithOrigin:symbolRectOrigin andSize:symbolRectSize];
        }
        symbolRectOrigin.y += (symbolRectSize.height + symbolRectGap);
    }

}

-(void)drawOvalInRectWithOrigin:(CGPoint)origin andSize:(CGSize) size
{
	CGRect rect = CGRectMake(origin.x, origin.y, size.width, size.height);
	UIBezierPath *oval = [UIBezierPath bezierPathWithOvalInRect:rect];
    [oval stroke];
    [oval fill];
}

-(void)drawDiamondInRectWithOrigin:(CGPoint) origin andSize:(CGSize) size
{
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(origin.x, origin.y + size.height/2)];
    [path addLineToPoint:CGPointMake(origin.x + size.width/2, origin.y)];
    [path addLineToPoint:CGPointMake(origin.x + size.width, origin.y + size.height/2)];
    [path addLineToPoint:CGPointMake(origin.x + size.width/2, origin.y + size.height)];
    [path closePath];
    [path stroke];
    [path fill];
}

-(void) drawSquiggleInRectWithOrigin:(CGPoint) origin andSize:(CGSize) size
{
    // UIBezierPath * rect = [UIBezierPath bezierPathWithRect:CGRectMake(origin.x, origin.y, size.width,size.height)];
    //[rect stroke];
    //[rect addClip];
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(origin.x, origin.y + size.height)];
    [path addQuadCurveToPoint:CGPointMake(origin.x + size.width * 0.5, origin.y + size.height * 0.25) controlPoint:CGPointMake(origin.x, origin.y - size.height * 0.5)];
    [path addQuadCurveToPoint:CGPointMake(origin.x + size.width, origin.y) controlPoint:CGPointMake(origin.x + size.width, origin.y + size.height)];
    
    [path moveToPoint:CGPointMake(origin.x + size.width, origin.y)];
    [path addQuadCurveToPoint:CGPointMake(origin.x + size.width * 0.5, origin.y + size.height * 0.75) controlPoint:CGPointMake(origin.x+ size.width, origin.y + size.height * 1.5)];
    [path addQuadCurveToPoint:CGPointMake(origin.x, origin.y + size.height) controlPoint:CGPointMake(origin.x, origin.y)];
    
    [path stroke];
    [path fill];
}

- (void)setNumber:(NSUInteger)number
{
	_number = number;
	[self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)symbol
{
	_symbol = symbol;
	[self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
	_shading = shading;
	[self setNeedsDisplay];
}

- (void)setColor:(NSString *)color
{
	_color = color;
	[self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
	_faceUp  = faceUp;
	[self setNeedsDisplay];
}

-(UIImage *)selectedCardBackgroundImage
{
    if(!_selectedCardBackgroundImage) _selectedCardBackgroundImage=[self imageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.3]];
    return _selectedCardBackgroundImage;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setup
{
	// Initialization code
}

- (void)awakeFromNib
{
	[self setup];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		[self setup];
	}
	return self;
}

@end