//
//  MixedNumberView.m
//  SeamCalc
//
//  Created by Purbo Mohamad on 12/11/13.
//  Copyright (c) 2013 Purbo Mohamad. All rights reserved.
//

#import "MixedNumberView.h"

@interface MixedNumberView()

@property (nonatomic, strong, readwrite) UILabel *labelWhole;
@property (nonatomic, strong, readwrite) UILabel *labelNumerator;
@property (nonatomic, strong, readwrite) UILabel *labelDenominator;

@property (nonatomic, strong) UIColor *currentColor;

@end

@implementation MixedNumberView

- (id)initWithFloat:(CGFloat)floatNumber frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.whole = floor(floatNumber);
        
        // calculating float number to fractional number with int components: whole numerator/denominator
        // e.g. 1.25 -> 1 1/4
        // adapted from: http://rosettacode.org/wiki/Convert_decimal_number_to_rational#C
        
        CGFloat f = floatNumber - self.whole;
        
        NSInteger num;
        NSInteger denom;
        NSInteger md = 10;
        
        NSInteger a, h[3] = { 0, 1, 0 }, k[3] = { 1, 0, 0 };
        NSInteger x, d, n = 1;
        NSInteger i, neg = 0;
        
        if (md <= 1) {
            denom = 1;
            num = (NSInteger)f;
        } else {
            if (f < 0) { neg = 1; f = -f; }
            
            while (f != floor(f)) { n <<= 1; f *= 2; }
            d = f;
            
            /* continued fraction and check denominator each step */
            for (i = 0; i < 64; i++) {
                a = n ? d / n : 0;
                if (i && !a) break;
                
                x = d; d = n; n = x % n;
                
                x = a;
                if (k[1] * a + k[0] >= md) {
                    x = (md - k[0]) / k[1];
                    if (x * 2 >= a || k[1] >= md)
                        i = 65;
                    else
                        break;
                }
                
                h[2] = x * h[1] + h[0]; h[0] = h[1]; h[1] = h[2];
                k[2] = x * k[1] + k[0]; k[0] = k[1]; k[1] = k[2];
            }
            denom = k[1];
            num = neg ? -h[1] : h[1];
        }
        
        self.denominator = denom;
        self.numerator = num;
        
        //NSLog(@"%d %d/%d", self.whole, self.numerator, self.denominator);
        [self initLabelsWithFrame:frame];
    }
    return self;
}

- (id)initWithWhole:(NSInteger)whole numerator:(NSUInteger)numerator denominator:(NSUInteger)denominator frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.whole = whole;
        self.numerator = numerator;
        self.denominator = denominator;
        [self initLabelsWithFrame:frame];
    }
    return self;
}

- (void)setColor:(UIColor *)color
{
    if (self.labelWhole) {
        self.labelWhole.textColor = color;
    }
    if (self.labelNumerator) {
        self.labelNumerator.textColor = color;
    }
    if (self.labelDenominator) {
        self.labelDenominator.textColor = color;
    }
    self.currentColor = color;
}

