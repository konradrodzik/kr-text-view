KRTextView**postText = [[alloc](KRTextView.md) initWithFontName:FONT withFontSize:20];**

> RegexpDataSelector pageOpenSelector = ^(NSString **link) {
> > NSLog(@"Clicked on %@", link);

> };**

> [addExpression:@"#([A-Za-z0-9\_](postText.md)+)" withColor:[colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f](UIColor.md) runSelector:pageOpenSelector];
> [addExpression:@"@([A-Za-z0-9\_](postText.md)+)" withColor:[colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f](UIColor.md) runSelector:pageOpenSelector];
> [addExpression:@"(http|https)://((\\w)\*|([0-9](postText.md)_)|([-|**])**)+([\\.|/]((\\w)**|([0-9]**)|([-|_])**))+" withColor:[colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f](UIColor.md) runSelector:pageOpenSelector];**

> postText.clickableLinks = TRUE;
> postText.displayedText = @"#polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl #polidea @konradrodzik http://www.polidea.pl";

> self.view = postText;
> self.view.backgroundColor = [grayColor](UIColor.md);