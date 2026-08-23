from utils.database import engine, Base
from models import models

Base.metadata.create_all(bind=engine)
print("Database initialized.")
