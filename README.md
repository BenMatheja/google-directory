Google-Directory
----------------


```
GoogleDirectory::Config.client_id = ""
GoogleDirectory::Config.client_secret = ""
GoogleDirectory::Config.client_email = ""
GoogleDirectory::Config.config_dir = "/tmp"

response = GoogleDirectory::User.new.users
```

config_dir points to the directory which stores the refresh_token data