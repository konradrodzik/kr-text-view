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
#import "ViewController.h"
#import "KRTextView.h"

#define FONT @"arial"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)loadView {
    KRTextView* postText = [[KRTextView alloc] initWithFontName:FONT withFontSize:20];
    
    RegexpDataSelector pageOpenSelector = ^(NSString *link) {
        NSLog(@"Clicked on %@", link);
    };
    
    [postText addExpression:@"#([A-Za-z0-9_]+)" withColor:[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f] runSelector:pageOpenSelector];
    [postText addExpression:@"@([A-Za-z0-9_]+)" withColor:[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f] runSelector:pageOpenSelector];
    [postText addExpression:@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+" withColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f] runSelector:pageOpenSelector];
    
    postText.clickableLinks = TRUE;
    postText.displayedText = @"#polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl";

    self.view = postText;
    self.view.backgroundColor = [UIColor grayColor];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
