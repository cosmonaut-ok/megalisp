#!/bin/sh

tar cvzf dummy.box ./metadata.json

ssh-keygen -f docker/id_rsa -t rsa -N '' -q
