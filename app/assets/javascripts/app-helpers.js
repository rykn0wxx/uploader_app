(function() {
  const context = this

  function _run (msg) {
    const auth_element = document.getElementsByClassName('auth')
    if (auth_element.length !== 0) {
      document.body.classList.add('auth')
    } else {
      document.body.classList.remove('auth')
    }
  }

  if (document.readyState !== 'loading') {
    _run('document.readyState')
  } else if (document.addEventListener) {
    if (context.Turbolinks) {
      document.addEventListener('turbolinks:load', _run('turbolinks:load'))
    } else {
      document.addEventListener('DOMContentLoaded', _run('DOMContentLoaded'))
    }
  } else {
    document.attachEvent('onreadystatechange', () => {
      if (document.readyState ==='complete') _run('onreadystatechange')
    })
  }

}).call(this)