#!/bin/sh

tar czf dummy.box ./metadata.json

ssh-keygen -f docker/id_rsa -t rsa -N '' -q
