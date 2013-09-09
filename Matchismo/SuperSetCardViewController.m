//
//  SuperSetCardControllerViewController.m
//  Matchismo
//
//  Created by Henok T on 9/7/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "SuperSetCardViewController.h"
#import "Deck.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "Card.h"
#import "SetCardVew.h"

@interface SuperSetCardViewController ()
@property (weak, nonatomic) IBOutlet SetCardVew *setCardView;
@property (strong, nonatomic) Deck *deck;

@end

@implementation SuperSetCardViewController

- (void)setSetCardView:(SetCardVew *)setCardView
{
	_setCardView = setCardView;
	[self drawRandomSetCard];
}

- (Deck *)deck
{
	if (!_deck)
	{
		_deck = [[SetCardDeck alloc] init];
	}
	return _deck;
}

- (void)drawRandomSetCard
{
	Card *card = [self.deck drawRandomCard];
    
	if ([card isKindOfClass:[SetCard class]])
	{
		SetCard *setCard = (SetCard *)card;
		self.setCardView.number = setCard.number;
		self.setCardView.symbol = setCard.symbol;
		self.setCardView.shading = setCard.shading;
		self.setCardView.color = setCard.color;
	}
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    
    //    [UIView transitionWithView:self.setCardView
    //					  duration:0.5
    //					   options:UIViewAnimationOptionTransitionFlipFromLeft
    //					animations:^{
    //                        if (!self.setCardView.faceUp)
    //                        {
    //                         [self drawRandomSetCard];
    //                        }
    //                        self.setCardView.faceUp = !self.setCardView.faceUp;
    //                    }
    //     
    //					completion:NULL];
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    
    if (!self.setCardView.faceUp)
    {
        [self drawRandomSetCard];
    }
    self.setCardView.faceUp = !self.setCardView.faceUp;
}

@end
