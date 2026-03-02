import * as React from 'react'

const SERVER_URL = 'http://127.0.0.1:5050'

interface ZXWidgetProps {
  diagram: {
    nodes: Array<{
      id: number
      type: 'spider' | 'input' | 'output'
      color?: 'Z' | 'X'
      phase?: string
      ioId?: number
    }>
    edges: Array<{
      src: number
      tgt: number
    }>
  }
}

export default function ZXDiagram({ diagram }: ZXWidgetProps) {
  const [serverResponse, setServerResponse] = React.useState<string | null>(null)
  const [loading, setLoading] = React.useState(false)
  const [error, setError] = React.useState<string | null>(null)

  const diagramJson = JSON.stringify(diagram, null, 2)

  React.useEffect(() => {
    setLoading(true)
    setError(null)
    fetch(`${SERVER_URL}/diagram`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: diagramJson,
    })
      .then((res) => {
        if (!res.ok) throw new Error(`Server returned ${res.status}`)
        return res.json()
      })
      .then((data) => setServerResponse(JSON.stringify(data, null, 2)))
      .catch((err) => setError(err.message))
      .finally(() => setLoading(false))
  }, [diagramJson])

  return (
    <div style={{ fontFamily: 'monospace', padding: '10px' }}>
      <pre>{diagramJson}</pre>
      <hr />
      {loading && <p>Contacting server...</p>}
      {error && <p style={{ color: 'orange' }}>Server: {error}</p>}
      {serverResponse && (
        <div>
          <strong>Server response:</strong>
          <pre>{serverResponse}</pre>
        </div>
      )}
    </div>
  )
}
