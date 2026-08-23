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
