@colors = colors = ['#fc3500', '#fff77f', '#00ffa8', '#ff00b4', '#00fcff']

componentToHex = (c) ->
  hex = c.toString(16)
  (if hex.length is 1 then "0" + hex else hex)
rgbToHex = (r, g, b) ->
  "#" + componentToHex(r) + componentToHex(g) + componentToHex(b)

rgbToHsl = (r, g, b) ->
  r /= 255
  g /= 255
  b /= 255

  max = Math.max(r, g, b)
  min = Math.min(r, g, b)
  h = undefined
  s = undefined
  l = (max + min) / 2
  if max is min
    h = s = 0 # achromatic
  else
    d = max - min
    s = (if l > 0.5 then d / (2 - max - min) else d / (max + min))
    switch max
      when r
        h = (g - b) / d + ((if g < b then 6 else 0))
      when g
        h = (b - r) / d + 2
      when b
        h = (r - g) / d + 4
    h /= 6
  [h, s, l]
hexToRgb = (hex) ->
  result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
  if result
    [
      parseInt(result[1], 16)
      parseInt(result[2], 16)
      parseInt(result[3], 16)
    ]

  else null

hslToRgb = (h, s, l) ->
  r = undefined
  g = undefined
  b = undefined
  if s is 0
    r = g = b = l # achromatic
  else
    hue2rgb = (p, q, t) ->
      t += 1  if t < 0
      t -= 1  if t > 1
      return p + (q - p) * 6 * t  if t < 1 / 6
      return q  if t < 1 / 2
      return p + (q - p) * (2 / 3 - t) * 6  if t < 2 / 3
      p
    q = (if l < 0.5 then l * (1 + s) else l + s - l * s)
    p = 2 * l - q
    r = hue2rgb(p, q, h + 1 / 3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1 / 3)
  [
    Math.round(r * 255)
    Math.round(g * 255)
    Math.round(b * 255)
  ]

invertRgb = (obj) ->
  r: 255-obj.r
  g: 255-obj.g
  b: 255-obj.b

rgbToString = (r, g, b) ->
  "rgb(#{r}, #{g}, #{b})"

@complementary = (hex) ->
  rgb = hexToRgb(hex)
  hsl = rgbToHsl.apply null, rgb
  invertedHsl = [hsl[0]+0.5, hsl[1], hsl[2]]
  rgb = hslToRgb.apply null, invertedHsl
  rgbToHex.apply(null, rgb)

@darken = (hex, amount) ->
  rgb = hexToRgb(hex)
  hsl = rgbToHsl.apply null, rgb
  darkened = [hsl[0], hsl[1], hsl[2]-amount]
  rgb = hslToRgb.apply null, darkened
  rgbToHex.apply(null, rgb)

between = (n1, n2) ->
  Math.floor (Math.random()*(n2-n1))+n1
# @RandomColorMixin = ->
  