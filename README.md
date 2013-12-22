Android Bootcamp REST server
============================

Install
-------

Install MongoDB for OSX
```shell
brew install mongo
```

Clone the repo
```shell
git clone https://github.com/dbousamra/android-bootcamp-rest-server
```

Change directory into the project repo
```shell
cd android-bootcamp-rest-server
```

Install gems
```shell
bundle install
```

Run
---

Change directory into the project repo
```shell
cd android-bootcamp-rest-server
```

Start the database server
```shell
mongod
```
Start the Sinatra server
```shell
ruby app.rb
```
### Browse to http://localhost:4567/

Rake tasks!
-----------

Seed db data
```shell
rake db:seed
```

Drop db data
```shell
rake db:drop
```

Run the specs
```shell
rake spec
```
