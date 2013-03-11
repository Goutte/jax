class Jax.Mesh.LineCube extends Jax.Mesh.Lines
  constructor: (@halfSize = 0.5, @offset = [0,0,0]) ->
    if typeof @halfSize isnt 'number'
      super @halfSize
      @halfSize = @size / 2
    else
      super()
  
  init: (vertices, colors, normals, textures, indices) ->
    halfSize = @halfSize
    offset = @offset
    
    v = vec3.create()
    # left quad
    vertices.push vec3.add(v, vec3.scale(v, [-1, 1, 1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [-1, 1,-1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [-1, 1,-1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [-1,-1,-1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [-1,-1,-1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [-1,-1, 1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [-1,-1, 1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [-1, 1, 1], halfSize), offset)...
    # right quad
    vertices.push vec3.add(v, vec3.scale(v, [ 1, 1, 1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [ 1, 1,-1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [ 1, 1,-1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [ 1,-1,-1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [ 1,-1,-1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [ 1,-1, 1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [ 1,-1, 1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [ 1, 1, 1], halfSize), offset)...
    # front horizontal
    vertices.push vec3.add(v, vec3.scale(v, [-1, 1, 1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [ 1, 1, 1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [-1,-1, 1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [ 1,-1, 1], halfSize), offset)...
    # back horizontal
    vertices.push vec3.add(v, vec3.scale(v, [-1, 1,-1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [ 1, 1,-1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [-1,-1,-1], halfSize), offset)...
    vertices.push vec3.add(v, vec3.scale(v, [ 1,-1,-1], halfSize), offset)...

    true
