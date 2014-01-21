Template.ddd.rendered = ->
	w = 1200
	h = 800
	r = 6
	color = d3.scale.category20()

	force = d3.layout.force()
		.charge(-80)
		.gravity(0.06)
		.linkDistance(50)
		.size([w, h ])

	svg = d3.select(".hereD").append("svg")
		.attr("width", w)
		.attr("height", h)
		.attr("transform", "translate(" + w / 4 + "," + h / 3 + ")")

	d3.json "netDataTest.json", (error, graph) ->
		force.nodes(graph.nodes).links(graph.links).start()
		link = svg.selectAll(".link")
			.data(graph.links)
			.enter()
			.append("line")
			.attr("class", "link")
			.style("stroke-width", (d) ->
				1
			)

		gnodes = svg.selectAll("g.gnode")
			.data(graph.nodes)
			.enter()
			.append("g")
			.classed("gnode", true)
			.on("mouseover", (d) ->
				nodeSelection = d3.select(this)
				nodeSelection.select("circle").style(opacity: "1.0")
				nodeSelection.select("text").style(opacity: "1.0")
				console.log nodeSelection.text()
			)
			.on("mouseout", (d) ->
				nodeSelection = d3.select(this)
				nodeSelection.select("circle").style(opacity: "1.0")
				nodeSelection.select("text").style(opacity: "0.2")
				console.log nodeSelection.text()
			)

		node = gnodes.append("circle")
			.attr("class", "node")
			.attr("class", "node").attr("r", (d) ->
				d.inlinks
			)
			.style("fill", (d) ->
				color d.inlinks
			)
			.style("opacity", "1.0")
			.call(force.drag)
			
		labels = gnodes.append("text").text((d) ->
			d.name
		)
		.style("opacity", "0.2")
		.attr("text-anchor", "middle")
		.attr("class","node-label")

		force.on "tick", ->
			q = d3.geom.quadtree(graph.nodes)
			# console.log q
			i = 0
			n = graph.nodes.length
			# console.log graph.nodes[i]
			q.visit collide(graph.nodes[i])  while ++i < n


			# Update the links
			link.attr("x1", (d) ->
			  d.source.x
			).attr("y1", (d) ->
			  d.source.y
			).attr("x2", (d) ->
			  d.target.x
			).attr "y2", (d) ->
			  d.target.y
			# node.each(collide(.5))

			# console.log svg.selectAll(".gnode")
			# svg.selectAll(".gnode").attr("cx", (d) ->
			#     d.source.x
			#   ).attr "cy", (d) ->
			#     d.y

			# Translate the groups
			gnodes.attr "transform", (d) ->
			  "translate(" + [Math.max(r, Math.min(w - r, d.x)), d.y = Math.max(r, Math.min(h - r, d.y))] + ")"

			
		collide = (node) ->
			rr = node.inlinks + 16
			# console.log rr
			nx1 = node.x - rr
			nx2 = node.x + rr
			ny1 = node.y - rr
			ny2 = node.y + rr
			(quad, x1, y1, x2, y2) ->
			  if quad.point and (quad.point isnt node)
			    x = node.x - quad.point.x
			    y = node.y - quad.point.y
			    l = Math.sqrt(x * x + y * y)
			    rr = node.radius + quad.point.radius
			    if l < rr
			      l = (l - rr) / l * .5
			      node.x -= x *= l
			      node.y -= y *= l
			      quad.point.x += x
			      quad.point.y += y
			  x1 > nx2 or x2 < nx1 or y1 > ny2 or y2 < ny1

# Template.wikiData.created = ->
# 	Session.set "updated", false

window.addEventListener "message", ((event) ->
  # We only accept messages from ourselves
  return  unless event.source is window
  if event.data.type and (event.data.type is "FROM_PAGE")
    Meteor.call "printVal", event.data.text
    Session.set "updated", true
), false

Template.wikiData.wikiData = ->
	if Session.get "updated"
		xx = WikiData.findOne({accountID:'travis'})
		if xx
			console.log xx['titles']
			Session.set "updated", false
			postToExt(xx['titles'])
		return xx


@postToExt = (xx) ->
	window.postMessage
	  type: "FROM_Server"
	  text: xx
	, "*"

		# How about no links, but a spectrum of colors, based on link connection. Not simply 6 colors, 
		# but a wide spectrum that communicate connections. Too many links for them to actually show value.
		# When you click, then you can draw all it's connections



		# maxRadius = 50
		# padding = 1.5
		# clusterPadding = 6

		# collide = (alpha) ->
		#   quadtree = d3.geom.quadtree(gnodes)
		#   (d) ->
		#     r = d.radius + maxRadius + Math.max(padding, clusterPadding)
		#     nx1 = d.x - r
		#     nx2 = d.x + r
		#     ny1 = d.y - r
		#     ny2 = d.y + r
		#     quadtree.visit (quad, x1, y1, x2, y2) ->
		#       if quad.point and (quad.point isnt d)
		#         x = d.x - quad.point.x
		#         y = d.y - quad.point.y
		#         l = Math.sqrt(x * x + y * y)
		#         r = d.radius + quad.point.radius + ((if d.cluster is quad.point.cluster then padding else clusterPadding))
		#         if l < r
		#           l = (l - r) / l * alpha
		#           d.x -= x *= l
		#           d.y -= y *= l
		#           quad.point.x += x
		#           quad.point.y += y
		#       x1 > nx2 or x2 < nx1 or y1 > ny2 or y2 < ny1

		# http://bl.ocks.org/mbostock/1748247

