# rsync -avirh data.dat andrew@water-ami.usask.ca:~/Desktop/ImaginaryRepo/.
nums='1 2 3 1-P 2-P'

for scenario_num in $nums
do
  scenario="Scenario_${scenario_num}"

#Dry Run
rsync -avirh --dry-run $scenario/Output/ hbrauner@graham.computecanada.ca:~/projects/rpp-hwheater/hbrauner/BakerCreekProject/Model/$scenario/Output

#Regular
#rsync -avirh --dry-run $scenario/Output/ hbrauner@graham.computecanada.ca:~/projects/rpp-hwheater/hbrauner/BakerCreekProject/Model/$scenario/Output

done