- (void)initLabelsWithFrame:(CGRect)frame
{
    if (self.whole > 0 && self.numerator == 0) {
        // whole number only
        self.labelWhole = [self labelForNumber:self.whole
                                  startingSize:20.0
                                          rect:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        [self addSubview:self.labelWhole];
        self.labelNumerator = nil;
        self.labelDenominator = nil;
    } else if (self.whole == 0 && self.numerator > 0) {
        self.labelWhole = nil;
        // fractional part only
        CGFloat halfSize = frame.size.width/2.0;
        // numerator
        self.labelNumerator = [self labelForNumber:self.numerator
                                      startingSize:17.0
                                              rect:CGRectMake(0.0, 0.0, halfSize, halfSize)];
        [self addSubview:self.labelNumerator];
        // denominator
        self.labelDenominator = [self labelForNumber:self.denominator
                                        startingSize:17.0
                                                rect:CGRectMake(halfSize, halfSize, halfSize, halfSize)];
        [self addSubview:self.labelDenominator];
    } else if (self.whole > 0 && self.numerator > 0) {
        // display both whole and fractional part
        CGFloat wholeWidth = frame.size.width * 0.5;
        CGFloat fractWidth = frame.size.width * 0.6;
        CGFloat fractLeft = frame.size.width - fractWidth;
        // whole
        CGFloat magicNumber = 3.0;
        self.labelWhole = [self labelForNumber:self.whole
                                  startingSize:20.0
                                          rect:CGRectMake(0.0, -magicNumber, wholeWidth, frame.size.height)];
        [self addSubview:self.labelWhole];
        // numerator
        self.labelNumerator = [self labelForNumber:self.numerator
                                      startingSize:14.0
                                              rect:CGRectMake(fractLeft, 0.0, fractWidth/2.0, frame.size.height/2.0)];
        [self addSubview:self.labelNumerator];
        // denom
        self.labelDenominator = [self labelForNumber:self.denominator
                                        startingSize:14.0
                                                rect:CGRectMake(fractLeft + fractWidth/2.0, fractWidth/2.0, fractWidth/2.0, frame.size.height/2.0)];
        [self addSubview:self.labelDenominator];
    }
    
}

- (UILabel *)labelForNumber:(NSUInteger)number startingSize:(CGFloat)startingSize rect:(CGRect)rect
{
    NSString *str = [NSString stringWithFormat:@"%d", number];
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    CGFloat xmargin = rect.size.width * 0.15;
    CGFloat ymargin = rect.size.height * 0.15;
    label.font = [self adjustFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:startingSize]
                      toFitString:str
                               in:CGSizeMake(rect.size.width - xmargin*2, rect.size.height - ymargin*2)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = str;
    return label;
}

- (UIFont *)adjustFont:(UIFont *)font toFitString:(NSString *)string in:(CGSize)fitSize
{
    UIFont *ret = font;
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:ret}];
    while (size.width > fitSize.width /*|| size.height > fitSize.height*/) {
        ret = [UIFont fontWithDescriptor:ret.fontDescriptor size:ret.pointSize - 1];
        size = [string sizeWithAttributes:@{NSFontAttributeName:ret}];
    }
    // reduce size even more so it the text doesn't fill the whole box, except if the font is small already
    if (ret.pointSize > 12.0) {
        ret = [UIFont fontWithDescriptor:ret.fontDescriptor size:ret.pointSize - 1];
    }
    NSLog(@"Size: %@, pt: %f", NSStringFromCGSize(size), ret.pointSize);
    return ret;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.whole == 0 && self.numerator > 0) {
        // fractional part only
        CGContextSetLineWidth(context, 0.8);
        if (self.currentColor) {
            CGContextSetStrokeColorWithColor(context, self.currentColor.CGColor);
        } else {
            CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
        }
        CGContextBeginPath(context);
        CGFloat offsetX = self.bounds.size.width * 0.2;
        CGFloat offsetY = self.bounds.size.height * 0.1;
        CGContextMoveToPoint(context, offsetX, self.bounds.size.height - offsetY);
        CGContextAddLineToPoint(context, self.bounds.size.width - offsetX, offsetY);
        CGContextStrokePath(context);
    } else if (self.whole > 0 && self.numerator > 0) {
        // display both whole and fractional part
        CGFloat fractWidth = self.bounds.size.width * 0.6;
        CGFloat fractLeft = self.bounds.size.width - fractWidth;
        CGContextSetLineWidth(context, 0.8);
        if (self.currentColor) {
            CGContextSetStrokeColorWithColor(context, self.currentColor.CGColor);
        } else {
            CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
        }
        CGContextBeginPath(context);
        CGFloat offsetX = fractWidth * 0.25;
        CGFloat offsetY = self.bounds.size.height * 0.25;
        // WTF!!! TODO: do proper calculation
        CGFloat magicNumber = 3.0;
        CGContextMoveToPoint(context, fractLeft + magicNumber, self.bounds.size.height - offsetY - magicNumber);
        CGContextAddLineToPoint(context, self.bounds.size.width - offsetX, offsetY);
        CGContextStrokePath(context);
    }
}

@end
