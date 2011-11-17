/*
 Copyright (c) 2009, Konrad Rodzik, Polidea
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the Polidea nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY KONRAD RODZIK, POLIDEA ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL KONRAD RODZIK, POLIDEA BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "KRTextView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RegexpData
@synthesize regExp;
@synthesize regExpColor;
@synthesize runSelector;
@synthesize matchedResults;
-(void)dealloc {
    [regExp release];
    [regExpColor release];
    [runSelector release];
    [matchedResults release];
    
    [super dealloc];
}
@end


@implementation KRTextView

@synthesize displayedText;
@synthesize displayedTextAttributes;
@synthesize displayedTextAttributesRangeArray;
@synthesize displayedTextFrame;

@synthesize clickableLinks;

@synthesize fontName;
@synthesize fontObject;
@synthesize fontSize;

-(id) initWithFontName:(NSString *)_fontName withFontSize:(CGFloat)_fontSize {
    self = [super init];
    if (self) {
        self.fontName = _fontName;
        self.fontSize = _fontSize;
        
        regexpDataArray = [[NSMutableArray alloc] initWithCapacity:5];
        clickableLinks = FALSE;
        
        self.backgroundColor = [UIColor clearColor];
    }
    
	return self;
}

-(id)initWithFrame:(CGRect)_frame withTextString:(NSString *)_string withFontName:(NSString *)_fontName withFontSize:(CGFloat)_fontSize {
    self = [super initWithFrame:_frame];
    if (self) {
        self.displayedText = _string;
        self.fontName = _fontName;
        self.fontSize = _fontSize;
        
        regexpDataArray = [[NSMutableArray alloc] initWithCapacity:5];
        clickableLinks = FALSE;
 
        self.backgroundColor = [UIColor clearColor];
    }
    
	return self;
}

-(void) addExpression:(NSString*)regExp withColor:(UIColor*)color {
    RegexpData *regexpData = [[RegexpData alloc] init];
    regexpData.regExp = regExp;
    regexpData.regExpColor = color;
    regexpData.runSelector = nil;
    regexpData.matchedResults = [[NSMutableArray alloc] init];
    [regexpDataArray addObject:regexpData];
    [regexpData release];
}

-(void) addExpression:(NSString*)regExp withColor:(UIColor*)color runSelector:(RegexpDataSelector) selector {
    RegexpData *regexpData = [[RegexpData alloc] init];
    regexpData.regExp = regExp;
    regexpData.regExpColor = color;
    regexpData.runSelector = selector;
    regexpData.matchedResults = [[NSMutableArray alloc] init];
    [regexpDataArray addObject:regexpData];
    [regexpData release];
}

-(void) clearAllExpressions {
    [regexpDataArray removeAllObjects];
}

-(void) applyRegexpExpression:(RegexpData*)regexpExpression {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexpExpression.regExp options:NSRegularExpressionCaseInsensitive error:nil];
	[regex enumerateMatchesInString:displayedTextAttributes.string options:0 range:NSMakeRange(0, displayedTextAttributes.length) 
						 usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
							 [displayedTextAttributes addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)regexpExpression.regExpColor.CGColor range:[match range]];
							 [displayedTextAttributesRangeArray addObject:match];
                             
                             [regexpExpression.matchedResults addObject:[NSString stringWithString:[displayedTextAttributes.string substringWithRange:[match range]]]];
						 }];
}

- (void) prepareText {
    fontObject = CTFontCreateWithName((CFStringRef)self.fontName, fontSize, NULL);
    displayedTextAttributes = [[NSMutableAttributedString alloc] initWithString:self.displayedText];
    displayedTextAttributesRangeArray = [[NSMutableArray alloc] init];
    
    for(RegexpData* regexp in regexpDataArray) {
        [self applyRegexpExpression:regexp];
    }
    
    [displayedTextAttributes addAttribute:(NSString*)kCTFontAttributeName value:(id)fontObject range:NSMakeRange(0,displayedTextAttributes.length)];
    CFRelease(fontObject);

    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, self.bounds.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
	
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
	
	
    CFMutableAttributedStringRef attrString = (CFMutableAttributedStringRef)displayedTextAttributes;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFRelease(attrString);

    displayedTextFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
	
    CFRelease(framesetter);
    CGPathRelease(path);

}

-(void) prepareClickableLinks {
    for (UIView *bt in [self subviews]) {
        if ([bt class] == [KRTextViewClickableLink class]) {
            [bt removeFromSuperview];
            [bt release];
        }
    }
    if(clickableLinks && [displayedTextAttributesRangeArray count]) {
    
        CFArrayRef lines = CTFrameGetLines(displayedTextFrame);
        CFIndex i, total = CFArrayGetCount(lines);
        CGFloat y;
        NSUInteger k = 0;
        
        while (k<[displayedTextAttributesRangeArray count]) {
         
            for (i = 0; i < total; i++) {

                CGPoint origins;;
                CTFrameGetLineOrigins( displayedTextFrame, CFRangeMake(i, 1), &origins);
                CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, i);
                y = self.bounds.origin.y + self.bounds.size.height - origins.y;

                CFArrayRef runs = CTLineGetGlyphRuns(line);
                CFIndex r, runsTotal = CFArrayGetCount(runs);

                for (r = 0; r < runsTotal; r++) {
                    
                    CTRunRef run = CFArrayGetValueAtIndex(runs, r);
                    
                    if (CTRunGetStringRange(run).location == [[displayedTextAttributesRangeArray objectAtIndex:k] range].location) {
                        
                        CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                        CGRect runBounds = CTRunGetImageBounds(run, UIGraphicsGetCurrentContext(), CFRangeMake(0, 0));
                        runBounds.origin.x += xOffset;

                        KRTextViewClickableLink *firstPartOfLink = [[KRTextViewClickableLink alloc] initWithFrame:CGRectMake(round(runBounds.origin.x), round(round(y-runBounds.size.height-runBounds.origin.y)), runBounds.size.width, runBounds.size.height)];
                        
                        NSString* firstPartSelectedText = [NSString stringWithString:[displayedText substringWithRange:[[displayedTextAttributesRangeArray objectAtIndex:k] range]]];
                        for(RegexpData* data in regexpDataArray) {
                            BOOL found = false;
                            for(NSString* tmpText in data.matchedResults) {
                                if([tmpText isEqualToString:firstPartSelectedText]) {
                                    firstPartOfLink.matchedText = firstPartSelectedText;
                                    firstPartOfLink.data = data;
                                    found = TRUE;
                                    break;
                                }
                            }
                            if(found)
                                break;
                        }
   
                        [self addSubview:firstPartOfLink];

                        if (CTRunGetStringRange(CFArrayGetValueAtIndex(runs, r)).length != [[displayedTextAttributesRangeArray objectAtIndex:k] range].length) {
                            
                            CTFrameGetLineOrigins( displayedTextFrame, CFRangeMake(i+1, 1), &origins);
                            y = self.bounds.origin.y + self.bounds.size.height - origins.y;
                            runs = CTLineGetGlyphRuns((CTLineRef)CFArrayGetValueAtIndex(lines, i+1));
                            runBounds = CTRunGetImageBounds(CFArrayGetValueAtIndex(runs, 0), UIGraphicsGetCurrentContext(), CFRangeMake(0, 0));

                            KRTextViewClickableLink *secondPartOfLink = [[KRTextViewClickableLink alloc] initWithFrame:CGRectMake(round(runBounds.origin.x), round(y-runBounds.size.height-runBounds.origin.y), runBounds.size.width, runBounds.size.height)];
                            
                            NSString* secondPartSelectedText = [NSString stringWithString:[displayedText substringWithRange:[[displayedTextAttributesRangeArray objectAtIndex:k] range]]];
                            for(RegexpData* data in regexpDataArray) {
                                BOOL found = false;
                                for(NSString* tmpText in data.matchedResults) {
                                    if([tmpText isEqualToString:secondPartSelectedText]) {
                                        secondPartOfLink.matchedText = secondPartSelectedText;
                                        secondPartOfLink.data = data;
                                        found = TRUE;
                                        break;
                                    }
                                }
                                if(found)
                                    break;
                            }
                            
                            [self addSubview:secondPartOfLink];
                        }

                        r = runsTotal;
                        i = total;
                    }
                }
            }
            k++;
        }
    }
    
    [displayedTextAttributesRangeArray release];
}

- (void)drawRect:(CGRect)rect {
    [self prepareText];
    [self prepareClickableLinks];
    
    CTFrameDraw(displayedTextFrame, UIGraphicsGetCurrentContext());
	CFRelease(displayedTextFrame);
}

- (void)dealloc {
	[displayedText release];
    [displayedTextAttributes release];
    [fontName release];
    
    [self clearAllExpressions];
    [regexpDataArray release];
    
    [super dealloc];
}

@end
