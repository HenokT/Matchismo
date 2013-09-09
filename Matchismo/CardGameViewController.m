//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Buta on 8/16/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "CardMatchingGame.h"
#import "FlipResult.h"

@interface CardGameViewController ()<UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UISlider *timeMachine;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;

@property (strong, nonatomic) CardMatchingGame *game;

@end

@implementation CardGameViewController

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.game numberOfCardsInPlay];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
	Card *card = [self.game cardAtIndex:indexPath.item];

	[self updateCell:cell usingCard:card animate:NO];
	return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
	// abstract
}

- (CardMatchingGame *)game
{
	if (!_game)
	{
		_game = [[CardMatchingGame  alloc] initWithCardCount:self.startingCardCount
														deck:[self createDeck]
										numberOfCardsToMatch:self.numberOfCardsToMatch
												  matchBonus:self.matchBonus
											 mismatchPenalty:self.mismatchPenality];
	}
	return _game;
}

- (Deck *)createDeck
{
    // abstract
	return nil;
}                                    

- (void)setResultLabel:(UILabel *)resultLabel
{
	_resultLabel = resultLabel;
	_resultLabel.text = @"";
}

- (void)updateUIWhileAnimatingCardAtIndex:(NSUInteger)index
{
	for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells])
	{
		NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
		Card *card = [self.game cardAtIndex:indexPath.item];
		[self updateCell:cell usingCard:card animate:(!card.isUnplayable && indexPath.item == index)];
	}
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
	self.resultLabel.attributedText = [self attributedDescriptionOfFlipResult:[self.game.flipResults lastObject]];
	self.resultLabel.alpha = 1;
    self.addCardsButton.enabled= !self.game.deckEmpty;
    self.addCardsButton.alpha = self.game.deckEmpty? 0.3 : 1;
	// adjusting the maximum value for the slider based on the flip result count
	if (self.game.flipResults.count + 2 > self.timeMachine.maximumValue)
	{
		self.timeMachine.maximumValue += 2;
	}
	self.timeMachine.value = self.game.flipResults.count;
    
    
}

- (NSAttributedString *)attributedDescriptionOfFlipResult:(FlipResult *)flipResult
{
	NSString *flipResultDescription = @"";

	if (flipResult)
	{
        NSString *cardsInvolvedAsString = [flipResult.cardsInvolved componentsJoinedByString:@" & "];
		if (flipResult.points > 0)
		{
			flipResultDescription = [NSString stringWithFormat:@"Matched %@ for %d points", cardsInvolvedAsString, flipResult.points];
		}
		else if (flipResult.points < 0)
		{
			flipResultDescription = [NSString stringWithFormat:@"%@ don't match! %d point penalty!", cardsInvolvedAsString, flipResult.points];
		}
		else
		{
            flipResultDescription = [NSString stringWithFormat:@"Flipped up %@", cardsInvolvedAsString];
		}
	}
	return [[NSAttributedString alloc] initWithString:flipResultDescription];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
	CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
	NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
	
    if (indexPath)
	{
		[self.game flipCardAtIndex:indexPath.item];
        [self removeMatchingCardsIfPresent];
        [self updateUIWhileAnimatingCardAtIndex:indexPath.item];
    }
    
}


-(void)removeMatchingCardsIfPresent
{
        FlipResult * flipResult = [self.game.flipResults lastObject];
    
        if(flipResult.points > 0){ //we have a match
            
            NSMutableArray *indexPaths = [NSMutableArray array];
            
            for(Card *card in flipResult.cardsInvolved){
                int cardIndex = [self.game indexOfCard:card];
                if(cardIndex != NSNotFound){
                    [indexPaths addObject:[NSIndexPath indexPathForItem:cardIndex inSection:0]];
                }
            }
            
            [self.game removeCards:flipResult.cardsInvolved];
            
            [self.cardCollectionView deleteItemsAtIndexPaths:indexPaths];
        }
}

- (IBAction)addMoreCards:(UIButton *)sender
{
    [self.game addMoreCardsToPlay:3];
    [self.cardCollectionView reloadData];
    NSIndexPath *lastItemIndexPath = [NSIndexPath indexPathForItem:self.game.numberOfCardsInPlay - 1 inSection:0];
    [self.cardCollectionView scrollToItemAtIndexPath:lastItemIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    [self updateUIWhileAnimatingCardAtIndex:NSNotFound];
}

- (IBAction)deal:(UIButton *)sender
{
	self.game = nil;
    [self.cardCollectionView reloadData];
    [self updateUIWhileAnimatingCardAtIndex:NSNotFound];
}


- (IBAction)timeTravel:(UISlider *)sender
{
	int flipResultIndex = sender.value;

	if (flipResultIndex < self.game.flipResults.count)
	{
		self.resultLabel.attributedText = [self attributedDescriptionOfFlipResult:self.game.flipResults[flipResultIndex]];
		self.resultLabel.alpha = 0.3;
	}
}

@end