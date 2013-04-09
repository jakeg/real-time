###
  USAGE:
    - $ npm install
    - $ coffee server.coffee
    - ensure nginx is running to proxy ubuntu vm to windows host
    - connect to phone's hotspot
    - give everyone the phone's access-point name and password
    - ipconfig then tell everyone ip e.g. 192.168.1.100:8081
    - let the fun commence!
###

# BORING STUFF
port = 8081
app = require('express')()
server = require('http').createServer(app)
io = require('socket.io').listen(server)
server.listen(port)
app.get('/', (req, res) -> res.sendfile(__dirname + '/index.html'))
app.get('/jquery.js', (req, res) -> res.sendfile(__dirname + '/jquery.js'))
app.get('/client.js', (req, res) -> res.sendfile(__dirname + '/client.js'))
io.enable('browser client minification')  # send minified client
io.enable('browser client etag')          # apply etag caching logic based on version number
io.enable('browser client gzip')          # gzip the file
io.set('log level', 1)                    # reduce logging

### FUN STUFF BELOW ###

todays_topic = 'no topic yet'
todays_img = 'http://farm4.static.flickr.com/3066/2677948183_52d02f4f8e_o.jpg'
global_pos = {x:100, y:100}
mover = 'Anon'

io.sockets.on('connection', (socket) ->

  # set a default name
  socket.set('name', 'Anon')

  # share current stuff with new peeps
  socket.emit('sync:topic', todays_topic)
  socket.emit('sync:img', todays_img)
  socket.emit('sync:pos', global_pos)

  console.log('session', socket.id)

  # change your name and tell everyone about it
  socket.on('name_change', (name) ->
    console.log('name change', name)
    socket.set('name', name, ->
      io.sockets.emit('sync:name', name)
    )
  )

  # anyone can change this one
  socket.on('topic_change', (topic) ->
    console.log('topic change', topic)
    todays_topic = topic
    io.sockets.emit('sync:topic', topic)
  )

  # anyone can change this one
  socket.on('img_change', (img) ->
    console.log('img change', img)
    todays_img = img
    io.sockets.emit('sync:img', img)
  )

  # move and shake
  socket.on('move', (pos) ->
    console.log('move', pos)
    global_pos = pos
    socket.get('name', (err, name) ->
      pos.name = name
      io.sockets.emit('sync:pos', pos)
    )
  )

  socket.on('disconnect', ->
    console.log('TODO: deal with socket disconnects')
  )

)