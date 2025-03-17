/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ['./{lib,web}/**/*.dart'],
    theme: {
      extend: {
        animation: {
          typewriter: "typewriter 2s steps(11) forwards"
        },
        keyframes: {
          typewriter: {
            to: {
              left: "100%"
            }
          }
        }
      },
    },
    plugins: [
        require('daisyui'),
    ],
  }
  