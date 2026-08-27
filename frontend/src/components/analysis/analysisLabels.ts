import type {
  AnalysisContractType,
  AnalysisLanguage,
  ClauseSeverity,
  ClauseType,
  FavoredParty,
  FindingType,
  OverallRiskLevel,
} from '../../types/analysis'

export const contractTypeLabels: Record<AnalysisContractType, string> = {
  employment: 'Punësim',
  service: 'Shërbim',
  lease: 'Qira',
}

export const languageLabels: Record<AnalysisLanguage, string> = {
  sq: 'Shqip',
  en: 'Anglisht',
  mixed: 'E përzier',
  unknown: 'E papërcaktuar',
}

export const riskLabels: Record<OverallRiskLevel, string> = {
  low: 'I ulët',
  medium: 'Mesatar',
  high: 'I lartë',
  critical: 'Kritik',
  unknown: 'I panjohur',
}

export const clauseTypeLabels: Record<ClauseType, string> = {
  parties: 'Palët',
  subject: 'Objekti',
  obligations: 'Detyrimet',
  duration: 'Kohëzgjatja',
  payment: 'Pagesa',
  penalty: 'Penalitetet',
  termination: 'Ndërprerja',
  jurisdiction: 'Juridiksioni',
  confidentiality: 'Konfidencialiteti',
  liability: 'Përgjegjësia',
  data_protection: 'Mbrojtja e të dhënave',
  dispute_resolution: 'Zgjidhja e mosmarrëveshjeve',
  other: 'Tjetër',
}

export const findingTypeLabels: Record<FindingType, string> = {
  normal: 'Normale',
  risky: 'Me rrezik',
  imbalanced: 'E pabalancuar',
  missing: 'Mungon',
  ambiguous: 'E paqartë',
}

export const severityLabels: Record<ClauseSeverity, string> = {
  none: 'Informuese',
  low: 'I ulët',
  medium: 'Mesatar',
  high: 'I lartë',
  critical: 'Kritik',
  review_required: 'Kërkon shqyrtim',
}

export const favoredPartyLabels: Record<FavoredParty, string> = {
  party_a: 'Pala e parë',
  party_b: 'Pala e dytë',
  balanced: 'E balancuar',
  unclear: 'E paqartë',
  not_applicable: 'Nuk aplikohet',
}
