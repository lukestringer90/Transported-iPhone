//
//  TRNNaPTANEntryViewController.m
//  Transport
//
//  Created by Luke Stringer on 30/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNNaPTANEntryViewController.h"
#import "TRNLiveDataViewController.h"
#import "TRNNaPTANInfoViewController.h"

typedef NS_ENUM(NSInteger, EntryTableViewSection) {
    EntryTableViewSectionNaPTAN,
	EntryTableViewSectionSubmit,
	EntryTableViewSectionCount
};


static NSString * const NaPTANCellID = @"NaPTANCellID";
static NSString * const SubmitCellID = @"SubmitCellID";

@interface TRNNaPTANEntryViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *NaPTANCodeText;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UINavigationController *infoViewNavController;
@end

@implementation TRNNaPTANEntryViewController

- (instancetype)init {
	self = [super init];
	if (self) {
		self.title = @"Code Entry";
		
		self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NaPTANCellID];
		[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SubmitCellID];
		
		self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
		self.textField.delegate = self;
		self.textField.keyboardType = UIKeyboardTypeDecimalPad;
		self.textField.returnKeyType = UIReturnKeyDone;
		self.textField.placeholder = @"8 digit code";
        
        self.infoViewNavController = [[UINavigationController alloc] initWithRootViewController:[TRNNaPTANInfoViewController new]];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
	[self.view addSubview:self.tableView];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self setupBarButtonItems];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	self.tableView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (void)setupBarButtonItems {
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showInfoViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
}

- (void)showInfoViewController {
    [self presentViewController:self.infoViewNavController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == EntryTableViewSectionSubmit) {
		[self NaPTANCodeWasEntryFinished];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return EntryTableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
	
	switch (indexPath.section) {
		case EntryTableViewSectionNaPTAN:
			cell = [self NaPTANEntryCell];
			break;
		case EntryTableViewSectionSubmit:
			cell = [self submitCell];
			break;
		default:
			break;
	}
    
    return cell;
}

- (UITableViewCell *)NaPTANEntryCell {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NaPTANCellID];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	CGFloat xInset = 15.0f;
	self.textField.frame = CGRectMake(xInset,
									  CGRectGetMinY(cell.contentView.frame),
									  CGRectGetWidth(cell.contentView.frame) - (2 * xInset),
									  CGRectGetHeight(cell.contentView.frame));
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	[cell.contentView addSubview:self.textField];
	
	return cell;
}

- (UITableViewCell *)submitCell {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SubmitCellID];
	cell.textLabel.text = @"Get Live Departures";
    cell.textLabel.textColor = self.view.tintColor;
	cell.textLabel.textAlignment = NSTextAlignmentCenter;
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return section == EntryTableViewSectionNaPTAN ? @"Enter NaPTAN Code:" : nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.textField resignFirstResponder];
	[self NaPTANCodeWasEntryFinished];
	return YES;
}

- (void)NaPTANCodeWasEntryFinished {
	if (self.textField.text.length > 0) {
//		TRNLiveDataViewController *liveDataViewController = [[TRNLiveDataViewController alloc] initWithNaPTANCode:self.textField.text];
//		[self.navigationController pushViewController:liveDataViewController animated:YES];
	}
}


@end
