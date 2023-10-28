# Very Basic Log Rotater

<!-- toc -->

- [Synopsis](#synopsis)
- [Why?](#why)
- [Disclaimer](#disclaimer)
- [Help](#help)

<!-- /toc -->

## Synopsis

This is a very basic log rotater written in a single shell script.

## Why?

Because it does the job.

## Disclaimer

Warning. Use this software at your own risk. I may not be hold responsible for any data loss, starving your kittens or losing the bling bling powerpoint presentation you made to impress human resources with the efficiency of your employee's performance.

## Help

```go mdox-exec="./rotate.sh -h"

vblr help

  args
    -h/--help    display help
    -d/--debug   just print don't do
    -[0-9]+      to indicate how many old zip logs to keep, default is 0 and keeps all

  usage
    rotate.sh /var/log
    rotate.sh /var/log -5
    rotate.sh /var/log -9 -d

```
