//
//  TaskHelper.m
//  ToDoObjC
//
//  Created by Josue Hernandez on 6/18/22.
//

#import <Foundation/Foundation.h>
#import "TaskHelper.h"
#import "Task.h"

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
    
    NSLog(@"list size before DELETE: %lu",(unsigned long)tasks.count);
    int section = value ? 1 : 0;
    Task *task = self.tasks[section][index];

    dispatch_queue_t myQueue = dispatch_queue_create("queue.delete", NULL);
    
    dispatch_async(myQueue, ^(void){
        NSLog(@"inside dispatch async block main thread from main thread");
        [self.tasks[section] removeObjectAtIndex:index];
        NSLog(@"list size after delete: %lu",(unsigned long)self->tasks.count);
    });
    
//    dispatch_sync(
//        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
//                                  ^{
//                                    NSLog(@"inside dispatch async block main thread from main thread");
//                                    [self.tasks[section] removeObjectAtIndex:index];
//                                    NSLog(@"list size after delete: %lu",(unsigned long)tasks.count);
//                                   });
    
    
    
//    [self.tasks[section] removeObjectAtIndex:index];
    return task;
}


/// <#Description#>
- (void)printTodoList{
    NSError *error = nil;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *data = [prefs objectForKey:@"listUpdated"];
    if (data == NULL) {
        NSLog(@"la lista de objetos IMPRIMIR esta vacia.");
        return;
    }
    NSSet *nSet = [NSSet setWithObjects:[NSArray class], [Task class], [NSString class], nil];
    NSArray * array = [NSKeyedUnarchiver unarchivedObjectOfClasses:nSet
                                                          fromData:data
                                                             error:&error];
    NSLog(@"la lista de objetos IMPRIMIR: %@",array);
    if (array != NULL && [array count] > 0) {
        
        // TODO: solo se estan agregando los objetos tipo isDone = NO, primer seccion
        // el array tiene otra posicion, isDone = YES, o la segunda seccion
        // falta enviar esa posicion porque ahora solo se esta enviando la primera
//        NSArray *arrayData = [array firstObject];
        for (Task *obj in array) {
            NSLog(@"name: %@", obj.name);
            NSLog(@"done: %i", obj.isDone);
        }
    }
}

- (void)deleteTaskFromToDoList {
    // TODO: hacer lo mismo que removeTaskAtIndex
    // 1. quitar la tarea de la lista -> NO. estoy ya se hace cuando se llama a removeTaskAtIndex
    // 2. borrar todo el nsuserdafaults, la vdd no importa
    // 3. antes de llamar a salvar, vemos si ya no hay items en la lista, ya que no seria
    // necesario llamar a salvar, ya que no hay nada que guardar, ya se fue todo
    // 4. luego volver a salvar, porque quizas tengamos una lista con mas de 1 sola tarea
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *listOfObjs = [defaults objectForKey:@"listUpdated"];
    
    if (listOfObjs != NULL) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"listUpdated"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([self.tasks count] == 0) {
        return;
    }
    [self saveTodoList];
}

- (void)saveTodoList{
    NSLog(@"saveTodoList metodo desde el helper, num de tareas: %lu",(unsigned long)tasks.count);
    if (tasks == NULL) { return; }
    
    NSError *error = nil;
    NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:tasks.count];
    
    for (Task *taskObject in tasks.firstObject) {
        [archiveArray addObject:taskObject];
    }
    if (tasks.count > 1 && tasks.lastObject != NULL) {
        for (Task *taskObject in tasks.lastObject) {
            [archiveArray addObject:taskObject];
        }
    }
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:archiveArray
                                         requiringSecureCoding:true
                                                         error:&error];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(error == nil) {
        [defaults setObject:data forKey:@"listUpdated"];
        [defaults synchronize];
    }
    NSLog(@"salvando correcto");
}

- (NSMutableArray *)fetchTodoList{
    // get the objets from nsuserdefaults
    NSError *error = nil;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *data = [prefs objectForKey:@"listUpdated"];
    if (data == NULL) {
        return nil;
    }
    NSSet *nSet = [NSSet setWithObjects:[NSArray class], [Task class], [NSString class], nil];
    NSArray * array = [NSKeyedUnarchiver unarchivedObjectOfClasses:nSet
                                                          fromData:data
                                                             error:&error];
    if (array != NULL && [array count] > 0){
        NSMutableArray *todoTasks = [[NSMutableArray alloc] init];
        NSMutableArray *doneTasks = [[NSMutableArray alloc] init];
        for (Task *task in array) {
            if (task.isDone) {
                [doneTasks addObject:task];
            } else {
                [todoTasks addObject:task];
            }
        }
        NSMutableArray *allTasks =  [NSMutableArray arrayWithObjects:todoTasks, doneTasks, nil];
        NSLog(@"el nuevo mutable array %@", allTasks);
        return allTasks;
    }

    return nil;
}

@end

//To answer the question in comments you can use the below line to suppress these warnings:

// #pragma clang diagnostic ignored "-Wmissing-selector-name"
