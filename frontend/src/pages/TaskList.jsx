import React, { useState, useEffect } from 'react';
import { 
  Box, Typography, TextField, MenuItem, Table, TableBody, TableCell, 
  TableContainer, TableHead, TableRow, Paper, IconButton, Menu
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import SearchIcon from '@mui/icons-material/Search';
import MoreVertIcon from '@mui/icons-material/MoreVert';
import { StatusBadge } from '../components/StatusBadge';
import { PriorityBadge } from '../components/PriorityBadge';
import { Button } from '../components/Button';
import { TaskForm } from '../components/TaskForm';
import { TaskViewModal } from '../components/TaskViewModal';
import api from '../api';

export function TaskList() {
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [selectedTask, setSelectedTask] = useState(null);
  const [editingTask, setEditingTask] = useState(null);
  const [statusFilter, setStatusFilter] = useState('All');
  const [priorityFilter, setPriorityFilter] = useState('All');
  
  // Menu state
  const [anchorEl, setAnchorEl] = useState(null);
  const [menuTask, setMenuTask] = useState(null);

  const handleMenuClick = (event, task) => {
    setAnchorEl(event.currentTarget);
    setMenuTask(task);
  };

  const handleMenuClose = () => {
    setAnchorEl(null);
    setMenuTask(null);
  };

  useEffect(() => {
    const fetchTasks = async () => {
      try {
        const response = await api.get('/tasks/', {
          params: { status: statusFilter, priority: priorityFilter }
        });
        setTasks(response.data);
      } catch (error) {
        console.error('Error fetching tasks:', error);
      } finally {
        setLoading(false);
      }
    };
    fetchTasks();
  }, [statusFilter, priorityFilter]);

  const handleTaskSaved = (savedTask, isEdit) => {
    if (isEdit) {
      setTasks(prev => prev.map(t => t.id === savedTask.id ? savedTask : t));
    } else {
      setTasks(prev => [...prev, savedTask]);
    }
  };

  const openEditForm = (task) => {
    setEditingTask(task);
    setIsFormOpen(true);
  };

  const closeForm = () => {
    setIsFormOpen(false);
    setEditingTask(null);
  };

  const handleDelete = async (id) => {
    try {
      await api.delete(`/tasks/${id}`);
      setTasks(prev => prev.filter(t => t.id !== id));
    } catch (error) {
      console.error('Error deleting task:', error);
    }
  };

  return (
    <Box>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4" fontWeight="bold">Tasks</Typography>
        <Button startIcon={<AddIcon />} onClick={() => { setEditingTask(null); setIsFormOpen(true); }}>Create Task</Button>
      </Box>

      <Paper elevation={2} sx={{ p: 2, mb: 3 }}>
        <Box display="flex" gap={2} flexWrap="wrap">
          <TextField 
            variant="outlined" 
            placeholder="Search tasks..." 
            size="small"
            InputProps={{ startAdornment: <SearchIcon color="action" sx={{ mr: 1 }} /> }}
            sx={{ flexGrow: 1 }}
          />
          <TextField 
            select 
            label="Status" 
            size="small" 
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)} 
            sx={{ minWidth: 150 }}
          >
            {['All', 'Pending', 'In Progress', 'Completed'].map(o => (
              <MenuItem key={o} value={o}>{o}</MenuItem>
            ))}
          </TextField>
          <TextField 
            select 
            label="Priority" 
            size="small" 
            value={priorityFilter}
            onChange={(e) => setPriorityFilter(e.target.value)} 
            sx={{ minWidth: 150 }}
          >
            {['All', 'Low', 'Medium', 'High', 'Urgent'].map(o => (
              <MenuItem key={o} value={o}>{o}</MenuItem>
            ))}
          </TextField>
        </Box>
      </Paper>

      <TableContainer component={Paper} elevation={2}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell fontWeight="bold">Title</TableCell>
              <TableCell fontWeight="bold">Assignee</TableCell>
              <TableCell fontWeight="bold">Priority</TableCell>
              <TableCell fontWeight="bold">Status</TableCell>
              <TableCell fontWeight="bold">Due Date</TableCell>
              <TableCell align="right">Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {tasks.map((task) => (
              <TableRow key={task.id} hover>
                <TableCell>{task.title}</TableCell>
                <TableCell>{task.assigned_to || 'Unassigned'}</TableCell>
                <TableCell><PriorityBadge priority={task.priority} /></TableCell>
                <TableCell><StatusBadge status={task.status} /></TableCell>
                <TableCell>{task.due_date ? new Date(task.due_date).toLocaleDateString() : 'None'}</TableCell>
                <TableCell align="right">
                  <IconButton onClick={(e) => handleMenuClick(e, task)}>
                    <MoreVertIcon />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
      
      <TaskForm 
        open={isFormOpen} 
        onClose={closeForm} 
        onTaskSaved={handleTaskSaved}
        taskToEdit={editingTask}
      />
      
      <TaskViewModal 
        task={selectedTask} 
        onClose={() => setSelectedTask(null)} 
      />
      
      <Menu
        anchorEl={anchorEl}
        open={Boolean(anchorEl)}
        onClose={handleMenuClose}
      >
        <MenuItem onClick={() => { setSelectedTask(menuTask); handleMenuClose(); }}>View</MenuItem>
        <MenuItem onClick={() => { openEditForm(menuTask); handleMenuClose(); }}>Edit</MenuItem>
        <MenuItem onClick={() => { handleDelete(menuTask.id); handleMenuClose(); }} sx={{ color: 'error.main' }}>Delete</MenuItem>
      </Menu>
    </Box>
  );
}
