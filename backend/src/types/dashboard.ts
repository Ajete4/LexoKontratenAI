export type DashboardStats = {
  completedAnalyses: number;
  criticalClauses: number;
  professionalReviewClauses: number;
  qaQuestions: 0;
};

export type DashboardLatestAnalysis = {
  analysisId: string;
  versionId: string;
  overallRiskLevel: "low" | "medium" | "high" | "critical" | "unknown";
  completedAt: string;
  criticalClauseCount: number;
  professionalReviewClauseCount: number;
};

export type DashboardRecentContract = {
  id: string;
  title: string;
  contractType: "employment" | "service" | "lease";
  status: "draft" | "uploaded" | "processing" | "analyzed" | "failed" | "archived";
  createdAt: string;
  latestCompletedAnalysis: DashboardLatestAnalysis | null;
};

export type DashboardRecentReview = {
  analysisId: string;
  contractId: string;
  versionId: string;
  contractTitle: string;
  clausePosition: number;
  heading: string | null;
  severity: "none" | "low" | "medium" | "high" | "critical" | "review_required";
  findingType: "normal" | "risky" | "imbalanced" | "missing" | "ambiguous";
  completedAt: string;
};

export type Dashboard = {
  stats: DashboardStats;
  recentContracts: DashboardRecentContract[];
  recentReviews: DashboardRecentReview[];
};
