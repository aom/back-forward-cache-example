# Browser Back Caching Example

Install

 * rvm
 * bundler

Develop

 * clone
 * `bundle`

## Explanation of the fixes

This doesn't seem to be a new issue and Internet is full of different fixes. I've gathered some that I feel are less hackier.

### <META> tags

HTML tells the browser not to store or cache pages.

```
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
```

### Response headers

Server tells the browser not to store or cache pages.

```
response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
response.headers['Pragma'] = 'no-cache'
response.headers['Expires'] = '0'
```

### Page Show Event tells if it's persisted

This one seems rather new Safari specific fix. `pageshow` event includes a `persisted` boolean and does reload if true.

```
window.onpageshow = function(event) {
  if (event.persisted) {
    window.location.reload()
  }
};
```
