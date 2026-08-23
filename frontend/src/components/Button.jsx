import React from 'react';
import { Button as MuiButton } from '@mui/material';

export function Button({ children, variant = 'contained', color = 'primary', ...props }) {
  return (
    <MuiButton variant={variant} color={color} {...props}>
      {children}
    </MuiButton>
  );
}
