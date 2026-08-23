import React from 'react';
import { Chip } from '@mui/material';

const statusColors = {
  'Pending': 'warning',
  'In Progress': 'info',
  'Completed': 'success',
  'Blocked': 'error',
};

export function StatusBadge({ status, ...props }) {
  const color = statusColors[status] || 'default';
  return (
    <Chip label={status} color={color} size="small" {...props} />
  );
}
