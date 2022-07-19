//
//  TaskTableViewController.m
//  ToDoObjC
//
//  Created by Josue Arambula on 6/5/22.
//

#import "TaskTableViewController.h"
#import "Task.h"

static NSString *cellId = @"cell";
static NSString *deleteImageName = @"delete";
static NSString *doneImageName = @"done";
const CGFloat buttonWidth = 30.0F;
const CGFloat estimatedRowHeight = 60.0F;


@interface TaskTableViewController ()

@property (strong, nonatomic) TaskHelper * taskHelper;

@end

@implementation TaskTableViewController


- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if(self){
        self.taskHelper = [[TaskHelper alloc] init];
        self.taskHelper.tasks = [[NSMutableArray alloc] initWithCapacity:2];
        self.tableData = [NSMutableArray arrayWithObjects:
                          [[NSMutableArray alloc] init],
                          [[NSMutableArray alloc] init], nil];
        [self.tableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:cellId];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.navigationItem setTitle:@"To-Do List"];
    [self tableViewSetup];
    NSMutableArray *allTasks = [[NSMutableArray alloc] init];
    self.taskHelper.tasks = allTasks;
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                               target:self
                               action:@selector(addTaskBtn:)];
    addBtn.width = buttonWidth;
    self.navigationItem.rightBarButtonItem = addBtn;
    self.tableData = self.taskHelper.tasks;
}

-(void)tableViewSetup {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = estimatedRowHeight;
}

- (void) addTaskBtn:(UIBarButtonItem *)paramSender {
    NSLog(@"add a new task.");

    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Add a Task"
                                message:NULL
                                preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action = [UIAlertAction
                             actionWithTitle: @"Add"
                             style: UIAlertActionStyleDefault
                             handler: ^ (UIAlertAction * _Nonnull action) {

        NSString *name = [[alert textFields].firstObject.text
                          stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        Task *task = [[Task alloc] initWithName:name isDone:NO];
        [self.taskHelper addTask:task atIndex:0 isDone:NO];

        [self.tableView beginUpdates];
        NSInteger sections = [self.tableView numberOfSections];
        if (sections <= 0) {
            NSIndexSet* insertSection = [NSIndexSet indexSetWithIndex:0];
            [self.tableView insertSections:insertSection
                          withRowAnimation:UITableViewRowAnimationTop];
        } else {
            // at least we have one section. Adding a task always goes to the first section; section 0
            NSArray *insertIndexPaths = [[NSArray alloc] initWithObjects:
                                         [NSIndexPath indexPathForRow:0
                                                            inSection:0], nil];
            [self.tableView insertRowsAtIndexPaths:insertIndexPaths
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.tableView endUpdates];
    }];

    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
      {
        textField.placeholder = @"Enter task name...";
        textField.textColor = [UIColor redColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textField addTarget:self
                      action:@selector(handleTextChanged:)
            forControlEvents:UIControlEventEditingChanged];
      }
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:NULL];
    [alert addAction: action];
    [alert addAction: cancel];
    [self presentViewController:alert animated:YES completion:nil];

    if (alert) {
        //go and get the action field
        UITextField *alertText1 = alert.textFields.firstObject;
        [self handleTextChanged:alertText1];
    }
}

-(void)handleTextChanged:(UITextField *)sender {

    if ([self.presentedViewController isKindOfClass:[UIAlertController class]]) {
        // Hide/unhide or add button
        UIAlertController *alert = (UIAlertController *)self.presentedViewController;
        UIAlertAction *addAction = [alert actions].firstObject;
        NSString *text = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ( [text length] == 0 ) {
            [addAction setEnabled:NO];
        } else {
            [addAction setEnabled:YES];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.taskHelper.tasks count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.taskHelper.tasks objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];
    Task *task = self.taskHelper.tasks[indexPath.section][indexPath.row];
    cell.textLabel.text = task.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section == 0 ? @"To-Do" : @"Done";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0;
}

#pragma mark - Table view delegate

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *delete = [UIContextualAction
                                  contextualActionWithStyle:UIContextualActionStyleDestructive
                                  title:@"DELETE"
                                  handler:^(UIContextualAction * _Nonnull action,
                                            __kindof UIView * _Nonnull sourceView,
                                            void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"index path of delete: %@", indexPath);
        [self.taskHelper removeTaskAtIndex:indexPath.row isDone:indexPath.section];
        [self.tableView beginUpdates];
        NSInteger sections = [self.tableView numberOfSections];
        if (sections <= 0) {
            NSIndexSet* insertSection = [NSIndexSet indexSetWithIndex:0];
            [self.tableView insertSections:insertSection
                          withRowAnimation:UITableViewRowAnimationTop];
        }
        NSArray *insertIndexPaths = [[NSArray alloc] initWithObjects:
                                     [NSIndexPath indexPathForRow:indexPath.row
                                                        inSection:indexPath.section], nil];
        [self.tableView deleteRowsAtIndexPaths:insertIndexPaths
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        completionHandler(YES);
    }];

    delete.backgroundColor = [UIColor redColor];
    [delete setImage:[UIImage imageNamed:deleteImageName]];

    UISwipeActionsConfiguration *swipeActionConfig = [UISwipeActionsConfiguration
                                                      configurationWithActions:@[delete]];
    return swipeActionConfig;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {

    UIContextualAction *doneAction = [UIContextualAction
                                      contextualActionWithStyle:UIContextualActionStyleNormal
                                      title:NULL
                                      handler:^(UIContextualAction * _Nonnull action,
                                                __kindof UIView * _Nonnull sourceView,
                                                void (^ _Nonnull completionHandler)(BOOL)) {
        // toggle that the task is done
        // only in the first (i.e. cero) section the user can complete a task
        Task *doneTask = [[self.taskHelper.tasks objectAtIndex:0] objectAtIndex:indexPath.row];
        doneTask.isDone = YES;

        // remove the task from the array containing todo tasks
        [self.taskHelper removeTaskAtIndex:indexPath.row isDone:NO];

        // reload tableview
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];

        // add the task to the array containing done tasks
        [self.taskHelper addTask:doneTask atIndex:0 isDone:YES];

        // reload table view
        [self.tableView beginUpdates];
        NSInteger sections = [self.tableView numberOfSections];
        if (sections == 1) {
            // create section 1 for the first time
            NSIndexSet* insertSection = [NSIndexSet indexSetWithIndex:1];
            [self.tableView insertSections:insertSection
                          withRowAnimation:UITableViewRowAnimationTop];
        }
        NSArray *insertIndexPaths = [[NSArray alloc] initWithObjects:
                                     [NSIndexPath indexPathForRow:0 inSection:1], nil];
        [self.tableView insertRowsAtIndexPaths:insertIndexPaths
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        completionHandler(YES);
    }];
    doneAction.backgroundColor = [UIColor greenColor];
    [doneAction setImage:[UIImage imageNamed:doneImageName]];
    UISwipeActionsConfiguration *swipeAction = [UISwipeActionsConfiguration
                                                configurationWithActions:@[doneAction]];
    return indexPath.section == 0 ? swipeAction : NULL;
}


@end
