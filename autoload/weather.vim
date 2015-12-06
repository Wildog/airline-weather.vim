scriptencoding utf-8

let s:unit = {
\ "metric": "°C",
\ "imperial": "°F",
\}

let s:status = get(g:, 'weather#status_map', {
\ "01": "☼",
\ "02": "☁",
\ "03": "☁",
\ "04": "☁",
\ "09": "☂",
\ "10": "☂",
\ "11": "☈",
\ "13": "❅",
\ "50": "≡",
\})

let g:weather#area = get(g:, 'weather#area', 'beijing,china')

let g:weather#cache_file = get(g:, 'weather#cache_file', '~/.cache/.weather')

let g:weather#cache_ttl = get(g:, 'weather#cache_ttl', '3600')

let g:weather#unit = get(g:, 'weather#unit', 'metric')

let g:weather#format = get(g:, 'weather#format', '%s %.0f'.s:unit[g:weather#unit])

let g:weather#appid = get(g:, 'weather#appid', '2de143494c0b295cca9337e1e96b00e0')

function! weather#get() abort
    let file = expand(g:weather#cache_file)
    let content = ""
    if filereadable(file)
      if localtime() - getftime(file) < g:weather#cache_ttl
        let content = join(readfile(file), "\n")
      endif
    endif
    if content == ""
      let content = webapi#http#get(printf("http://api.openweathermap.org/data/2.5/weather?q=%s&units=%s&appid=%s", g:weather#area, g:weather#unit, g:weather#appid)).content
      call writefile(split(content, "\n"), file)
    endif
    let json = webapi#json#decode(content)
    let area = json["name"]
    let status = json["weather"][0]["icon"][:1]
    let degree = json["main"]["temp"]
    return printf(g:weather#format,
    \ has_key(s:status, status) ? s:status[status] : '?',
    \ degree)
endfunction
