fetchAndPlot = (chart, interval) ->
  console.log 'Fetching new data'
  $.get '/dept', (dept) ->

    console.log 'Plotting fetched data'

    colors = [
      
    ]

    window.dept = dept # make globally available
    maxScore = Math.max (scores = (d.score for d in dept))...
    
    inc   = Math.max 10, Math.floor(maxScore/100)*10
    steps = Math.floor(1.1*maxScore/inc) + 1

    options =
      animation: false
      scaleShowGridLines: false
      scaleOverride: true
      # Required for step calculations
      scaleSteps: steps
      scaleStepWidth: inc
      scaleStartValue: 0
    data =
      labels: (d.dept for d in dept)
      datasets: [
        fillColor: 'rgba(220,220,220,0.5)'
        strokeColor: 'rgba(220,220,220,1)'
        data: scores
      ]

    chart.Bar data, options

$ ->

  ctx = document.getElementById('scores').getContext '2d'
  chart = new Chart(ctx)
  fetchAndPlot chart, 2000

