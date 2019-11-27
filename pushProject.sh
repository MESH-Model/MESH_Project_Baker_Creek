# This script pushes the contents of this entire project folder from the local machine to Graham.
# To use, change "hbrauner" to your username, and update the file paths

#Switch between dry run and regular by commenting/uncommenting the lines below

#Dry Run
# rsync -rultvzi --dry-run --exclude '.git' ./ hbrauner@graham.computecanada.ca:~/projects/rpp-hwheater/hbrauner/MESH_Project_Baker_Creek

#Regular
rsync -rultvzi --exclude '.git' ./ hbrauner@graham.computecanada.ca:~/projects/rpp-hwheater/hbrauner/MESH_Project_Baker_Creek

# Note: Don't use "-a" for transferring to Graham. Or if you do, you must also add "--no-g" and "--no-p". Otherwise, you will get a disk quota exceeded error message.

# r - recursive
# u - update; skip files that are newer on the receiver
# l - synlinks remain as symlinks
# t - preserve modification times
# v - increase verbosity
# z - compress file data during transfer
# i - output a change-summary for all updates

## DON'T USE
# a - archive; equals -rlptgoD; particularly -p and -g
# p - preserve permissions
# g - preserve group
