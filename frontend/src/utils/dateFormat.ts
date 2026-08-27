const ISO_TIMESTAMP_PATTERN =
  /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:\d{2})$/

const ALBANIAN_MONTHS = [
  'janar',
  'shkurt',
  'mars',
  'prill',
  'maj',
  'qershor',
  'korrik',
  'gusht',
  'shtator',
  'tetor',
  'nëntor',
  'dhjetor',
] as const

const numericDateFormatter = new Intl.DateTimeFormat('en-US-u-nu-latn', {
  day: 'numeric',
  month: 'numeric',
  timeZone: 'Europe/Belgrade',
  year: 'numeric',
})

export function formatDatabaseDate(timestamp: string): string {
  if (!ISO_TIMESTAMP_PATTERN.test(timestamp)) {
    return '—'
  }

  const date = new Date(timestamp)

  if (Number.isNaN(date.getTime())) {
    return '—'
  }

  const dateParts = numericDateFormatter.formatToParts(date)
  const day = Number(dateParts.find((part) => part.type === 'day')?.value)
  const month = Number(dateParts.find((part) => part.type === 'month')?.value)
  const year = Number(dateParts.find((part) => part.type === 'year')?.value)
  const monthName = ALBANIAN_MONTHS[month - 1]

  if (
    !Number.isInteger(day) ||
    day < 1 ||
    day > 31 ||
    !monthName ||
    !Number.isInteger(year)
  ) {
    return '—'
  }

  return `${day} ${monthName} ${year}`
}
