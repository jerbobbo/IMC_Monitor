imcMonitorJS
============
Monitoring Application for international telecom traffic based on parsing Sansay Softswitch CDRs

Installation
============

- Run npm install
- create config folder along with db-config.js, ftp-config.js:

  db-config.js
  ```
  module.exports = {
    "DATABASE_USER": "user",
    "DATABASE_PASS": "password",
    "DATABASE_URI": "db_name",
    "DATABASE_HOST": "127.0.0.1",
    "DATABASE_PORT": 3306
  };
  ```

  ftp-config.js (add url's of each Sansay Softswitch)
  ```
  module.exports = {
    "USERNAME": "user",
    "PASSWORD": "password",
    "SERVERS": [
      '192.168.0.1',
      '192.168.20.22',
    ]
  };
