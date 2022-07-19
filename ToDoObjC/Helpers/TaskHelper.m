//
//  TaskHelper.m
//  ToDoObjC
//
//  Created by Josue Hernandez on 6/18/22.
//

#import <Foundation/Foundation.h>
#import "TaskHelper.h"

@interface TaskHelper()

@end

@implementation TaskHelper

@synthesize tasks;

- (void)addTask:(Task *)task atIndex:(NSInteger)index isDone:(bool)value {
    int section = value ? 1 : 0;
    if (!self.tasks || !self.tasks.count){
        // this goes to section 0, in to-do's; it's the first time to insert ever
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:task];
        [self.tasks addObject:array];
    } else {
        if (section == 1 && self.tasks.count == 1){
            // there's no section 1 at all
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:task];
            [self.tasks addObject:array];
        } else {
            // interchangeable; save at section 0 or 1
            [[self.tasks objectAtIndex:section] insertObject:task atIndex:index];
        }
    }
}

- (Task *)removeTaskAtIndex:(NSInteger)index isDone: (BOOL)value {
    int section = value ? 1 : 0;
    Task *task = self.tasks[section][index];
    [self.tasks[section] removeObjectAtIndex:index];
    return task;
}

@end

//To answer the question in comments you can use the below line to suppress these warnings:

// #pragma clang diagnostic ignored "-Wmissing-selector-name"
