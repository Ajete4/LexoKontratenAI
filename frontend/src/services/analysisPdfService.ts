import { isAnalysisUuid } from './contractAnalysisService'

const apiBaseUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')

export class AnalysisPdfServiceError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'AnalysisPdfServiceError'
  }
}

function getFileName(response: Response): string {
  const disposition = response.headers.get('Content-Disposition')
  const match = disposition?.match(/filename="([^"]+\.pdf)"/iu)
  return match?.[1] ?? 'raporti-i-analizes.pdf'
}

export async function downloadAnalysisPdf(input: {
  accessToken: string
  contractId: string
  versionId: string
  signal?: AbortSignal
}): Promise<{ blob: Blob; fileName: string }> {
  if (
    !apiBaseUrl ||
    !isAnalysisUuid(input.contractId) ||
    !isAnalysisUuid(input.versionId)
  ) {
    throw new AnalysisPdfServiceError('Kërkesa për eksport nuk është valide.')
  }

  let response: Response
  try {
    response = await fetch(
      `${apiBaseUrl}/api/contracts/${encodeURIComponent(input.contractId)}/versions/${encodeURIComponent(input.versionId)}/analysis/export.pdf`,
      {
        method: 'GET',
        headers: { Authorization: `Bearer ${input.accessToken}` },
        signal: input.signal,
      },
    )
  } catch (error) {
    if (
      input.signal?.aborted ||
      (error instanceof DOMException && error.name === 'AbortError')
    ) {
      throw new AnalysisPdfServiceError('Eksporti u anulua.')
    }
    throw new AnalysisPdfServiceError(
      'Raporti PDF nuk mund të gjenerohet për momentin.',
    )
  }

  if (!response.ok) {
    throw new AnalysisPdfServiceError(
      response.status === 404
        ? 'Analiza e përfunduar nuk u gjet.'
        : 'Raporti PDF nuk mund të gjenerohet për momentin.',
    )
  }

  const contentType = response.headers.get('Content-Type')
  if (!contentType?.toLowerCase().startsWith('application/pdf')) {
    throw new AnalysisPdfServiceError('Përgjigjja e eksportit nuk ishte PDF.')
  }

  const blob = await response.blob()
  if (blob.size === 0 || await blob.slice(0, 5).text() !== '%PDF-') {
    throw new AnalysisPdfServiceError('Dokumenti PDF nuk ishte valid.')
  }

  return { blob, fileName: getFileName(response) }
}

