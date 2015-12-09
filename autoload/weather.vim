scriptencoding utf-8

let s:unit = {
\ "metric": "°C",
\ "imperial": "°F",
\}

let s:status = get(g:, 'weather#status_map', {
\ "01": "☀",
\ "02": "☁",
\ "03": "☁",
\ "04": "☁",
\ "09": "☂",
\ "10": "☂",
\ "11": "☈",
\ "13": "❅",
\ "50": "≡",
\})

let g:weather#cache_file = get(g:, 'weather#cache_file', '~/.cache/.weather')

let g:weather#cache_ttl = get(g:, 'weather#cache_ttl', '3600')

let g:weather#unit = get(g:, 'weather#unit', 'metric')

let g:weather#format = get(g:, 'weather#format', '%s %.0f'.s:unit[g:weather#unit])

let g:weather#appid = get(g:, 'weather#appid', '2de143494c0b295cca9337e1e96b00e0')

function! weather#get(forcerefresh) abort
  if !exists("g:weather#area")
    echom "Please set your location in .vimrc, for example: let g:weather#area='newyorkcity,us'"
    return ""
    finish
  endif
  let file = expand(g:weather#cache_file)
  " init cache file if not exist
  if !filereadable(file)
    let init_content = webapi#http#get(printf("http://api.openweathermap.org/data/2.5/weather?q=%s&units=%s&appid=%s", g:weather#area, g:weather#unit, g:weather#appid)).content
    call writefile(split(init_content, "\n"), file)
  endif
  " cache exists
  let content = join(readfile(file), "\n")
  " cache expired
  if localtime() - getftime(file) > g:weather#cache_ttl || a:forcerefresh
    let connectivity = system("ping -q -c 1 -t 1 baidu.com > /dev/null && echo y || echo n")[0]
    " internet connected, get weather and update cache
    if connectivity == 'y'
      let content = webapi#http#get(printf("http://api.openweathermap.org/data/2.5/weather?q=%s&units=%s&appid=%s", g:weather#area, g:weather#unit, g:weather#appid)).content
    endif
    " no internet connection, just use old cache and rewrite it
    call writefile(split(content, "\n"), file)
  endif
  let json = webapi#json#decode(content)
  let area = json["name"]
  let status = json["weather"][0]["icon"][:1]
  let degree = json["main"]["temp"]
  return printf(g:airline_right_alt_sep.' '.g:weather#format,
  \ has_key(s:status, status) ? s:status[status] : '?',
  \ degree)
  return ''
endfunction

function! RefreshWeather()
    call weather#get(1)
    echom "Weather refreshed."
endfunction
