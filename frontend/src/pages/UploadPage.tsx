import {
  useRef,
  useState,
  type ChangeEvent,
  type DragEvent,
  type FormEvent,
  type KeyboardEvent,
} from 'react'

import { Icon } from '../components/ui/Icon'
import { useContractUpload } from '../hooks/useContractUpload'
import { usePastedContract } from '../hooks/usePastedContract'
import type { ContractType } from '../types/database'

const MAX_FILE_SIZE_BYTES = 20 * 1024 * 1024
const MAX_PASTED_TEXT_CHARACTERS = 80_000
const MAX_PASTED_TEXT_BYTES = 320_000
const FILE_INPUT_ACCEPT =
  '.pdf,.docx,.txt,application/pdf,application/vnd.openxmlformats-officedocument.wordprocessingml.document,text/plain'

const contractTypes: Array<{ label: string; value: ContractType }> = [
  { label: 'Punësim', value: 'employment' },
  { label: 'Shërbim', value: 'service' },
  { label: 'Qira', value: 'lease' },
]

const mimeTypeByExtension: Record<string, string> = {
  '.docx':
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  '.pdf': 'application/pdf',
  '.txt': 'text/plain',
}

function getFileExtension(filename: string): string {
  const lastDotIndex = filename.lastIndexOf('.')
  return lastDotIndex >= 0 ? filename.slice(lastDotIndex).toLowerCase() : ''
}

function getTitleFromFilename(filename: string): string {
  const extension = getFileExtension(filename)
  const title = extension ? filename.slice(0, -extension.length) : filename
  return title.trim().slice(0, 200)
}

function formatFileSize(size: number): string {
  if (size < 1024) {
    return `${size} B`
  }

  if (size < 1024 * 1024) {
    return `${(size / 1024).toFixed(1)} KB`
  }

  return `${(size / (1024 * 1024)).toFixed(1)} MB`
}

function validateFile(file: File): string | null {
  if (file.size === 0) {
    return 'Skedari është bosh. Zgjidh një dokument me përmbajtje.'
  }

  if (file.size > MAX_FILE_SIZE_BYTES) {
    return 'Skedari nuk duhet të jetë më i madh se 20 MB.'
  }

  const extension = getFileExtension(file.name)
  const expectedMimeType = mimeTypeByExtension[extension]

  if (!expectedMimeType) {
    return 'Lejohen vetëm skedarë PDF, DOCX ose TXT.'
  }

  if (file.type && file.type !== expectedMimeType) {
    return 'Formati i skedarit nuk përputhet me prapashtesën e tij.'
  }

  return null
}

function getUnicodeCharacterCount(value: string): number {
  return Array.from(value).length
}

function getUtf8ByteCount(value: string): number {
  return new TextEncoder().encode(value).byteLength
}

function validatePastedText(text: string): string | null {
  if (text.trim().length === 0) {
    return 'Ngjit tekstin e kontratës para se të vazhdosh.'
  }

  if (getUnicodeCharacterCount(text) > MAX_PASTED_TEXT_CHARACTERS) {
    return 'Teksti nuk duhet të ketë më shumë se 80,000 karaktere.'
  }

  if (getUtf8ByteCount(text) > MAX_PASTED_TEXT_BYTES) {
    return 'Teksti tejkalon kufirin prej 320,000 UTF-8 bytes.'
  }

  return null
}

