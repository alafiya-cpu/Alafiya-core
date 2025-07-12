<<<<<<< HEAD
=======
import React from 'react';
>>>>>>> 9046908e0b385a012eb9da9b851b94d1db272183
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import ProtectedRoute from './components/ProtectedRoute';
import Layout from './components/Layout';
import LoginForm from './components/LoginForm';
import RegisterForm from './components/RegisterForm';
import Dashboard from './components/Dashboard';
import PatientManagement from './components/PatientManagement';
import TreatmentTracking from './components/TreatmentTracking';
import PaymentManagement from './components/PaymentManagement';
import NotificationCenter from './components/NotificationCenter';
import DischargeManagement from './components/DischargeManagement';

function App() {
  return (
    <AuthProvider>
      <Router>
        <Routes>
          <Route path="/login" element={<LoginForm />} />
          <Route path="/register" element={<RegisterForm />} />
          <Route path="/" element={<Navigate to="/dashboard" replace />} />
          <Route path="/dashboard" element={
            <ProtectedRoute>
              <Layout>
                <Dashboard />
              </Layout>
            </ProtectedRoute>
          } />
          <Route path="/patients" element={
            <ProtectedRoute>
              <Layout>
                <PatientManagement />
              </Layout>
            </ProtectedRoute>
          } />
          <Route path="/treatments" element={
            <ProtectedRoute>
              <Layout>
                <TreatmentTracking />
              </Layout>
            </ProtectedRoute>
          } />
          <Route path="/payments" element={
            <ProtectedRoute>
              <Layout>
                <PaymentManagement />
              </Layout>
            </ProtectedRoute>
          } />
          <Route path="/notifications" element={
            <ProtectedRoute>
              <Layout>
                <NotificationCenter />
              </Layout>
            </ProtectedRoute>
          } />
          <Route path="/discharge" element={
            <ProtectedRoute>
              <Layout>
                <DischargeManagement />
              </Layout>
            </ProtectedRoute>
          } />
        </Routes>
      </Router>
    </AuthProvider>
  );
}

export default App;