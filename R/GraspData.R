GraspData = function(keyPerson)
{
  RetStart = 1
  corePerson = keyPerson
  corePerson = gsub(pattern = "\\s",replacement = "+",x = corePerson)
  webSite = paste("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&usehistory=y&term=",corePerson,"%5BAuthor%5D&RetMax=100&RetStart=",RetStart,sep="")
  cat("Downloading data from record 1 ...\n")
  webPage = getURL(webSite,.encoding="UTF-8")
  webPage = paste(webPage,collapse = "\n")
  webHtml = htmlParse(webPage,encoding="UTF-8")
  nodes = getNodeSet(doc = webHtml,path = "//id")
  PMIDs = sapply(nodes,FUN = xmlValue)
  nodes = getNodeSet(doc = webHtml,path = "//webenv")
  uid = sapply(nodes,FUN = xmlValue)
  totalCounts = as.numeric(xmlValue(getNodeSet(webHtml,"//count")[[1]]))
  cat("\tTotal",totalCounts,"records need to be downloaded ...\n")
  
  if(totalCounts > 100)
  {
    for(RetStart in seq(101,totalCounts,100))
    {
      cat("Downloading data from record", RetStart ,"...\n")
      
      webSite = paste("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&id=",uid,"&usehistory=y&term=",corePerson,"%5BAuthor%5D&RetMax=100&RetStart=",RetStart,sep="")
      webPage = getURL(webSite,.encoding="UTF-8")
      webPage = paste(webPage,collapse = "\n")
      webHtml = htmlParse(webPage,encoding="UTF-8")
      nodes = getNodeSet(doc = webHtml,path = "//id")
      PMIDs =c(PMIDs,sapply(nodes,FUN = xmlValue)) 
      
    }
  }
  
  relationship = function(author)
  {
    p1 = p2 = NULL
    for(i in 1:(length(author)-1))
    {
      for(j in (i+1):(length(author)))
      {
        p = c(author[i],author[j])
        p = sort(p)
        p1 = c(p1,p[1])
        p2 = c(p2,p[2])
      }
    }
    p1 = tolower(p1)
    p2 = tolower(p2)
    data.frame(p1,p2)
  }
  
  len = 40
  start = seq(1,length(PMIDs),len)
  if(length(PMIDs)>(len+1))
    end = c(seq((len+1),length(PMIDs),len)) else
      end = length(PMIDs)
  if(length(start) != length(end))
     end = c(end,length(PMIDs))
  relationSet = NULL
  pb = txtProgressBar(min = 1,max = length(PMIDs),style = 3)
  for(i in 1:length(start))
  {
    setTxtProgressBar(pb,value = start[i])
    webSite = paste("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&id=",paste(PMIDs[start[i]:end[i]],collapse = ","),sep="")
    
    webPage = getURL(webSite,.encoding="UTF-8")
    webPage = paste(webPage,collapse = "\n")
    webHtml = htmlParse(webPage,encoding="UTF-8")
    nodes = getNodeSet(doc = webHtml,path = "//item [@name='AuthorList']")
    nodesCount = length(nodes)
    for(k in 1:nodesCount)
    {
      node = nodes[[k]]
      childrenNodes = xmlChildren(node)
      childrenAuthor = sapply(childrenNodes,xmlValue)
      if(all(!childrenAuthor %in% tolower(keyPerson)))
        next
      if(length(childrenAuthor)<=1)
        next
      print(childrenAuthor)
      relationSet = rbind(relationSet,relationship(childrenAuthor))
    }
    setTxtProgressBar(pb,value = end[i])
  }
  return(relationSet)
}
