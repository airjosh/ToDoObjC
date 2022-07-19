//
//  TaskTableViewController.h
//  ToDoObjC
//
//  Created by Josue Arambula on 6/5/22.
//

#import <UIKit/UIKit.h>
#import "TaskHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *tableData; // holds the table data

@end



NS_ASSUME_NONNULL_END
