angular.module('cgcu')
  .directive 'chart', (Dept) ->
    restrict: 'AEC'
    link: ($scope, $elem, attr) ->

      plot = (depts) ->

        maxScore = Math.max (scores = (d.score for d in depts))...

        inc   = Math.max 10, Math.floor(maxScore/100)*10
        steps = Math.floor(1.1*maxScore/inc) + 1

        data   = ([[i, d.score]] for d,i in depts)
        labels = (d.name for d in depts)

        options =
          xaxis:
            tickLength: 0
            tickFormatter: (x) -> labels[x]
            min: -0.5, max: depts.length - 0.5
            tickSize: 1
          yaxis:
            tickLength: 0
            min: 0, max: inc*steps
          bars:
            show: true
            align: 'center'
            barWidth: 0.5
          grid:
            borderWidth:
              top: 0, right: 0
              bottom: 1, left: 1
          colors: [
            '#314043', '#3FB8CD', '#9AD74C'
            '#FBA44F', '#EE5E91', '#F46040'
          ]

        chart = $.plot $elem, data, options

      Dept.get (depts) ->
        plot (d for n,d of depts)
