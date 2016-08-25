# Browser Back Caching Example

## Run on your computer

Install

 * rvm
 * bundler

Develop

 * `bundle`
 * `foreman start`

## Run with Docker

Requirements:

 * Docker

Development:

 * `docker-compose up`

## Explanation of the fixes

This isn't a new issue and Internet is full of different fixes. I've gathered some that I feel are less hackier.

### <META> tags

HTML tells the browser not to store or cache pages.

```
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
```

This doesn't have any effect.

### Response headers

Source: http://stackoverflow.com/a/2068407/103049

Server tells the browser not to store or cache pages.

```
response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
response.headers['Pragma'] = 'no-cache'
response.headers['Expires'] = '0'
```

### Page Show Event tells if it's persisted

Source: http://stackoverflow.com/a/13123626/103049

This is recommend fix from Firefox and works also for Safari. Check if `pageshow` event includes a `persisted` boolean do reload if true.

```
window.onpageshow = function(event) {
  if (event.persisted) {
    window.location.reload()
  }
};
```

### Hidden input hack

Source: http://stackoverflow.com/a/20899422/103049

Create hidden input that retains the value between page loads.

```
<input type="hidden" id="refreshed" value="no">
```

Listen to `onload` event and check value from hidden input. Reload if necessary.

```
window.onload = function(){
  var refreshed = document.getElementById("refreshed");
  if(refreshed.value === "no") {
    refreshed.value = "yes";
  } else {
    refreshed.value = "no";
    window.location.reload();
  }
}
```

This fixed the issue on IE11 every second try or so. It also blew up my Capybara test suite.

### Body onunload

Source: http://jakub.fedyczak.net/post/force-page-refresh-on-back-button/

Attempts to trigger a reload with empty event handler.

```
<body onunload="">
```

I didn't see this working in any browser.

## Read more

 * https://madhatted.com/2013/6/16/you-do-not-understand-browser-history
 * https://webkit.org/blog/427/webkit-page-cache-i-the-basics/
 * https://developer.mozilla.org/en-US/docs/Working_with_BFCache
 * https://developer.mozilla.org/en-US/Firefox/Releases/1.5/Using_Firefox_1.5_caching
 * https://support.microsoft.com/en-us/kb/199805

## The MIT License (MIT)

Copyright (c) 2016 Mika Marttila

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
