# Full-Stack Task Management Dashboard

A full-stack task management application built with **React, Vite, Material-UI** on the frontend, and **Python, FastAPI, PostgreSQL, SQLAlchemy** on the backend.

## Features
- **Full CRUD functionality** (Create, Read, Update, Delete tasks).
- **Filtering & Pagination** via backend APIs.
- **Modern UI** built with Material-UI and custom badges.
- **External API Integration** fetching random motivational quotes.
- **PostgreSQL Database** with Alembic migrations.

## Project Structure
This repository contains both the frontend and backend applications in a single monorepo format.
- `/frontend`: React frontend application.
- `/backend`: FastAPI backend server.

---

## Backend Setup (FastAPI)

### Prerequisites
- Python 3.10+
- PostgreSQL Server running locally or remotely.

### Installation
1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   # On Windows:
   venv\Scripts\activate
   # On macOS/Linux:
   source venv/bin/activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Configure Environment Variables:
   Create a `.env` file in the `/backend` directory based on your PostgreSQL setup:
   ```env
   DATABASE_URL=postgresql://your_user:your_password@localhost:5432/your_database_name
   ```
5. Run Database Migrations:
   ```bash
   alembic upgrade head
   ```
6. Start the Server:
   ```bash
   uvicorn main:app --reload
   ```
   The backend API will run on `http://localhost:8000`.

---

## Frontend Setup (React + Vite)

### Prerequisites
- Node.js (v16+)
- npm or yarn

### Installation
1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the Development Server:
   ```bash
   npm run dev
   ```
   The frontend will run on `http://localhost:5174` (or 5173).

---
