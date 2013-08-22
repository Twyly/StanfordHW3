//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Teddy Wyly on 8/8/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"
#import "PlayingCardView.h"

@interface PlayingCardGameViewController ()


@end

@implementation PlayingCardGameViewController

#define PLAYING_CARD_NAME @"PlayingCardGameName"

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
    return PLAYING_CARD_NAME;
}


- (void)configureCardButton:(UIButton *)cardButton forCard:(Card *)card
{
    [cardButton setTitle:card.contents forState:UIControlStateSelected];
    [cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
    UIImage *cardback = [UIImage imageNamed:@"cardbackimage.jpeg"];
    [cardButton setBackgroundImage:(!cardButton.selected ? cardback : nil) forState:UIControlStateNormal];
    cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    
}

- (NSAttributedString *)lastFlipText
{
    NSString *string = @"";
    if ([self.game.flipStatus.cardsInvolved count] == 1) {
        Card *flippedCard = [self.game.flipStatus.cardsInvolved lastObject];
        if (flippedCard.isFaceUp) {
            string = @"";
        }
    } else if ([self.game.flipStatus.cardsInvolved count] == 2) {
        //Card *flippedCard = self.game.flipStatus.cardsInvolved[0];
        //Card *otherCard = self.game.flipStatus.cardsInvolved[1];
        if (self.game.flipStatus.successfulFlip) {
            string = [NSString stringWithFormat:@"Match for %i points!", self.game.flipStatus.pointChange];
        } else {
            string = [NSString stringWithFormat:@"No match! %i point penalty!", self.game.flipStatus.pointChange];
        }
    } else if ([self.game.flipStatus.cardsInvolved count] == 3) {
        //Card *flippedCard = self.game.flipStatus.cardsInvolved[0];
        //Card *secondCard = self.game.flipStatus.cardsInvolved[1];
        //Card *thirdCard = self.game.flipStatus.cardsInvolved[2];
        if (self.game.flipStatus.successfulFlip) {
            string = [NSString stringWithFormat:@"Match for %i points!", self.game.flipStatus.pointChange];
        } else {
            string = [NSString stringWithFormat:@"No match! %i point penalty!", self.game.flipStatus.pointChange];
        }
    }
    return [[NSAttributedString alloc] initWithString:string];;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    // put animations here!
    
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardCollectionViewCell *cardCell = (PlayingCardCollectionViewCell *)cell;
        PlayingCardView *cardView = cardCell.playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            cardView.rank = playingCard.rank;
            cardView.suit = playingCard.suit;
            cardView.faceUp = playingCard.isFaceUp;
            cardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
        
        
    }
}

- (void)addCards:(NSArray *)cards toView:(UIView *)view
{
    
    for (UIView *subView in [view subviews]) {
        [subView removeFromSuperview];
    }
    
    CGRect bounds = view.bounds;
    CGRect cardBounds = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width / 3.0, bounds.size.height);
    for (Card *card in cards) {
        if ([card isKindOfClass:[PlayingCard class]]) {
            NSUInteger index = [cards indexOfObject:card];
            cardBounds.origin.x = cardBounds.origin.x + (bounds.size.width / 3.0) * index;
            PlayingCard *playingCard = (PlayingCard *)card;
            PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:cardBounds];
            cardView.rank = playingCard.rank;
            cardView.suit = playingCard.suit;
            cardView.opaque = NO;
            cardView.faceUp = YES;
            
            [view addSubview:cardView];
        }
    }
    
}


- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)startingCardCount
{
    return 22;
}

- (BOOL)isTwoCardGame
{
    return YES;
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


@end
