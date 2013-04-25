//
//  MainViewController.m
//  OX
//
//  Created by huimin liu on 4/24/13.
//  Copyright (c) 2013 huimin liu. All rights reserved.
//

#import "MainViewController.h"
#import "StageView.h"
#import "StageViewCell.h"

#define STAGE_SIZE 276
#define PLAYER_MARK @"X"
#define ROBOT_MARK @"O"

@interface MainViewController () {
	StageView *_stageView;
	NSMutableArray *_marks;
	int _steps;
	BOOL _isGameOver;
	BOOL _isRobotThinking;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		_steps = 0;
		_isGameOver = NO;
		_isRobotThinking = NO;
		_marks = [@[@"", @"", @"", @"", @"", @"", @"", @"", @"",] mutableCopy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor blackColor];
	
	UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
	resetButton.frame = CGRectMake(200, 30, 100, 40);
	resetButton.titleLabel.font = [UIFont systemFontOfSize:32];
	[resetButton setTitle:@"Reset" forState:UIControlStateNormal];
	[resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[resetButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
	[resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:resetButton];
	
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.itemSize = CGSizeMake(90, 90.);
	layout.minimumInteritemSpacing = 3.;
	layout.minimumLineSpacing = 3.;
	
	_stageView = [[StageView alloc] initWithFrame:CGRectMake(22, self.view.bounds.size.height - STAGE_SIZE - 40, STAGE_SIZE, STAGE_SIZE) collectionViewLayout:layout];
	_stageView.scrollEnabled = NO;
	_stageView.backgroundColor = [UIColor redColor];
	[_stageView registerClass:[StageViewCell class] forCellWithReuseIdentifier:@"StageViewCell"];
	[self.view addSubview:_stageView];
	
	_stageView.dataSource = self;
	_stageView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	StageViewCell *cell = (StageViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"StageViewCell" forIndexPath:indexPath];
	return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	StageViewCell *cell = (StageViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
	if ([cell.mark isEqualToString:@""] && !_isGameOver && !_isRobotThinking) {
		cell.mark = PLAYER_MARK;
		_marks[indexPath.row] = PLAYER_MARK;
		_steps++;
		
		if ([self doesGameOverByMark:PLAYER_MARK]) {
			[self showMessage:@"You win~"];
		} else if (_steps == 9) {
			[self showMessage:@"Tie.."];
		} else {
			_isRobotThinking = YES;
			[self performSelector:@selector(robotGoes) withObject:nil afterDelay:0.5];
		}
	}
}

#pragma mark - UICollectionViewDelegateFlowLayout

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//	return UIEdgeInsetsMake(22, 22, 22, 22);
//}

#pragma mark - private methods

- (void)reset
{
	for (int i = 0; i < 9; i++) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
		StageViewCell *cell = (StageViewCell *)[_stageView cellForItemAtIndexPath:indexPath];
		cell.mark = @"";
		cell.shining = NO;
		_marks[i] = @"";
	}
	_steps = 0;
	_isGameOver = NO;
}

- (BOOL)doesGameOverByMark:(NSString *)mark
{
	//穷举吧..
	if ([_marks[0] isEqualToString:mark]) {
		if ([_marks[1] isEqualToString:mark] && [_marks[2] isEqualToString:mark]) {
			[self highlightTheRoute:@[@0, @1, @2]];
			return YES;
		} else if ([_marks[3] isEqualToString:mark] && [_marks[6] isEqualToString:mark]) {
			[self highlightTheRoute:@[@0, @3, @6]];
			return YES;
		} else if ([_marks[4] isEqualToString:mark] && [_marks[8] isEqualToString:mark]) {
			[self highlightTheRoute:@[@0, @4, @8]];
			return YES;
		}
	}
	if ([_marks[4] isEqualToString:mark]) {
		if ([_marks[1] isEqualToString:mark] && [_marks[7] isEqualToString:mark]) {
			[self highlightTheRoute:@[@4, @1, @7]];
			return YES;
		} else if ([_marks[2] isEqualToString:mark] && [_marks[6] isEqualToString:mark]) {
			[self highlightTheRoute:@[@4, @2, @6]];
			return YES;
		} else if ([_marks[3] isEqualToString:mark] && [_marks[5] isEqualToString:mark]) {
			[self highlightTheRoute:@[@4, @3, @5]];
			return YES;
		}
	}
	if ([_marks[8] isEqualToString:mark]) {
		if ([_marks[2] isEqualToString:mark] && [_marks[5] isEqualToString:mark]) {
			[self highlightTheRoute:@[@8, @2, @5]];
			return YES;
		} else if ([_marks[6] isEqualToString:mark] && [_marks[7] isEqualToString:mark]) {
			[self highlightTheRoute:@[@8, @6, @7]];
			return YES;
		}
	}
	return NO;
}

//轮到傻傻的机器人了..
- (void)robotGoes
{
	int index = -1;
	
	index = [self findTheLoopholdByMark:ROBOT_MARK]; //机器人进攻
	
	if (index == -1) {
		index = [self findTheLoopholdByMark:PLAYER_MARK]; //机器人防守
	}

	//无果，则随机走一步
	if (index == -1) {
		NSMutableArray *blank = [NSMutableArray arrayWithCapacity:9];
		for (int i = 0; i < 9; i++) {
			if ([_marks[i] isEqualToString:@""]) {
				[blank addObject:[NSNumber numberWithInt:i]];
			}
		}
		int random = arc4random() % [blank count];
		index = [blank[random] intValue];
	}
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	StageViewCell *cell = (StageViewCell *)[_stageView cellForItemAtIndexPath:indexPath];
	
	cell.mark = ROBOT_MARK;
	_marks[index] = ROBOT_MARK;
	_steps++;
	
	if ([self doesGameOverByMark:ROBOT_MARK]) {
		[self showMessage:@"You lose..."];
	} else if (_steps == 9) {
		[self showMessage:@"Tie.."];
	}
	_isRobotThinking = NO;
}

//穷举找枪眼..囧
- (int)findTheLoopholdByMark:(NSString *)mark
{
	int index = -1;

	if ([_marks[0] isEqualToString:mark]) {
		if ([_marks[1] isEqualToString:mark] && [_marks[2] isEqualToString:@""]) {
			index = 2;
		} else if ([_marks[2] isEqualToString:mark] && [_marks[1] isEqualToString:@""]) {
			index = 1;
		} else if ([_marks[3] isEqualToString:mark] && [_marks[6] isEqualToString:@""]) {
			index = 6;
		} else if ([_marks[6] isEqualToString:mark] && [_marks[3] isEqualToString:@""]) {
			index = 3;
		} else if ([_marks[4] isEqualToString:mark] && [_marks[8] isEqualToString:@""]) {
			index = 8;
		} else if ([_marks[8] isEqualToString:mark] && [_marks[4] isEqualToString:@""]) {
			index = 4;
		}
	}
	if ([_marks[1] isEqualToString:mark]) {
		if ([_marks[2] isEqualToString:mark] && [_marks[0] isEqualToString:@""]) {
			index = 0;
		} else if ([_marks[4] isEqualToString:mark] && [_marks[7] isEqualToString:@""]) {
			index = 7;
		} else if ([_marks[7] isEqualToString:mark] && [_marks[4] isEqualToString:@""]) {
			index = 4;
		}
	}
	if ([_marks[2] isEqualToString:mark]) {
		if ([_marks[4] isEqualToString:mark] && [_marks[6] isEqualToString:@""]) {
			index = 6;
		} else if ([_marks[6] isEqualToString:mark] && [_marks[4] isEqualToString:@""]) {
			index = 4;
		} else if ([_marks[5] isEqualToString:mark] && [_marks[8] isEqualToString:@""]) {
			index = 8;
		} else if ([_marks[8] isEqualToString:mark] && [_marks[5] isEqualToString:@""]) {
			index = 5;
		}
	}
	if ([_marks[3] isEqualToString:mark]) {
		if ([_marks[6] isEqualToString:mark] && [_marks[0] isEqualToString:@""]) {
			index = 0;
		} else if ([_marks[4] isEqualToString:mark] && [_marks[5] isEqualToString:@""]) {
			index = 5;
		} else if ([_marks[5] isEqualToString:mark] && [_marks[4] isEqualToString:@""]) {
			index = 4;
		}
	}
	if ([_marks[4] isEqualToString:mark]) {
		if ([_marks[8] isEqualToString:mark] && [_marks[0] isEqualToString:@""]) {
			index = 0;
		} else if ([_marks[7] isEqualToString:mark] && [_marks[1] isEqualToString:@""]) {
			index = 1;
		} else if ([_marks[6] isEqualToString:mark] && [_marks[2] isEqualToString:@""]) {
			index = 2;
		} else if ([_marks[5] isEqualToString:mark] && [_marks[3] isEqualToString:@""]) {
			index = 3;
		}
	}
	if ([_marks[5] isEqualToString:mark]) {
		if ([_marks[8] isEqualToString:mark] && [_marks[2] isEqualToString:@""]) {
			index = 2;
		}
	}
	if ([_marks[6] isEqualToString:mark]) {
		if ([_marks[7] isEqualToString:mark] && [_marks[8] isEqualToString:@""]) {
			index = 8;
		} else if ([_marks[8] isEqualToString:mark] && [_marks[7] isEqualToString:@""]) {
			index = 7;
		}
	}
	if ([_marks[7] isEqualToString:mark]) {
		if ([_marks[8] isEqualToString:mark] && [_marks[6] isEqualToString:@""]) {
			index = 6;
		}
	}
	return index;
}

- (void)highlightTheRoute:(NSArray *)route
{
	for (int i = 0; i < [route count]; i++) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[route[i] intValue] inSection:0];
		StageViewCell *cell = (StageViewCell *)[_stageView cellForItemAtIndexPath:indexPath];
		cell.shining = YES;
	}
}

- (void)showMessage:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
													message:nil
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	_isGameOver = YES;
}

@end
