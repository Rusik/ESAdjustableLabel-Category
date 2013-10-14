//
//  UILabel+ESAdjustableLabel.h
//  ===========================
//  This category adds a few helper methods to adjust
//  a UIlabel to fit its text.
//
//  You can specify the minimum and maximum label size,
//  minimum font size, or none at all.
//                      ----
//
//  Created by Edgar Schmidt (@edgarschmidt) on 4/14/12.
//  Copyright (c) 2012 Edgar Schmidt. All rights reserved.
//
//  This code is provided without any warranties.
//  Hack around and enjoy ;)
//

#import "UILabel+ESAdjustableLabel.h"

@implementation UILabel (ESAdjustableLabel)

- (void)adjustLabelToMaximumWidth:(CGFloat)width
                    minimumHeight:(CGFloat)height {
    [self adjustLabelToMaximumSize:CGSizeMake(width, MAXFLOAT) minimumSize:CGSizeMake(width, height) minimumFontSize:0];
}

- (void)adjustLabelToMaximumSize:(CGSize)maxSize
                     minimumSize:(CGSize)minSize
                 minimumFontSize:(int)minFontSize {
	NSLineBreakMode lineBreakMode = NSLineBreakByWordWrapping;

	[self setNumberOfLines:0];
	[self setLineBreakMode:lineBreakMode];

	if (maxSize.height == CGSizeZero.height) {
		maxSize.width = [[UIScreen mainScreen] bounds].size.width - 40.0;
		maxSize.height = MAXFLOAT; // infinite height
	}

	CGSize tempSize = [[self text] sizeWithFont:[self font]
	                          constrainedToSize:maxSize
	                              lineBreakMode:[self lineBreakMode]];

	if (minSize.height != CGSizeZero.height) {
		if (tempSize.width <= minSize.width) tempSize.width = minSize.width;
		if (tempSize.height <= minSize.height) tempSize.height = minSize.height;
	}

    if (minFontSize != 0) {
        UIFont *labelFont = [self font];            // temporary label object
        CGFloat fSize = [labelFont pointSize];      // temporary font size value
        CGSize calculatedSizeWithCurrentFontSize;   // temporary frame size

        CGSize unconstrainedSize = CGSizeMake(tempSize.width, MAXFLOAT);

        do {
            if (fSize > minFontSize) {
                labelFont = [UIFont fontWithName:[labelFont fontName]
                                            size:fSize];
                calculatedSizeWithCurrentFontSize =
                [[self text] sizeWithFont:labelFont
                        constrainedToSize:unconstrainedSize
                            lineBreakMode:lineBreakMode];
                fSize--;
            } else {
                break;
            }
        }
        while (calculatedSizeWithCurrentFontSize.height > maxSize.height);

        if ((calculatedSizeWithCurrentFontSize.height <= maxSize.height) && (calculatedSizeWithCurrentFontSize.width <= maxSize.width)) {
            [self setFont:labelFont];
            tempSize = calculatedSizeWithCurrentFontSize;
        }
    }

	CGRect newFrameSize = CGRectMake([self frame].origin.x, [self frame].origin.y, tempSize.width, tempSize.height);
	[self setFrame:newFrameSize];
}

- (void)adjustLabelToMaximumSize:(CGSize)maxSize
                 minimumFontSize:(int)minFontSize {
	[self adjustLabelToMaximumSize:maxSize
	                   minimumSize:CGSizeZero
	               minimumFontSize:minFontSize];
}

- (void)adjustLabelSizeWithMinimumFontSize:(int)minFontSize {
	[self adjustLabelToMaximumSize:CGSizeZero
	                   minimumSize:CGSizeZero
	               minimumFontSize:minFontSize];
}

- (void)adjustLabel {
	[self adjustLabelToMaximumSize:CGSizeZero
	                   minimumSize:CGSizeZero
	               minimumFontSize:0];
}

@end
