# code checking
pyflakes .

# activate the fedml environment
source "$HOME/miniconda/etc/profile.d/conda.sh"
conda activate fedml

# MNIST standalone FedAvg
wandb off
cd ./fedml_experiments/standalone/fedavg
sh run_fedavg_standalone_pytorch.sh 2 10 10 mnist ./../../../data/mnist lr hetero 2 2 0.03
cd ./../../../

# MNIST distributed FedAvg
cd ./fedml_experiments/distributed/fedavg
sh run_fedavg_distributed_pytorch.sh 10 10 1 4 lr hetero 2 2 10 0.03 mnist "./../../../data/mnist"
cd ./../../../

# MNIST mobile FedAvg
cd ./fedml_mobile/server/executor/
python3 -m app.py &
bg_pid_server=$!

python3 ./mobile_clent_simulator.py --client_uuid '0'
bg_pid_client0=$!

python3 ./mobile_clent_simulator.py --client_uuid '1'
bg_pid_client1=$!

sleep 60
kill $bg_pid_server
kill $bg_pid_client0
kill $bg_pid_client1

exit 0

cd ./../../../