// See the Tailwind default theme values here:
// https://github.com/tailwindcss/tailwindcss/blob/master/stubs/defaultConfig.stub.js
const colors = require('tailwindcss/colors')
const defaultTheme = require('tailwindcss/defaultTheme')

/** @type {import('tailwindcss').Config */
module.exports = {
  plugins: [
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/line-clamp'),
    require('@tailwindcss/typography'),
  ],

  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.erb',
    './app/views/**/*.haml',
    './app/views/**/*.slim',
    './lib/jumpstart/app/views/**/*.erb',
    './lib/jumpstart/app/helpers/**/*.rb',
  ],

  // All the default values will be compiled unless they are overridden below
  theme: {
    // Extend (add to) the default theme in the `extend` key
    extend: {
      // Create your own at: https://javisperez.github.io/tailwindcolorshades
      colors: {
        primary: colors.blue,
        secondary: colors.emerald,
        tertiary: colors.gray,
        danger: colors.red,
        "code-400": "#fefcf9",
        "code-600": "#3c455b",
        tokaniprimary: {
          '50': '#f2fcfc', 
          '100': '#e6f9f8', 
          '200': '#bff1ee', 
          '300': '#99e8e3', 
          '400': '#4dd6cf', 
          '500': '#00c5ba', // base
          '600': '#00b1a7', 
          '700': '#00948c', 
          '800': '#007670', 
          '900': '#00615b'
        },
        tokanisecondary: {
          '50': '#faf4fb', 
          '100': '#f5e9f7', 
          '200': '#e7c7ec', 
          '300': '#d8a6e0', 
          '400': '#bb63c9', 
          '500': '#9e20b2', // base
          '600': '#8e1da0', 
          '700': '#771886', 
          '800': '#5f136b', 
          '900': '#4d1057'
        },
        tokaniaccent: {
          '50': '#fef9f7', 
          '100': '#fdf2ee', 
          '200': '#fbdfd6', 
          '300': '#f9ccbd', 
          '400': '#f4a68b', 
          '500': '#ef8059', // base
          '600': '#d77350', 
          '700': '#b36043', 
          '800': '#8f4d35', 
          '900': '#753f2c'
      }
      },
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans],
      },
    },
  },

  // Opt-in to TailwindCSS future changes
  future: {
  },
}
