# This script pushes the contents of this entire project folder from the local machine to Graham.
# To use, change "hbrauner" to your username, and update the file paths

#Switch between dry run and regular by commenting/uncommenting the lines below

#Dry Run
rsync -avirh --dry-run hbrauner@graham.computecanada.ca:~/projects/rpp-hwheater/hbrauner/BakerCreekProject/ .

#Regular
#rsync -avirh hbrauner@graham.computecanada.ca:~/projects/rpp-hwheater/hbrauner/BakerCreekProject/ .
