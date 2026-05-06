import commonjs from '@rollup/plugin-commonjs'
import resolve from '@rollup/plugin-node-resolve'
import replace from '@rollup/plugin-replace'
import terser from '@rollup/plugin-terser'
import { readdirSync, readFileSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import path from 'node:path'

const __dirname = fileURLToPath(new URL('.', import.meta.url))

// Imports src .js files (like zxViewer.js) as plain string modules so they can
// be embedded for eval(). Resolves paths from dist/ back to src/ since tsc
// compiles there but these files stay in src/.
const rawAssets = {
  name: 'raw-assets',
  resolveId(id, importer) {
    if (id.endsWith('.js') && importer) {
      const srcImporter = importer.replace(`${path.sep}dist${path.sep}`, `${path.sep}src${path.sep}`)
      const resolved = path.resolve(path.dirname(srcImporter), id)
      // Only handle .js files that live in src/ (not node_modules)
      if (!resolved.includes(path.join(__dirname, 'src'))) return null
      return resolved
    }
  },
  load(id) {
    if (id.endsWith('.js') && id.includes(path.join(__dirname, 'src'))) {
      return `export default ${JSON.stringify(readFileSync(id, 'utf8'))};`
    }
  },
}

const production = process.env.NODE_ENV === 'production'
const outputDir = process.env.OUTPUT_DIR || 'build'

const inputs = readdirSync('dist').filter(f => f.endsWith('.js')).map(f => `dist/${f}`)

export default inputs.map(input => ({
  input,
  output: {
    dir: outputDir,
    format: 'es',
    sourcemap: production ? false : 'inline',
    intro: 'const global = window;',
  },
  external: [
    'react',
    'react-dom',
    'react/jsx-runtime',
    '@leanprover/infoview',
  ],
  plugins: [
    rawAssets,
    resolve({ browser: true }),
    replace({
      preventAssignment: true,
      'typeof window': JSON.stringify('object'),
      'process.env.NODE_ENV': JSON.stringify(production ? 'production' : 'development'),
    }),
    commonjs(),
    production && terser(),
  ],
}))
