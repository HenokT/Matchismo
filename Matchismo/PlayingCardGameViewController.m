//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Henok T on 8/31/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
@interface PlayingCardGameViewController ()
@property (nonatomic) UIImage *cardBackImage;
@end

@implementation PlayingCardGameViewController

- (NSUInteger)numberOfCardsToMatch
{
    return 2;
}

-(Deck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}

-(int)matchBonus
{
    return 4;
}

-(int)mismatchPenality
{
    return 2;
}

-(void) updateCardButton:(UIButton *) cardButton withCard:(Card *) card
{
    [cardButton  setTitle:card.contents
                 forState:UIControlStateSelected];
    [cardButton  setTitle:card.contents
                 forState:UIControlStateSelected|UIControlStateDisabled];
    cardButton.selected=card.isFaceUp;
    [cardButton setImage:(card.isFaceUp?nil:self.cardBackImage) forState:UIControlStateNormal];
    cardButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    cardButton.enabled=!card.isUnplayable;
    cardButton.alpha=card.isUnplayable ? 0.3 : 1;
}

-(UIImage *)cardBackImage
{
    if(!_cardBackImage) _cardBackImage=[UIImage imageNamed:@"cardback.png"];
    return  _cardBackImage;
}

@end
