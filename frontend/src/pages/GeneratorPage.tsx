import { useState } from 'react'
import type { ReactNode } from 'react'

import { Icon } from '../components/ui/Icon'

const steps = [
  'Lloji & palët',
  'Objekti',
  'Pagesa & afatet',
  'Përgjegjësitë',
  'Konfidencialiteti & ndërprerja',
  'Zgjidhja e mosmarrëveshjeve',
]

type WizardData = {
  type: string
  partyA: string
  partyB: string
  object: string
  payment: string
  deadline: string
  responsibilities: string
  confidentiality: boolean
  termination: string
  dispute: string
}

type FieldProps = {
  label: string
  children: ReactNode
}

type DraftArticleProps = {
  number: string
  title: string
  text: string
}

const initialData: WizardData = {
  type: 'Marrëveshje shërbimi',
  partyA: '',
  partyB: '',
  object: '',
  payment: '',
  deadline: '',
  responsibilities: '',
  confidentiality: true,
  termination: '',
  dispute: 'Gjykata Themelore në Prishtinë',
}

export function GeneratorPage() {
  const [step, setStep] = useState(0)
  const [data, setData] = useState(initialData)

  const setField = <K extends keyof WizardData>(
    key: K,
    value: WizardData[K],
  ) => {
    setData((currentData) => ({ ...currentData, [key]: value }))
  }

  const preview = {
    object:
      data.object ||
      'objekti dhe qëllimi i marrëveshjes do të përcaktohen nga palët',
    payment: data.payment || 'kushtet e pagesës do të plotësohen',
    deadline: data.deadline || 'kohëzgjatja do të plotësohet',
    responsibilities:
      data.responsibilities ||
      'përgjegjësitë e secilës palë do të plotësohen',
    termination:
      data.termination || 'sipas kushteve që do të plotësohen',
  }

  return (
    <div className="generator-page">
      <div className="generator-heading">
        <h2>Gjenerues kontrate</h2>
        <p>
          Plotësoni hapat dhe shihni strukturën e draftit të ndërtohet
          drejtpërdrejt. Drafti nuk gjenerohet me AI në këtë fazë.
        </p>
      </div>

      <div className="wizard-step-strip">
        {steps.map((label, index) => (
          <div
            className={index === step ? 'active' : index < step ? 'done' : ''}
            key={label}
          >
            {label}
          </div>
        ))}
      </div>

      <div className="wizard-progress">
        <span style={{ width: `${((step + 1) / steps.length) * 100}%` }} />
      </div>

      <div className="generator-layout">
        <section className="wizard-card">
          <div className="wizard-step-number">
            HAPI {step + 1} / {steps.length}
          </div>
          <h3>{steps[step]}</h3>

          {step === 0 && (
            <div className="wizard-fields">
              <Field label="Lloji i kontratës">
                <select
                  value={data.type}
                  onChange={(event) => setField('type', event.target.value)}
                >
                  <option>Marrëveshje shërbimi</option>
                  <option>Kontratë pune</option>
                  <option>Kontratë qiraje</option>
                </select>
              </Field>
              <Field label="Pala e parë (Ofruesi / Punëdhënësi)">
                <input
                  value={data.partyA}
                  onChange={(event) => setField('partyA', event.target.value)}
                  placeholder="Emri i kompanisë ose personit"
                />
              </Field>
              <Field label="Pala e dytë (Klienti / Punëmarrësi)">
                <input
                  value={data.partyB}
                  onChange={(event) => setField('partyB', event.target.value)}
                  placeholder="Emri i palës tjetër"
                />
              </Field>
            </div>
          )}

          {step === 1 && (
            <Field label="Objekti / qëllimi i kontratës">
              <textarea
                value={data.object}
                onChange={(event) => setField('object', event.target.value)}
                placeholder="Përshkruani çfarë mbulon kontrata…"
              />
              <small>
                P.sh. ofrimi i shërbimeve të zhvillimit softuerik, përfshirë
                dizajn dhe mirëmbajtje.
              </small>
            </Field>
          )}

          {step === 2 && (
            <div className="wizard-fields">
              <Field label="Kushtet e pagesës">
                <input
                  value={data.payment}
                  onChange={(event) => setField('payment', event.target.value)}
                  placeholder="Shuma, monedha, afati i pagesës"
                />
              </Field>
              <Field label="Afatet / kohëzgjatja">
                <input
                  value={data.deadline}
                  onChange={(event) => setField('deadline', event.target.value)}
                  placeholder="Kohëzgjatja dhe afatet kryesore"
                />
              </Field>
            </div>
          )}

          {step === 3 && (
            <Field label="Përgjegjësitë e palëve">
              <textarea
                value={data.responsibilities}
                onChange={(event) =>
                  setField('responsibilities', event.target.value)
                }
                placeholder="Çfarë detyrohet të bëjë secila palë…"
              />
            </Field>
          )}

          {step === 4 && (
            <div className="wizard-fields">
              <label className="checkbox-row">
                <span>Përfshi klauzolë konfidencialiteti</span>
                <input
                  type="checkbox"
                  checked={data.confidentiality}
                  onChange={(event) =>
                    setField('confidentiality', event.target.checked)
                  }
                />
              </label>
              <Field label="Kushtet e ndërprerjes">
                <input
                  value={data.termination}
                  onChange={(event) =>
                    setField('termination', event.target.value)
                  }
                  placeholder="P.sh. me njoftim 30 ditë nga secila palë"
                />
              </Field>
            </div>
          )}

          {step === 5 && (
            <div className="wizard-fields">
              <Field label="Zgjidhja e mosmarrëveshjeve">
                <select
                  value={data.dispute}
                  onChange={(event) => setField('dispute', event.target.value)}
                >
                  <option>Gjykata Themelore në Prishtinë</option>
                  <option>Ndërmjetësim, pastaj gjykata kompetente</option>
                  <option>Arbitrazh sipas marrëveshjes</option>
                </select>
              </Field>
              <div className="wizard-info">
                <Icon name="info" size={15} />
                <span>
                  Struktura është gati. Gjenerimi real do të aktivizohet pasi të
                  lidhet API-ja.
                </span>
              </div>
            </div>
          )}

          <div className="wizard-actions">
            <button
              type="button"
              onClick={() => setStep((value) => Math.max(0, value - 1))}
              disabled={step === 0}
            >
              Prapa
            </button>
            {step < steps.length - 1 ? (
              <button
                className="primary"
                type="button"
                onClick={() =>
                  setStep((value) => Math.min(steps.length - 1, value + 1))
                }
              >
                Vazhdo
              </button>
            ) : (
              <button className="primary" type="button" disabled>
                <Icon name="sparkle" size={15} />
                Gjenero draftin
              </button>
            )}
          </div>
        </section>

        <section className="draft-preview">
          <div className="draft-preview__header">
            <Icon name="file" size={14} />
            PARAPAMJE E DRAFTIT
          </div>
          <div className="draft-document">
            <div className="draft-title">
              <strong>{data.type}</strong>
              <span>Prishtinë · {data.dispute}</span>
            </div>
            <p>
              Lidhur ndërmjet <b>{data.partyA || '[Pala e parë]'}</b> (Pala e
              parë) dhe <b>{data.partyB || '[Pala e dytë]'}</b> (Pala e dytë).
            </p>
            <DraftArticle
              number="1"
              title="Objekti"
              text={`${preview.object}.`}
            />
            <DraftArticle
              number="2"
              title="Pagesa dhe afatet"
              text={`Pagesa: ${preview.payment}. Kohëzgjatja: ${preview.deadline}.`}
            />
            <DraftArticle
              number="3"
              title="Përgjegjësitë"
              text={`${preview.responsibilities}.`}
            />
            {data.confidentiality && (
              <DraftArticle
                number="4"
                title="Konfidencialiteti"
                text="Palët ruajnë fshehtësinë e informatave të shkëmbyera gjatë dhe pas marrëdhënies kontraktuale."
              />
            )}
            <DraftArticle
              number="5"
              title="Ndërprerja"
              text={`Kontrata mund të ndërpritet ${preview.termination}.`}
            />
            <DraftArticle
              number="6"
              title="Zgjidhja e mosmarrëveshjeve"
              text={`Mosmarrëveshjet zgjidhen nga ${data.dispute}, sipas legjislacionit në fuqi të Republikës së Kosovës.`}
            />
          </div>
        </section>
      </div>
    </div>
  )
}

function Field({ label, children }: FieldProps) {
  return (
    <label className="wizard-field">
      <span>{label}</span>
      {children}
    </label>
  )
}

function DraftArticle({ number, title, text }: DraftArticleProps) {
  return (
    <div className="draft-article">
      <h4>
        Neni {number} — {title}
      </h4>
      <p>{text}</p>
    </div>
  )
}
