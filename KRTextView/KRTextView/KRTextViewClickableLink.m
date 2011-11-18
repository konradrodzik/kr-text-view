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



#import "KRTextViewClickableLink.h"
#import <QuartzCore/QuartzCore.h>
#import "KRTextView.h"

@implementation KRTextViewClickableLink

@synthesize displayedLinkText;
@synthesize matchedText;
@synthesize data;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		displayedLinkText = [[UIButton alloc] initWithFrame:CGRectMake(-5.0f, -5.0f, self.layer.bounds.size.width+10.0f, self.layer.bounds.size.height+10.0f)];
        [self addSubview:displayedLinkText];
        [displayedLinkText addTarget:self action:@selector(runSelector:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

- (void)dealloc {
    [displayedLinkText release];
    [matchedText release];
    [data release];
    
    [super dealloc];
}

-(void)runSelector:(id)senderi
{
    if(data.runSelector != nil && matchedText != nil) {
        data.runSelector(matchedText);  
    }
}

@end
