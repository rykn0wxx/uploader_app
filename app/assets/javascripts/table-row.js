(function() {
  const context = this

  const TableRow = {
    selector: '[data-row-url]',
    keycodes: {
      space: 32,
      enter: 13
    },
    visitUrl: function (event) {
      if (event.type === 'click' || event.keyCode == this.keycodes.space || event.keyCode == keycodes.enter) {
        if (event.target.href) return;
        const dataUrl = event.target.parentElement.dataset.rowUrl
        const selection = context.getSelection().toString()
        if (selection.length === 0 && dataUrl) {
          window.location = dataUrl
        }
      }
    },
    init: function () {
      const elems = document.querySelectorAll(`${this.selector}`)
      elems.forEach((elem, ind) => {
        elem.addEventListener('click', this.visitUrl.bind(TableRow))
      })
    }
  }

  function _run (msg) {
    TableRow.init.bind(TableRow)()
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
      if (document.readyState=='complete') _run('onreadystatechange')
    })
  }

}).call(this)