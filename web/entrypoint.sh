#!/bin/bash

home_dir='/opt/config'

if [ ! -d $home_dir ]; then
	mkdir $home_dir
fi

#start node
node ./bin/www