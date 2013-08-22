//
//  SetCardView.m
//  Matchismo
//
//  Created by Teddy Wyly on 8/19/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#define SYMBOL_HEIGHT_PERCENTAGE 0.20
#define SYMBOL_WIDTH_PERCENTAGE 0.5

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5.0];
    
    [roundedRect addClip];
    
    UIColor *cardColor = !self.faceUp ? [UIColor whiteColor] : [UIColor orangeColor];
    [cardColor setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    UIColor *colorOfSymbol = nil;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ([self.color isEqualToString:@"red"]) {
        colorOfSymbol = [UIColor redColor];
    } else if ([self.color isEqualToString:@"green"]) {
        colorOfSymbol = [UIColor greenColor];
    } else if ([self.color isEqualToString:@"purple"]) {
        colorOfSymbol = [UIColor purpleColor];
    }
    
    // Create a Rect in the center of the CollectionViewCell that is proportional to its size.
    
    CGRect symbolRect = CGRectMake(self.bounds.size.width / 2.0 - (self.bounds.size.width * SYMBOL_WIDTH_PERCENTAGE) / 2.0, self.bounds.size.height / 2.0  - (self.bounds.size.height * SYMBOL_HEIGHT_PERCENTAGE) / 2.0, self.bounds.size.width * SYMBOL_WIDTH_PERCENTAGE, self.bounds.size.height * SYMBOL_HEIGHT_PERCENTAGE);
    
    
    if (self.number == 1) {
        
        [self drawAppropiateSymbolInRect:symbolRect withColor:colorOfSymbol inContext:context];

    } else if (self.number == 2) {
        
        CGRect topRect = symbolRect;
        topRect.origin.y = (2/3.0) * symbolRect.origin.y;
        CGRect bottomRect = symbolRect;
        bottomRect.origin.y = (4/3.0) * symbolRect.origin.y;
        
        [self drawAppropiateSymbolInRect:topRect withColor:colorOfSymbol inContext:context];
        [self drawAppropiateSymbolInRect:bottomRect withColor:colorOfSymbol inContext:context];
        
        
    } else if (self.number == 3) {
        
        CGRect topRect = symbolRect;
        topRect.origin.y = (1/3.0) * symbolRect.origin.y;
        CGRect bottomRect = symbolRect;
        bottomRect.origin.y = (5/3.0) * symbolRect.origin.y;
        
        [self drawAppropiateSymbolInRect:topRect withColor:colorOfSymbol inContext:context];
        [self drawAppropiateSymbolInRect:symbolRect withColor:colorOfSymbol inContext:context];
        [self drawAppropiateSymbolInRect:bottomRect withColor:colorOfSymbol inContext:context];
        
        
    }
    
    
    

    
    
}

- (void)drawAppropiateSymbolInRect:(CGRect)symbolRect withColor:(UIColor *)colorOfSymbol inContext:(CGContextRef)context
{
    if ([self.symbol isEqualToString:@"oval"]) {
        
        [self drawOvalInRect:symbolRect withColor:colorOfSymbol andShading:self.shading inContext:context];
        
    } else if ([self.symbol isEqualToString:@"diamond"]) {
        
        [self drawDiamondInRect:symbolRect withColor:colorOfSymbol andShading:self.shading inContext:context];
        
    } else if ([self.symbol isEqualToString:@"squiggle"]) {
        
        [self drawSquiggleInRect:symbolRect withColor:colorOfSymbol andShading:self.shading inContext:context];
        
    }
}


- (void)drawOvalInRect:(CGRect)rect withColor:(UIColor *)color andShading:(NSString *)shading inContext:(CGContextRef)context
{
    
    CGContextSaveGState(context);
    
    
    UIBezierPath *oval = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10.0, 10.0)];
    
    UIColor *fillColor = color;
    
    if ([shading isEqualToString:@"solid"]) {
        fillColor = [color colorWithAlphaComponent:1.0];
    } else if ([shading isEqualToString:@"striped"]) {
        fillColor = [color colorWithAlphaComponent:0.3];
    } else if ([shading isEqualToString:@"open"]) {
        fillColor = [color colorWithAlphaComponent:0.0];
    }
    
    [fillColor setFill];
    [oval fill];
    
    [color setStroke];
    [oval stroke];
    
    CGContextRestoreGState(context);
    
}

- (void)drawDiamondInRect:(CGRect)rect withColor:(UIColor *)color andShading:(NSString *)shading inContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    
    UIColor *fillColor = color;
    
    if ([shading isEqualToString:@"solid"]) {
        fillColor = [color colorWithAlphaComponent:1.0];
    } else if ([shading isEqualToString:@"striped"]) {
        fillColor = [color colorWithAlphaComponent:0.3];
    } else if ([shading isEqualToString:@"open"]) {
        fillColor = [color colorWithAlphaComponent:0.0];
    }
    
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, rect.size.height / 2.0)];
    [path addLineToPoint:CGPointMake(rect.size.width / 2.0, 0)];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height / 2.0)];
    [path addLineToPoint:CGPointMake(rect.size.width / 2.0, rect.size.height)];
    [path closePath];
    
    [fillColor setFill];
    [path fill];
    
    [color setStroke];
    [path stroke];
    
    CGContextRestoreGState(context);
}

- (void)drawSquiggleInRect:(CGRect)rect withColor:(UIColor *)color andShading:(NSString *)shading inContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    
    UIColor *fillColor = color;
    
    if ([shading isEqualToString:@"solid"]) {
        fillColor = [color colorWithAlphaComponent:1.0];
    } else if ([shading isEqualToString:@"striped"]) {
        fillColor = [color colorWithAlphaComponent:0.3];
    } else if ([shading isEqualToString:@"open"]) {
        fillColor = [color colorWithAlphaComponent:0.0];
    }
    
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, rect.size.height)];
    [path addQuadCurveToPoint:CGPointMake(rect.size.width / 2.0, (1/3) * rect.size.height) controlPoint:CGPointMake(0, -rect.size.height)];
    [path addQuadCurveToPoint:CGPointMake(rect.size.width, 0.0) controlPoint:CGPointMake(rect.size.width - rect.size.width / 8.0, rect.size.height)];
    [path addQuadCurveToPoint:CGPointMake(rect.size.width / 2.0, rect.size.height) controlPoint:CGPointMake(rect.size.width, rect.size.height + rect.size.height)];
    [path addQuadCurveToPoint:CGPointMake(0.0, rect.size.height) controlPoint:CGPointMake(0.0 + rect.size.width / 4.0, 0.0)];
    
    [fillColor setFill];
    [path fill];
    
    [color setStroke];
    [path stroke];
    
    
    CGContextRestoreGState(context);
    
}

@end
