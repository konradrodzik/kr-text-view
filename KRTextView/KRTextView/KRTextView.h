/*
 Copyright (c) 2011, Konrad Rodzik, Polidea
 All rights reserved.
 
 mailto: konrad.rodzik@gmail.com
 
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


#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "KRTextViewClickableLink.h"

typedef void(^RegexpDataSelector)(NSString*);
@interface RegexpData : NSObject 
{
    NSString *regExp;
    UIColor *regExpColor;
    RegexpDataSelector runSelector;
    NSMutableArray* matchedResults;
}
@property(nonatomic, retain) NSString *regExp;
@property(nonatomic, retain) UIColor *regExpColor;
@property(nonatomic, copy) RegexpDataSelector runSelector;
@property(nonatomic, retain) NSMutableArray* matchedResults;
@end

@interface KRTextView : UIView {
    NSString* displayedText;
    NSMutableAttributedString* displayedTextAttributes;
    NSMutableArray* displayedTextAttributesRangeArray;
    CTFrameRef displayedTextFrame;
    
    BOOL clickableLinks;
    
    NSString* fontName;
    CTFontRef fontObject;
    float fontSize;
    
    NSMutableArray *regexpDataArray;
}

@property (nonatomic, retain) NSString* displayedText;
@property (nonatomic, retain) NSMutableAttributedString *displayedTextAttributes;
@property (nonatomic, retain) NSMutableArray* displayedTextAttributesRangeArray;
@property CTFrameRef displayedTextFrame;

@property BOOL clickableLinks;

@property (nonatomic, retain) NSString* fontName;
@property CTFontRef fontObject;
@property float fontSize;

-(id) initWithFontName:(NSString *)_fontName withFontSize:(CGFloat)_fontSize;
-(id) initWithFrame:(CGRect)_frame withTextString:(NSString *)_string withFontName:(NSString *)_fontName withFontSize:(CGFloat)_fontSize;

-(void) addExpression:(NSString*)regExp withColor:(UIColor*)color;
-(void) addExpression:(NSString*)regExp withColor:(UIColor*)color runSelector:(RegexpDataSelector) selector;

-(void) clearAllExpressions;

@end
