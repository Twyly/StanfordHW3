//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Teddy Wyly on 8/15/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayingCardView;

@interface PlayingCardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end
