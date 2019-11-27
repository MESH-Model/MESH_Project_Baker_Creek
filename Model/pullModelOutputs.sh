# This script pulls the model output file contents from Graham the local machine.
# To use, change "hbrauner" to your username, and update the file paths
# Note: each iteration will require you to enter your Graham password unless you've connected your ssh key to Graham.

# Enter your model scenario numbers / names here (ensure you have a consistent format for the "scenario" name following)
nums='1 2 3 1-P 2-P'

for scenario_num in $nums
do
  scenario="Scenario${scenario_num}"

#Switch between dry run and regular by commenting/uncommenting the lines below

#Dry Run
rsync -rultvzi --dry-run hbrauner@graham.computecanada.ca:~/projects/rpp-hwheater/hbrauner/MESH_
/Model/$scenario/Output/ $scenario/Output

#Regular
#rsync -rultvzi hbrauner@graham.computecanada.ca:~/projects/rpp-hwheater/hbrauner/MESH_Project_Baker_Creek/Model/$scenario/Output/ $scenario/Output

done
