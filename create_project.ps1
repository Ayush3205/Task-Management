$frontendDir = "d:\Assessment\frontend"
$backendDir = "d:\Assessment\backend"

# --- BACKEND ---
New-Item -ItemType Directory -Force -Path $backendDir\models
New-Item -ItemType Directory -Force -Path $backendDir\schemas
New-Item -ItemType Directory -Force -Path $backendDir\routes
New-Item -ItemType Directory -Force -Path $backendDir\services
New-Item -ItemType Directory -Force -Path $backendDir\repositories
New-Item -ItemType Directory -Force -Path $backendDir\utils

Set-Content -Path $backendDir\main.py -Value @"
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import tasks, users, dashboard

app = FastAPI(title="Task Management API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(tasks.router, prefix="/api/tasks", tags=["Tasks"])
app.include_router(users.router, prefix="/api/users", tags=["Users"])
app.include_router(dashboard.router, prefix="/api/dashboard", tags=["Dashboard"])

@app.get("/")
def read_root():
    return {"message": "Task Management API"}
"@

Set-Content -Path $backendDir\utils\database.py -Value @"
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

SQLALCHEMY_DATABASE_URL = "sqlite:///./sql_app.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
"@

Set-Content -Path $backendDir\models\models.py -Value @"
from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from utils.database import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    email = Column(String, unique=True, index=True)
    role = Column(String, default="user")
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class Task(Base):
    __tablename__ = "tasks"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    description = Column(Text, nullable=True)
    status = Column(String, default="Pending")
    priority = Column(String, default="Medium")
    assigned_to = Column(Integer, ForeignKey("users.id"), nullable=True)
    due_date = Column(DateTime, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    assignee = relationship("User")

class Comment(Base):
    __tablename__ = "comments"
    id = Column(Integer, primary_key=True, index=True)
    task_id = Column(Integer, ForeignKey("tasks.id"))
    user_id = Column(Integer, ForeignKey("users.id"))
    comment = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
"@

Set-Content -Path $backendDir\schemas\schemas.py -Value @"
from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class UserBase(BaseModel):
    name: str
    email: str
    role: str = "user"

class UserCreate(UserBase):
    pass

class UserResponse(UserBase):
    id: int
    created_at: datetime
    class Config:
        orm_mode = True

class TaskBase(BaseModel):
    title: str
    description: Optional[str] = None
    status: str = "Pending"
    priority: str = "Medium"
    assigned_to: Optional[int] = None
    due_date: Optional[datetime] = None

class TaskCreate(TaskBase):
    pass

class TaskUpdate(TaskBase):
    pass

class TaskResponse(TaskBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None
    class Config:
        orm_mode = True
"@

Set-Content -Path $backendDir\repositories\task_repository.py -Value @"
from sqlalchemy.orm import Session
from models.models import Task
from schemas.schemas import TaskCreate, TaskUpdate

def get_tasks(db: Session, skip: int = 0, limit: int = 100):
    return db.query(Task).offset(skip).limit(limit).all()

def create_task(db: Session, task: TaskCreate):
    db_task = Task(**task.dict())
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task
"@

Set-Content -Path $backendDir\routes\tasks.py -Value @"
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from utils.database import get_db
from schemas.schemas import TaskCreate, TaskResponse, TaskUpdate
from repositories import task_repository

router = APIRouter()

@router.get("/", response_model=List[TaskResponse])
def read_tasks(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return task_repository.get_tasks(db, skip=skip, limit=limit)

@router.post("/", response_model=TaskResponse)
def create_task(task: TaskCreate, db: Session = Depends(get_db)):
    return task_repository.create_task(db, task)
"@

Set-Content -Path $backendDir\routes\users.py -Value @"
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List
from utils.database import get_db
from models.models import User
from schemas.schemas import UserResponse, UserCreate
import httpx

router = APIRouter()

@router.get("/", response_model=List[UserResponse])
def get_users(db: Session = Depends(get_db)):
    return db.query(User).all()

@router.get("/external")
async def get_external_users():
    async with httpx.AsyncClient() as client:
        response = await client.get("https://jsonplaceholder.typicode.com/users")
        return response.json()
"@

Set-Content -Path $backendDir\routes\dashboard.py -Value @"
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
"@

Set-Content -Path $backendDir\setup_db.py -Value @"
from utils.database import engine, Base
from models import models

Base.metadata.create_all(bind=engine)
print("Database initialized.")
"@

# --- FRONTEND ---
Set-Content -Path $frontendDir\tailwind.config.js -Value @"
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
"@

Set-Content -Path $frontendDir\postcss.config.js -Value @"
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
"@

Set-Content -Path $frontendDir\src\index.css -Value @"
@tailwind base;
@tailwind components;
@tailwind utilities;

body {
  margin: 0;
  font-family: 'Inter', system-ui, Avenir, Helvetica, Arial, sans-serif;
  background-color: #f3f4f6;
}
"@

Set-Content -Path $frontendDir\src\App.jsx -Value @"
import React from 'react'

function App() {
  return (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center">
      <div className="bg-white p-8 rounded-lg shadow-lg">
        <h1 className="text-3xl font-bold text-gray-800">Task Management Dashboard</h1>
        <p className="mt-4 text-gray-600">The frontend and backend have been scaffolded successfully.</p>
        <p className="mt-2 text-sm text-gray-500">To run the full app, you will need to start both the Vite dev server and the FastAPI server.</p>
      </div>
    </div>
  )
}

export default App
"@
