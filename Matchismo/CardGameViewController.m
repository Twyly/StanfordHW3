//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Teddy Wyly on 8/5/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "GameResult.h"

@interface CardGameViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic, readwrite) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *history; // of strings
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;
@property (weak, nonatomic) IBOutlet UIView *cardsSelectedView;

@end


@implementation CardGameViewController



- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck] isTwoCardGame:[self isTwoCardGame]];
    return _game;
}

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] initWithGameName:self.gameName];
    return _gameResult;
}

- (Deck *)createDeck
{
    return nil;
}


- (NSMutableArray *)history
{
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}



- (IBAction)dealButtonPressed:(UIButton *)sender
{
    self.game = nil;
    self.gameResult = nil;
    self.history = nil;
    [self updateUI];
}


- (IBAction)moreCardsButtonPressed:(UIButton *)sender
{
    NSUInteger numberOfCards = [self.game numberOfCardsInPlay];
    [self addMoreCards];
    NSUInteger cardsAdded = [self.game numberOfCardsInPlay] - numberOfCards;
    
    if (cardsAdded == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh oh!" message:@"No cards are left in the deck!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSUInteger item = numberOfCards; item < numberOfCards + cardsAdded; item++) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:item inSection:0];
        [array addObject:path];
    }
    
    // Fix Scrolling!
    [self.collectionView insertItemsAtIndexPaths:array];
    
    NSLog(@"%f, %f", self.collectionView.contentSize.height, self.collectionView.bounds.size.height);
    
    if (self.collectionView.contentSize.height > self.collectionView.bounds.size.height) {
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentSize.height - self.collectionView.bounds.size.height) animated:YES];
    }
}

- (void)addMoreCards
{
    // abstract method
}


- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        if ([self lastFlipText]) [self.history addObject:[self lastFlipText]];
        self.gameResult.score = self.game.score;
        [self updateUI];
    }
}

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastFlipLabel.attributedText = [self.history lastObject];
    [self addCards:self.game.flipStatus.cardsInvolved toView:self.cardsSelectedView];
    [self.collectionView reloadData];
}




- (void)configureCardButton:(UIButton *)cardButton forCard:(Card *)card
{
    // abstract method
}

// Abstract Class

- (BOOL)isTwoCardGame
{
    return NO;
}

// Abstract Method

- (NSAttributedString *)lastFlipText
{
    NSAttributedString *string = nil;
    return string;
}

# pragma mark - CollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.game numberOfCardsInPlay];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    // abstract mehod
}

- (void)addCards:(NSArray *)cards toView:(UIView *)view
{
    // abstract method
}



#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"retina_wood"]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}



@end
