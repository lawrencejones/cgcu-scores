fetchAndPlot = (chart, interval) ->
  console.log 'Fetching new data'
  $.get '/dept', (dept) ->
    console.log 'Plotting fetched data'
    window.dept = dept # make globally available
    chart.Bar
      labels: (d.dept for d in dept)
      datasets: [
        {
          fillColor: 'rgba(220,220,220,0.5)'
          strokeColor: 'rgba(220,220,220,1)'
          data: (d.score for d in dept)
        }
      ]
    setTimeout (-> fetchAndPlot chart, interval), interval

$ ->

  ctx = document.getElementById('scores').getContext '2d'
  chart = new Chart(ctx)
  fetchAndPlot chart, 2000

