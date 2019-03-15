(function() {
  const context = this

  const FormControl = {
    selector: '[data-form-input]',
    formGroup: '.form-group--float',
    classes: {
      focus: 'form-group--focused',
      invalid: 'form-group--invalid',
      filled: 'form-group--filled',
      valid: 'form-group--valid'
    },
    init: function () {
      const _this = this
      const elements = $(_this.selector)
      elements.on('focus blur', (i) => {
        const curElement = i.target
        const curGroup = $(curElement).parents(_this.formGroup)
        curGroup
          .toggleClass(_this.classes.focus, i.type === 'focus')
          .toggleClass(_this.classes.filled, curElement.value.length !== 0 && i.type === 'blur')
          .toggleClass(_this.classes.invalid, !curElement.checkValidity() && i.type === 'blur')
          .toggleClass(_this.classes.valid, curElement.checkValidity() && curElement.value.length !== 0 && i.type === 'blur')
      })
      elements.each((ind, el) => {
        if ($(el).val().length !== 0) {
          console.log($(el).val(), $(el))
          $(el).parents(_this.formGroup).addClass(_this.classes.filled)
        }
      })
    }
  }

  function _run (msg) {
    FormControl.init()
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