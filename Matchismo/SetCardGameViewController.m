//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Henok T on 8/25/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "Card.h"
#import "SetCard.h"
#import "CardMatchingGame.h"
#import "SetCardDeck.h"
#import "FlipResult.h"
#import "SetCardCollectionViewCell.h"

@interface SetCardGameViewController ()
@property (strong, nonatomic) NSDictionary *colors;
@property (strong, nonatomic) NSDictionary *alphas;

@end

@implementation SetCardGameViewController

-(NSDictionary *)colors
{
    if(!_colors) _colors=@{@"red":[UIColor redColor], @"green":[UIColor greenColor], @"purple":[UIColor purpleColor]};
    return _colors;
}

-(NSDictionary *)alphas
{
    if(!_alphas) _alphas=@{@"solid":@(0), @"striped":@(0.3), @"open":@(1)};
    return _alphas;
}

-(NSUInteger)startingCardCount
{
    return 12;
}

-(Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

-(NSUInteger)numberOfCardsToMatch
{
    return 3;
}

-(int)matchBonus
{
    return 4;
}

-(int)mismatchPenality
{
    return 2;
}


- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card alwaysFaceUp:(BOOL)alwaysFaceUp //abstract
{
    if([cell isKindOfClass:[SetCardCollectionViewCell class]] && [card isKindOfClass:[SetCard class]]){
        SetCardVew *setCardView = ((SetCardCollectionViewCell *) cell).setCardView;
        SetCard *setCard = (SetCard *) card;
        setCardView.number = setCard.number;
        setCardView.symbol = setCard.symbol;
        setCardView.shading = setCard.shading;
        setCardView.color = setCard.color;
        setCardView.faceUp = alwaysFaceUp || setCard.faceUp;
        //setCardView.alpha = setCard.isUnplayable ? 0.1 : 1;
    }
}

@end
