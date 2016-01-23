scriptencoding utf-8

let s:unit = {
\ "metric": "°C",
\ "imperial": "°F",
\}

let s:status = get(g:, 'weather#status_map', {
\ "01d": "☀",
\ "02d": "☁",
\ "03d": "☁",
\ "04d": "☁",
\ "09d": "☂",
\ "10d": "☂",
\ "11d": "☈",
\ "13d": "❅",
\ "50d": "≡",
\ "01n": "☽",
\ "02n": "☁",
\ "03n": "☁",
\ "04n": "☁",
\ "09n": "☂",
\ "10n": "☂",
\ "11n": "☈",
\ "13n": "❅",
\ "50n": "≡",
\})

let g:weather#cache_file = get(g:, 'weather#cache_file', '~/.cache/.weather')

let g:weather#cache_ttl = get(g:, 'weather#cache_ttl', '3600')

let g:weather#unit = get(g:, 'weather#unit', 'metric')

let g:weather#format = get(g:, 'weather#format', '%s %.0f'.s:unit[g:weather#unit])

let g:weather#appid = get(g:, 'weather#appid', 'ed90eae4e8091ae0975288aeb85f9f74')

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
  if !has_key(json, "name") || !has_key(json["main"], "temp")
      return g:airline_right_alt_sep.' '."API Err"
  endif
  let area = json["name"]
  let status = json["weather"][0]["icon"][:2]
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
