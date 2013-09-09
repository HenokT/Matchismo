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


-(void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate; //abstract
{
    if([cell isKindOfClass:[SetCardCollectionViewCell class]] && [card isKindOfClass:[SetCard class]]){
        SetCardVew *setCardView = ((SetCardCollectionViewCell *) cell).setCardView;
        SetCard *setCard = (SetCard *) card;
        setCardView.number = setCard.number;
        setCardView.symbol = setCard.symbol;
        setCardView.shading = setCard.shading;
        setCardView.color = setCard.color;
        setCardView.faceUp = setCard.faceUp;
        setCardView.alpha = setCard.isUnplayable ? 0.1 : 1;
    }
}


- (NSAttributedString *) attributedDescriptionOfFlipResult:(FlipResult *) flipResult
{
    NSMutableAttributedString * flipResultAttributedText=[[NSMutableAttributedString alloc] init];
    if(flipResult){
        NSAttributedString *cardsAsAttributedText=[self attributedTitlesOfCards:flipResult.cardsInvolved joinedBy:@" & "];
        if(flipResult.points > 0){
            [flipResultAttributedText appendAttributedString:[self attributedStringFromString:@"Matched "]];
            [flipResultAttributedText appendAttributedString:cardsAsAttributedText];
            [flipResultAttributedText appendAttributedString:[self attributedStringFromString:[NSString stringWithFormat: @" for %d points", flipResult.points]]];
        }
        else if(flipResult.points < 0){
            [flipResultAttributedText appendAttributedString:cardsAsAttributedText];
            [flipResultAttributedText appendAttributedString:[self attributedStringFromString: [NSString stringWithFormat:@" don't match! %d point penalty!",flipResult.points]]];
        }
        else{
            [flipResultAttributedText appendAttributedString:[self attributedStringFromString:@"Selected "]];
            [flipResultAttributedText appendAttributedString:cardsAsAttributedText];
        }
    }
    return flipResultAttributedText;
}

-(NSAttributedString *)  attributedTitlesOfCards:(NSArray *) cards joinedBy:(NSString *) aString
{
    NSMutableAttributedString *attributedText=[[NSMutableAttributedString alloc] init];
    for(Card *card in cards){
        if([card isKindOfClass:[SetCard class]]){
            SetCard * setCard=(SetCard *) card;
            if(attributedText.length){
                [attributedText appendAttributedString:[self attributedStringFromString: aString]];
            }
            [attributedText appendAttributedString:[self attributedTitleOfCard:setCard]];
        }
    }
    return attributedText;
}

-(NSAttributedString *) attributedTitleOfCard:(SetCard *) card
{
    NSString * titleText=[@"" stringByPaddingToLength:card.number withString:card.symbol startingAtIndex:0];
    UIColor *titleStrokeColor = self.colors[card.color];
    UIColor *titleForegroundColor = [titleStrokeColor colorWithAlphaComponent:[self.alphas[card.shading] floatValue]];
    NSDictionary *titleAttributes=@{ NSStrokeWidthAttributeName : @-5, NSStrokeColorAttributeName : titleStrokeColor, NSForegroundColorAttributeName : titleForegroundColor};
    return [[NSMutableAttributedString alloc] initWithString:titleText attributes:titleAttributes];
}


- (NSAttributedString *) attributedStringFromString:(NSString *) aString
{
    return [[NSAttributedString alloc] initWithString:aString];
}

@end
