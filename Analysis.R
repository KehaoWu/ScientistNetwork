library(RCurl)
library(XML)
library(igraph)
source("R/Construct.R")
source("R/Graph.R")
source("R/GraspData.R")
keyPerson = "Rao Y"

relationSet = GraspData(keyPerson = keyPerson)
relationData = Construct(relationSet = relationSet,cutoff = 0)
jpeg(filename = "ScientistNetwork.jpg",width = 1000,height = 1000,quality = 100)
g = Graph(data = RelationData,keyPerson = keyPerson)
dev.off()
