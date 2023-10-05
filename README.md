
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Spark tasks experiencing shuffle spills and high disk I/O.
---

This incident type typically occurs in distributed computing systems, where Spark tasks are experiencing high disk I/O and shuffle spills. Spark is a popular distributed computing engine that uses shuffle operations to move data between nodes in a cluster, which can sometimes result in performance issues due to spills. The spills occur when the data being shuffled exceeds the memory capacity allocated for the shuffle operations. This incident requires optimization of the shuffle operations to reduce spills and improve overall performance.

### Parameters
```shell
export COUNT="PLACEHOLDER"

export INTERVAL="PLACEHOLDER"

export APPLICATION_ID="PLACEHOLDER"

export NEW_MEMORY_FRACTION_VALUE="PLACEHOLDER"

export CONFIGURATION_PARAMETER_TO_UPDATE="PLACEHOLDER"

export PATH_TO_SPARK_CONF="PLACEHOLDER"
```

## Debug

### Check the disk I/O usage
```shell
iostat -x ${INTERVAL} ${COUNT}
```

### Check the network bandwidth usage
```shell
sar -n DEV ${INTERVAL} ${COUNT}
```

### Check the Spark task metrics
```shell
yarn logs -applicationId ${APPLICATION_ID} | grep "TaskMetrics" | grep "ExecutorRunTime"
```

### Check the shuffle size and spill metrics
```shell
yarn logs -applicationId ${APPLICATION_ID} | grep "ShuffleMetrics" | grep "spilled"
```

### Check the system resource usage
```shell
top
```

### Insufficient memory allocated for shuffle operations.
```shell


#!/bin/bash



# set the Spark configuration file path

SPARK_CONF=${PATH_TO_SPARK_CONF}



# get the current value of spark.memory.fraction

MEMORY_FRACTION=$(grep "spark.memory.fraction" $SPARK_CONF | awk '{print $3}')



# calculate the current value of spark.shuffle.memoryFraction

SHUFFLE_MEMORY_FRACTION=$(echo "scale=2; $MEMORY_FRACTION * 0.2" | bc)



# get the current value of spark.shuffle.memoryFraction

CURRENT_SHUFFLE_MEMORY_FRACTION=$(grep "spark.shuffle.memoryFraction" $SPARK_CONF | awk '{print $3}')



# compare the current value of spark.shuffle.memoryFraction with the calculated value

if (( $(echo "$CURRENT_SHUFFLE_MEMORY_FRACTION < $SHUFFLE_MEMORY_FRACTION" | bc -l) )); then

    # if the current value is less than the calculated value, increase the memory fraction for shuffle operations

    sed -i "s/spark.shuffle.memoryFraction=.*/spark.shuffle.memoryFraction=$SHUFFLE_MEMORY_FRACTION/g" $SPARK_CONF

    echo "Increased memory fraction for shuffle operations to $SHUFFLE_MEMORY_FRACTION"

else

    echo "Memory fraction for shuffle operations is already sufficient"

fi


```

## Repair

### Increase the memory allocation for shuffle operations to avoid spills. This can be done by increasing the `spark.shuffle.memoryFraction` or `spark.memory.fraction` configuration parameters.
```shell
bash

#!/bin/bash



# Set the path to the Spark configuration file

SPARK_CONF=${PATH_TO_SPARK_CONF}



# Set the new memory fraction value

NEW_MEM_FRACTION=${NEW_MEMORY_FRACTION_VALUE}



# Set the configuration parameter to be updated

CONF_PARAM=${CONFIGURATION_PARAMETER_TO_UPDATE}



# Update the configuration parameter in the Spark configuration file

sed -i "s/$CONF_PARAM=.*/$CONF_PARAM=$NEW_MEM_FRACTION/g" $SPARK_CONF



# Restart the Spark cluster to apply the configuration changes

sudo systemctl restart spark


```