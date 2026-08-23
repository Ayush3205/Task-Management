import React, { useEffect, useState } from 'react';
import { Grid, Card, CardContent, Typography, Box } from '@mui/material';
import DashboardIcon from '@mui/icons-material/Dashboard';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import AccessTimeIcon from '@mui/icons-material/AccessTime';
import InfoIcon from '@mui/icons-material/Info';
import api from '../api';

export function Dashboard() {
  const [stats, setStats] = useState({ total_tasks: 0, pending_tasks: 0, in_progress: 0, completed: 0 });
  const [quote, setQuote] = useState('');

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const response = await api.get('/dashboard/');
        setStats(response.data);
      } catch (error) {
        console.error('Error fetching dashboard stats:', error);
      }
    };
    
    const fetchQuote = async () => {
      try {
        // External API Integration
        const res = await fetch('https://dummyjson.com/quotes/random');
        const data = await res.json();
        setQuote(`"${data.quote}" - ${data.author}`);
      } catch (e) {
        setQuote("Keep pushing forward!");
      }
    };

    fetchStats();
    fetchQuote();
  }, []);

  const cards = [
    { name: 'Total Tasks', value: stats.total_tasks, icon: <DashboardIcon color="primary" fontSize="large" /> },
    { name: 'Pending Tasks', value: stats.pending_tasks, icon: <AccessTimeIcon color="warning" fontSize="large" /> },
    { name: 'In Progress', value: stats.in_progress, icon: <InfoIcon color="info" fontSize="large" /> },
    { name: 'Completed', value: stats.completed, icon: <CheckCircleIcon color="success" fontSize="large" /> },
  ];

  return (
    <Box sx={{ flexGrow: 1 }}>
      <Typography variant="h4" fontWeight="bold" gutterBottom>
        Dashboard Overview
      </Typography>
      {quote && (
        <Typography variant="subtitle1" color="textSecondary" sx={{ mb: 3, fontStyle: 'italic' }}>
          {quote}
        </Typography>
      )}
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
