import { BrowserRouter, Route, Routes } from 'react-router-dom'

import { ProtectedRoute } from './components/auth/ProtectedRoute'
import { AppShell } from './components/layout/AppShell'
import { AnalysisResultsPage } from './pages/AnalysisResultsPage'
import { GeneratorPage } from './pages/GeneratorPage'
import { ForgotPasswordPage } from './pages/ForgotPasswordPage'
import { HistoryPage } from './pages/HistoryPage'
import { HomePage } from './pages/HomePage'
import { LegalSourcesPage } from './pages/LegalSourcesPage'
import { LoginPage } from './pages/LoginPage'
import { NotesChecklistPage } from './pages/NotesChecklistPage'
import { NotFoundPage } from './pages/NotFoundPage'
import { ProcessingPage } from './pages/ProcessingPage'
import { QuestionsPage } from './pages/QuestionsPage'
import { RegisterPage } from './pages/RegisterPage'
import { ResetPasswordPage } from './pages/ResetPasswordPage'
import { RewriteClausePage } from './pages/RewriteClausePage'
import { RiskReportPage } from './pages/RiskReportPage'
import { SettingsPage } from './pages/SettingsPage'
import { UploadPage } from './pages/UploadPage'

import './App.css'

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />
        <Route path="/forgot-password" element={<ForgotPasswordPage />} />
        <Route path="/reset-password" element={<ResetPasswordPage />} />

        <Route element={<ProtectedRoute />}>
          <Route element={<AppShell />}>
            <Route index element={<HomePage />} />
            <Route path="upload" element={<UploadPage />} />
            <Route path="generator" element={<GeneratorPage />} />
            <Route path="processing" element={<ProcessingPage />} />
            <Route
              path="processing/:contractId/:versionId"
              element={<ProcessingPage />}
            />
            <Route path="analysis" element={<AnalysisResultsPage />} />
            <Route
              path="analysis/:contractId/:versionId"
              element={<AnalysisResultsPage />}
            />
            <Route path="/risk" element={<RiskReportPage />} />
            <Route
              path="/risk/:contractId/:versionId"
              element={<RiskReportPage />}
            />
            <Route path="/questions" element={<QuestionsPage />} />
            <Route
              path="/questions/:contractId/:versionId"
              element={<QuestionsPage />}
            />
            <Route path="/rewrite" element={<RewriteClausePage />} />
            <Route
              path="/rewrite/:contractId/:versionId"
              element={<RewriteClausePage />}
            />
            <Route path="/notes" element={<NotesChecklistPage />} />
            <Route
              path="/notes/:contractId/:versionId"
              element={<NotesChecklistPage />}
            />
            <Route path="/history" element={<HistoryPage />} />
            <Route path="/legal-sources" element={<LegalSourcesPage />} />
            <Route path="/settings" element={<SettingsPage />} />
            <Route path="*" element={<NotFoundPage />} />
          </Route>
        </Route>
      </Routes>
    </BrowserRouter>
  )
}

export default App
