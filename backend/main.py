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
