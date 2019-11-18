# This script pushes the model output file contents from the local machine to Graham.
# To use, change "hbrauner" to your username, and update the file paths
# Note: each iteration will require you to enter your Graham password unless you've connected your ssh key to Graham.

# Enter your model scenario numbers / names here (ensure you have a consistent format for the "scenario" name following)
nums='1 2 3 1-P 2-P'

for scenario_num in $nums
do
  scenario="Scenario${scenario_num}"

#Switch between dry run and regular by commenting/uncommenting the lines below

#Dry Run
rsync -avirh --dry-run $scenario/Output/ hbrauner@graham.computecanada.ca:~/projects/rpp-hwheater/hbrauner/BakerCreekProject/Model/$scenario/Output

#Regular
#rsync -avirh $scenario/Output/ hbrauner@graham.computecanada.ca:~/projects/rpp-hwheater/hbrauner/BakerCreekProject/Model/$scenario/Output

done
