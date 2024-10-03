
# PySpark Setup on Hadoop Cluster for User `hadoop`

This guide explains how to set up PySpark on a Hadoop cluster for a new user named `hadoop`.

---

## Prerequisites for User `hadoop`

### 1. Login as `hadoop` on Both Systems (Master and Slave Nodes)
```bash
su - hadoop
```

### 2. Grant `hadoop` sudo Privileges
If `hadoop` does not have sudo privileges, add them by editing the sudoers file:
```bash
sudo visudo
```
Add the following line:
```bash
hadoop ALL=(ALL) NOPASSWD: ALL
```

### 3. Install Java and Python
Ensure that both Java and Python are installed and configured for the `hadoop` user.

---

## Download and Install Spark as `hadoop` User

### 1. Download Apache Spark
Log in as `hadoop` on the master node and download Spark.
```bash
wget https://downloads.apache.org/spark/spark-3.4.0/spark-3.4.0-bin-hadoop3.tgz
```

### 2. Extract Spark
```bash
tar -xvzf spark-3.4.0-bin-hadoop3.tgz
mv spark-3.4.0-bin-hadoop3 /home/hadoop/spark
```

### 3. Distribute Spark to Slave Nodes
Use `scp` to copy Spark from the master node to slave nodes:
```bash
scp -r /home/hadoop/spark hadoop@slave_ip:/home/hadoop/
```

---

## Set Environment Variables for `hadoop` User

### 1. Edit `~/.bashrc` for Both Master and Slave Nodes
```bash
nano ~/.bashrc
```

### 2. Add the Following Lines:
```bash
export SPARK_HOME=/home/hadoop/spark
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
export PYSPARK_PYTHON=python3  # Ensure Python 3 is being used
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64  # Adjust if needed
```

### 3. Apply Changes:
```bash
source ~/.bashrc
```

---

## Configure Spark for the Cluster

### 1. Edit `spark-env.sh` on the Master Node
Navigate to the Spark configuration directory:
```bash
cd /home/hadoop/spark/conf
cp spark-env.sh.template spark-env.sh
nano spark-env.sh
```

Add these lines:
```bash
export SPARK_WORKER_CORES=4  # Adjust based on your system specs
export SPARK_WORKER_MEMORY=4g  # Adjust based on your system memory
export SPARK_DRIVER_MEMORY=2g
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

### 2. Edit the `slaves` File
```bash
nano slaves
```

Add the hostnames or IP addresses of the slave nodes:
```bash
slave-node-1
slave-node-2
```

---

## Start Hadoop and Spark

### 1. Start Hadoop
```bash
start-dfs.sh
start-yarn.sh
```
Verify Hadoop is running:
```
http://master-node-ip:50070
```

### 2. Start Spark on the Master Node
```bash
$SPARK_HOME/sbin/start-all.sh
```
Check the Spark UI:
```
http://master-node-ip:8080
```
