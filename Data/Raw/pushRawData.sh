# Push to Graham
#rsync -rultvzi ./ hbrauner@graham.computecanada.ca:~/projects/rpp-hwheater/hbrauner/MESH_Project_Baker_Creek/Data/Raw

# Push to water-ami server
rsync -rultvzi ./ mws_students@water-ami.usask.ca:~/Haley/BakerCreekRawData
