# The following code was initially developed for use in the Immersion project: immersion.media.mit.edu
# Code author: Daniel Smilkov

@communityDetection = (graph) ->
  nodesMap = {}
  nodesRef = {}
  for i of graph.nodes
    continue  if graph.nodes[i].skip
    node = graph.nodes[i]
    nodesMap[node.id] =
      node: node
      degree: 0
    nodesRef[node.id] = node.attr
  m = 0
  linksMap = {}
  graph.links.forEach (link) ->
    a = link.source.id
    b = link.target.id
    return  if link.skip or link.source.skip or link.target.skip
    linksMap[a] = {}  unless a of linksMap
    linksMap[b] = {}  unless b of linksMap
    unless b of linksMap[a]
      linksMap[a][b] = 0
      linksMap[b][a] = 0
      m++
      nodesMap[a].degree += 1
      nodesMap[b].degree += 1

  communities = {}
  Q = 0
  for id of nodesMap
    communities[id] =
      score: nodesMap[id].degree / (2.0 * m)
      nodes: [id]
  # console.log communities
  for a of linksMap
    for b of linksMap[a]
      linksMap[a][b] = 1.0 / (2 * m) - (nodesMap[a].degree * nodesMap[b].degree) / (4.0 * m * m)
  # console.log linksMap
  iter = 0
  while iter < 1000
    deltaQ = -1
    maxa = `undefined`
    maxb = `undefined`
    for a of linksMap
      for b of linksMap[a]
        # console.log a + " " + b
        if linksMap[a][b] > deltaQ
          if a != b
          # console.log linksMap[a][b]
            deltaQ = linksMap[a][b]
            maxa = a
            maxb = b
    break  if deltaQ < 0
    for k of linksMap[maxa]
      unless k is maxb
        if k of linksMap[maxb]
          linksMap[maxb][k] += linksMap[maxa][k]
        else
          linksMap[maxb][k] = linksMap[maxa][k] - 2 * communities[maxb].score * communities[k].score
        linksMap[k][maxb] = linksMap[maxb][k]
      delete linksMap[k][maxa]
    for k of linksMap[maxb]
      if (k not of linksMap[maxa]) and k isnt maxb
        linksMap[maxb][k] -= 2 * communities[maxa].score * communities[k].score
        linksMap[k][maxb] = linksMap[maxb][k]
    for i of communities[maxa].nodes
      # console.log maxa
      # console.log maxb
      communities[maxb].nodes.push communities[maxa].nodes[i]
    communities[maxb].score += communities[maxa].score
    delete communities[maxa]

    delete linksMap[maxa]
    
    Q += deltaQ
    iter++


  # console.log communities
  clusterData = []
  isOne = 0
  isMore = 0
  clusterCounter = 1
  for community of communities
    mlength = communities[community].nodes.length
    if mlength == 1
      isOne+=1
      clusterData.push({cluster:0, radius:nodesRef[community], title: community})
    else
      isMore+=1
      # console.log "--------"
      # console.log nodesRef
      for node in communities[community].nodes
        clusterData.push({cluster:clusterCounter, radius:nodesRef[node], title: node})
        # console.log node
      clusterCounter+=1
      # console.log "--------"
  # console.log isOne
  # console.log isMore
  # console.log clusterData
  return clusterData
  # clusterData = []
  #   for item of renderData['nodes']
  #     # console.log renderData['nodes'][item]
  #     title = renderData['nodes'][item]['id']
  #     inlinks = renderData['nodes'][item]['attr']/100
  #     # console.log inlinks
  #     # if inlinks < 45
  #     clusterData.push({cluster:1, radius:graph.nodes[, title: title})



  # tmp = []
  # for cid of communities
  #   # console.log "im here?"
  #   tmp.push [cid, communities[cid].nodes.length]
  # tmp.sort (a, b) ->
  #   b[1] - a[1]

  # colorid = 0
  # for i of tmp
  #   cid = tmp[i][0]
  #   for i of communities[cid].nodes
  #     nodesMap[communities[cid].nodes[i]].node.attr.color = colorid
  #   colorid++  if communities[cid].nodes.length > 1
  # 