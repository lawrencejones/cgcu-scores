console.log 'Sudo user'
$modal = $ '#new-score'

openModal = ->

  submitScore = (dept, score) ->
    $.ajax
      url: "/dept/#{dept}/score"
      method: 'POST'
      data: { score: score }
      success: (data) ->
        $('#new-score').modal 'hide'

  selectScore = ($table, score) ->
    $table.html ''
    for dept in window.dept
      $row = $ "<tr><td>#{dept.dept}</td></tr>"
      $row.click -> submitScore $(this).text(), score
      $table.append $row
    
  populateScoreOptions = ($table) ->
    for i in [1..5]
      $row = $ "<tr><td>#{i*10}</td></tr>"
      $row.click -> selectScore $table, parseInt $(this).text(), 10
      $table.append $row

  $modal.modal()
  $table = $('#new-score table')
  $table.html ''
  populateScoreOptions $table

$('canvas#scores').click openModal
  



