//
//  TaskHelper.h
//  ToDoObjC
//
//  Created by Josue A.H. on 6/18/22.
//

#ifndef TaskHelper_h
#define TaskHelper_h

#import "Task.h"

@interface TaskHelper : NSObject 

@property (nonatomic, strong) NSMutableArray *tasks; // holds the table data
//@property (nonatomic, strong) NSArray *tasks;

- (void)addTask:(Task *)task atIndex:(NSInteger)index isDone: (BOOL)value;
- (Task *)removeTaskAtIndex:(NSInteger)index isDone: (BOOL)value;

@end

#endif /* TaskHelper_h */
