$frontendDir = "d:\Assessment\frontend\src"

Set-Content -Path $frontendDir\components\Button.jsx -Value @"
import React from 'react';
import { Button as MuiButton } from '@mui/material';

export function Button({ children, variant = 'contained', color = 'primary', ...props }) {
  return (
    <MuiButton variant={variant} color={color} {...props}>
      {children}
    </MuiButton>
  );
}
"@

Set-Content -Path $frontendDir\components\StatusBadge.jsx -Value @"
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
"@

Set-Content -Path $frontendDir\components\PriorityBadge.jsx -Value @"
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
"@

Set-Content -Path $frontendDir\pages\Dashboard.jsx -Value @"
import React, { useEffect, useState } from 'react';
import { Grid, Card, CardContent, Typography, Box } from '@mui/material';
import DashboardIcon from '@mui/icons-material/Dashboard';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import AccessTimeIcon from '@mui/icons-material/AccessTime';
import ErrorOutlineIcon from '@mui/icons-material/ErrorOutline';

export function Dashboard() {
  const [stats, setStats] = useState({ total_tasks: 0, pending_tasks: 0, in_progress: 0, completed: 0 });

  useEffect(() => {
    setStats({ total_tasks: 12, pending_tasks: 5, in_progress: 4, completed: 3 });
  }, []);

  const cards = [
    { name: 'Total Tasks', value: stats.total_tasks, icon: <DashboardIcon color="primary" fontSize="large" /> },
    { name: 'Pending Tasks', value: stats.pending_tasks, icon: <AccessTimeIcon color="warning" fontSize="large" /> },
    { name: 'In Progress', value: stats.in_progress, icon: <ErrorOutlineIcon color="info" fontSize="large" /> },
    { name: 'Completed', value: stats.completed, icon: <CheckCircleIcon color="success" fontSize="large" /> },
  ];

  return (
    <Box sx={{ flexGrow: 1 }}>
      <Typography variant="h4" fontWeight="bold" gutterBottom>
        Dashboard Overview
      </Typography>
      <Grid container spacing={3}>
        {cards.map((card) => (
          <Grid item xs={12} sm={6} md={3} key={card.name}>
            <Card elevation={2}>
              <CardContent sx={{ display: 'flex', alignItems: 'center' }}>
                <Box sx={{ mr: 2 }}>{card.icon}</Box>
                <Box>
                  <Typography color="textSecondary" variant="subtitle2">
                    {card.name}
                  </Typography>
                  <Typography variant="h4" component="h2" fontWeight="bold">
                    {card.value}
                  </Typography>
                </Box>
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
}
"@

Set-Content -Path $frontendDir\pages\TaskList.jsx -Value @"
import React, { useState } from 'react';
import { 
  Box, Typography, TextField, MenuItem, Table, TableBody, TableCell, 
  TableContainer, TableHead, TableRow, Paper, IconButton
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import SearchIcon from '@mui/icons-material/Search';
import { StatusBadge } from '../components/StatusBadge';
import { PriorityBadge } from '../components/PriorityBadge';
import { Button } from '../components/Button';

const mockTasks = [
  { id: 1, title: 'Update homepage design', status: 'In Progress', priority: 'High', assignee: 'John Doe', due_date: '2026-08-25' },
  { id: 2, title: 'Fix login bug', status: 'Pending', priority: 'Urgent', assignee: 'Jane Smith', due_date: '2026-08-24' },
  { id: 3, title: 'Write API documentation', status: 'Completed', priority: 'Medium', assignee: 'Alice Johnson', due_date: '2026-08-20' },
];

export function TaskList() {
  const [tasks, setTasks] = useState(mockTasks);

  return (
    <Box>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4" fontWeight="bold">Tasks</Typography>
        <Button startIcon={<AddIcon />}>Create Task</Button>
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
          <TextField select label="Status" size="small" defaultValue="All" sx={{ minWidth: 150 }}>
            {['All', 'Pending', 'In Progress', 'Completed'].map(o => (
              <MenuItem key={o} value={o}>{o}</MenuItem>
            ))}
          </TextField>
          <TextField select label="Priority" size="small" defaultValue="All" sx={{ minWidth: 150 }}>
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
                <TableCell>{task.assignee}</TableCell>
                <TableCell><PriorityBadge priority={task.priority} /></TableCell>
                <TableCell><StatusBadge status={task.status} /></TableCell>
                <TableCell>{task.due_date}</TableCell>
                <TableCell align="right">
                  <Button variant="text" size="small">View</Button>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  );
}
"@

Set-Content -Path $frontendDir\App.jsx -Value @"
import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link, useLocation } from 'react-router-dom';
import { 
  Box, Drawer, AppBar, Toolbar, Typography, List, ListItem, 
  ListItemButton, ListItemIcon, ListItemText, CssBaseline 
} from '@mui/material';
import DashboardIcon from '@mui/icons-material/Dashboard';
import AssignmentIcon from '@mui/icons-material/Assignment';
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
import { Dashboard } from './pages/Dashboard';
import { TaskList } from './pages/TaskList';

const drawerWidth = 240;

function Navigation() {
  const location = useLocation();
  
  return (
    <List>
      <ListItem disablePadding>
        <ListItemButton component={Link} to="/" selected={location.pathname === '/'}>
          <ListItemIcon><DashboardIcon color={location.pathname === '/' ? 'primary' : 'inherit'} /></ListItemIcon>
          <ListItemText primary="Dashboard" />
        </ListItemButton>
      </ListItem>
      <ListItem disablePadding>
        <ListItemButton component={Link} to="/tasks" selected={location.pathname === '/tasks'}>
          <ListItemIcon><AssignmentIcon color={location.pathname === '/tasks' ? 'primary' : 'inherit'} /></ListItemIcon>
          <ListItemText primary="Tasks" />
        </ListItemButton>
      </ListItem>
    </List>
  );
}

function App() {
  return (
    <Router>
      <Box sx={{ display: 'flex' }}>
        <CssBaseline />
        <AppBar position="fixed" sx={{ zIndex: (theme) => theme.zIndex.drawer + 1, backgroundColor: '#1976d2' }}>
          <Toolbar>
            <Typography variant="h6" noWrap component="div" sx={{ flexGrow: 1 }}>
              TaskFlow
            </Typography>
            <AccountCircleIcon fontSize="large" />
          </Toolbar>
        </AppBar>
        <Drawer
          variant="permanent"
          sx={{
            width: drawerWidth,
            flexShrink: 0,
            [\`& .MuiDrawer-paper\`]: { width: drawerWidth, boxSizing: 'border-box' },
          }}
        >
          <Toolbar />
          <Box sx={{ overflow: 'auto', mt: 2 }}>
            <Navigation />
          </Box>
        </Drawer>
        <Box component="main" sx={{ flexGrow: 1, p: 3, backgroundColor: '#f5f5f5', minHeight: '100vh' }}>
          <Toolbar />
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/tasks" element={<TaskList />} />
          </Routes>
        </Box>
      </Box>
    </Router>
  );
}

export default App;
"@
