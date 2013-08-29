//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Henok T on 8/25/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "SetGameViewController.h"
#import "Card.h"
#import "SetCard.h"
#import "CardMatchingGame.h"
#import "SetCardDeck.h"
#import "FlipResult.h"

@interface SetGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSDictionary *colors;
@property (strong, nonatomic) NSDictionary *alphas;
@end

@implementation SetGameViewController

-(CardMatchingGame *)game
{
    int matcBonus=4;
    int mismatchPenalty=2;
    if(!_game) _game=[[CardMatchingGame  alloc]  initWithCardCount:self.cardButtonsCount
                                                              deck:[[SetCardDeck alloc] init]
                                                          setCount:3
                                                        matchBonus:matcBonus
                                                   mismatchPenalty:mismatchPenalty];
    return _game;
}

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


-(void) updateCardButton:(UIButton *) cardButton withCard:(Card *) card
{
    [cardButton setAttributedTitle:[self attributedTitleForCard:(SetCard *)card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self imageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.3]] forState:UIControlStateSelected];
    cardButton.selected=card.isFaceUp;
    cardButton.enabled=!card.isUnplayable;
    cardButton.alpha=card.isUnplayable ? 0.1 : 1;
}

-(NSAttributedString *) attributedTitleForCard:(SetCard *) card
{
    NSString * titleText=[@"" stringByPaddingToLength:card.number withString:card.symbol startingAtIndex:0];
    UIColor *titleStrokeColor = self.colors[card.color];
    UIColor *titleForegroundColor = [titleStrokeColor colorWithAlphaComponent:[self.alphas[card.shading] floatValue]];
    NSDictionary *titleAttributes=@{ NSStrokeWidthAttributeName : @-5, NSStrokeColorAttributeName : titleStrokeColor, NSForegroundColorAttributeName : titleForegroundColor};
    return [[NSMutableAttributedString alloc] initWithString:titleText attributes:titleAttributes];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (NSAttributedString *) attributedTextForFlipResult:(FlipResult *) flipResult
{
    NSMutableAttributedString * flipResultAttributedText=[[NSMutableAttributedString alloc] init];
    if(flipResult){
        NSAttributedString *cardsAsAttributedText=[self attributedTitleForCards:flipResult.cards joinedBy:@"&"];
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
            [flipResultAttributedText appendAttributedString:[self attributedStringFromString:@"Flipped up "]];
            [flipResultAttributedText appendAttributedString:cardsAsAttributedText];
        }
    }
    return flipResultAttributedText;
}

-(NSAttributedString *)  attributedTitleForCards:(NSArray *) cards joinedBy:(NSString *) aString
{
    NSMutableAttributedString *attributedText=[[NSMutableAttributedString alloc] init];
    for(SetCard *card in cards){
        if(attributedText.length){
            [attributedText appendAttributedString:[self attributedStringFromString: aString]];
        }
        [attributedText appendAttributedString:[self attributedTitleForCard:card]];
    }
    return attributedText;
}



- (NSAttributedString *) attributedStringFromString:(NSString *) aString
{
    return [[NSAttributedString alloc] initWithString:aString];
}

@end
