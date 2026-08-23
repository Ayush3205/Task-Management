import React, { useState } from 'react';
import { 
  Dialog, DialogTitle, DialogContent, DialogActions, 
  TextField, MenuItem, Button, Box
} from '@mui/material';
import api from '../api';

export function TaskForm({ open, onClose, onTaskSaved, taskToEdit }) {
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    status: 'Pending',
    priority: 'Medium',
    due_date: ''
  });
  const [loading, setLoading] = useState(false);

  React.useEffect(() => {
    if (taskToEdit) {
      setFormData({
        title: taskToEdit.title || '',
        description: taskToEdit.description || '',
        status: taskToEdit.status || 'Pending',
        priority: taskToEdit.priority || 'Medium',
        due_date: taskToEdit.due_date ? taskToEdit.due_date.split('T')[0] : ''
      });
    } else {
      setFormData({ title: '', description: '', status: 'Pending', priority: 'Medium', due_date: '' });
    }
  }, [taskToEdit, open]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!formData.title) return;
    
    setLoading(true);
    try {
      if (taskToEdit) {
        const response = await api.put(`/tasks/${taskToEdit.id}`, formData);
        onTaskSaved(response.data, true);
      } else {
        const response = await api.post('/tasks/', formData);
        onTaskSaved(response.data, false);
      }
      onClose();
    } catch (error) {
      console.error('Error saving task:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
      <form onSubmit={handleSubmit}>
        <DialogTitle>{taskToEdit ? 'Edit Task' : 'Create New Task'}</DialogTitle>
        <DialogContent>
          <Box display="flex" flexDirection="column" gap={2} mt={1}>
            <TextField
              name="title"
              label="Title"
              value={formData.title}
              onChange={handleChange}
              required
              fullWidth
            />
            <TextField
              name="description"
              label="Description"
              value={formData.description}
              onChange={handleChange}
              multiline
              rows={3}
              fullWidth
            />
            <TextField
              select
              name="priority"
              label="Priority"
              value={formData.priority}
              onChange={handleChange}
              fullWidth
            >
              {['Low', 'Medium', 'High', 'Urgent'].map(option => (
                <MenuItem key={option} value={option}>{option}</MenuItem>
              ))}
            </TextField>
            <TextField
              select
              name="status"
              label="Status"
              value={formData.status}
              onChange={handleChange}
              fullWidth
            >
              {['Pending', 'In Progress', 'Completed'].map(option => (
                <MenuItem key={option} value={option}>{option}</MenuItem>
              ))}
            </TextField>
            <TextField
              type="date"
              name="due_date"
              label="Due Date"
              value={formData.due_date}
              onChange={handleChange}
              InputLabelProps={{ shrink: true }}
              fullWidth
            />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose} color="inherit">Cancel</Button>
          <Button type="submit" variant="contained" color="primary" disabled={loading}>
            {loading ? 'Saving...' : 'Save Task'}
          </Button>
        </DialogActions>
      </form>
    </Dialog>
  );
}
