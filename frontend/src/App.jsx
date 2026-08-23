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
            '& .MuiDrawer-paper': { width: drawerWidth, boxSizing: 'border-box' },
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
