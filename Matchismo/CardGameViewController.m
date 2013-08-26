//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Buta on 8/16/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"
#import "FlipResult.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitch;
@property (weak, nonatomic) IBOutlet UISlider *timeMachine;

@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) int flipCount;
@property (nonatomic) NSArray * playModes;

@property (nonatomic) UIImage *cardBackImage;

@end


@implementation CardGameViewController

-(CardMatchingGame *)game
{
    if(!_game) _game=[[CardMatchingGame  alloc]  initWithCardCount:self.cardButtons.count
                                                         usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

-(NSArray *)playModes
{
    if(!_playModes) _playModes=@[[NSNumber  numberWithInt:TwoCardMatchMode],[NSNumber numberWithInt:ThreeCardMatchMode]];
    return _playModes;
}

-(UIImage *)cardBackImage
{
    if(!_cardBackImage) _cardBackImage=[UIImage imageNamed:@"cardback.png"];
    return  _cardBackImage;
}

- (void)setCardButtons:(NSArray *)cardButtons{
    _cardButtons=cardButtons;
    [self  updateUI];
}

-(void)setResultLabel:(UILabel *)resultLabel
{
    _resultLabel=resultLabel;
    _resultLabel.text=@"";
}

- (void) updateUI
{
    for(UIButton *cardButton in self.cardButtons)
    {
        Card * card=[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
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
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultLabel.text = [self stringFromFlipResult:[self.game.flipResults lastObject]];
    self.resultLabel.alpha=1;
    if(self.game.flipResults.count + 2 > self.timeMachine.maximumValue){
        self.timeMachine.maximumValue += 2;
    }
    self.timeMachine.value=self.game.flipResults.count;
}

- (NSString *) stringFromFlipResult:(FlipResult *) flipResult
{
    NSString * stringFromFlipResult=@"";
    if(flipResult){
        if(flipResult.points > 0){
            stringFromFlipResult= [NSString stringWithFormat:@"Matched %@ for %d points",[flipResult.cards componentsJoinedByString:@" & "], flipResult.points];
        }
        else if(flipResult.points < 0){
            stringFromFlipResult= [NSString stringWithFormat:@"%@ don't match! %d point penalty!",[flipResult.cards componentsJoinedByString:@" & "], flipResult.points];
        }
        else{
            Card *card=[flipResult.cards lastObject];
            stringFromFlipResult= [@"Flipped up " stringByAppendingString:card.contents];
        }
    }
    return stringFromFlipResult;
}


- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
    self.modeSwitch.enabled=false;
}
     
- (void) setFlipCount:(int)flipCount
{
 _flipCount=flipCount;
 self.flipsLabel.text=[NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)deal:(UIButton *)sender {
    self.game = nil;
    self.flipCount = 0;
    [self updateUI];
    self.modeSwitch.enabled=true;
}

- (IBAction)switchMode:(UISegmentedControl *)sender {
   
    if(sender.selectedSegmentIndex < self.playModes.count){
        self.game.playMode=[self.playModes[sender.selectedSegmentIndex] intValue];
    }
    NSLog(@"Switching Mode to %d", self.game.playMode);
}

- (IBAction)timeTravel:(UISlider *)sender {
    int flipResultIndex = sender.value;
    if(flipResultIndex < self.game.flipResults.count){
        self.resultLabel.text=[self stringFromFlipResult:self.game.flipResults[flipResultIndex]];
        self.resultLabel.alpha=0.3;
    }
}

@end
