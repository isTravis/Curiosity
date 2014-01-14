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
				if d.inlinks > 50
					10
				else
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

			# gnodes.attr("cx", (d) ->
			# 	d.x = Math.max(r, Math.min(w - r, d.x))
			# ).attr "cy", (d) ->
			# 	d.y = Math.max(r, Math.min(h - r, d.y))

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

			# Translate the groups
			gnodes.attr "transform", (d) ->
			  "translate(" + [Math.max(r, Math.min(w - r, d.x)), d.y = Math.max(r, Math.min(h - r, d.y))] + ")"

			




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

