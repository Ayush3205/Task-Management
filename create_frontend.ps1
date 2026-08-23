$frontendDir = "d:\Assessment\frontend\src"

New-Item -ItemType Directory -Force -Path $frontendDir\components
New-Item -ItemType Directory -Force -Path $frontendDir\pages
New-Item -ItemType Directory -Force -Path $frontendDir\services

Set-Content -Path $frontendDir\services\api.js -Value @"
import axios from 'axios';

const API_URL = 'http://localhost:8000/api';

const api = axios.create({
  baseURL: API_URL,
});

export const getTasks = () => api.get('/tasks/');
export const getDashboardStats = () => api.get('/dashboard/');
export const getExternalUsers = () => api.get('/users/external');
"@

Set-Content -Path $frontendDir\components\StatusBadge.jsx -Value @"
import React from 'react';
import { clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

const statusColors = {
  'Pending': 'bg-yellow-100 text-yellow-800',
  'In Progress': 'bg-blue-100 text-blue-800',
  'Completed': 'bg-green-100 text-green-800',
  'Blocked': 'bg-red-100 text-red-800',
};

export function StatusBadge({ status, className }) {
  const colorClass = statusColors[status] || 'bg-gray-100 text-gray-800';
  return (
    <span className={twMerge(clsx('px-2.5 py-0.5 rounded-full text-xs font-medium', colorClass), className)}>
      {status}
    </span>
  );
}
"@

Set-Content -Path $frontendDir\components\PriorityBadge.jsx -Value @"
import React from 'react';
import { clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

const priorityColors = {
  'Low': 'bg-gray-100 text-gray-800',
  'Medium': 'bg-blue-100 text-blue-800',
  'High': 'bg-orange-100 text-orange-800',
  'Urgent': 'bg-red-100 text-red-800',
};

export function PriorityBadge({ priority, className }) {
  const colorClass = priorityColors[priority] || 'bg-gray-100 text-gray-800';
  return (
    <span className={twMerge(clsx('px-2.5 py-0.5 rounded-full text-xs font-medium', colorClass), className)}>
      {priority}
    </span>
  );
}
"@

Set-Content -Path $frontendDir\components\Button.jsx -Value @"
import React from 'react';
import { clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function Button({ children, className, variant = 'primary', ...props }) {
  const baseStyle = "inline-flex items-center justify-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 transition-colors";
  const variants = {
    primary: "text-white bg-indigo-600 hover:bg-indigo-700 focus:ring-indigo-500",
    secondary: "text-indigo-700 bg-indigo-100 hover:bg-indigo-200 focus:ring-indigo-500",
    danger: "text-white bg-red-600 hover:bg-red-700 focus:ring-red-500",
  };
  
  return (
    <button className={twMerge(clsx(baseStyle, variants[variant]), className)} {...props}>
      {children}
    </button>
  );
}
"@

Set-Content -Path $frontendDir\pages\Dashboard.jsx -Value @"
import React, { useEffect, useState } from 'react';
import { getDashboardStats } from '../services/api';
import { LayoutDashboard, CheckCircle, Clock, AlertCircle } from 'lucide-react';

export function Dashboard() {
  const [stats, setStats] = useState({ total_tasks: 0, pending_tasks: 0 });

  useEffect(() => {
    // In a real app we'd fetch from API
    // getDashboardStats().then(res => setStats(res.data)).catch(console.error);
    setStats({ total_tasks: 12, pending_tasks: 5, in_progress: 4, completed: 3 });
  }, []);

  const cards = [
    { name: 'Total Tasks', value: stats.total_tasks, icon: LayoutDashboard, color: 'text-blue-500' },
    { name: 'Pending Tasks', value: stats.pending_tasks, icon: Clock, color: 'text-yellow-500' },
    { name: 'In Progress', value: stats.in_progress, icon: AlertCircle, color: 'text-orange-500' },
    { name: 'Completed', value: stats.completed, icon: CheckCircle, color: 'text-green-500' },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold leading-7 text-gray-900 sm:truncate sm:text-3xl sm:tracking-tight">
          Dashboard Overview
        </h2>
      </div>
      <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
        {cards.map((card) => (
          <div key={card.name} className="relative overflow-hidden rounded-lg bg-white px-4 pb-12 pt-5 shadow sm:px-6 sm:pt-6">
            <dt>
              <div className="absolute rounded-md bg-gray-50 p-3">
                <card.icon className={`h-6 w-6 ${card.color}`} aria-hidden="true" />
              </div>
              <p className="ml-16 truncate text-sm font-medium text-gray-500">{card.name}</p>
            </dt>
            <dd className="ml-16 flex items-baseline pb-6 sm:pb-7">
              <p className="text-2xl font-semibold text-gray-900">{card.value}</p>
            </dd>
          </div>
        ))}
      </div>
    </div>
  );
}
"@

Set-Content -Path $frontendDir\pages\TaskList.jsx -Value @"
import React, { useState } from 'react';
import { StatusBadge } from '../components/StatusBadge';
import { PriorityBadge } from '../components/PriorityBadge';
import { Button } from '../components/Button';
import { Search, Plus } from 'lucide-react';

const mockTasks = [
  { id: 1, title: 'Update homepage design', status: 'In Progress', priority: 'High', assignee: 'John Doe', due_date: '2026-08-25' },
  { id: 2, title: 'Fix login bug', status: 'Pending', priority: 'Urgent', assignee: 'Jane Smith', due_date: '2026-08-24' },
  { id: 3, title: 'Write API documentation', status: 'Completed', priority: 'Medium', assignee: 'Alice Johnson', due_date: '2026-08-20' },
];

export function TaskList() {
  const [tasks, setTasks] = useState(mockTasks);

  return (
    <div className="space-y-6">
      <div className="sm:flex sm:items-center sm:justify-between">
        <h2 className="text-2xl font-bold leading-7 text-gray-900 sm:truncate sm:text-3xl sm:tracking-tight">
          Tasks
        </h2>
        <div className="mt-4 sm:ml-4 sm:mt-0">
          <Button className="flex items-center gap-2">
            <Plus className="h-4 w-4" />
            Create Task
          </Button>
        </div>
      </div>

      <div className="bg-white shadow rounded-lg p-6">
        <div className="flex flex-col sm:flex-row gap-4 mb-6">
          <div className="relative flex-1">
            <div className="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
              <Search className="h-5 w-5 text-gray-400" />
            </div>
            <input
              type="text"
              className="block w-full rounded-md border-0 py-1.5 pl-10 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
              placeholder="Search tasks..."
            />
          </div>
          <select className="block w-full sm:w-48 rounded-md border-0 py-1.5 pl-3 pr-10 text-gray-900 ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-indigo-600 sm:text-sm sm:leading-6">
            <option>All Statuses</option>
            <option>Pending</option>
            <option>In Progress</option>
            <option>Completed</option>
          </select>
          <select className="block w-full sm:w-48 rounded-md border-0 py-1.5 pl-3 pr-10 text-gray-900 ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-indigo-600 sm:text-sm sm:leading-6">
            <option>All Priorities</option>
            <option>Low</option>
            <option>Medium</option>
            <option>High</option>
            <option>Urgent</option>
          </select>
        </div>

        <div className="overflow-hidden shadow ring-1 ring-black ring-opacity-5 sm:rounded-lg">
          <table className="min-w-full divide-y divide-gray-300">
            <thead className="bg-gray-50">
              <tr>
                <th className="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6">Title</th>
                <th className="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">Assignee</th>
                <th className="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">Priority</th>
                <th className="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">Status</th>
                <th className="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">Due Date</th>
                <th className="relative py-3.5 pl-3 pr-4 sm:pr-6">
                  <span className="sr-only">Edit</span>
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200 bg-white">
              {tasks.map((task) => (
                <tr key={task.id} className="hover:bg-gray-50 transition-colors">
                  <td className="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:pl-6">
                    {task.title}
                  </td>
                  <td className="whitespace-nowrap px-3 py-4 text-sm text-gray-500">{task.assignee}</td>
                  <td className="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                    <PriorityBadge priority={task.priority} />
                  </td>
                  <td className="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                    <StatusBadge status={task.status} />
                  </td>
                  <td className="whitespace-nowrap px-3 py-4 text-sm text-gray-500">{task.due_date}</td>
                  <td className="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6">
                    <a href="#" className="text-indigo-600 hover:text-indigo-900">View</a>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
"@

Set-Content -Path $frontendDir\App.jsx -Value @"
import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import { Dashboard } from './pages/Dashboard';
import { TaskList } from './pages/TaskList';
import { LayoutDashboard, CheckSquare } from 'lucide-react';

function App() {
  return (
    <Router>
      <div className="min-h-screen bg-gray-50 flex">
        {/* Sidebar */}
        <div className="w-64 bg-white shadow-sm h-screen sticky top-0">
          <div className="h-16 flex items-center px-6 border-b border-gray-100">
            <h1 className="text-xl font-bold text-indigo-600">TaskFlow</h1>
          </div>
          <nav className="p-4 space-y-1">
            <Link to="/" className="flex items-center gap-3 px-3 py-2 text-sm font-medium rounded-md text-gray-700 hover:bg-gray-50 hover:text-indigo-600">
              <LayoutDashboard className="h-5 w-5" />
              Dashboard
            </Link>
            <Link to="/tasks" className="flex items-center gap-3 px-3 py-2 text-sm font-medium rounded-md text-gray-700 hover:bg-gray-50 hover:text-indigo-600">
              <CheckSquare className="h-5 w-5" />
              Tasks
            </Link>
          </nav>
        </div>

        {/* Main content */}
        <div className="flex-1 overflow-auto">
          <header className="bg-white shadow-sm h-16 flex items-center px-8">
            <div className="flex-1"></div>
            <div className="flex items-center gap-3">
              <div className="h-8 w-8 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold">
                JD
              </div>
            </div>
          </header>
          <main className="p-8">
            <Routes>
              <Route path="/" element={<Dashboard />} />
              <Route path="/tasks" element={<TaskList />} />
            </Routes>
          </main>
        </div>
      </div>
    </Router>
  );
}

export default App;
"@
