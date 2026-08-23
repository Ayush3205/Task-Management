from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from utils.database import get_db
from schemas.schemas import TaskCreate, TaskResponse, TaskUpdate
from repositories import task_repository

router = APIRouter()

@router.get("/", response_model=List[TaskResponse])
def read_tasks(skip: int = 0, limit: int = 100, status: str = None, priority: str = None, db: Session = Depends(get_db)):
    return task_repository.get_tasks(db, skip=skip, limit=limit, status=status, priority=priority)

@router.post("/", response_model=TaskResponse)
def create_task(task: TaskCreate, db: Session = Depends(get_db)):
    return task_repository.create_task(db, task)

@router.put("/{task_id}", response_model=TaskResponse)
def update_task(task_id: int, task: TaskUpdate, db: Session = Depends(get_db)):
    updated_task = task_repository.update_task(db, task_id, task)
    if not updated_task:
        raise HTTPException(status_code=404, detail="Task not found")
    return updated_task

@router.delete("/{task_id}", response_model=dict)
def delete_task(task_id: int, db: Session = Depends(get_db)):
    deleted_task = task_repository.delete_task(db, task_id)
    if not deleted_task:
        raise HTTPException(status_code=404, detail="Task not found")
    return {"message": "Task deleted successfully"}
