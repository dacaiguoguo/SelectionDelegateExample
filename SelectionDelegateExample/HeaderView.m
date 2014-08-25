//
//  HeaderView.m
//  FlowLayoutNoNIB
//
//  Created by Beau G. Bolle on 2012.10.29.
//
//

#import "HeaderView.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
        NSUInteger uii = (((NSUInteger)self >> 4) % 256);
        CGFloat hue = uii / 255.0;
        UIColor *color = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
		[self setBackgroundColor:color];
	}
	return self;
}

@end
