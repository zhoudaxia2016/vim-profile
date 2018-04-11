import babel from 'rollup-plugin-babel'
import resolve from 'rollup-plugin-node-resolve'
import commonjs from 'rollup-plugin-commonjs'
import replace from 'rollup-plugin-replace'
import vue from 'rollup-plugin-vue'

export default {
  entry: 'src/scripts/main.js',
  dest: 'build/main.js',
  format: 'iife',
  sourceMap: 'inline',
  plugins: [
    babel({
      exclude: ['node_modules/**', '**/*.vue'],
    }),
    resolve(),
    commonjs(),
    replace({
      'process.env.NODE_ENV': JSON.stringify('development'),
      'process.env.VUE_ENV': JSON.stringify('brower')
    }),
    vue({
      compileTemplate: true
    }),
  ]
}
