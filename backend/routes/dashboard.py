from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from utils.database import get_db
from models.models import Task

router = APIRouter()

@router.get("/")
def get_dashboard_stats(db: Session = Depends(get_db)):
    total = db.query(Task).count()
    pending = db.query(Task).filter(Task.status == "Pending").count()
    return {"total_tasks": total, "pending_tasks": pending}
