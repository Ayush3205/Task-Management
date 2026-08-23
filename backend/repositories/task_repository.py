from sqlalchemy.orm import Session
from models.models import Task
from schemas.schemas import TaskCreate, TaskUpdate

def get_tasks(db: Session, skip: int = 0, limit: int = 100, status: str = None, priority: str = None):
    query = db.query(Task)
    if status and status != "All":
        query = query.filter(Task.status == status)
    if priority and priority != "All":
        query = query.filter(Task.priority == priority)
    return query.offset(skip).limit(limit).all()

def create_task(db: Session, task: TaskCreate):
    db_task = Task(**task.dict())
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task

def update_task(db: Session, task_id: int, task: TaskUpdate):
    db_task = db.query(Task).filter(Task.id == task_id).first()
    if db_task:
        update_data = task.dict(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_task, key, value)
        db.commit()
        db.refresh(db_task)
    return db_task

def delete_task(db: Session, task_id: int):
    db_task = db.query(Task).filter(Task.id == task_id).first()
    if db_task:
        db.delete(db_task)
        db.commit()
    return db_task
