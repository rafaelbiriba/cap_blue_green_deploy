# Changelog

## ??

  - Changing custom variables name for live and previous dir

## 1.0.0

  - Removing cleanup callback after live deploy. Need to put manually in Capfile.
  - Releasing 1.0.0 version :)

## 1.0.0.pre.rc1

  - Adding fully functional ```cap deploy:blue_green:live``` command
  - Adding fully functional ```cap deploy:blue_green:rollback``` command
  - Overriding default ```cap deploy:cleanup``` command to use the gem cleanup command: ```cap deploy:blue_green:cleanup```
