import sys, os
from pylab import *  # for plotting
from numpy.random import *  # for random sampling
from graph_tool.all import *
import time
import pickle


def main():
	print "Loading Graph..."
	g = load_graph("fullNet.xml.gz")
	print "Done loading Graph"
	strengths = g.edge_properties["strength"]
	b, mdl = graph_tool.community.minimize_blockmodel_dl(g,eweight=strengths,verbose=True)
	pickle.dump(b, open( "fullNetwork_b.p", "wb" ) )
	pickle.dump(mdl, open( "fullNetwork_mdl.p", "wb" ) )
	graph_tool.graph_draw(g, pos=g.vp["pos"], vertex_fill_color=b, vertex_shape=b, output="fullNetwork_blocks_mdl.pdf")

main()
