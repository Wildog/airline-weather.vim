#airline-weather.vim

![screenshot](https://raw.githubusercontent.com/Wildog/airline-weather.vim/master/screenshot.png)
This is a vim-airline extension to show current weather on the right end of the status line, just like the weather segment in Powerline.

__This extension depends on [vim-airline](https://github.com/bling/vim-airline) and [webapi-vim](https://github.com/mattn/webapi-vim), you should install them first.__

##Installation

* ###Use Vundle

    Make sure you have these lines in your .vimrc

        Plugin 'bling/vim-airline'
        Plugin 'mattn/webapi-vim'
        Plugin 'Wildog/airline-weather.vim'

    :PluginInstall

* ###Manually
Make sure you have installed [vim-airline](https://github.com/bling/vim-airline) and [webapi-vim](https://github.com/mattn/webapi-vim), then put files to corresponding directories.

##Usage

* Set location

        let g:weather#area = 'newyorkcity,us'

* Set unit ('metric' for ºC, 'imperial' for ºF.):

        let g:weather#unit = 'metric'

* Set API Key, default key is provided but it'd be better if you use your own OpenWeatherMap API key, you can apply for it [here](http://openweathermap.org/appid) for free:

        let g:weather#appid = '2de143494c0b295cca9337e1e96b00e0'

* This extension use a cache file to store weather informations, and update the weather information every hour as default, you may change it with caution, update too frequently will slow down vim.

        let g:weather#cache_file = '~/.cache/.weather'
        let g:weather#cache_ttl = '3600'

* Configure the format, %s for weather icon, %f for temperature.

        let g:weather#format = '%s %.0f'

* Configure weather icon, suffix 'd' for the day and 'n' for the night, you can find informations about weather icon code [here](http://openweathermap.org/weather-conditions)

        let g:weather#status_map = {
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
        \}

* Plus, you can force refresh the weather by

        :call RefreshWeather()

##LICENSE
MIT
