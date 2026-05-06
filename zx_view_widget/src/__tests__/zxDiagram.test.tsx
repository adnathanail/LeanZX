import React from 'react'
import { render as rtlRender, screen, waitFor } from '@testing-library/react'
import { vi, beforeEach, test, expect } from 'vitest'

const diagram = {
  nodes: [
    { id: 0, type: 'input' as const, ioId: 0 },
    { id: 1, type: 'spider' as const, color: 'Z' as const, phase: '1/2' },
    { id: 2, type: 'output' as const, ioId: 0 },
  ],
  edges: [
    { src: 0, tgt: 1 },
    { src: 1, tgt: 2 },
  ],
}

async function setup() {
  vi.doMock('../zxViewer.js', () => ({ default: 'function showGraph() {}' }))
  vi.doMock('d3', () => ({}))
  const { default: ZXDiagram } = await import('../zxDiagram')
  return ZXDiagram
}

beforeEach(() => {
  vi.resetModules()
})

test('renders D3 container after a successful render', async () => {
  const ZXDiagram = await setup()
  const { container } = rtlRender(<ZXDiagram diagram={diagram} />)
  await waitFor(() => {
    const div = container.querySelector('div[style*="background-color"]')
    expect(div).toBeInTheDocument()
  })
})

test('shows an error message when the render call throws', async () => {
  vi.doMock('../zxRender', () => ({
    render: () => { throw new Error('TS render error') },
  }))
  const ZXDiagram = await setup()
  rtlRender(<ZXDiagram diagram={diagram} />)
  await waitFor(() => screen.getByText(/TS render error/))
})
