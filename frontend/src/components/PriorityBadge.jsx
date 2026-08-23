import React from 'react';
import { Chip } from '@mui/material';

const priorityColors = {
  'Low': 'default',
  'Medium': 'info',
  'High': 'warning',
  'Urgent': 'error',
};

export function PriorityBadge({ priority, ...props }) {
  const color = priorityColors[priority] || 'default';
  return (
    <Chip label={priority} color={color} size="small" variant="outlined" {...props} />
  );
}
