Rich text view for iOS.
iOS library for managing different colored texts with self clickable phrases. It based on TextCore library for iOS.

##### Changes in version 1.0: #####
  * Initial version.

##### Changes in version 1.1: #####
  * fixing two potential memory leaks
  * changed all TRUE,FALSE to YES,NO
  * some small refactoring


How to use:

```
KRTextView* postText = [[KRTextView alloc] initWithFontName:FONT withFontSize:20];
    
RegexpDataSelector pageOpenSelector = ^(NSString *link) {
	NSLog(@"Clicked on %@", link);
};

[postText addExpression:@"#([A-Za-z0-9_]+)" withColor:[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f] runSelector:pageOpenSelector];
[postText addExpression:@"@([A-Za-z0-9_]+)" withColor:[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f] runSelector:pageOpenSelector];
[postText addExpression:@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+" withColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f] runSelector:pageOpenSelector];

postText.clickableLinks = YES;
postText.displayedText = @"#polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl";
```