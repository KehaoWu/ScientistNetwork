Construct = function(relationSet,cutoff=0)
{

  
  relationSetMatrix = xtabs(~p1+p2,relationSet)
  p1 = NULL
  p2 = NULL
  p1Set = rownames(relationSetMatrix)
  p2Set = colnames(relationSetMatrix)
  strength = NULL
  for(i in 1:nrow(relationSetMatrix))
  {
    for(j in 1:ncol(relationSetMatrix))
    {
      if(relationSetMatrix[i,j]>cutoff)
      {
        p1 = c(p1,p1Set[i])
        p2 = c(p2,p2Set[j])
        strength = c(strength,relationSetMatrix[i,j])
      }
    }
  }
  return(list(p1=p1,p2=p2,strength=strength))
}
