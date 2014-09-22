# Changelog

## 1.1.2

  - Fixing blue_green_previous and blue_green_live custom variables new names under tasks

## 1.1.1

  - Cleanup the gem package, removing docs file.

## 1.1.0

  - Changing custom variables name for live and previous dir
  - Adding cap deploy:blue_green:pre command to deploy application

## 1.0.0

  - Removing cleanup callback after live deploy. Need to put manually in Capfile.
  - Releasing 1.0.0 version :)

## 1.0.0.pre.rc1

  - Adding fully functional ```cap deploy:blue_green:live``` command
  - Adding fully functional ```cap deploy:blue_green:rollback``` command
  - Overriding default ```cap deploy:cleanup``` command to use the gem cleanup command: ```cap deploy:blue_green:cleanup```
