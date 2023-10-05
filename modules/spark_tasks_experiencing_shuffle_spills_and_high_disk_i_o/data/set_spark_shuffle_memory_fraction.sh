

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