export function UploadPage() {
  const fileInputRef = useRef<HTMLInputElement>(null)
  const [selectedType, setSelectedType] =
    useState<ContractType>('employment')
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [pastedText, setPastedText] = useState('')
  const [title, setTitle] = useState('')
  const [isTitleUserEdited, setIsTitleUserEdited] = useState(false)
  const [isDragActive, setIsDragActive] = useState(false)
  const [validationError, setValidationError] = useState<string | null>(null)
  const {
    draftContractId,
    error: uploadError,
    isSubmitting,
    startNewAttempt,
    submit,
  } = useContractUpload()
  const {
    error: pastedContractError,
    isSubmitting: isSubmittingPastedContract,
    submit: submitPastedContract,
  } = usePastedContract()

  const isDraftLocked = Boolean(draftContractId)
  const isAnySubmitting = isSubmitting || isSubmittingPastedContract
  const trimmedTitle = title.trim()
  const pastedTextCharacterCount = getUnicodeCharacterCount(pastedText)
  const hasPastedText = pastedText.trim().length > 0
  const isReady =
    (Boolean(selectedFile) || hasPastedText) &&
    trimmedTitle.length >= 1 &&
    trimmedTitle.length <= 200

  const openFilePicker = () => {
    if (!isAnySubmitting) {
      fileInputRef.current?.click()
    }
  }

  const selectFile = (file: File) => {
    const nextValidationError = validateFile(file)

    if (nextValidationError) {
      setSelectedFile(null)
      setValidationError(nextValidationError)
      return
    }

    setSelectedFile(file)
    setPastedText('')
    setValidationError(null)

    if (!isTitleUserEdited && !isDraftLocked) {
      setTitle(getTitleFromFilename(file.name))
    }
  }

  const handleFileChange = (event: ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0]

    if (file) {
      selectFile(file)
    }

    event.target.value = ''
  }

  const handleDrop = (event: DragEvent<HTMLDivElement>) => {
    event.preventDefault()
    setIsDragActive(false)

    if (isAnySubmitting) {
      return
    }

    if (event.dataTransfer.files.length !== 1) {
      setSelectedFile(null)
      setValidationError('Zgjidh ose tërhiq vetëm një skedar.')
      return
    }

    const file = event.dataTransfer.files[0]

    if (file) {
      selectFile(file)
    }
  }

  const handleDragOver = (event: DragEvent<HTMLDivElement>) => {
    event.preventDefault()

    if (!isAnySubmitting) {
      event.dataTransfer.dropEffect = 'copy'
      setIsDragActive(true)
    }
  }

  const handleDragLeave = (event: DragEvent<HTMLDivElement>) => {
    if (!event.currentTarget.contains(event.relatedTarget as Node | null)) {
      setIsDragActive(false)
    }
  }

  const handleDropZoneKeyDown = (event: KeyboardEvent<HTMLDivElement>) => {
    if (event.key === 'Enter' || event.key === ' ') {
      event.preventDefault()
      openFilePicker()
    }
  }

  const removeSelectedFile = () => {
    if (isAnySubmitting) {
      return
    }

    setSelectedFile(null)
    setValidationError(null)

    if (!isTitleUserEdited && !isDraftLocked) {
      setTitle('')
    }
  }

  const handleTitleChange = (event: ChangeEvent<HTMLInputElement>) => {
    setTitle(event.target.value)
    setIsTitleUserEdited(true)
    setValidationError(null)
  }

  const handlePastedTextChange = (event: ChangeEvent<HTMLTextAreaElement>) => {
    const nextText = event.target.value

    if (nextText.length > 0 && selectedFile) {
      setSelectedFile(null)
    }

    if (nextText.length > 0 && draftContractId) {
      startNewAttempt()
    }

    setPastedText(nextText)
    setValidationError(null)
  }

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()

    if (trimmedTitle.length < 1 || trimmedTitle.length > 200) {
      setValidationError('Titulli duhet të ketë nga 1 deri në 200 karaktere.')
      return
    }

    setValidationError(null)

    if (selectedFile) {
      const fileError = validateFile(selectedFile)

      if (fileError) {
        setValidationError(fileError)
        return
      }

      await submit({
        contractType: selectedType,
        file: selectedFile,
        title: trimmedTitle,
      })
      return
    }

    const pastedTextError = validatePastedText(pastedText)

    if (pastedTextError) {
      setValidationError(pastedTextError)
      return
    }

    await submitPastedContract({
      contractType: selectedType,
      text: pastedText,
      title: trimmedTitle,
    })
  }

  const handleStartNewAttempt = () => {
    startNewAttempt()
    setValidationError(null)
  }

  return (
    <form className="upload-page" onSubmit={handleSubmit}>
      <div className="upload-heading">
        <h2>Analizë e re e kontratës</h2>
        <p>
          Ngarko një kontratë në PDF, DOCX ose TXT. Pas nxjerrjes së tekstit,
          mund ta nisësh analizën nga faqja e përpunimit.
        </p>
      </div>

      <div className="upload-layout">
        <div className="upload-main-column">
          <div
            aria-label="Zgjidh ose tërhiq skedarin e kontratës"
            className={`drop-zone${isDragActive ? ' drop-zone--active' : ''}`}
            onClick={openFilePicker}
            onDragEnter={handleDragOver}
            onDragLeave={handleDragLeave}
            onDragOver={handleDragOver}
            onDrop={handleDrop}
            onKeyDown={handleDropZoneKeyDown}
            role="button"
            tabIndex={isAnySubmitting ? -1 : 0}
          >
            <input
              ref={fileInputRef}
              accept={FILE_INPUT_ACCEPT}
              aria-label="Skedari i kontratës"
              className="upload-file-input"
              disabled={isAnySubmitting}
              onChange={handleFileChange}
              type="file"
            />

            <div className="drop-zone__icon">
              <Icon name="upload" size={24} />
            </div>
            <h3>Tërhiq dhe lësho kontratën këtu</h3>
            <p>
              PDF, DOCX ose TXT · deri në 20 MB
              <br />
              ose
            </p>
            <button
              disabled={isAnySubmitting}
              onClick={(event) => {
                event.stopPropagation()
                openFilePicker()
              }}
              type="button"
            >
              {selectedFile ? 'Zëvendëso skedarin' : 'Zgjidh skedar'}
            </button>

            {selectedFile && (
              <div className="selected-upload-file" role="status">
                <Icon name="file" size={16} />
                <span>
                  <strong>{selectedFile.name}</strong>
                  <small>{formatFileSize(selectedFile.size)}</small>
                </span>
                <button
                  aria-label="Hiq skedarin e zgjedhur"
                  disabled={isAnySubmitting}
                  onClick={(event) => {
                    event.stopPropagation()
                    removeSelectedFile()
                  }}
                  type="button"
                >
                  Hiq
                </button>
              </div>
            )}
          </div>

          <div className="or-divider">
            <span />
            <b>OSE NGJIT TEKSTIN</b>
            <span />
          </div>

          <div className="contract-text-box">
            <div>
              <span>Teksti i kontratës</span>
              <span>{pastedTextCharacterCount}/80,000</span>
            </div>
            <textarea
              aria-label="Teksti i kontratës"
              disabled={isAnySubmitting}
              onChange={handlePastedTextChange}
              placeholder="Ngjit këtu tekstin e kontratës…"
              value={pastedText}
            />
          </div>
        </div>

        <div className="upload-options">
          <section className="option-card">
            <label className="upload-title-field" htmlFor="contract-title">
              <span>Titulli i kontratës</span>
              <input
                disabled={isAnySubmitting || isDraftLocked}
                id="contract-title"
                maxLength={200}
                onChange={handleTitleChange}
                placeholder="P.sh. Kontrata e punës"
                required
                value={title}
              />
              <small>{trimmedTitle.length}/200 karaktere</small>
            </label>
          </section>

          <section className="option-card">
            <h3>Lloji i kontratës</h3>
            <div className="contract-types">
              {contractTypes.map((type) => (
                <button
                  className={selectedType === type.value ? 'selected' : ''}
                  disabled={isAnySubmitting || isDraftLocked}
                  key={type.value}
                  onClick={() => setSelectedType(type.value)}
                  type="button"
                >
                  {type.label}
                </button>
              ))}
            </div>
          </section>

          <section className="option-card">
            <h3>Roli juaj në kontratë</h3>
            <p>
              Ky opsion është vetëm informues dhe nuk ruhet në këtë fazë.
            </p>
            <select aria-label="Roli juaj" disabled={isAnySubmitting}>
              <option>Punëmarrës (employee)</option>
              <option>Punëdhënës (employer)</option>
              <option>Qiramarrës</option>
              <option>Qiradhënës</option>
              <option>Ofrues shërbimi</option>
              <option>Klient</option>
            </select>
          </section>

          <section className="option-card">
            <h3>Juridiksioni</h3>
            <div className="jurisdiction">
              <span>Kosovë</span>
              <b>Parazgjedhur</b>
            </div>
            <p>
              Juridiksioni i synuar: Kosovë. Verifikimi me burime ligjore do të
              shtohet në fazën RAG.
            </p>
          </section>

          <div className="privacy-note">
            <Icon name="lock" size={15} />
            <span>
              Skedari dërgohet përmes backend-it dhe ruhet në hapësirën private
              të dokumenteve.
            </span>
          </div>

          {draftContractId && (
            <div className="upload-draft-note">
              <span>
                Drafti u krijua. Një retry do të përdorë të njëjtën kontratë.
              </span>
              <button
                disabled={isAnySubmitting}
                onClick={handleStartNewAttempt}
                type="button"
              >
                Fillo tentativë të re
              </button>
            </div>
          )}

          {(validationError || uploadError || pastedContractError) && (
            <div className="upload-error" role="alert">
              {validationError ?? uploadError ?? pastedContractError}
            </div>
          )}

          <button
            className={`analyze-button${isReady ? ' analyze-button--ready' : ''}`}
            disabled={isAnySubmitting || !isReady}
            type="submit"
          >
            <Icon name="fileCheck" size={17} />
            {isAnySubmitting
              ? selectedFile
                ? 'Duke ngarkuar…'
                : 'Duke krijuar…'
              : selectedFile
                ? 'Ngarko kontratën'
                : hasPastedText
                  ? 'Krijo nga teksti'
                  : 'Vazhdo'}
          </button>
        </div>
      </div>
    </form>
  )
}
