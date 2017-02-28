console.log('play_invitation coffee')

window.PlayInvitation =
  showChildren: (family_select) ->
    family_id = $(family_select).val()
    if $('#children_' + family_id).length > 0
      $('#play_invitation_parents').html($('#parents_' + family_id).html())
      if $('#play_invitation_parents select option').length == 2
        $('#play_invitation_parents select').val($($('#play_invitation_parents select option')[1]).val())

      $('#play_invitation_children').html($('#children_' + family_id).html())
      $('#play_invitation_children select').click ->
        child_id = $(this).val()
        if $('#friends_' + child_id).length > 0
          console.log($('#friends_' + child_id))
          console.log($('#play_invitation_friends'))
          $('#play_invitation_friends').html($('#friends_' + child_id).html())
  initialize: () ->
    if $('#family_id option').length == 2
      $('#family_id').val($($('#family_id option')[1]).val())
      window.PlayInvitation.showChildren($('#family_id'))

console.log(window.PlayInvitation)