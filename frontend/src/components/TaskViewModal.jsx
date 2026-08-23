import React from 'react';
import { 
  Dialog, DialogTitle, DialogContent, DialogActions, 
  Button, Typography, Box, Divider 
} from '@mui/material';
import { StatusBadge } from './StatusBadge';
import { PriorityBadge } from './PriorityBadge';

export function TaskViewModal({ task, onClose }) {
  if (!task) return null;

  return (
    <Dialog open={!!task} onClose={onClose} maxWidth="sm" fullWidth>
      <DialogTitle>
        <Typography variant="h6" fontWeight="bold">
          {task.title}
        </Typography>
      </DialogTitle>
      <DialogContent dividers>
        <Box display="flex" flexDirection="column" gap={2}>
          <Box display="flex" justifyContent="space-between" alignItems="center">
            <Typography variant="subtitle2" color="textSecondary">
              Status
            </Typography>
            <StatusBadge status={task.status} />
          </Box>
          <Divider />
          <Box display="flex" justifyContent="space-between" alignItems="center">
            <Typography variant="subtitle2" color="textSecondary">
              Priority
            </Typography>
            <PriorityBadge priority={task.priority} />
          </Box>
          <Divider />
          <Box display="flex" justifyContent="space-between" alignItems="center">
            <Typography variant="subtitle2" color="textSecondary">
              Assignee
            </Typography>
            <Typography variant="body2">
              {task.assigned_to || 'Unassigned'}
            </Typography>
          </Box>
          <Divider />
          <Box display="flex" justifyContent="space-between" alignItems="center">
            <Typography variant="subtitle2" color="textSecondary">
              Due Date
            </Typography>
            <Typography variant="body2">
              {task.due_date ? new Date(task.due_date).toLocaleDateString() : 'None'}
            </Typography>
          </Box>
          <Divider />
          <Box>
            <Typography variant="subtitle2" color="textSecondary" gutterBottom>
              Description
            </Typography>
            <Typography variant="body1" sx={{ whiteSpace: 'pre-wrap' }}>
              {task.description || 'No description provided.'}
            </Typography>
          </Box>
        </Box>
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose} variant="contained" color="primary">
          Close
        </Button>
      </DialogActions>
    </Dialog>
  );
}
