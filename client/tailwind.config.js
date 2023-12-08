/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{js,jsx,ts,tsx}"],
  theme: {
    extend: {
      colors: {
        'darkblue': '#013034',
        'blue1': '#0E494E',
        'blue2':'#146269',
        'blue3':'#417C81',
        'bluelight': '#86BEC2',
        'medium':'#4F959B',
        'superlight':'#B6DADD',
        'red':'#FF7070',
        'darkred':'#DD4708',
        primary: {"50":"#eff6ff","100":"#dbeafe","200":"#bfdbfe","300":"#93c5fd","400":"#60a5fa","500":"#3b82f6","600":"#2563eb","700":"#1d4ed8","800":"#1e40af","900":"#1e3a8a","950":"#172554"}
      },
      aspectRatio: {
        '4/3': '4 / 3',
        '3/4': '3 / 4',
      }
    },
  },
  plugins: [],
};


