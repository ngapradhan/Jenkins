#/bin/bash

PLUGIN_FILE="./plugins.txt"

while read line; do
    plugin=$(echo $line | awk '{print $1}')
    version=$(echo "$line" | awk '{print $2}')
    
    url="http://ip172-18-0-146-csq4j5ol2o9000e0ldn0-8081.direct.labs.play-with-docker.com/repository/jenkins-plugins/$plugin/$version/$plugin.hpi"
    
    curl -L "$url" -o "/usr/share/jenkins/ref/plugins/$plugin.jpi"
    
done < "$PLUGIN_FILE"
