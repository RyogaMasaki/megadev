#ifndef CHIRA__TASK_H
#define CHIRA__TASK_H

#include <types.h>

#define MAX_TASKS 64

// task status flags
static u8 const TASKSTATE_DEAD = 0b00000000;
static u8 const TASKSTATE_INIT = 0b00000001;
static u8 const TASKSTATE_PAUSE = 0b00000010;
static u8 const TASKSTATE_ACTIVE = 0b10000000;

struct Task {
  u8 id;
  u8 status;
  void (*init_sub)(struct Task*);
  void (*loop_sub)(struct Task*);
  // total object size = 64 bytes
  u8 buffer[54];
};

// max of 64 tasks
// (arbitrary, we may increase or decrease this)
struct Task task_list[MAX_TASKS];
u8 task_count = 0;

struct Task* new_task(void (*init)(struct Task*), void (*loop)(struct Task*)) {
  // no more task space to spare!
  if (task_count >= MAX_TASKS) {
    return NULL;
  }

  struct Task* free_task;
  // loop over available tasks to see which if any are free
  for (u8 free_task_slot = 0; free_task_slot < MAX_TASKS; ++free_task_slot) {
    // if this task is in use, continue
    if (task_list[free_task_slot].status & TASKSTATE_ACTIVE) continue;

    // found a free task, set it up
    free_task = &task_list[free_task_slot];
    free_task->id = free_task_slot;
    free_task->status = TASKSTATE_ACTIVE;
    free_task->init_sub = init;
    free_task->loop_sub = loop;
    ++task_count;
    return free_task;
  }

  // no free task slots found, even though task_count
  // shouldn't ever end up here... task_count out of sync?
  task_count = MAX_TASKS;
  return NULL;
};

void run_tasks() {
  struct Task* this_task;
  for (u8 this_task_slot = 0; this_task_slot < task_count; ++this_task_slot) {
    this_task = &task_list[this_task_slot];
    if ((this_task->status & TASKSTATE_ACTIVE)) {
      if (!(this_task->status & TASKSTATE_INIT)) {
        (*this_task->init_sub)(this_task);
        this_task->status |= TASKSTATE_INIT;
        continue;
      }
      (*this_task->loop_sub)(this_task);
    }
  }
}

void kill_task(u8 task_id) {
  task_list[task_id].status = TASKSTATE_DEAD;
  --task_count;
}

#endif