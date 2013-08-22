//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Teddy Wyly on 8/8/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardCollectionViewCell.h"
#import "SetCardView.h"
#import "SetCard.h"

@interface SetCardGameViewController ()

@property (nonatomic) NSUInteger cardCount;

@end

@implementation SetCardGameViewController

#define SET_CARD_NAME @"SetCardGameName"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)gameName
{
    return SET_CARD_NAME;
}

- (BOOL)isTwoCardGame
{
    return NO;
}


- (void)configureCardButton:(UIButton *)cardButton forCard:(Card *)card
{
    [cardButton setAttributedTitle:[self displayAttributedContentsFromString:card.contents] forState:UIControlStateNormal];
    [cardButton setBackgroundColor:cardButton.isSelected ? [UIColor lightGrayColor] : [UIColor whiteColor]];
    cardButton.alpha = cardButton.isEnabled ? 1.0 : 0.0;
    
}



- (NSAttributedString *)lastFlipText
{
    NSString *string = @"";
    if ([self.game.flipStatus.cardsInvolved count] == 1 || [self.game.flipStatus.cardsInvolved count] == 2) {
        //
    } else if ([self.game.flipStatus.cardsInvolved count] == 3) {
        if (self.game.flipStatus.successfulFlip) {
            string = [NSString stringWithFormat:@"Match for %i points!", self.game.flipStatus.pointChange];
        } else {
            string = [NSString stringWithFormat:@"No match! %i point penalty!", self.game.flipStatus.pointChange];
        }
    }
    
    return [[NSAttributedString alloc] initWithString:string];;
}

- (NSAttributedString *)displayAttributedContentsFromString:(NSString *)contents
{
    // Array of (number, color, shadeing, symbol
    NSArray *components = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *symbol = @"";
    if ([components[3] isEqualToString:@"diamond"]) {
        symbol = @"▲";
    } else if ([components[3] isEqualToString:@"squiggle"]) {
        symbol = @"■";
    } else if ([components[3] isEqualToString:@"oval"]) {
        symbol = @"●";
    }
    
    NSUInteger number = [components[0] integerValue];
    NSMutableString *mutableString = [@"" mutableCopy];
    
    for (NSUInteger count = 1; count <= number; count++) {
        mutableString = [[mutableString stringByAppendingString:symbol] mutableCopy];
    }
    
    
    
    float alpha = 1.0;
    if ([components[2] isEqualToString:@"solid"]) {
        alpha = 1.0;
    } else if ([components[2] isEqualToString:@"striped"]) {
        alpha = 0.3;
    } else if ([components[2] isEqualToString:@"open"]) {
        alpha = 0.0;
    }
    
    
    UIColor *color = nil;
    if ([components[1] isEqualToString:@"red"]) {
        color = [UIColor redColor];
    } else if ([components[1] isEqualToString:@"green"]) {
        color = [UIColor greenColor];
    } else if ([components[1] isEqualToString:@"purple"]) {
        color = [UIColor purpleColor];
    }
    
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@""];
    if (components) {
        attributedString = [[NSAttributedString alloc] initWithString:mutableString attributes:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:alpha], NSStrokeColorAttributeName : color, NSStrokeWidthAttributeName : @-5}];

    }
    
    return attributedString;
    
    
    
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    // put animations here!
    
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardCollectionViewCell *cardCell = (SetCardCollectionViewCell *)cell;
        SetCardView *cardView = cardCell.setCardView;
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            cardView.number = setCard.number;
            cardView.symbol = setCard.symbol;
            cardView.shading = setCard.shading;
            cardView.color = setCard.color;
            cardView.faceUp = setCard.isFaceUp;
            cardView.alpha = setCard.isUnplayable ? 0.3 : 1.0;
        }
        
    }
}

- (void)addCards:(NSArray *)cards toView:(UIView *)view
{
    for (UIView *subView in [view subviews]) {
        [subView removeFromSuperview];
    }
    
    CGRect bounds = view.bounds;
    for (Card *card in cards) {
        if ([card isKindOfClass:[SetCard class]]) {
            CGRect cardBounds = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width / 3.33, bounds.size.height);
            NSUInteger index = [cards indexOfObject:card];
            cardBounds.origin.x = cardBounds.origin.x + (cardBounds.size.width) * index;
            SetCard *setCard = (SetCard *)card;
            SetCardView *cardView = [[SetCardView alloc] initWithFrame:cardBounds];
            cardView.number = setCard.number;
            cardView.symbol = setCard.symbol;
            cardView.color = setCard.color;
            cardView.shading = setCard.shading;
            cardView.opaque = NO;
            cardView.faceUp = NO;
            
            [view addSubview:cardView];
        }
    }
    
}

- (IBAction)showSetButtonPressed:(UIButton *)sender
{
    
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSUInteger)startingCardCount
{
    return 12;
}

- (void)addMoreCards
{
    [self.game drawCardsFromDeck:3];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


@end
