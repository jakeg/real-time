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

socket.on('sync:pos', function (data) {
  console.log('moving', data);
  $('#hotspot').css('left', (data.x - 10) + 'px').css('top', (data.y - 10) + 'px');
  $('#mover').text(data.name);
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

  // i like to move it move it
  $('img').on('click', function(e) {
    var offset = $(this).parent().offset();
    var x = e.pageX - offset.left;
    var y = e.pageY - offset.top;
    console.log(x, y);
    socket.emit('move', {x: x, y: y});
  });

  // quick img changer
  $('.quick').on('click', function() {
    socket.emit('img_change', $(this).attr('href'));
    return false;
  });
});