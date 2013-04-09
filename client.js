var socket = io.connect('/');

socket.on('sync:name', function (data) {
  console.log('name', data);
});

socket.on('sync:topic', function (data) {
  console.log('topic', data);
  $('#todays-topic').text(data);
});

socket.on('sync:img', function (data) {
  console.log('img', data);
  $('img').attr('src', data);
});

$(function() {
  // change your name
  $('#input-name').on('keyup', function() {
    socket.emit('name_change', $(this).val());
  });

  // anyone can change this message
  $('#input-share').on('click', function() {
    socket.emit('topic_change', $('#input-topic').val());
  });

  // anyone can share an img url
  $('#input-share2').on('click', function() {
    socket.emit('img_change', $('#input-img').val());
  });
});