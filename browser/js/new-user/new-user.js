$('#new-user')
  .form({
    on: 'blur',
    fields: {
      match: {
        identifier  : 'passConfirm',
        rules: [
          {
            type   : 'match[pass]',
            prompt : 'Passwords do not match'
          }
        ]
      }
    }
  });
