Graph = function(data,keyPerson)
{
  nameize = function(name)
  {
    if(name=="")
      return("")
    name = strsplit(name,split = "\\s")[[1]]
    first = unlist(strsplit(name[1],split = "")[[1]])
    first = paste(c(toupper(first[1]),first[-1]),collapse = "")
    second = toupper(name[2])
    paste(first,second)
  }
  keyPerson = tolower(keyPerson)
  p1 = data$p1
  p2 = data$p2
  strength = data$strength
  pSet = unique(c(p1,p2))
  p1Index = match(p1,pSet)
  p2Index = match(p2,pSet)
  g = graph(as.vector(rbind(p1Index,p2Index)))
  
  #colSeq = seq(.7,0,-0.07)
  #colorSet = rgb(colSeq,colSeq,colSeq)
  #Ecolor = colorSet[ceiling((strength + 1 -min(strength)) * 9 / (max(strength) - min(strength)))]
  Ecolor = "palegreen"
  keyCouple = (p1 %in% keyPerson) | (p2 %in% keyPerson) 
  keyP1 = p1[keyCouple]
  keyP2 = p2[keyCouple]
  keyStrength = strength[keyCouple]
  keyP1 = keyP1[order(keyStrength,decreasing = T)]
  keyP2 = keyP2[order(keyStrength,decreasing = T)]
  keyStrength = keyStrength[order(keyStrength,decreasing = T)]
  keyP1 = head(keyP1,n = 30)
  keyP2 = head(keyP2,n = 30)
  keyStrength = head(keyStrength,n = 30)
  keyOtherP = keyP1
  keyOtherP[keyOtherP==keyPerson] = keyP2[keyOtherP==keyPerson]
  label =  pSet
  VLColor = rep("grey",length(pSet))
  VLColor[label %in% c(keyOtherP,keyPerson)] = "indianred2"
  VLSize = 1
  VLSize[label %in% c(keyOtherP,keyPerson)] = 3
  
  nodesPerPerson = names(sort(table(c(p1,p2)),decreasing = T))
  nodesPerPerson = head(nodesPerPerson,n = 30)
  label[!label %in% nodesPerPerson] = ""
  
  E(g)$arrow.mode = 0
  E(g)$width = log10(strength)*3 + .1
  E(g)$color = Ecolor
  
  V(g)$frame.color = "white"
  V(g)$color = "palegreen"
  V(g)$size = .2
  V(g)$label.size = VLSize
  V(g)$label = unlist(lapply(X = label,FUN = nameize))
  V(g)$label.color = VLColor
  plot(g,layout=layout.fruchterman.reingold)
  return(g)
}
